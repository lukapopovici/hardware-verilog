module mux2to1_behavioral #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire sel,
    output reg [WIDTH-1:0] y
);
    always @(*) begin
        if (sel)
            y = b;
        else
            y = a;
    end
endmodule
