`timescale 1ns / 1ps

module ALU# (parameter N = 8)(
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