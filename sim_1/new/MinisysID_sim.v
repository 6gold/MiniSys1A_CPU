`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/10 13:05:47
// Design Name: 
// Module Name: MinisysID_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MinisysID_sim( );
    reg clk=0,clrn=0,regwriteW;
    reg [31:0] instrD,pcplus4D,result_to_writeW;
    reg [4:0] write_regW;
    reg mdcsE2D,keepmdE;
    reg [31:0] mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW;
    reg mdcsW,multbusyE,multoverE,divbusyE,divoverE;

    wire regwriteE,mem2regE,branchE,alusrcE;//regdstE,lwswE;
    wire [3:0] alucontrolE,memwriteE;//memwriteE为4位，因为4个存储器各自有独立的写控制信号
    wire [31:0] rd1E,rd2E,signImmeE,pcplus4E,pc_jumpI;
    wire [4:0] rsE,rtE,rdE,write_regE;
    wire op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    wire write_$31E,op_beqE,op_bneE,load_use;
    wire [1:0] alu_mdE;
    wire mdE;//表示是乘除法
    wire MDPause;//乘除法阻塞信号
    wire [31:0] hi2rdataE,lo2rdataE;
    wire mfhiE,mfloE,jumpI;
    MinisysID MinisysID(
    /* input */
    .instrD(instrD),.pcplus4D(pcplus4D),    //from【IF阶段】
    .clk(clk),.clrn(clrn),
    .write_regW(write_regW),         //【WB阶段】的写入地址：5bits
    .result_to_writeW(result_to_writeW),   //【WB阶段】的写入数据：32bits
    .regwriteW(regwriteW),          //【WB阶段】的写使能信号：1bits
    //EXE和WB乘除法相关结果前推
    .mdcsE2D(mdcsE2D),.keepmdE(keepmdE),
    .mdhidataE2D(mdhidataE2D),.mdlodataE2D(mdlodataE2D),
    .mdcsW(mdcsW),.mdhidataW(mdhidataW),.mdlodataW(mdlodataW),
    .multbusyE(multbusyE),.multoverE(multoverE),.divbusyE(divbusyE),.divoverE(divoverE),
    /* output */
    //to【EXE阶段】
    .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.branchE(branchE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),//lwswE,//cu产生的控制信号
    .rd1E(rd1E),.rd2E(rd2E),          //寄存器堆读出的两个数
    .rsE(rsE),.rtE(rtE),.rdE(rdE),            //两种写回地址
    .signImmeE(signImmeE),          //扩展后的立即数：32bits
    .pcplus4E(pcplus4E),            //pcplus4
    .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
    .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),.load_use(load_use),
    .write_regE(write_regE),.alu_mdE(alu_mdE),.mdE(mdE),.MDPause(MDPause),
    .hi2rdataE(hi2rdataE),.lo2rdataE(lo2rdataE),
    .mfhiE(mfhiE),.mfloE(mfloE),
    //to [IF]
    .pc_jumpI(pc_jumpI),.jumpI(jumpI)
    );

    initial begin
    clrn=1;
    	regwriteW=1;
    //32bit
    instrD=32'b00100000000000010000000000000001;
    pcplus4D=32'h00000004;
    result_to_writeW=32'b110;
    //5bit
    write_regW=5'b00110;
    //1bit exe写Hilo 乘除法
    mdcsE2D=0;
    keepmdE=0;
    //32bit 乘除结果  写回的值
    mdhidataE2D=32'ha;
    mdlodataE2D=32'ha;
    mdhidataW=32'ha;
    mdlodataW=32'hf;
    //1bit wr片选写Hilo  正在乘 除 
    mdcsW=0;
    multbusyE=0;
    multoverE=0;
    divbusyE=0;
    divoverE=0;
	forever
	#5 clk = ~clk;
	end
	

endmodule
