module pipo # ( parameter LEN) (
    input wire clk,       
    input wire rst,      
    input wire load,      
    input wire [LEN-1:0] data,
    output reg [LEN-1:0] par_out  
);
    reg [LEN-1:0] shift_reg;   

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= {LEN{1'b0}};    
            par_out <= {LEN{1'b0}};
        end else if (load) begin
            shift_reg <= data;  
        end 
        par_out <= shift_reg; 
    end
endmodule