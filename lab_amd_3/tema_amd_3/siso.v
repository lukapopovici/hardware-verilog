module siso (
    input wire clk,        
    input wire rst,        
    input wire serial_in,  
    output reg serial_out  
);
    reg [7:0] shift_reg;  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;    
            serial_out <= 1'b0;    
        end else begin
            serial_out <= shift_reg[7]; 
            shift_reg <= {shift_reg[6:0], serial_in}; 
        end
    end
endmodule

module siso_1 (
    input wire clk,        
    input wire rst,        
    input wire serial_in,  
    output reg serial_out  
);
    reg  shift_reg;  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;    
            serial_out <= 0;    
        end else begin
            serial_out <= shift_reg; 
            shift_reg <= serial_in; 
        end
    end
endmodule
