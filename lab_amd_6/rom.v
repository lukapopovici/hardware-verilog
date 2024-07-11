module rom (
    input clk,
    input reset,
    input enable,
    output [31:0] data
);
    reg [7:0] address; 
    reg [31:0] rom [99:0];  

    integer i;
    initial begin
        rom[0] = 32'h00000001;
        for (i = 1; i < 99; i = i + 1) begin
            rom[i] = 0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            address <= 0;
        else if (enable)
            address <= address + 1;
    end

    assign data = rom[address];

endmodule
