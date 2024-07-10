module ram(
input addr[7:0],
input clk,
input rw,
input [31:0] din,
output reg [31:0] OUT
    );
    
    reg [31:0] internal_mem [7:0];
    
    always @(posedge clk) begin
        if(rw == 0) begin 
            OUT = internal_mem[addr];
        end
        
        else begin 
            internal_mem[addr] = din;
            OUT <= internal_mem[addr];
        end
    end
    
endmodule
