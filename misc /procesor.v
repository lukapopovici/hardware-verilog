`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2024 12:37:44
// Design Name: 
// Module Name: mips_singlecycle
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

module PC(input clk,output reg [31:0] addr, input [31:0] in);
    always @(posedge clk) begin
            addr<=in;
    end
endmodule



module ALU #(parameter SIZE=32) (input [SIZE-1:0] rd1, input [SIZE-1:0] rd2, input [3:0] op , output reg [SIZE-1:0] rez, output reg zero);
        always @(*) begin
            case (op) 
                4'b0000 : rez = rd1 & rd2;
                4'b0001 : rez = rd1 | rd2;
                4'b0010 : rez = rd1 + rd2;
                4'b0110 : rez = rd1 - rd2;
                4'b0111 : begin if (rd1< rd2) rez=0; else rez=1; end
                4'b1100 : rez = !(rd1 | rd2) ;
            endcase
            
            if(rez==0) begin 
                    zero = 1;
                     end
        end
endmodule

module adder(input [31:0] op1,output reg [31:0] out);
        always @(*) begin
            out<=op1+4;
        end   
endmodule

module register_bank(
    input regwrite,
    input [4:0] ra1,
    input [4:0] ra2,
    input [4:0] wa,
    input [31:0] wd,
    output reg [31:0] rd1,
    output reg [31:0] rd2
);

    reg [31:0] registers [31:0];

    always @(*) begin
        rd1 = registers[ra1];
    end

    always @(*) begin
        rd2 = registers[ra2];
    end

    always @(*) begin
        if (regwrite) begin
            registers[wa] = wd;
        end
    end

endmodule

module DM(input clk,input memwrite,input [31:0] addr,input [31:0] wd,output reg [31:0] rd);
    reg [31:0] internal_mem [99:0];  
    parameter ERR_CODE = 32'hDEAD;  

    integer i;
    initial begin
        for (i = 0; i < 100; i = i + 1) begin
            internal_mem[i] = 0;
        end
    end

    always @(posedge clk) begin
           internal_mem[addr] = wd;
    end

endmodule




module Instr_Mem(input [31:0] addr , output reg [31:0] instr);
        reg [31:0] instructions [31:0];
        always @(*) begin 
            instr = instructions[addr];
        end
endmodule

module alusrc(input [31:0] extsign, input [31:0] rd2, input alusrc,output reg [31:0] out);
        always @(*) begin 
            if(alusrc)
                out<=extsign;
            else
                out<=rd2;
        end
endmodule


module extsign(input extop,input [15:0] original, output reg [31:0] out);
    always @(posedge extop) begin
        out<={16'h000,original};
    end
endmodule


module main_control(input Zero, input [5:0] opcode,input [5:0] func, output reg alusrc, extop , regdst, regwrite, memwrite, mem2reg, aluop);

endmodule

module toplevel();
        reg clk;
        wire [31:0] instruction;
        wire [31:0] adder_pc_in;
        wire [31:0] address;
         PC(clk,address, adder_pc_in);
         adder(address,adder_pc_in);
         ALU  alu(input [SIZE-1:0] rd1, input [SIZE-1:0] rd2, input [3:0] op , output reg [SIZE-1:0] rez, output reg zero);
         register_bank rb(input regwrite,input [4:0] ra1,input [4:0] ra2,input [4:0] wa,input [31:0] wd,output reg [31:0] rd1,output reg [31:0] rd2);
        Instr_Mem IM(address ,instruction);
        extsign ex(input extop,[15:0] instruction, output reg [31:0] out);
        DM dm(input clk,input memwrite,input [31:0] addr,input [31:0] wd,output reg [31:0] rd);


endmodule
