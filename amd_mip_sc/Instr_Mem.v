`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2024 11:22:20
// Design Name: 
// Module Name: Instr_Mem
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
module Instr_Mem(input [31:0] addr, output  [31:0] instr);
    reg [7:0] instructions [99:0];

    initial begin
       $readmemh("instr.mem", instructions);
        
    end

        assign instr[31:24] = instructions[addr];
        assign instr [23:16] = instructions[addr+1];
        assign instr [15:8] = instructions[addr+2];
        assign instr[7:0] = instructions[addr+3];
endmodule