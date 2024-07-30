module piso # ( parameter LEN)(
    input wire clk,       
    input wire rst,      
    input wire load,      
    input wire [LEN-1:0] data,
    output reg serial_out  
);
    reg [LEN-1:0] shift_reg;   

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= {LEN{1'b0}};  
            serial_out <= 1'b0;  
        end else if (load) begin
            shift_reg <= data;  
        end else begin
            serial_out <= shift_reg[0]; 
            shift_reg <= shift_reg >> 1; 
        end
    end
endmodule