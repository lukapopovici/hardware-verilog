module project(
    input [3:0] data_in,
    output reg [3:0] tmr0,
    input en,reset,clk1,clk2,clksel
    );
    
    reg clk;
    reg [7:0] tmr0 = 0; //sintetizabil pe fpga
    always begin
           if(clksel)
                 clk<=clk1;
           else
                 clk<=clk2; 
    end
    
    always @(posedge clk) begin
            if(reset) begin 
                    tmr0 = data_in;
            end
            else begin
                     tmr0=tmr0+1;
                            
            end  
    end
endmodule
