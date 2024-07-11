module rom (
    input clk,
    input enable,
    output [31:0] data
);
    reg [7:0] address = 0;
    reg [31:0] rom [99:0];  

    integer i;
    initial begin
        for (i = 0; i <= 99; i = i + 1) begin
           rom[i] = 32'h00_100_100;
        end
    end

    always @(posedge clk) begin
         if (enable) begin
            address <= address + 1;
         end
     end

    assign data = rom[address];

endmodule