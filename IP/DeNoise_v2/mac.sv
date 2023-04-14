module gaussian_mac(
    input [3:0] in [2:0][2:0],
    output reg [3:0] out
);
    assign out = (in[0][0]*1 + in[0][1]*2 + in[0][2]*1 + in[1][0]*2 + in[1][1]*4 + in[1][2]*2 + in[2][0]*1 + in[2][1]*2 + in[2][2]*1)/16;
endmodule

module sobel_h(
    input [3:0] in [2:0][2:0],
    output reg signed [15:0] out
);
    assign out = (in[0][0]*(-1) + in[0][1]*0 + in[0][2]*1 + in[1][0]*(-2) + in[1][1]*0 + in[1][2]*2 + in[2][0]*(-1) + in[2][1]*0 + in[2][2]*1);
endmodule

module sobel_v(
    input [3:0] in [2:0][2:0],
    output reg signed [15:0] out
);
    assign out = (in[0][0]*(-1) + in[0][1]*(-2) + in[0][2]*(-1) + in[1][0]*0 + in[1][1]*0 + in[1][2]*0 + in[2][0]*1 + in[2][1]*2 + in[2][2]*1);
endmodule

module de_noise_activation (
    input [3:0] in [2:0][2:0],
    output reg [3:0] out
);
    
    wire [7:0] adjacent;
    wire [4:0] n_adjacent;
    wire centre;
    
    assign centre = in[1][1][0];
    
    assign adjacent[0] = in[0][0][0];
    assign adjacent[1] = in[0][1][0];
    assign adjacent[2] = in[0][2][0];
    assign adjacent[3] = in[1][0][0];
    assign adjacent[4] = in[1][2][0];
    assign adjacent[5] = in[2][0][0];
    assign adjacent[6] = in[2][1][0];
    assign adjacent[7] = in[2][2][0];
    
    assign out = adjacent[0] + adjacent[1] + adjacent[2] + adjacent[3] + adjacent[4] + adjacent[5] + adjacent[6] + adjacent[7];

    //assign out = (n_adjacent > NOISE_THRESHOLD)&&(centre);
        
endmodule