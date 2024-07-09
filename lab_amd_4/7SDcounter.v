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
module decoder_2_led(input [3:0] IN, output reg [6:0] OUT);
always @(*) begin
        casex (IN)
        4'b0000: OUT<=1000000; //0
        4'b0001: OUT<=1111001; //1
        4'b0010: OUT<=0100100;  //2
        4'b0011: OUT<=0110000;  //3
        4'b0100: OUT<=0011001;  //4 
        4'b0101: OUT<=0010010; //5
        4'b0110: OUT<=0000010; //6
        4'b0111: OUT<=1111000; //7
        4'b1000: OUT<=0000000; //8
        4'b1001: OUT<=0010000; //9
        4'b1010: OUT<=1110111;  //a
        4'b1011: OUT<=0011111;  //b
        4'b1100: OUT<=0001101;  //c 
        4'b1101: OUT<=0111101; //d
        4'b1110: OUT<=1001111; //e
        4'b1111: OUT<=1000111; //f
        default: OUT<=1111111;      
        endcase
end

endmodule

module dec2to4(input [1:0] IN, output reg [3:0] OUT);
always @(*) begin
        case (IN)
        2'b00: OUT=4'b0001; //0
        2'b01: OUT=4'b0010; //1
        2'b10: OUT=4'b0100;  //2
        2'b11: OUT=4'b1000;  //3
        default: OUT=4'b1111;
              
        endcase
end

endmodule

module cnt(input clk,output reg [1:0] OUT=0);
always @(posedge clk) begin
        OUT<=OUT+1;
                    
end

endmodule

module top(input [15:0] IN, input clk, output [6:0] digiout, output [3:0] A);
    wire [1:0] COout;
    reg [3:0] DIGIN;
    
    cnt CO(clk,COout);
    
    always @(*) begin 
        case (COout)
        2'b00: DIGIN <=  IN[15:12];
         2'b01: DIGIN <= IN[11:8] ;
         2'b10: DIGIN <= IN[7:4];
         2'b11: DIGIN <= IN[3:0];
        default: DIGIN <= IN[3:0];       
        endcase
    end
    
    decoder_2_led TB(DIGIN,digiout);
    dec2to4 D24(COout, A);
    

endmodule

module tb();
reg clk;
reg [15:0] in;
wire [6:0] digiout;
wire [3:0] Aout;
top TB(in,clk,digiout,Aout);

 initial begin 
     clk = 0;
    forever begin
    #5 clk = ~clk;
    end
end

initial begin 
    #0 in=16'b0000_1101_1000_1100;
    #70 $finish;
end
endmodule