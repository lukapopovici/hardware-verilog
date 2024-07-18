module toplevel();
    reg clk;
    wire [31:0] instruction;
    wire [31:0] adder_pc_in;
    wire [31:0] address;

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
    wire jump;
    wire branch;
    wire Zero;
    wire [31:0] rd;
    wire [31:0] extout;
    wire [4:0] wa;

   

    PC pc (
        .clk(clk),
        .addr(address),
        .in(B2_Mux_Out)
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
        .clk(clk),
        .rd1(rd1),
        .rd2(rd2)
    );

    Instr_Mem IM (
        .addr(adder_pc_in),
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
        .aluop(aluop),
        .jump(jump),
        .branch(branch)
    );

    MUX #(.SIZE(32)) alusrc_mux (
        .op1(extout),
        .op2(rd2),
        .sig(alusrc),
        .out(rd2_alu)
    );

    MUX #(.SIZE(32)) mem2reg_mux (
        .op1(alu_rez),
        .op2(rd_dm),
        .sig(mem2reg),
        .out(rd)
    );

    MUX #(.SIZE(5)) regdst_mux (
        .op1(instruction[15:11]),
        .op2(instruction[20:16]),
        .sig(regdst),
        .out(wa)
    );
    
    wire [27:0] jmp_addr;
    
    shifter #(.SIZE(28),.SHIFTVAL(2)) SH_PC(
        .in(instruction[27:0]),
        .out(jmp_addr)
    );
    
    wire [31:0] ext_shft;
    
    shifter #(.SIZE(32),.SHIFTVAL(2)) SH_ALU(
        .in(extout),
        .out(ext_shft)
    );
    
    wire [31:0] alu_sht_out;
    
    wire [31:0] B1_Mux_Out;
    
    wire [31:0] B2_Mux_Out;
     
    TwoOpAdder TwoAdd(.op2(adder_pc_in),.op1(ext_shft),.out(alu_sht_out));
     
    MUX  #(.SIZE(32)) Branch2_mux (
        .op1({adder_pc_in[31:28],jmp_addr}),
        .op2(B1_Mux_Out),
        .sig(jump),
        .out(B2_Mux_Out)
    );
    
    
    
    MUX  #(.SIZE(32)) Branch1_mux (
        .op1(alu_sht_out),
        .op2(adder_pc_in),
        .sig((Zero && branch)),
        .out(B1_Mux_Out)
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
