`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ȡָ��ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysIF(
    /* input */
    pc_srcM,pc_branchM,//pc_srcM����ѡ��pc��Դ��pcbranchM��EXEִ�����֮�������branch��ַ
    clk,clrn,load_use,jumpI,pc_jumpI,keepmdE,
    /* output */
    instrD,pcplus4D//to��ID��
    );
    
    input [31:0] pc_branchM,pc_jumpI;
    input clk,clrn,pc_srcM,load_use,jumpI,keepmdE;
    output [31:0] instrD,pcplus4D;
    
    /* �м���� */
    wire [31:0] pc;
    mux4_1 pc_mux(
        .in0(pcplus4F),.in1(pc_branchM),.in2(pc_jumpI),.in3({32'b0}),
        .sel({jumpI,pc_srcM}),.out(pc)
        );
    //assign pc = pc_srcM ? pc_branchM : pcplus4F;//pc_srcMΪ0ʱѡ��pcplus4F

    wire [31:0] pcF;    //pc�Ĵ������
    //pc�Ĵ�������
    dffe_32 pc_reg(
        .d(pc),
        .clk(clk),
        .clrn(clrn),
        .q(pcF),
        .e(~load_use & ~keepmdE)
    );
    
    //ָ��洢������
    wire [31:0] instrF;      //ָ��Ĵ����������
    prgrom instrmem(
        .clka(clk),
        .addra(pcF[15:2]),
        .douta(instrF)
    );
    
    //add4�ӷ�������
    wire [31:0] pcplus4F;
    addFour addFour(
        .pc(pcF),
        .pc_plus4(pcplus4F)
    );
    
    //ָ��Ĵ�������
    dff_32 instr_reg(
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
