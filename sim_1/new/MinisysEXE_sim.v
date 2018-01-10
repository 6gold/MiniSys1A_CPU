`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module MinisysEXE_sim();
    reg clk=0,clrn=0;
    
    wire multbusy,divbusy,multover,divover;
    wire mdcsE2D,mdcsE2W,keepmdE;
    wire [31:0] mdhidataE2W,mdlodataE2W,mdhidataE2D,mdlodataE2D;//乘除法运算结果后推到WB级
    
    MinisysEXE MinisysEXE(
        /* input（from【ID阶段】） */
        .clk(clk),.clrn(clrn),  
        .regwriteE(/*是否写回寄存器*/),
        .mem2regE(/*是否把mem读出的数写回寄存器*/),
        .memwriteE(/*是否写mem*/),
        .branchE(/*是否有条件跳转*/),
        .alucontrolE(/*alu控制信号*/),
        .alusrcE(/*alusrc为0时选择rd2,为1选立即数*/{1'b0}),//CU产生的控制信号
        .rd1E({32'h00000001}),.rd2E({32'hf0000002}),      //alu的两个操作数    
        .rsE(),.rtE(),.rdE(),    //两种写入地址
        .signImmeE(),      //扩展后的立即数
        .pcplus4E(),       //pcplus4
        .result_to_writeW(),.write_regE(),.regwriteW(),
        .alu_mdE(/*选择具体的乘除法操作*/{2'b00}),.mdE(/*表示当前指令是乘除法*/{1'b1}),//乘除法相关
        .hi2rdataE(),.lo2rdataE(),
        .mfhiE(),.mfloE(),
        /* output（to【ID阶段】） */
        .regwriteM(),.mem2regM(),.memwriteM(),.branchM(),
        .op_lbE(),.op_lbuE(),.op_lhE(),.op_lhuE(),.op_lwE(),.write_$31E(),
        .op_beqE(),.op_bneE(),
        .zeroM(),.carryM(),.overflowM(),//结果零，借位进位，溢出
        .alu_outM(),.write_dataM(),.write_regM(),.pc_branchM(),     //送至MEM级的数据
        .pcplus4M(),.op_lbM(),.op_lbuM(),.op_lhM(),.op_lhuM(),.op_lwM(),.write_$31M(),
        //乘除法相关
        .multbusy(),.divbusy(),.multover(),.divover(),                  //乘除法忙信号和结束信号
        .mdcsE2D(),.mdcsE2W(),.keepmdE(),
        .mdhidataE2W(),.mdlodataE2W(),                            //乘除法运算结果后推到WB级
        .mdhidataE2D(),.mdlodataE2D(),                            //乘除法运算结果前推到ID级     
        .hi2rdataM(),.lo2rdataM(),
        .mfhiM(),.mfloM(),.rd1M()//rd1M因为mthi mtlo指令需要 因此向后推一下     
    );
        
    initial begin
    #5 clrn=1;
    forever
    #5 clk = ~clk;
    end
endmodule
