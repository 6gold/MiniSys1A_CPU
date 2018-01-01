`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 指令执行模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysEXE(
    /* input（from【ID阶段】） */
    clk,clrn,  
    regwriteE,mem2regE,memwriteE,branchE,jumpE,alucontrolE,alusrcE,regdstE,lwswE,//CU产生的控制信号
    rd1E,rd2E,      //alu的两个操作数    
    rtE,rdE,        //两种写入地址
    signImmeE,      //扩展后的立即数
    pcplus4E,       //pcplus4
//    regdst,alusrc,alucontrol,
    /* output（to【ID阶段】） */
    regwriteM,mem2regM,memwriteM,branchM,
//    zero,
    zeroM,carryM,overflowM,//结果零，借位进位，溢出
    alu_outM,write_dataM,write_regM,pc_branchM     //送至MEM级的数据
    );
    
    input clk,clrn;
    input regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    input [3:0] memwriteE;      //四个存储亲都有独立的写控制信号
    input [3:0] alucontrolE;
    input [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    input [4:0] rtE,rdE;

    output zeroM,carryM,overflowM;
    output regwriteM,mem2regM,branchM;
    output [3:0] memwriteM;
    output [4:0] write_regM;   
    output [31:0] alu_outM,write_dataM,pc_branchM;
    
    /* 中间变量 */
    wire zeroE;
    wire [31:0] alu_srcaE,alu_srcbE,alu_outE,writr_dataE,pc_branchE;
    wire [4:0] write_regE;   
    assign alu_srcaE = rd1E;
    assign writr_dataE = rd2E;
    assign alu_srcbE = alusrc ? rd2E : signImmeE;           //alusrc为0时选择rd2   
    assign write_regE = regdst ? rtE : rdE;   //regdst位0时选择rt
    
    /* 元件例化 */
    
    //alu例化（alu要改一下，改成下面的输入输出↓）
    alu_32 alu(
        .alu_a(alu_srcaE),
        .alu_b(alu_srcbE),
        .alu_control(alucontrolE),
        .q(alu_outE),   //运算结果
        .cf(carryM),    //进位借位
        .of(overflowM), //溢出
        .zf(zeroE)      //结果是否为零
    );
    
    //addsub_32例化
    addsub_32 imme_pcplus4(
        .a({signImmeE[29:0],2'b00}),
        .b(pcplus4E),
        .sub_ctrl(1'b0),
        .s(pc_branchE),
        .cf(),
        .of()
    );

    //寄存器：存放cu产生的各控制信号、zero值、write_reg
    wire [31:0] cu_zero_writeE,cu_zero_writeM;
    assign cu_zero_writeE = {19'b0,regwriteE,mem2regE,branchE,zeroE,write_regE,memwriteE};
    dff_32 cu_zero_write_reg(
        .d(cu_zero_writeE),
        .clk(clk),
        .clrn(clrn),
        .q(cu_zero_writeM)
    );
    assign memwriteM = cu_zero_writeM[3:0];
    assign write_regM = cu_zero_writeM[8:4];
    assign zeroM = cu_zero_writeM[9];
    assign branchM = cu_zero_writeM[10];
    assign mem2regM = cu_zero_writeM[11];
    assign regwriteM = cu_zero_writeM[12];

    //寄存器：存alu_out
    dff_32 alu_out_reg(
        .d(alu_outE),
        .clk(clk),
        .clrn(clrn),
        .q(alu_outM)
    );
    
    //寄存器：存write_data
    dff_32 write_data_reg(
        .d(writr_dataE),
        .clk(clk),
        .clrn(clrn),
        .q(write_dataM)
    );
    
    //寄存器：存pcbranch
    dff_32 pcbranch_reg(
        .d(pc_branchE),
        .clk(clk),
        .clrn(clrn),
        .q(pc_branchM)
    );
    
endmodule
