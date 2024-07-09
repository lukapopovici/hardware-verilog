`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2024 12:37:44
// Design Name: 
// Module Name: top
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

module ALU# (parameter N = 12)(
    input [N-1:0] op1,
    input [N-1:0] op2,
    input [3:0] cmd,
    output reg [N-1:0] out,
    output reg over,
    output reg under,
    output reg err,
    output reg log
);
    always @(*) begin 
        out = 0;
        over = 0;
        under = 0;
        err = 0;
        log = 0;

        case (cmd)
            4'd0: begin
                out = op1 + op2;
                if (out < op1) 
                    over = 1;
            end
            4'd1: begin
                out = op1 - op2;
                if (op1 < op2) 
                    under = 1;
            end
            4'd2: begin
                out = op1 << op2; 
            end
            4'd3: begin
                out = op1 >> op2;
            end
            4'd4: begin
                log = (op1 == op2);
            end
            4'd5: begin
                log = (op1 > op2);
            end
            4'd6: begin
                log = (op1 < op2);
            end
            default: begin
                err = 1;
            end
        endcase
    end
endmodule

module FULL(
    input [11:0] s,
    input b1,
    input b2,
    input b3,
    input pl,
    input clk,
    output [6:0] digiout,
    output [3:0] A
);

    reg [11:0] R1 = 0, R2 = 0;
    reg [3:0] R3 = 0;
    reg [1:0] DBcmd = 0;

    wire [11:0] ALUout;
    reg [11:0] MUXout = 0;
    wire [3:0] sigs;

    ALU alu(R1, R2, R3, ALUout, sigs[0], sigs[1], sigs[2], sigs[3]);
    TOP7ds display({MUXout, sigs}, clk, digiout, A);

    always @(*) begin 
        case (DBcmd)
            2'b00: MUXout = ALUout;
            2'b01: MUXout = R1;
            2'b10: MUXout = R2;
            2'b11: MUXout = {8'b0, R3}; 
            default: MUXout = ALUout;
        endcase
    end

    always @(posedge clk) begin
        if (pl) begin 
            case ({b3, b2, b1})
                3'b000: DBcmd <= 2'b00;
                3'b001: R1 <= s; 
                3'b010: R2 <= s;
                3'b100: R3 <= s[3:0];
                default: DBcmd <= 2'b00;
            endcase
        end else begin 
            case ({b3, b2, b1})
                3'b000: DBcmd <= 2'b00;
                3'b001: DBcmd <= 2'b01; 
                3'b010: DBcmd <= 2'b10;
                3'b100: DBcmd <= 2'b11;
                default: DBcmd <= 2'b00;
            endcase
        end
    end

endmodule

module decoder_2_led(input [3:0] IN, output reg [6:0] OUT);
    always @(*) begin
        case (IN)
            4'b0000: OUT <= 7'b1000000; //0
            4'b0001: OUT <= 7'b1111001; //1
            4'b0010: OUT <= 7'b0100100; //2
            4'b0011: OUT <= 7'b0110000; //3
            4'b0100: OUT <= 7'b0011001; //4 
            4'b0101: OUT <= 7'b0010010; //5
            4'b0110: OUT <= 7'b0000010; //6
            4'b0111: OUT <= 7'b1111000; //7
            4'b1000: OUT <= 7'b0000000; //8
            4'b1001: OUT <= 7'b0010000; //9
            4'b1010: OUT <= 7'b1110111; //a
            4'b1011: OUT <= 7'b0011111; //b
            4'b1100: OUT <= 7'b0001101; //c 
            4'b1101: OUT <= 7'b0111101; //d
            4'b1110: OUT <= 7'b1001111; //e
            4'b1111: OUT <= 7'b1000111; //f
            default: OUT <= 7'b1111111;      
        endcase
    end
endmodule

module dec2to4(input [1:0] IN, output reg [3:0] OUT);
    always @(*) begin
        case (IN)
            2'b00: OUT = 4'b0001; //0
            2'b01: OUT = 4'b0010; //1
            2'b10: OUT = 4'b0100; //2
            2'b11: OUT = 4'b1000; //3
            default: OUT = 4'b0001; 
        endcase
    end
endmodule

module cnt(input clk, output reg [1:0] OUT=0);
    always @(posedge clk) begin
        OUT <= OUT + 1;
    end
endmodule

module TOP7ds(input [15:0] IN, input clk, output [6:0] digiout, output [3:0] A);
    wire [1:0] COout;
    reg [3:0] DIGIN;
    
    cnt CO(clk, COout);
    
    always @(*) begin 
        case (COout)
            2'b00: DIGIN <= IN[15:12];
            2'b01: DIGIN <= IN[11:8];
            2'b10: DIGIN <= IN[7:4];
            2'b11: DIGIN <= IN[3:0];
            default: DIGIN <= IN[3:0];       
        endcase
    end
    
    decoder_2_led TB(DIGIN, digiout);
    dec2to4 D24(COout, A);
endmodule

module tb();
    reg clk;
    reg [11:0] in;
    wire [6:0] digiout;
    wire [3:0] Aout;
    reg b1, b2, b3, pl;
    FULL F(in, b1, b2, b3, pl, clk, digiout, Aout);

    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin 
        pl = 0;
        b1 = 0;
        b2 = 0;
        b3 = 0;
        in = 12'b0000_0000_1000; 
        #10 pl = 1; b1 = 1;
        #10  in = 12'b0000_0000_0010; pl = 1; b1 = 0; b2 = 1;
        #10 pl = 0; b1 = 0;b2=0;
        #10 pl = 1; in = 12'b0000_0000_0001; 
        #10 pl = 1; b2 = 0; b3 = 1;
        #10 pl = 1; b2 = 0; b3 = 0;
        #10 pl = 0; b2 = 0; b3 = 0; b1 = 1;
        #10 pl = 0; b2 = 0; b3 = 0; b1 = 0;
        #10 pl = 0; b2 = 0; b3 = 0; b1 = 0;
        #10 pl = 0; b2 = 0; b3 = 0; b1 = 0;
        #50 $finish;
    end
endmodule

