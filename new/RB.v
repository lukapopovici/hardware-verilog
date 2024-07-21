`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2024 04:02:21 PM
// Design Name: 
// Module Name: RB
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


module register_bank(
    input clk,
    input regwrite,
    input swap,
    input [4:0] ra1,
    input [4:0] ra2,
    input [4:0] wa,
    input [31:0] wd,
    output [31:0] rd1,
    output [31:0] rd2
);

    reg [31:0] registers [0:31];
    reg [31:0] AUX;
    initial begin
        $readmemb("reg.mem", registers);
    end

    assign rd1 = registers[ra1];
    assign rd2 = registers[ra2];

    always @(posedge clk) begin
        if (regwrite == 1) begin
            registers[wa] <= wd;  
        end
        
        if (swap == 1) begin
            AUX=registers[ra1];
            registers[ra1]=registers[ra2];
            registers[ra2]=AUX;
        end
    end

endmodule

