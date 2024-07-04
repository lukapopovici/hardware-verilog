
module sipo (
    input wire clk,        
    input wire rst,       
    input wire serial_in,  
    output reg [7:0] par_out 
);
    reg [7:0] shift_reg;   

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;     
            par_out <= 8'b0;      
        end else begin
            shift_reg <= {shift_reg[6:0], serial_in};
            par_out <= shift_reg; 
        end
    end
endmodule


module sipo_1 (
    input wire clk,        
    input wire rst,       
    input wire serial_in,  
    output reg par_out 
);
    reg  shift_reg;   

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;     
            par_out <= 0;      
        end else begin
            shift_reg <= serial_in;
            par_out <= shift_reg; 
        end
    end
endmodule