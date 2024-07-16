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