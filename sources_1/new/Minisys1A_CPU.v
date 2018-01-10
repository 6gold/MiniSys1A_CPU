`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: CPU顶层文件
//////////////////////////////////////////////////////////////////////////////////

module Minisys1A_CPU(
    clk,clrn,io_data,
    /*仿真用out*/
    //【IF】
    clk,pc_branchM,load_use,jumpI,keepmdE,pc_jumpI,instrD,pcplus4F,pcplus4D,pc,pcF,
    //【ID】
    write_regW,result_to_writeW,regwriteW,mdcsE2D,mdcsW,multbusyE,multoverE,divbusyE,divoverE,
    mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW,regwriteE,mem2regE,branchE,alusrcE,
    memwriteE,alucontrolE,rd1E,rd2E,rsE,rtE,rdE,signImmeE,pcplus4E,
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,op_beqE,op_bneE,
    write_regE,alu_mdE,mdE,MDPause,hi2rdataE,lo2rdataE,mfhiE,mfloE,rd11,
    //【EXE】
    mdcsE2W,mdhidataE2W,mdlodataE2W,hi2rdataM,lo2rdataM,
    mfhiM,mfloM,rd1M,regwriteM,mem2regM,branchM,memwriteM,zeroM,carryM,overflowM,
    op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,alu_outM,write_dataM,pcplus4M,write_regM,
    alu_srcaE,alu_srcbE,alu_b,fwda,fwdb,alu_outE,
    //【MEM】
    mem2regW,write_$31W,alu_outW,read_dataW,pcplus4W,hi2rdataW,lo2rdataW,mfhiW,mfloW, 
    //【WB】
    write_regD,hi2regdataW,lo2regdataW,
    rs,rt,rd,rd1D,rd2D
    );
    input clk,clrn;
    input [31:0] io_data;
  
//    output wire clk;   
//    divclk divclk(.clk(clk),.rst(clrn),.clk_sys(clk));
    
    //【IF】
    output wire branchM;               //用于选择pc来源
    output wire [31:0] pc_branchM;     //EXE执行完毕之后产生的branch地址
    output wire load_use;
    output wire jumpI,keepmdE;         //keepmdE：乘除法进行中
    output wire [31:0] pc_jumpI;
    output wire [31:0] instrD,pcplus4F,pcplus4D,pc,pcF;//to【ID】
    MinisysIF MinisysIF(
        /* input */
        .branchM(branchM),.pc_branchM(pc_branchM),
        .clk(clk),.clrn(clrn),.load_use(load_use),
        .jumpI(jumpI),.pc_jumpI(pc_jumpI),.keepmdE(keepmdE),
        /* output */
        .instrD(instrD),.pcplus4D(pcplus4D),.pcplus4F(pcplus4F),.pc(pc),.pcF(pcF)
        );

    //【ID】
    output wire [4:0] write_regW;          //from【WB】：reg的写入地址
    output wire [31:0] result_to_writeW;   //from【WB阶段】reg的写入数据
    output wire regwriteW;                 //from【WB】reg的写使能信号
    /*EXE和WB乘除法相关结果前推*/
    output wire mdcsE2D,mdcsW,multbusyE,multoverE,divbusyE,divoverE;
    output wire [31:0] mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW;
    /*后推至EXE阶段*/
    output wire regwriteE,mem2regE,branchE,alusrcE;
    output wire [3:0] memwriteE;           //4个存储器各自有独立的写控制信号
    output wire [3:0] alucontrolE;
    output wire [31:0] rd1E,rd2E;
    output wire [4:0] rsE,rtE,rdE;
    output wire [31:0] signImmeE,pcplus4E;
    output wire op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    output wire write_$31E,op_beqE,op_bneE;
    output wire [4:0] write_regE;          //to【EXE】：reg的写入地址
    output wire [1:0] alu_mdE;             //选择具体的四种乘除法操作
    output wire mdE,MDPause;               //mdE:表示是乘除法;MDPause:乘除法阻塞信号
    output wire [31:0] hi2rdataE,lo2rdataE;//hilo寄存器给通用寄存器的数据
    output wire mfhiE,mfloE;
    output wire [4:0] rs,rt,rd;
    output wire [31:0] rd1D,rd2D,rd11;
    MinisysID MinisysID(
        /* input */
        .instrD(instrD),.pcplus4D(pcplus4D),//from【IF】
        .clk(clk),.clrn(clrn),
        .write_regW(write_regW),
        .result_to_writeW(result_to_writeW),
        .regwriteW(regwriteW),
        //EXE和WB乘除法相关结果前推
        .mdcsE2D(mdcsE2D),.keepmdE(keepmdE),
        .mdhidataE2D(mdhidataE2D),.mdlodataE2D(mdlodataE2D),
        .mdcsW(mdcsW),.mdhidataW(mdhidataW),.mdlodataW(mdlodataW),
        .multbusyE(multbusyE),.multoverE(multoverE),.divbusyE(divbusyE),.divoverE(divoverE),
        /* output */
        //to【EXE阶段】
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.branchE(branchE),
        .alucontrolE(alucontrolE),.alusrcE(alusrcE),//cu产生的控制信号
        .rd1E(rd1E),.rd2E(rd2E),          //寄存器堆读出的两个数
        .rsE(rsE),.rtE(rtE),.rdE(rdE),    //两种写回地址
        .signImmeE(signImmeE),            //扩展后的立即数：32bits
        .pcplus4E(pcplus4E),              //pcplus4
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),.load_use(load_use),.write_regE(write_regE),
        .alu_mdE(alu_mdE),.mdE(mdE),.MDPause(MDPause),
        .hi2rdataE(hi2rdataE),.lo2rdataE(lo2rdataE),
        .mfhiE(mfhiE),.mfloE(mfloE),
        .pc_jumpI(pc_jumpI),.jumpI(jumpI),
        /*仿真*/
        .rs(rs),.rt(rt),.rd(rd),.rd1D(rd1D),.rd2D(rd2D),.rd11(rd11)
        );

   //【EXE】
   output wire mdcsE2W;
   output wire [31:0] mdhidataE2W,mdlodataE2W,hi2rdataM,lo2rdataM;
   output wire mfhiM,mfloM,rd1M;
   output wire regwriteM,mem2regM;
   output wire [3:0] memwriteM;
   output wire zeroM,carryM,overflowM;
   output wire op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M;
   output wire [31:0] alu_outM,write_dataM,pcplus4M;    
   output wire [4:0] write_regM;
   output [31:0] alu_srcaE,alu_srcbE,alu_b,alu_outE;
   output [1:0] fwda,fwdb;
   MinisysEXE MinisysEXE(
        /* input（from【ID阶段】） */
        .clk(clk),.clrn(clrn), 
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),
        .branchE(branchE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),//以上均为CU产生的控制信号
        .rd1E(rd1E),.rd2E(rd2E),        //alu的两个操作数    
        .rsE(rsE),.rtE(rtE),.rdE(rdE),  //两种写入地址
        .signImmeE(signImmeE),          //扩展后的立即数
        .pcplus4E(pcplus4E),            //pcplus4
        .result_to_writeW(result_to_writeW),.write_regE(write_regE),.regwriteW(regwriteW),
        .alu_mdE(alu_mdE),.mdE(mdE),//乘除法相关
        .hi2rdataE(hi2rdataE),.lo2rdataE(lo2rdataE),
        .mfhiE(mfhiE),.mfloE(mfloE),                
        /* output（to【ID阶段】） */
        .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),.branchM(branchM),
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),
        .zeroM(zeroM),.carryM(carryM),.overflowM(overflowM),//结果零，借位进位，溢出
        .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM),.pc_branchM(pc_branchM),     //送至MEM级的数据
        .pcplus4M(pcplus4M),.op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),
        .op_lwM(op_lwM),.write_$31M(write_$31M),
        .multbusy(multbusyE),.divbusy(divbusyE),.multover(multoverE),.divover(divoverE),//乘除法忙信号和结束信号
        .mdcsE2D(mdcsE2D),.mdcsE2W(mdcsE2W),.keepmdE(keepmdE),//hilo写使能信号和乘除法进行中信号
        .mdhidataE2W(mdhidataE2W),.mdlodataE2W(mdlodataE2W),//乘除法运算结果后推到WB级
        .mdhidataE2D(mdhidataE2D),.mdlodataE2D(mdlodataE2D),//乘除法运算结果前推到ID级
        .hi2rdataM(hi2rdataM),.lo2rdataM(lo2rdataM),//hilo送到reg的数据
        .mfhiM(mfhiM),.mfloM(mfloM),.rd1M(rd1M),//rd1M因为mthi mtlo指令需要 因此向后推一下
        .fwda(fwda),.fwdb(fwdb),
        .alu_srcaE(alu_srcaE),.alu_srcbE(alu_srcbE),.alu_b(alu_b),.alu_outE(alu_outE)
        );
 
   //【MEM】
   output wire mem2regW,write_$31W;
   output wire [31:0] alu_outW,read_dataW,pcplus4W;  //alu_out作为读写存储器的地址
   output wire [31:0] hi2rdataW,lo2rdataW;
   output wire mfhiW,mfloW;       
   MinisysMEM MinisysMEM(
         /* input*/
         .clk(clk),.clrn(clrn),
         //from【EXE阶段】
         .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),
         .zeroM(zeroM),.io_data(io_data),
         .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM), 
         .op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),.op_lwM(op_lwM),
         .write_$31M(write_$31M),.pcplus4M(pcplus4M),
         .hi2rdataM(hi2rdataM),.lo2rdataM(lo2rdataM),
         .mfhiM(mfhiM),.mfloM(mfloM),        
         /* output */
         //to【WB阶段】
         .regwriteW(regwriteW),      //该信号作为下一个【ID阶段】的输入
         .mem2regW(mem2regW),.alu_outW(alu_outW),       //alu_out作为读写存储器的地址
         .read_dataW(read_dataW),
         .write_regW(write_regW),     //该组信号作为下一个【ID阶段】的输入
         .write_$31W(write_$31W),
         .pcplus4W(pcplus4W),
         .hi2rdataW(hi2rdataW),.lo2rdataW(lo2rdataW),
         .mfhiW(mfhiW),.mfloW(mfloW)
         );
    
    //【WB】
    output wire [4:0] write_regD;
    output wire [31:0] hi2regdataW,lo2regdataW;            
    MinisysWB MinisysWB(
          /* input */   
          .mem2regW(mem2regW),
          .alu_outW(alu_outW),.read_dataW(read_dataW),.write_$31W(write_$31W),
          .pcplus4W(pcplus4W),.write_regW(write_regW),
          .mdcsE2W(mdcsE2W),
          .mdhidataE2W(mdhidataE2W),.mdlodataE2W(mdlodataE2W),//乘除法运算结果后推到WB级
          .hi2rdataW(hi2rdataW),.lo2rdataW(hi2rdataW),
          .mfhiW(mfhiW),.mfloW(mfhiW),
          /* output */
          .result_to_writeW(result_to_writeW),.write_regD(write_regD),
          .mdcsW(mdcsW),.mdhidataW(mdhidataW),.mdlodataW(mdlodataW),//WB级写回的乘除法运算结果
          .hi2regdataW(hi2regdataW),.lo2regdataW(lo2regdataW)   
          ); 
         
      wire [31:0] io_data;
//    wire rst; 
//    wire [31:0] io_data_in,io_data_out;
//    wire [15:0] i_switch;//拨码开关输入
//    wire [15:0] o_led;//led灯输出
//    wire o_wreset;// reset signal from watchdog
//    wire [7:0] disp_data,disp_sel;//数码管输出
//    wire pwm_out;//脉冲输出
//    wire cout1,cout2;//定时器输出
//    wire [3:0] row,col;
//    wire pulse1,pulse2;
//    assign io_data_in = write_dataM;//io_data_in[15:0]写给IO
//    interfaces interfaces(
//          .clk(clk), //时钟
//          .isReset(rst), //复位
//          .isR(mem2regM), //让IO读，需要连一根线mem2regM(mem2regM),.memwriteM
//          .isW(memwriteM),//让ID写，需要再连一根线
//          .addr(alu_outM), //给接口的地址（就是要访问的接口的地址）
//          .dR_inst(), //这两个不用管，不传参数没事的吧
//          .dR_mem(),// 这两个不用管
//          .dW(io_data_in[15:0]),  //给接口的数据 
//          .o_led(o_led), //output:下面的各个参数下午跟史说过啦
//          .i_switch(), //input
//          .o_wreset(o_wreset), //output
//          .disp_data(disp_data),//out
//          .disp_sel(disp_sel), //out
//          .pwm_out(pwm_out),//out
//          .pulse1(pulse1),//in
//          .pulse2(pulse2),//in
//          .cout1(cout1),//out
//          .cout2(cout2),//out
//          .row(row),//input
//          .col(col)//output
//          );      
        
endmodule
