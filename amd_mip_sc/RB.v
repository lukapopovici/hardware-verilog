module register_bank(
    input regwrite,
    input [4:0] ra1,
    input [4:0] ra2,
    input [4:0] wa,
    input [31:0] wd,
    output  [31:0] rd1,
    output  [31:0] rd2
);

    reg [31:0] registers [31:0];
    initial begin
      $readmemh("reg.mem", registers);
    end
        assign rd1 = registers[ra1];

        assign rd2 = registers[ra2];


    always @(posedge regwrite) begin
        if (regwrite) begin
            registers[wa] = wd;
        end
    end
endmodule
