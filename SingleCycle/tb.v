module tb();
    
    reg clk;

    toplevel(clk)
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