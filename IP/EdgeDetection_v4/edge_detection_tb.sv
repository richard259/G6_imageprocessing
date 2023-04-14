`timescale 1ns / 1ps

module edge_detection_tb();

    parameter WIDTH = 8;
    parameter HEIGHT = 8;
    //width of output window
    parameter WINDOW_WIDTH = 3;

    // Inputs
    reg clk;
    reg reset;
    reg [3:0] pixel_in;
    reg in_valid;
    
    reg [3:0] threshold  = 5;
   
    
    // Outputs
    wire [11:0] data_out;
    wire output_valid;
    wire [18:0] addr;
    
    // Instantiate module
    edge_detection #(.WIDTH(WIDTH), .WINDOW_WIDTH(WINDOW_WIDTH), .HEIGHT(HEIGHT)) dut (
        .clk(clk),
        .reset(reset),
        .thresh(threshold),
        .pixel_in(pixel_in),
        .in_valid(in_valid),
        .data_out(data_out),
        .output_valid(output_valid),
        .addr(addr)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1'b1;
        #10
        reset = 1'b0;
        
        for (int i=0; i<300; i=i+1) begin
            pixel_in <= $urandom%10;
            in_valid <= (i%4==0);
            #10;
        end
        
        reset = 1'b1;
        #10
        reset = 1'b0;
        
        for (int i=0; i<1000; i=i+1) begin
            pixel_in <= $urandom%10;
            in_valid <= (i%4==0);
            #10;
        end
                 
    end

endmodule