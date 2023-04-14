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
    assign out = ($signed({1'b0,in[0][0]})*(-1) + $signed({1'b0,in[0][1]})*0 + $signed({1'b0,in[0][2]})*1 + $signed({1'b0,in[1][0]})*(-2) + $signed({1'b0,in[1][1]})*0 + $signed({1'b0,in[1][2]})*2 + $signed({1'b0,in[2][0]})*(-1) + $signed({1'b0,in[2][1]})*0 + $signed({1'b0,in[2][2]})*1);
endmodule

module sobel_v(
    input [3:0] in [2:0][2:0],
    output reg signed [15:0] out
);
    //assign out = (in[0][0]*(-1) + in[0][1]*(-2) + in[0][2]*(-1) + in[1][0]*0 + in[1][1]*0 + in[1][2]*0 + in[2][0]*1 + in[2][1]*2 + in[2][2]*1);
    assign out = ($signed({1'b0,in[0][0]})*(-1) + $signed({1'b0,in[0][1]})*(-2) + $signed({1'b0,in[0][2]})*(-1) + $signed({1'b0,in[1][0]})*(0) + $signed({1'b0,in[1][1]})*0 + $signed({1'b0,in[1][2]})*0 + $signed({1'b0,in[2][0]})*(1) + $signed({1'b0,in[2][1]})*2 + $signed({1'b0,in[2][2]})*1);

endmodule

//module sobel_d1(
//    input [3:0] in [2:0][2:0],
//    output reg signed [15:0] out
//);
//    assign out = (in[0][0]*(0) + in[0][1]*(-1) + in[0][2]*(-2) + in[1][0]*(1) + in[1][1]*0 + in[1][2]*(-1) + in[2][0]*2 + in[2][1]*1 + in[2][2]*0);
//endmodule

//module sobel_d2(
//    input [3:0] in [2:0][2:0],
//    output reg signed [15:0] out
//);
//    assign out = (in[0][0]*(-2) + in[0][1]*(-1) + in[0][2]*(0) + in[1][0]*(-1) + in[1][1]*0 + in[1][2]*(1) + in[2][0]*0 + in[2][1]*1 + in[2][2]*2);
//endmodule


//module sobel_d(
//    input [3:0] in [2:0][2:0],
//    output reg signed [15:0] outs
//);
//    assign out = 0;
//endmodule