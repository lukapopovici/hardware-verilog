module toplevel();
    reg clk;
    wire [31:0] instruction;
    wire [31:0] adder_pc_in;
    wire [31:0] address;
    wire [31:0] lagged_address;

    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [31:0] rd2_alu;
    wire [31:0] alu_rez;

    wire regdst;
    wire extop;
    wire alusrc;
    wire [3:0] aluop;
    wire mem2reg;
    wire memwrite;
    wire regwrite;
    wire Zero;
    wire [31:0] rd;
    wire [31:0] extout;
    wire [4:0] wa;

    lagger lagger_inst (
        .in(address),
        .out(lagged_address),
        .clk(clk)
    );

    // PC module
    PC pc (
        .clk(clk),
        .addr(address),
        .in(adder_pc_in)
    );

    adder add (
        .op1(address),
        .out(adder_pc_in)
    );

    ALU alu (
        .rd1(rd1),
        .rd2(rd2_alu),
        .op(aluop),
        .rez(alu_rez),
        .zero(Zero)
    );

    register_bank rb (
        .regwrite(regwrite),
        .ra1(instruction[25:21]),
        .ra2(instruction[20:16]),
        .wa(wa),
        .wd(rd),
        .rd1(rd1),
        .rd2(rd2)
    );

    Instr_Mem IM (
        .addr(address),
        .instr(instruction)
    );

    extsign ex (
        .extop(extop),
        .original(instruction[15:0]),
        .out(extout)
    );

    wire [31:0] rd_dm; 

    DM dm (
        .clk(clk),
        .memwrite(memwrite),
        .addr(alu_rez),
        .wd(rd2),
        .rd(rd_dm)
    );

    main_control MC (
        .Zero(Zero),
        .opcode(instruction[31:26]),
        .func(instruction[5:0]),
        .alusrc(alusrc),
        .extop(extop),
        .regdst(regdst),
        .regwrite(regwrite),
        .memwrite(memwrite),
        .mem2reg(mem2reg),
        .aluop(aluop)
    );

    MUX #(.SIZE(32)) alusrc_mux (
        .op1(rd2),
        .op2(extout),
        .sig(alusrc),
        .out(rd2_alu)
    );

    MUX #(.SIZE(32)) mem2reg_mux (
        .op1(rd_dm),
        .op2(alu_rez),
        .sig(mem2reg),
        .out(rd)
    );

    MUX #(.SIZE(5)) regdst_mux (
        .op1(instruction[15:11]),
        .op2(instruction[20:16]),
        .sig(regdst),
        .out(wa)
    );

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

