`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2024 11:46:44
// Design Name: 
// Module Name: 2OpAdder
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


module TwoOpAdder(input [31:0] op2,input [31:0] op1, output reg [31:0] out);
    always @(*) begin
        out <= op1 + op2;
    end   
endmodule