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

module PC(input clk, output reg [31:0] addr, input [31:0] in);
    initial begin
        addr = 0;
    end
    always @(posedge clk) begin
        addr <= in;
    end
endmodule

module adder(input [31:0] op1, output reg [31:0] out);
    always @(*) begin
        out <= op1 + 4;
    end   
endmodule

module lagger (
    input [31:0] in,
    output reg [31:0] out,
    input clk
);
    reg switch = 0;
    reg [31:0] temp;

    always @(posedge clk) begin
        if (switch == 0) begin
            temp <= in;
            switch <= 1;
        end else begin
            out <= in;
        end
    end

    always @(posedge clk) begin
        if (switch == 0) begin
            out <= temp;
        end
    end
endmodule

module ALU #(parameter SIZE = 32) (
    input [SIZE-1:0] rd1, 
    input [SIZE-1:0] rd2, 
    input [3:0] op, 
    output reg [SIZE-1:0] rez, 
    output reg zero
);
    always @(*) begin
        case (op)
            4'b0000: rez = rd1 & rd2;
            4'b0001: rez = rd1 | rd2;
            4'b0010: rez = rd1 + rd2;
            4'b0110: rez = rd1 - rd2;
            4'b0111: begin if (rd1 < rd2) rez = 0; else rez = 1; end
            4'b1100: rez = !(rd1 | rd2);
        endcase
        
        if (rez == 0) begin 
            zero = 1;
        end else begin
            zero = 0;
        end
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

    initial begin
        for (integer i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    always @(*) begin
        rd1 = registers[ra1];
    end

    always @(*) begin
        rd2 = registers[ra2];
    end

    always @(posedge regwrite) begin
        if (regwrite) begin
            registers[wa] = wd;
        end
    end
endmodule

module DM(input clk, input memwrite, input [31:0] addr, input [31:0] wd, output reg [31:0] rd);
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

    always @(*) begin
        rd = internal_mem[addr];
    end
endmodule

module Instr_Mem(input [31:0] addr, output reg [31:0] instr);
    reg [31:0] instructions [31:0];

    initial begin
        for (integer i = 0; i < 100; i = i + 1) begin
            instructions[i] = 32'b0;
        end
        
        instructions[0] = 32'b00110100000010000001010001100110; // add $t0, $t0, $t0
        instructions[1] = 32'b00010000001000000000000000000101; // sub $t0, $t0, $t0
    end

    always @(*) begin
        instr = instructions[addr];
    end
endmodule

module alusrcMUX(
    input [31:0] extsign,
    input [31:0] rd2,
    input alusrc,
    output reg [31:0] out
);
    always @(*) begin 
        if (alusrc)
            out = extsign;
        else
            out = rd2;
    end
endmodule

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

module main_control(
    input Zero,
    input [5:0] opcode,
    input [5:0] func,
    output reg alusrc,
    output reg extop,
    output reg regdst,
    output reg regwrite,
    output reg memwrite,
    output reg mem2reg,
    output reg [3:0] aluop
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type instructions
                regdst = 1'b1;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b0;
                regwrite = 1'b1;
                extop = 1'b0;

                case (func)
                    6'b100000: aluop = 4'b0010; // ADD
                    6'b100010: aluop = 4'b0110; // SUB
                    6'b100100: aluop = 4'b0000; // AND
                    6'b100101: aluop = 4'b0001; // OR
                    6'b101010: aluop = 4'b0111; // SLT
                    default: aluop = 4'b1111; // Invalid instruction
                endcase
            end

            6'b100011: begin // LW
                regdst = 1'b0;
                alusrc = 1'b1;
                memwrite = 1'b0;
                mem2reg = 1'b1;
                regwrite = 1'b1;
                extop = 1'b1;
                aluop = 4'b0010; // ADD
            end

            6'b101011: begin // SW
                regdst = 1'b0;
                alusrc = 1'b1;
                memwrite = 1'b1;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b1;
                aluop = 4'b0010; // ADD
            end

            6'b000100: begin // BEQ
                regdst = 1'b0;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b1;
                aluop = 4'b0110; // SUB
            end

            default: begin // Invalid instruction
                regdst = 1'b0;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b0;
                aluop = 4'b1111;
            end
        endcase
    end
endmodule

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

module toplevel();
    reg clk;
    wire [31:0] instruction;
    wire [31:0] adder_pc_in;
    wire [31:0] address;
    wire [31:0] lagged_address;

    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [31:0] rd2_alu;
    wire [31:0] alu_rez;

    wire regdst;
    wire extop;
    wire alusrc;
    wire [3:0] aluop;
    wire mem2reg;
    wire memwrite;
    wire Zero;
    wire [4:0] wa;
    wire [31:0] rd;
    wire [31:0] extout;
    wire [4:0] wr;

    // Instantiate the lagger module to buffer the address
    lagger lagger_inst (
        .in(address),
        .out(lagged_address),
        .clk(clk)
    );

    // PC module
    PC pc (
        .clk(clk),
        .addr(address),
        .in(adder_pc_in)
    );

    // Adder module
    adder add (
        .op1(lagged_address),
        .out(adder_pc_in)
    );

    // ALU module
    ALU alu (
        .rd1(rd1),
        .rd2(rd2_alu),
        .op(aluop),
        .rez(alu_rez),
        .zero(Zero)
    );

    // Register Bank module
    register_bank rb (
        .regwrite(regwrite),
        .ra1(instruction[25:21]),
        .ra2(instruction[20:16]),
        .wa(wr),
        .wd(rd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Instruction Memory module
    Instr_Mem IM (
        .addr(address),
        .instr(instruction)
    );

    // Sign Extension module
    extsign ex (
        .extop(extop),
        .original(instruction[15:0]),
        .out(extout)
    );

    // Data Memory module
    DM dm (
        .clk(clk),
        .memwrite(memwrite),
        .addr(alu_rez),
        .wd(rd2),
        .rd(rd)
    );

    // Main Control Unit
    main_control MC (
        .Zero(Zero),
        .opcode(instruction[31:26]),
        .func(instruction[5:0]),
        .alusrc(alusrc),
        .extop(extop),
        .regdst(regdst),
        .regwrite(regwrite),
        .memwrite(memwrite),
        .mem2reg(mem2reg),
        .aluop(aluop)
    );

    // ALU Source Multiplexer
    MUX #(.SIZE(32)) alusrc_mux (
        .op1(rd2),
        .op2(extout),
        .sig(alusrc),
        .out(rd2_alu)
    );

    // Memory to Register Multiplexer
    MUX #(.SIZE(32)) mem2reg_mux (
        .op1(rd2),
        .op2(extout),
        .sig(mem2reg),
        .out(rd)
    );

    // Register Destination Multiplexer
    MUX #(.SIZE(5)) regdst_mux (
        .op1(instruction[20:16]),
        .op2(instruction[15:11]),
        .sig(regdst),
        .out(wr)
    );

    initial begin 
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end
    
    initial begin 
        #40 $finish;
    end
endmodule
