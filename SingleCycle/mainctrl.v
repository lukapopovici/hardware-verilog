module main_control(
    input Zero,
    input [5:0] opcode,
    input [5:0] func,
    output reg alusrc,
    output reg extop,
    output reg regdst,
    output reg regwrite,
    output reg memwrite,
    output reg mem2reg,
    output reg branch,
    output reg jump,
    output reg [3:0] aluop
);

    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type instructions
                regdst = 1'b1;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b1;
                regwrite = 1'b1;
                extop = 1'b0;
                branch= 1'b0;
                jump=1'b0;

                case (func)
                    6'b100000: aluop = 4'b0010; // ADD
                    6'b100010: aluop = 4'b0110; // SUB
                    6'b100100: aluop = 4'b0000; // AND
                    6'b100101: aluop = 4'b0001; // OR
                    6'b101010: aluop = 4'b0111; // SLT
                    default: aluop = 4'b1111; 
                endcase
            end

            6'b100011: begin // LW
                regdst = 1'b0;
                alusrc = 1'b1;
                memwrite = 1'b0;
                mem2reg = 1'b1;
                regwrite = 1'b1;
                extop = 1'b1;
                aluop = 4'b0010; // ADD
                branch= 1'b0;
                jump=1'b0;
            end

            6'b101011: begin // SW
                regdst = 1'b0;
                alusrc = 1'b1;
                memwrite = 1'b1;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b1;
                branch= 1'b0;
                jump=1'b0;
                aluop = 4'b0010; // ADD
            end

            6'b000100: begin // BEQ
                regdst = 1'b0;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b1;
                branch= 1'b1;
                jump=1'b0;
                aluop = 4'b0110; // SUB
            end
            
            6'b000010: begin // JMP
                regdst = 1'b0;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b1;
                branch= 1'b0;
                jump=1'b1;
                aluop = 4'b0110; // SUB
            end

            default: begin // Invalid instruction
                regdst = 1'b0;
                alusrc = 1'b0;
                memwrite = 1'b0;
                mem2reg = 1'b0;
                regwrite = 1'b0;
                extop = 1'b0;
                aluop = 4'b1111;
            end
        endcase
    end
endmodule