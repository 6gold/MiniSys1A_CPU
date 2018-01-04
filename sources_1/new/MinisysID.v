`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 指令译码模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysID(
    /* input */
    instrD,pcplus4D,    //from【IF阶段】
    clk,clrn,
    write_regW,         //【WB阶段】的写入地址：5bits
    result_to_writeW,   //【WB阶段】的写入数据：32bits
    regwriteW,          //【WB阶段】的写使能信号：1bits
    /* output */
    //to【EXE阶段】
    regwriteE,mem2regE,memwriteE,branchE,jumpE,alucontrolE,alusrcE,regdstE,lwswE,//cu产生的控制信号
    rd1E,rd2E,          //寄存器堆读出的两个数
    rtE,rdE,            //两种写回地址
    signImmeE,          //扩展后的立即数：32bits
    pcplus4E,            //pcplus4
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,
    write_$31E,op_begE,op_bneE
    );
    
    input [31:0] instrD,pcplus4D;
    input clk,clrn,regwriteW;
    input [4:0] write_regW;
    input [31:0] result_to_writeW;

    output regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    output [3:0] alucontrolE,memwriteE;//memwriteE为4位，因为4个存储器各自有独立的写控制信号
    output [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    output [4:0] rtE,rdE;
    output op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    output write_$31E,op_beqE,op_bneE;
    
    /* 中间变量 */
    wire [5:0] op,func;
    wire [4:0] rs,rt,rd,shamt;
    wire [15:0] imme;
    assign op = instrD[31:26];
    assign rs = instrD[25:21];
    assign rt = instrD[20:16];
    assign rd = instrD[15:11];
    assign shamt = instrD[10:6];
    assign func = instrD[5:0];
    wire regwriteD,mem2regD,branchD,jumpD,alusrcD,regdstD,lwswD;
    wire [3:0] alucontrolD,memwriteD;
    wire [31:0] rd1D,rd2D,signImmeD,pcplus4D;
    
    //控制器例化
    wire op_lbD,op_lbuD,op_lhD,op_lhuD,op_lwD;
    wire op_sll,op_srl,op_sra;
    wire write_$31,write_$31D,branch;
    wire op_beqD,op_bneD,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal ;
    CU controller(
        //输入
        .op(op),.func(func),
        //输出
        .regwriteD(regwriteD),.mem2regD(mem2regD),.memwriteD(memwriteD),//.branchD(branch),
        .jumpD(jumpD),.alucontrolD(alucontrolD),.alusrcD(alusrcD),.regdstD(regdstD),.lwswD(lwswD),
        .op_lb(op_lbD),.op_lbu(op_lbuD),.op_lh(op_lhD),.op_lhu(op_lhuD),.op_lw(op_lwD),
        .op_sll(op_sll),.op_srl(op_srl),.op_sra(op_sra),
        .write_$31(write_$31),.op_beq(op_beqD),.op_bne(op_bneD),.op_bgez(op_bgez),
        .op_bgtz(op_bgtz),.op_blez(op_blez),.op_bltz(op_bltz),.op_bgezal(op_bgezal),
        .op_bltzal(op_bltzal)
          //      【控制器里面要调用decoder并根据decoder的输出产生regwriteD等信号】
    );
    
    //32*32bit寄存器堆例化
    regfile_dataflow regfile(
        .rna(rs),
        .rnb(rt),
        .d(result_to_writeW),//写入数据
        .wn(write_regW),//写入地址
        .we(regwriteW),//写入使能端
        .clk(clk),
        .clrn(clrn),
        .qa(rd11),
        .qb(rd2D)
    );
    wire [31:0] rd11;
    wire move;
    assign move = op_sra | op_sll | op_srl;
    assign rd1D = move?{27'b0,shamt}:rd11;
    
    wire zero,bgez,bgtz,blez,bltz,bgezal,bltzal,bge_bltzal;
    assign zero = (rd1D == 32'b0) ? 1 : 0;
    assign bgez = op_bgez & ~rd1D[31];
    assign bgtz = op_bgtz & ~rd1D[31] & ~zero;
    assign blez = op_blez & rd1D[31] | zero;
    assign bltz = op_bltz & rd1D[31];
    assign bgezal = op_bgezal & ~rd1D[31];
    assign bltzal = op_bltzal & rd1D[31];
    
    assign branchD = bgez | bgtz | blez | bltz | bgezal | bltzal; 
    assign bge_bltzal = bgezal | bltzal;
    assign write_$31D = write_$31 | bge_bltzal; 
    
    //16to32位扩展器例化（此处为有符号扩展）
    extend imme_extend_reg(
        .imm(imme),
        .ExtOp(1'b1),
        .result(signImmeD)
    );
    
    //寄存器：存放cu产生的各控制信号
    wire [31:0] cu_outD,cu_outE;
    assign cu_outD = {9'b0,op_beqD,op_bneD,op_lbD,op_lbuD,op_lhD,op_lhuD,op_lwD,write_$31D,regwriteD,mem2regD,branchD,jumpD,alusrcD,regdstD,lwswD,alucontrolD,memwriteD};
    dff_32 cu_out_reg(
        .d(cu_outD),
        .clk(clk),
        .clrn(clrn),
        .q(cu_outE)      
    );
    //解析各控制信号
    assign memwriteE    = cu_outE[3:0];
    assign alucontrolE  = cu_outE[7:4];
    assign lwswE        = cu_outE[8];
    assign regdstE      = cu_outE[9];
    assign alusrcE      = cu_outE[10];
    assign jumpE        = cu_outE[11];
    assign branchE      = cu_outE[12];    
    assign mem2regE     = cu_outE[13];
    assign regwriteE    = cu_outE[14];
    assign {op_beqE,op_bneE,op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E} = cu_outE[22:15];
    //寄存器：存放寄存器堆中读出的数rd1
    dff_32 rd1_reg(
        .d(rd1D),
        .clk(clk),
        .clrn(clrn),
        .q(rd1E)
    );
    
    //寄存器：存放寄存器堆中读出的数rd2
    dff_32 rd2_reg(
        .d(rd2D),
        .clk(clk),
        .clrn(clrn),
        .q(rd2E)
    );
    
    //寄存器：存放rt和rd的内容
    wire [31:0] rtrdD,rtrdE;
    assign rtrdD = {22'b0,rt,rd};
    dff_32 rt_rd_reg(
        .d(rtrdD),
        .clk(clk),
        .clrn(clrn),
        .q(rtrdE)
    );
    assign rtE = rtrdE[9:5];
    assign rdE = rtrdE[4:0];
    
    //寄存器：存放扩展后的32位立即数
    dff_32 signImme_reg(
        .d(signImmeD),
        .clk(clk),
        .clrn(clrn),
        .q(signImmeE)
    );
    
    //寄存器：存放pcplus4的内容
    dff_32 pcplus4_reg(
        .d(pcplus4D),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4E)
    );
  
endmodule
