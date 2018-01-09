`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 取指令模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysIF(
    /* input */
    pc_srcM,pc_branchM,//pc_srcM用于选择pc来源，pcbranchM是EXE执行完毕之后产生的branch地址
    clk,clrn,load_use,jumpI,pc_jumpI,keepmdE,
    /* output */
    instrD,pcplus4D//to【ID】
    );
    
    input [31:0] pc_branchM,pc_jumpI;
    input clk,clrn,pc_srcM,load_use,jumpI,keepmdE;
    output [31:0] instrD,pcplus4D;
    
    /* 中间变量 */
    wire [31:0] pc;
    mux4_1 pc_mux(
        .in0(pcplus4F),.in1(pc_branchM),.in2(pc_jumpI),.in3({32'b0}),
        .sel({jumpI,pc_srcM}),.out(pc)
        );
    //assign pc = pc_srcM ? pc_branchM : pcplus4F;//pc_srcM为0时选择pcplus4F

    wire [31:0] pcF;    //pc寄存器输出
    //pc寄存器例化
    dffe_32 pc_reg(
        .d(pc),
        .clk(clk),
        .clrn(clrn),
        .q(pcF),
        .e(~load_use & ~keepmdE)
    );
    
    //指令存储器例化
    wire [31:0] instrF;      //指令寄存器数据输出
    prgrom instrmem(
        .clka(clk),
        .addra(pcF[15:2]),
        .douta(instrF)
    );
    
    //add4加法器例化
    wire [31:0] pcplus4F;
    addFour addFour(
        .pc(pcF),
        .pc_plus4(pcplus4F)
    );
    
    //指令寄存器例化
    dff_32 instr_reg(
        .d(instrF),
        .clk(clk),
        .clrn(clrn),
        .q(instrD)
    );
    
    //pc+4寄存器例化
    dff_32 pcplus4_reg(
        .d(pcplus4F),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4D)       
    );
    
 endmodule
