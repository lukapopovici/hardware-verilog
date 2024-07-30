`timescale 1ns / 1ps

module ALU# (parameter N = 8)(
    input [N-1:0] op1,
    input [N-1:0] op2,
    input [3:0] cmd,
    output reg [N-1:0] out,
    output reg over,
    output reg under,
    output reg err,
    output reg log
);
    always @(*) begin 
        out = 0;
        over = 0;
        under = 0;
        err = 0;
        log = 0;

        case (cmd)
            4'd0: begin
                out = op1 + op2;
                if (out < op1 || out < op2)
                    over = 1;
            end
            4'd1: begin
                out = op1 - op2;
                if (op1 < op2)
                    under = 1;
            end
            4'd2: begin
                out = op1 << op2; 
            end
            4'd3: begin
                out = op1 >> op2;
            end
            4'd4: begin
                log = (op1 == op2);
            end
            4'd5: begin
                log = (op1 > op2);
            end
            4'd6: begin
                log = (op1 < op2);
            end
            default: begin
                err = 1;
            end
        endcase
    end
endmodule

module test();
    reg [7:0] op1;
    reg [7:0] op2;
    reg [3:0] cmd;
    wire [7:0] out;
    wire err, over, under, log;
    reg [7:0] func_product;
    reg [3:0] mul;

    ALU #(.N(8)) alunelu(
        .op1(op1),
        .op2(op2),
        .cmd(cmd),
        .out(out),
        .over(over),
        .under(under),
        .err(err),
        .log(log)
    );

    // Multiplicare prin aditie repetata
    task multiply_task;
        input [7:0] a;
        output [7:0] result;
        reg [7:0] temp_a;
        reg [3:0] temp_b;
        integer i;
        begin
            temp_b = mul;
            result = 0;
            temp_a = a;
            temp_b = mul; 

            for (i = 0; i < temp_b; i = i + 1) begin
                op1 = result;
                op2 = temp_a;
                cmd = 4'd0;
                #10; //Latenta sa observam cum sa fac chestille
                result = out; 
            end
        end
    endtask

    initial begin
        mul = 4'b0011;  
        cmd = 4'b0000;    
        op1 = 8'b00001000;
        op2 = 8'b00001000;
        #10;
        
        multiply_task(8'b00001000, func_product);
        
        #10;
        $finish;
    end
endmodule