`timescale 1ns/1ps

module compression_tb;

    // Parameters
    parameter WIDTH = 640;
    parameter HEIGHT = 480;
    parameter C_WIDTH = 28;

    // Inputs
    reg clk;
    reg reset;
    reg v_sync;
    reg [3:0] pixel_in;
    reg in_valid;

    // Outputs
    wire [11:0] data_out;
    wire output_valid;
    wire [18:0] addr;
    wire [3:0] recognized_int;
    wire done;
    // Instantiate the unit under test (UUT)
    compression #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .C_WIDTH(C_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .v_sync(v_sync),
        .pixel_in(pixel_in),
        .in_valid(in_valid),
        .data_out(data_out),
        .output_valid(output_valid),
        .addr(addr),
        .recognized_int(recognized_int),
        .done(done)
    );
    integer i;
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        v_sync = 1;
        pixel_in = 0;
        in_valid = 0;

        // Wait for a few clock cycles to allow the reset to take effect
        #10;

        // Release reset
        reset = 0;

        // Wait for a few more clock cycles
        #10;

        // Send in pixels
        for (i = 0; i < WIDTH*HEIGHT; i=i+1) begin
            pixel_in = i % 16; // Use a simple test pattern
            in_valid = 1;
            #5;
            in_valid = 0;
            #5;
        end

        // Wait for the last output to become valid
        while (!done)
            #1;

        // Print the output address and recognized integer
        $display("Output address: %h, Recognized integer: %d", addr, recognized_int);
    end

    always #5 clk = ~clk;

endmodule