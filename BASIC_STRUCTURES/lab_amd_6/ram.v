`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 05:29:59 PM
// Design Name: 
// Module Name: ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ram(
    input [6:0] addr,  
    input clk,
    input rw,
    input [31:0] din,
    output reg [31:0] OUT
);

    reg [31:0] internal_mem [99:0];  
    parameter ERR_CODE = 32'hDEAD;  

    integer i;
    initial begin
        for (i = 0; i < 100; i = i + 1) begin
            internal_mem[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (addr > 99) begin
            OUT <= ERR_CODE;  
        end else if (rw == 0) begin
            OUT <= internal_mem[addr];
        end else begin
            internal_mem[addr] <= din;
            OUT <= internal_mem[addr];
        end
    end

endmodule


module tb;
    reg [6:0] addr;
    reg clk;
    reg rw;
    reg [31:0] din;
    wire [31:0] OUT;

    ram uut (
        .addr(addr),
        .clk(clk),
        .rw(rw),
        .din(din),
        .OUT(OUT)
    );

    always #5 clk = ~clk;  

    initial begin
        clk = 0;
        rw = 1;  
        addr = 0;
        din = 32'h12345678;  
        #10;
        addr = 0; din = 32'hAABBCCDD; rw = 1; #10;
        addr = 1; din = 32'h11223344; rw = 1; #10;
        //nu va fi citit
        addr = 2; din = 32'h55667788; rw = 0; #10;
        addr = 3; din = 32'h99AABBCC; rw = 1; #10;

        addr = 100; rw = 0; #10;

        #10;
        addr = 0; rw = 0; #10;
        addr = 1; rw = 0; #10;
        addr = 2; rw = 0; #10;
        addr = 3; rw = 0; #10;

        #10;
        $finish;
    end

endmodule
