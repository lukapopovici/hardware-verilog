module mux2to1_structural #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire sel,
    output wire [WIDTH-1:0] y
);
    wire [WIDTH-1:0] not_sel;
    wire [WIDTH-1:0] and_a;
    wire [WIDTH-1:0] and_b;

    assign not_sel = {WIDTH{~sel}};
    assign and_a = a & not_sel;
    assign and_b = b & {WIDTH{sel}};
    assign y = and_a | and_b;

endmodule
