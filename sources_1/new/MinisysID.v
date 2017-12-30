`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 指令译码模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysID(
    /* input */
    instrD,pcplus4D,clk,clrn,
    /* output */
    regwrite,mem2reg,memwrite,branch,jump,alucontrol,alusrc,regdst,lwsw,pcplus4E
    );
    
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
    
    //控制器例化
    controller controller(
        //控制器里面要调用decoder并根据decoder的输出产生regwrite等信号
    );
    
    //32*32bit寄存器堆例化
    wire [31:0] rd1D,rd2D;
    regfile_dataflow regfile(
        .rna(rs),
        .rnb(rt),
        .d(),//写入数据
        .wn(),//写入地址
        .we(),//写入使能端
        .clk(clk),
        .clrn(clrn),
        .qa(rd1D),
        .qb(rd2D)
    );
    
    //位扩展器例化（有符号扩展）
    wire [31:0] signImmeD;
    extend imme_extend_reg(
        .imm(imme),
        .ExtOp(1'b1),
        .result(signImmeD)
    );
    
    //寄存器：存放cu产生的各控制信号
    wire [31:0] cu_out,cu_outE;
    assign cu_out = {regwrite,mem2reg,memwrite,branch,jump,alucontrol,alusrc,regdst,lwsw,pcplus4E,22'b0};
    dff_32 cu_out_reg(
        .d(cu_out),
        .clk(clk),
        .clrn(clrn),
        .q(cu_outE)      
    );
    
    //寄存器：存放寄存器堆中读出的数rd1
    wire [31:0] rd1E;
    dff_32 rd1_reg(
        .d(rd1D),
        .clk(clk),
        .clrn(clrn),
        .q(rd1E)
    );
    
    //寄存器：存放寄存器堆中读出的数rd2
    wire [31:0] rd2E;
    dff_32 rd2_reg(
        .d(rd2D),
        .clk(clk),
        .clrn(clrn),
        .q(rd2E)
    );
    
    //寄存器：存放rt的内容（用32位寄存器？？？）
    dff_32 rt_reg(
        d,clk,clrn,q
    );
    
    //寄存器：存放rd的内容（用32位寄存器？？？）
    dff_32 rd_reg(
        d,clk,clrn,q
    );
    
    //寄存器：存放扩展后的32位立即数
    wire [31:0] signImmeE;
    dff_32 signImme_reg(
        .d(signImmeD),
        .clk(clk),
        .clrn(clrn),
        .q(signImmeE)
    );
    
    //寄存器：存放pcplus4的内容
    wire [31:0] pcplus4E;
    dff_32 pcplus4_reg(
        .d(pcplus4D),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4E)
    );
    
endmodule
