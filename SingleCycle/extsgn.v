`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2024 11:23:06
// Design Name: 
// Module Name: extsign
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

module extsign(
    input extop,
    input [15:0] original,
    output reg [31:0] out
);
    always @(*) begin
        if (extop)
            out = { {16{original[15]}}, original };
        else
            out = { 16'h0000, original };
    end
endmodule