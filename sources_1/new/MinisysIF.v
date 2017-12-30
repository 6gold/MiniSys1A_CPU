`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 取指令模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysIF(
    /* input */
    pc,clk,clrn,
    /* output */
    instrD,pcplus4D
    );
    
    input [31:0] pc;
    input clk,clrn;
    output [31:0] instrD,pcplus4D;

    wire [31:0] pcF;    //pc寄存器输出
    //pc寄存器例化
    dff_32 pc_reg(
        .d(pc),
        .clk(clk),
        .clrn(clrn),
        .q(pcF)
    );
    
    //指令存储器例化
    wire [31:0] instrF;      //指令寄存器数据输出
    prgrom instrmem(
        .clka(clk),
        .addra(pc[15:2]),
        .douta(instrF)
    );
    
    //add4加法器例化
    wire [31:0] pcplus4F;
    addFour addFour(
        .pc(pcF),
        .pc_plus4(pcplus4F)
    );
    
    //指令寄存器例化
    dff_32 IR(
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
