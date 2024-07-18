`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 03:56:17 PM
// Design Name: 
// Module Name: dm
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



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 03:56:17 PM
// Design Name: 
// Module Name: dm
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



module DM(input clk, input memwrite, input [31:0] addr, input [31:0] wd, output [31:0] rd);
    reg [31:0] internal_mem [99:0];
    parameter ERR_CODE = 32'hDEAD;

    integer i;
    initial begin
        for (i = 0; i < 100; i = i + 1) begin
            internal_mem[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (memwrite) begin
            internal_mem[addr] <= wd;
        end
    end

        assign  rd = internal_mem[addr];
 
endmodule