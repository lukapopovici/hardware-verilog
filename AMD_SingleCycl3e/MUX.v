`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 04:00:24 PM
// Design Name: 
// Module Name: MUX
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


module MUX #(parameter SIZE = 5) (
    input [SIZE-1:0] op1,
    input [SIZE-1:0] op2,
    input sig,
    output reg [SIZE-1:0] out
);
    always @(*) begin
        if (sig)
            out = op1;
        else
            out = op2;
    end
endmodule