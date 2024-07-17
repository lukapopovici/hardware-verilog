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
            4'b0111: rez = (rd1 < rd2) ? 1 : 0;
            4'b1100: rez = ~(rd1 | rd2);
            default: rez = 0; 
        endcase
        zero = (rez == 0);
    end
endmodule
