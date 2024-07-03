`timescale 1ns / 1ps

module DIV(input [15:0] Din,input clk,input en, input pl,output reg out);
     reg [15:0] curr;
     reg front;
     always @(clk) begin
     if (en) begin
            if(pl) begin
                front = 0;
                curr = Din;
               end
            else begin
                curr=curr-1;
                if(curr==0) begin
                    front=~front;
                    curr=Din;
                    out=front;
                    end
            end
       end            
     end   
     
endmodule

module tb();
reg [15:0] din;
reg clk;
reg en;
reg  pl;
wire out;
DIV divizor(din,clk, en,  pl,out);
initial begin
clk = 0;
forever #10 clk = ~clk;
end
initial begin
#5 en = 0; din=16'b0000000000000010;

#5 en = 1; pl=1;
#10 en = 1; pl=0;
#100
#5 $finish;
end
endmodule