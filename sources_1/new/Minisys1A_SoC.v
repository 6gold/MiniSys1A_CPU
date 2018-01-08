`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module Minisys1A_SoC(

    );
    
    wire [31:0] pc_branchM,instrD,pcplus4D;
    wire [31:0] alu_outW,read_dataW,pcplus4W;  //alu_out作为读写存储器的地址
    wire [31:0] result_to_writeW;
    wire [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    wire [31:0] alu_outM,write_dataM,pcplus4M;
    wire [4:0] write_regD;
    wire [4:0] write_regW;
    wire [4:0] rsE,rtE,rdE;
    wire [4:0] write_regM;
    wire [3:0] memwriteM;
    wire [3:0] alucontrolE,memwriteE;//memwriteE为4位，因为4个存储器各自有独立的写控制信号
    wire clk,clrn,pc_srcM,rst,clk_y;
    wire regwriteW;
    wire regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    wire write_$31E,op_beqE,op_bneE;
    wire op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    wire zeroM,carryM,overflowM;
    wire regwriteM,mem2regM,branchM;
    wire op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,jumpM;  
    wire mem2regW,write_$31W;
    wire load_use;
    wire [4:0] write_regE; 
    
    divclk divclk(.clk(clk_y),.rst(rst),.clk_sys(clk));
    
    MinisysIF MinisysIF(
        /* input */
        .pc_srcM(pc_srcM),.pc_branchM(pc_branchM),  //pc_srcM用于选择pc来源，pcbranchM是EXE执行完毕之后产生的branch地址
        .clk(clk),.clrn(clrn),.load_use(load_use),
        /* output */
        .instrD(instrD),.pcplus4D(pcplus4D)     //to【ID阶段】
        );
        
    MinisysID MinisysID(
        /* input */
        .instrD(instrD),.pcplus4D(pcplus4D),    //from【IF阶段】
        .clk(clk),.clrn(clrn),
        .write_regW(write_regW),         //【WB阶段】的写入地址：5bits
        .result_to_writeW(result_to_writeW),   //【WB阶段】的写入数据：32bits
        .regwriteW(regwriteW),          //【WB阶段】的写使能信号：1bits
        /* output */
        //to【EXE阶段】
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.branchE(branchE),
        .jumpE(jumpE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),//.regdstE(regdstE),//lwswE,//cu产生的控制信号
        .rd1E(rd1E),.rd2E(rd2E),          //寄存器堆读出的两个数
        .rsE(rsE),.rtE(rtE),.rdE(rdE),            //两种写回地址
        .signImmeE(signImmeE),          //扩展后的立即数：32bits
        .pcplus4E(pcplus4E),            //pcplus4
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),.load_use(load_use),.write_regE(write_regE)
        );
 
   MinisysEXE MinisysEXE(
            /* input（from【ID阶段】） */
        .clk(clk),.clrn(clrn),.write_regE(write_regE), 
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.regwriteW(regwriteW),
        .branchE(branchE),.jumpE(jumpE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),
        .regdstE(regdstE),//lwswE,//CU产生的控制信号
        .rd1E(rd1E),.rd2E(rd2E),      //alu的两个操作数    
        .rsE(rsE),.rtE(rtE),.rdE(rdE),        //两种写入地址
        .signImmeE(signImmeE),      //扩展后的立即数
        .pcplus4E(pcplus4E),       //pcplus4
        .result_to_writeW(result_to_writeW),
        //    regdst,alusrc,alucontrol,
        /* output（to【ID阶段】） */
        .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),.branchM(branchM),
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),
        //    zero,
        .zeroM(zeroM),.carryM(carryM),.overflowM(overflowM),//结果零，借位进位，溢出
        .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM),.pc_branchM(pc_branchM),     //送至MEM级的数据
        .pcplus4M(pcplus4M),.op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),
        .op_lwM(op_lwM),.write_$31M(write_$31M),.jumpM(jumpM)
        );
            
   MinisysMEM MinisysMEM(
         /* input*/
         .clk(clk),.clrn(clrn),
         //from【EXE阶段】
         .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),.branchM(branchM),
         .zeroM(zeroM),.io_data(io_data),
         .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM), 
         .op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),.op_lwM(op_lwM),
         .write_$31M(write_$31M),.pcplus4M(pcplus4M),    
         /* output */
         //to【WB阶段】
         .regwriteW(regwriteW),      //该信号作为下一个【ID阶段】的输入
         .mem2regW(mem2regW),.alu_outW(alu_outW),       //alu_out作为读写存储器的地址
         .read_dataW(read_dataW),
         .write_regW(write_regW),     //该组信号作为下一个【ID阶段】的输入
         .pc_srcM(pc_srcM),         //该信号作为下一个【IF阶段】的输入
         .write_$31W(write_$31W),
         .pcplus4W(pcplus4W)
         );
                
    MinisysWB MinisysWB(
          /* input */   
          .mem2regW(mem2regW),
          .alu_outW(alu_outW),.read_dataW(read_dataW),.write_$31W(write_$31W),
          .pcplus4M(pcplus4M),.write_regW(write_regW),
          /* output */
          .result_to_writeW(result_to_writeW),.write_regD(write_regD)
          ); 
          
    wire rst; 
    wire [31:0] io_data_in,io_data_out;
    wire [15:0] o_led;//led灯输出
    wire o_wreset;// reset signal from watchdog
    assign io_data_in = write_dataM;//io_data_in[15:0]写给IO
    interfaces interfaces(
          .clk(clk), //时钟
          .isReset(rst), //复位
          .isR(mem2regM), //让IO读，需要连一根线mem2regM(mem2regM),.memwriteM
          .isW(memwriteM),//让ID写，需要再连一根线
          .addr(alu_outM), //给接口的地址（就是要访问的接口的地址）
          .dR_inst(), //这两个不用管，不传参数没事的吧
          .dR_mem(),// 这两个不用管
          .dW(io_data_in[15:0]),  //给接口的数据 
          .o_led(o_led), //output:下面的各个参数下午跟史说过啦
          .i_switch(), //input
          .o_wreset(), //output
          .disp_data(),//out
          .disp_sel(), //out
          .pwm_out(),//out
          .pulse1(),//in
          .pulse2(),//in
          .cout1(),//out
          .cout2(),//out
          .row(),//input
          .col()//output
          );      
        
endmodule
