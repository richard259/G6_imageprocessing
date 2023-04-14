//stores 1 row of pixels

module de_noise
    //Width of row in pixels
    #(parameter WIDTH = 640,
    //height of column in pixels
    parameter HEIGHT = 480,
    //width of convolution window
    parameter WINDOW_WIDTH = 3
    //
    //parameter NOISE_THRESHOLD = 2
    ) (
    //stores input pixel at positive edge of clock
    input clk,
    //posedge of clock, if is low, begins loading pixels in
    input reset, 
    //4-bit rgb colour input
    input [3:0] pixel_in,
    
    input [3:0] thresh,
    //only loads pixels in of in_valid is high
    input in_valid,
    //provides ouput window 
    output reg [11:0] data_out,
    //high when output is valid
    output reg output_valid = 0,
    //output pixel address
    output reg [18:0] addr = 0
);
   
    int unsigned counter;
    int unsigned row;
    int unsigned col;
    int unsigned last_pixel;
    
    reg[3:0] noise_thresh;
    
    assign noise_thresh = thresh;
    
    (* ram_style = "distributed" *) reg [WINDOW_WIDTH:0][WIDTH-1:0][3:0] pixels;
    reg [3:0] to_mac [2:0][2:0];
    reg frame_done = 0;
    
    reg last_pixel_in = 0;
    
    reg [3:0] noise_activation;
    
    de_noise_activation dn (
        .in(to_mac),
        .out(noise_activation) 
    );
    
    
    assign row = (counter/WIDTH)%(WINDOW_WIDTH+1);
    assign col = (counter%WIDTH);
    

       
    always @(negedge clk) begin
       
        //reset at vsync pulse
        if (reset) begin
                counter <= 0;
                addr <= 0;
                frame_done <= 0;
                output_valid <= 0;
                last_pixel_in <= 0;
        end
        
        
        else begin
        
            //frame is completely output, do nothing
            if (frame_done ==1) begin
//                //auto-reset
//                frame_done <= 0;
//                counter <= 0;
//                addr <= 0;
//                output_valid <= 0;
            end
            
            else begin
            
                if (counter >= WIDTH*(HEIGHT+2)) begin
                    frame_done <= 1;
                end
            
                //we have reached end of frame loaded into pixel array
                else if (counter >= WIDTH*HEIGHT) begin
                    last_pixel_in <= 1;
                end
                
                if (last_pixel_in == 1) begin
                    counter <= counter + 1;
                end
                
                //if input is valid, load in the pixel, increment the counter
                else if (in_valid) begin
                
                    //convert to black and white and load in
                    pixels[row][col] <= pixel_in;
                    counter <= counter + 1;
                end 
                            
                //we do not have enough pixels loaded in to do convolution, or there is no new data
                if (addr >= WIDTH*HEIGHT || last_pixel==counter) begin
                    output_valid <= 0;
                end
                
                //we have enough pixels loaded in to do convolution, and there is new data loaded
                else if (counter >= ((WINDOW_WIDTH-1)*WIDTH)) begin
                
                    //set ouptut valid to high, because we are about to put out new data
                    output_valid <= 1;
                    last_pixel<=counter;
                    
                    
                    //this pixel is an edge, output white
                    if (noise_activation>noise_thresh) begin
                        data_out <= 12'b111111111111;
                    end
                    //this pixel is not an edge, output black
                    else begin 
                        data_out <= 12'b000000000000;
                    end
                    
                    //increment address to write new data
                    addr <= addr + 1'b1;
                
                    //assign proper inputs to MAC module, output is wired to output of conv module
                    if (row == 0) begin
                        to_mac[0][0] <= pixels[1][col-1];
                        to_mac[0][1] <= pixels[1][col];
                        to_mac[0][2] <= pixels[1][col+1];
                        
                        to_mac[1][0] <= pixels[2][col-1];
                        to_mac[1][1] <= pixels[2][col];
                        to_mac[1][2] <= pixels[2][col+1];
                        
                        to_mac[2][0] <= pixels[3][col-1];
                        to_mac[2][1] <= pixels[3][col];
                        to_mac[2][2] <= pixels[3][col+1];
                    end
                    
                    else if (row == 1) begin
                        to_mac[0][0] <= pixels[2][col-1];
                        to_mac[0][1] <= pixels[2][col];
                        to_mac[0][2] <= pixels[2][col+1];
                        
                        to_mac[1][0] <= pixels[3][col-1];
                        to_mac[1][1] <= pixels[3][col];
                        to_mac[1][2] <= pixels[3][col+1];
                        
                        to_mac[2][0] <= pixels[0][col-1];
                        to_mac[2][1] <= pixels[0][col];
                        to_mac[2][2] <= pixels[0][col+1];
                    end
                    
                    else if (row == 2) begin
                        to_mac[0][0] <= pixels[3][col-1];
                        to_mac[0][1] <= pixels[3][col];
                        to_mac[0][2] <= pixels[3][col+1];
                        
                        to_mac[1][0] <= pixels[0][col-1];
                        to_mac[1][1] <= pixels[0][col];
                        to_mac[1][2] <= pixels[0][col+1];
                        
                        to_mac[2][0] <= pixels[1][col-1];
                        to_mac[2][1] <= pixels[1][col];
                        to_mac[2][2] <= pixels[1][col+1];
                    end
                    
                    else if (row == 3) begin 
                        to_mac[0][0] <= pixels[0][col-1];
                        to_mac[0][1] <= pixels[0][col];
                        to_mac[0][2] <= pixels[0][col+1];
                        
                        to_mac[1][0] <= pixels[1][col-1];
                        to_mac[1][1] <= pixels[1][col];
                        to_mac[1][2] <= pixels[1][col+1];
                        
                        to_mac[2][0] <= pixels[2][col-1];
                        to_mac[2][1] <= pixels[2][col];
                        to_mac[2][2] <= pixels[2][col+1];
                    end
                    
                    //zero padding on left and right
                    if (col == 0) begin
                        to_mac[0][0] <= 0;
                        to_mac[1][0] <= 0;
                        to_mac[2][0] <= 0;
                    end else if (col == WIDTH-1) begin
                        to_mac[0][2] <= 0;
                        to_mac[1][2] <= 0;
                        to_mac[2][2] <= 0;
                    end
                    
                    //zero padding on top and bottom
                    if ((counter/WIDTH)<=WINDOW_WIDTH-1) begin
                        to_mac[0][0] <= 0;
                        to_mac[0][1] <= 0;
                        to_mac[0][2] <= 0;
                    end else if ((counter/WIDTH)>=HEIGHT+1) begin
                        to_mac[2][0] <= 0;
                        to_mac[2][1] <= 0;
                        to_mac[2][2] <= 0;
                    end
                
                end
                
                
            end     
    
        end
        
    end
    
endmodule