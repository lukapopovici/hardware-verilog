`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2024 11:20:53
// Design Name: 
// Module Name: lagger
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

module lagger (
    input [31:0] in,
    output reg [31:0] out,
    input clk
);
    reg switch;
    
    initial begin
        switch = 0;
    end
    
    always @(posedge clk) begin
        if (switch == 0) begin
            switch = 1;
            out = 0;
        end 
        else begin
                out = in;
        end
    end
endmodule
