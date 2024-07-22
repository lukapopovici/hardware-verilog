`timescale 1ns / 1ps

module tb();

    reg clk;
    
    toplevel uut (.clk(clk));  

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        #200 $finish;
    end

endmodule
