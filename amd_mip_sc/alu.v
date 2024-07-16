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