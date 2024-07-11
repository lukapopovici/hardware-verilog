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
module rom (
    input clk,
    input enable,
    output [31:0] data
);
    reg [7:0] address; 
    reg [31:0] rom [99:0];  

    integer i;
    initial begin
        rom[0] = 32'h00100100;
        rom[1] = 32'h00100100;
        rom[2] = 32'h00100100;
        rom[3] = 32'h00100100;
        rom[4] = 32'h00100100;
        for (i = 1; i < 99; i = i + 1) begin
            rom[i] = 0;
        end
    end

    always @(posedge clk ) begin
         if (enable)
            address <= address + 1;
     end

    assign data = rom[address];

endmodule


module DIV(input clk,output reg out = 0);
     reg [15:0] curr = 0;
     integer target=16'b1000_0000_0000_0000;
     always @(clk) begin
           curr=curr+1;
                if(curr>=target) begin
                    out=~out;
                    curr=0;
            end
       end            
     
endmodule


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
                if (out < op1 || out < op2)
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

module boardinterface(input [31:0] s,input b1,b2,b3,clk,output [6:0] digiout, output [3:0] A);

reg [11:0] R1,R2;
reg [3:0] R3;
reg [1:0] DBcmd;

wire [11:0] ALUout;
reg [11:0] MUXout;
wire [3:0] sigs;
wire clk_div;
//DIV divizor(clk,clk_div);
ALU alu(R1,R2,R3,ALUout,sigs[0],sigs[1],sigs[2],sigs[3]);
TOP7ds display({MUXout,sigs},clk,digiout,A);

//multiplexorul
always @(*)begin 
    case (DBcmd)
    2'b00: MUXout<=ALUout;
    2'b01: MUXout<=R1;
    2'b10: MUXout<=R2;
    2'b11: MUXout<=R3;
    default: MUXout<=ALUout;
    endcase
end

always @(posedge clk) begin 
  R1<=s[31:19] ;
  R2<=s [19: 7];
  R3<=s [7:4];
end

always @(*)begin 

 begin 
    case ({b3,b2,b1})
     3'b000: DBcmd<=2'b00;
     3'b001: begin DBcmd<=2'b01; end 
     3'b010: begin DBcmd<=2'b10;  end
     3'b100: begin DBcmd<=2'b11; end
     default: DBcmd<=2'b00;
    endcase
end
    
end

endmodule

module decoder_2_led(input [3:0] IN, output reg [6:0] OUT);
always @(*) begin
        casex (IN)
        4'b0000: OUT<=0000001; //0
        4'b0001: OUT<=1001111; //1
        4'b0010: OUT<=0010010;  //2
        4'b0011: OUT<=0000110;  //3
        4'b0100: OUT<=1001100;  //4 
        4'b0101: OUT<=0010010; //5
        4'b0110: OUT<=0100000; //6
        4'b0111: OUT<=0001111; //7
        4'b1000: OUT<=0000000; //8
        4'b1001: OUT<=0000100; //9
        4'b1010: OUT<=0001000;  //a
        4'b1011: OUT<=1100000;  //b
        4'b1100: OUT<=1110010;  //c 
        4'b1101: OUT<=1000010; //d
        4'b1110: OUT<=0010000; //e
        4'b1111: OUT<=0111000; //f
        default: OUT<=1111111;      
        endcase
end

endmodule

module dec2to4(input [1:0] IN, output reg [3:0] OUT);
always @(*) begin
        case (IN)
        2'b00: OUT=4'b1110; //0
        2'b01: OUT=4'b1101; //1
        2'b10: OUT=4'b1011;  //2
        2'b11: OUT=4'b0111;  //3
        default: OUT=1111;
              
        endcase
end

endmodule

module cnt(input clk,output reg [1:0] OUT=2'b00);
always @(posedge clk) begin
        OUT<=OUT+1;
                    
end

endmodule

module TOP7ds(input [15:0] IN, input clk, output [6:0] digiout, output [3:0] A);
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

module topper(
input b1,
input b2,
input b3,
input clk,
output [6:0] digiout,
 output [3:0] A,
 input enable);
 
wire [31:0] data;

rom ROM(clk, enable,  data);

boardinterface BI( data,b1,b2,b3,clk, digiout,A);


endmodule

module tb();
reg b1,b2,b3,clk;
wire [6:0] digiout;
wire [3:0] A;
reg enable;

topper TOP(b1,b2,b3,clk,digiout, A,enable);


 initial begin 
     clk = 0;
    forever begin
    #5 clk = ~clk;
    end
end

initial begin
enable=1;b1=0;b2=0;b3=0;
#40 $finish;
end
endmodule
