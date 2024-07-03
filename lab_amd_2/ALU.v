`timescale 1ns / 1ps


module ALU# (parameter N = 8)(
input [N-1:0]op1,input [N-1:0]op2, input [3:0]cmd, output reg [N-1:0]out, output reg over, output reg under, output reg err, output reg log
    );
    always @(*) begin 
        case (cmd)
          0: begin
           out = op1+op2;err=0;
           if (out < op1 || out < op2)
                  over=1;
                  log=0;
            end
          1: begin out=op1-op2 ; err=0; 
           if (out > op1 || out > op2)
                  under=1;
                   log=0;  
          end
         2: begin out=op1<<op2 ; err=0; log=0;over=0;under=0; end
          3: begin out=op1<<op2 ; err=0; log=0;over=0;under=0; end
         4: begin  log = op1==op2;  err=0;out=0;over=0;under=0; end
          5: begin  log = op1>op2 ; err=0;out=0;over=0;under=0; end
         6: begin  log = op1<op2 ; err=0;out=0;over=0;under=0;end
          default:
                err=1;
         endcase
    end
endmodule

module test();
reg [7:0] op1;
reg [7:0] op2;
wire [7:0] out;
reg [3:0] cmd;
wire err,over,under,log;
ALU #(.N(8)) alunelu(op1,op2, cmd, out, over,  under,  err, log);
initial begin
#10 op1=8'b00001111;op2=8'b00001111;cmd=4'b0000; //+
#10 op1=8'b11111111;op2=8'b11111111;cmd=4'b0000; //+
#10 op1=8'b00001111;op2=8'b00001111;cmd=4'b0001; //- 
#10 op1=8'b00001110;op2=8'b00000010;cmd=4'b0010; //shift
#10 op1=8'b00001111;op2=8'b00000010;cmd=4'b0011; //shift
#10 op1=8'b00001111;op2=8'b00001111;cmd=4'b0100; // ==
#10 op1=8'b00001111;op2=8'b00001111;cmd=4'b0101; // < 
#10 op1=8'b00001111;op2=8'b00000010;cmd=4'b0110; // >
#10 op1=8'b00001111;op2=8'b00000010;cmd=4'b0111; //ERR

#10 $finish;
end
endmodule