`timescale 1ns / 1ps

module de_noise_tb;

    localparam NOISE_THRESHOLD = 2;

    // Inputs
    //
    reg [3:0] to_mac [2:0][2:0];
    reg clk;
    
    // Outputs
    wire noise_activation;
    
    // Instantiate module
    de_noise_activation #(.NOISE_THRESHOLD(NOISE_THRESHOLD)) dn (
        .in(to_mac),
        .out(noise_activation) 
    );
    
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
//    initial begin
//        //reset = 1'b1;
//        #10
//        //reset = 1'b0;
        
//        for (int i=0; i<1000; i=i+1) begin
//            to_mac[1][1] <= $urandom%10;
//            //in_valid <= (i%4==0);
//            #10;
//        end
                 
//    end
    
    initial 
        begin
            to_mac[0][0] = 4'b0000;
            to_mac[0][1] = 4'b0000;
            to_mac[0][2] = 4'b0000;
            to_mac[1][0] = 4'b0000;
            to_mac[1][1] = 4'b0000;
            to_mac[1][2] = 4'b0000;
            to_mac[2][0] = 4'b0000;
            to_mac[2][1] = 4'b0000;
            to_mac[2][2] = 4'b0000;
            
            
            #10;
            to_mac[1][1] = 4'b1111;
            #10;
            to_mac[0][0] = 4'b1111;
            #10;
            to_mac[0][1] = 4'b1111;
            #10;
            to_mac[0][2] = 4'b1111;
            #10;
            to_mac[1][1] = 4'b0000;
        end

endmodule