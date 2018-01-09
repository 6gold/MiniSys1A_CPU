`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Minisys1A_CPU仿真
//////////////////////////////////////////////////////////////////////////////////

module Minisys1A_CPU_sim();
    reg clk_y=0,clrn=0;
    
    /*仿真用*/
    wire clk;
    //【IF】
    wire pc_srcM;               //用于选择pc来源
    wire [31:0] pc_branchM;     //EXE执行完毕之后产生的branch地址
    wire load_use;
    wire jumpI,keepmdE;         //keepmdE：乘除法进行中
    wire [31:0] pc_jumpI;
    wire [31:0] instrD,pcplus4D;//to【ID】
    //【ID】
    wire [4:0] write_regW;          //from【WB】：reg的写入地址
    wire [31:0] result_to_writeW;   //from【WB阶段】reg的写入数据
    wire regwriteW;                 //from【WB】reg的写使能信号
    /*EXE和WB乘除法相关结果前推*/
    wire mdcsE2D,keepmdE,mdcsW,multbusyE,multoverE,divbusyE,divoverE;
    wire [31:0] mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW;
    /*后推至EXE阶段*/
    wire regwriteE,mem2regE,branchE,alusrcE,regdstE;
    wire [3:0] memwriteE;           //4个存储器各自有独立的写控制信号
    wire [3:0] alucontrolE;
    wire [31:0] rd1E,rd2E;
    wire [4:0] rsE,rtE,rdE;
    wire [31:0] signImmeE,pcplus4E;
    wire op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    wire write_$31E,op_beqE,op_bneE;
    wire load_use;
    wire [4:0] write_regE;          //to【EXE】：reg的写入地址
    wire [1:0] alu_mdE;             //选择具体的四种乘除法操作
    wire mdE,MDPause;               //mdE:表示是乘除法;MDPause:乘除法阻塞信号
    wire [31:0] hi2rdataE,lo2rdataE;//hilo寄存器给通用寄存器的数据
    wire mfhiE,mfloE;
    //【EXE】
    wire mdcsE2W;
    wire [31:0] mdhidataE2W,mdlodataE2W,hi2rdataM,lo2rdataM;
    wire mfhiM,mfloM,rd1M;
    wire regwriteM,mem2regM,branchM;
    wire [3:0] memwriteM;
    wire zeroM,carryM,overflowM;
    wire op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M;
    wire [31:0] alu_outM,write_dataM,pcplus4M;    
    wire [4:0] write_regM;    
    //【MEM】
    wire mem2regW,write_$31W;
    wire [31:0] alu_outW,read_dataW,pcplus4W;  //alu_out作为读写存储器的地址
    wire [31:0] hi2rdataW,lo2rdataW;
    wire mfhiW,mfloW;
    //【WB】 
    wire [4:0] write_regD;
    wire [31:0] hi2regdataW,lo2regdataW;            

    Minisys1A_CPU Minisys1A_CPU(
        .clk_y(clk_y),
        .clrn(clrn),
        .io_data(),
        //【IF】
        .clk(clk),.pc_srcM(pc_srcM),.pc_branchM(pc_branchM),.load_use(load_use),
        .jumpI(jumpI),.keepmdE(keepmdE),.pc_jumpI(pc_jumpI),.instrD(instrD),.pcplus4D(pcplus4D),
        .write_regW(write_regW),.result_to_writeW(result_to_writeW),.regwriteW(regwriteW),
        .mdcsE2D(mdcsE2D),.keepmdE(keepmdE),.mdcsW(mdcsW),
        .multbusyE(multbusyE),.multoverE(multoverE),.divbusyE(divbusyE),.divoverE(divoverE),
        .mdhidataE2D(mdhidataE2D),.mdlodataE2D(mdlodataE2D),.mdhidataW(mdhidataW),.mdlodataW(mdlodataW),
        .regwriteE(regwriteE),.mem2regE(mem2regE),.branchE(branchE),.alusrcE(alusrcE),.regdstE(regdstE),
        .memwriteE(memwriteE),.alucontrolE(alucontrolE),.rd1E(rd1E),.rd2E(rd2E),
        .rsE(rsE),.rtE(rtE),.rdE(rdE),.signImmeE(signImmeE),.pcplus4E(pcplus4E),
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),.load_use(load_use),
        .write_regE(write_regE),.alu_mdE(alu_mdE),.mdE(mdE),.MDPause(MDPause),
        .hi2rdataE(hi2rdataE),.lo2rdataE(lo2rdataE),.mfhiE(mfhiE),.mfloE(mfloE),
        //【EXE】
        .mdcsE2W(mdcsE2W),.mdhidataE2W(mdhidataE2W),.mdlodataE2W(mdlodataE2W),
        .hi2rdataM(hi2rdataM),.lo2rdataM(lo2rdataM),
        .mfhiM(mfhiM),.mfloM(mfloM),.rd1M(rd1M),.regwriteM(regwriteM),.mem2regM(mem2regM),
        .branchM(branchM),.memwriteM(memwriteM),.zeroM(zeroM),.carryM(carryM),.overflowM(overflowM),
        .op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),.op_lwM(op_lwM),.write_$31M(write_$31M),
        .alu_outM(alu_outM),.write_dataM(write_dataM),.pcplus4M(pcplus4M),.write_regM(write_regM),
        //【MEM】
        .mem2regW(mem2regW),.write_$31W(write_$31W),.alu_outW(alu_outW),.read_dataW(read_dataW),
        .pcplus4W(pcplus4W),.hi2rdataW(hi2rdataW),.lo2rdataW(lo2rdataW),.mfhiW(mfhiW),.mfloW(mfloW), 
        //【WB】
        .write_regD(write_regD),.hi2regdataW(hi2regdataW),.lo2regdataW(lo2regdataW)        
    );
    initial begin
    forever #5 clk = ~clk;
    end
endmodule
