`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ȡָ��ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysIF(
    /* input */
    pc_srcM,pcbranchM,  //pc_srcM����ѡ��pc��Դ��pcbranchM��EXEִ�����֮�������branch��ַ
    clk,clrn,
    /* output */
    instrD,pcplus4D     //to��ID�׶Ρ�
    );
    
    input [31:0] pcbranchM;
    input clk,clrn,pc_srcM;
    output [31:0] instrD,pcplus4D;
    
    /* �м���� */
    wire [31:0] pc;
    assign pc = pc_srcM ? pcplus4F : pcbranchM;//pc_srcMΪ0ʱѡ��pcplus4F

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
