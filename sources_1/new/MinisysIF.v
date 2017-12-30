`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ȡָ��ģ��
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

    wire [31:0] pcF;    //pc�Ĵ������
    //pc�Ĵ�������
    dff_32 pc_reg(
        .d(pc),
        .clk(clk),
        .clrn(clrn),
        .q(pcF)
    );
    
    //ָ��洢������
    wire [31:0] instrF;      //ָ��Ĵ����������
    prgrom instrmem(
        .clka(clk),
        .addra(pc[15:2]),
        .douta(instrF)
    );
    
    //add4�ӷ�������
    wire [31:0] pcplus4F;
    addFour addFour(
        .pc(pcF),
        .pc_plus4(pcplus4F)
    );
    
    //ָ��Ĵ�������
    dff_32 IR(
        .d(instrF),
        .clk(clk),
        .clrn(clrn),
        .q(instrD)
    );
    
    //pc+4�Ĵ�������
    dff_32 pcplus4_reg(
        .d(pcplus4F),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4D)       
    );
    
 endmodule
