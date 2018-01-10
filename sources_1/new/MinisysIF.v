`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ȡָ��ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysIF(
    /* input */
    branchM,pc_branchM,//branchM����ѡ��pc��Դ��pc_branchM��EXEִ�����֮�������branch��ַ
    clk,clrn,load_use,jumpI,pc_jumpI,keepmdE,
    /* output */
    instrD,pcplus4F,pcplus4D,pc,pcF,instrF,sel//to��ID��
    );
    
    input [31:0] pc_branchM,pc_jumpI;
    input clk,clrn,branchM,load_use,jumpI,keepmdE;
    output [31:0] instrD,pcplus4D;
    
    /* �м���� */
    output wire [31:0] pc;//nextpc
    output wire [31:0] pcplus4F;
    output wire [1:0] sel;
    assign  sel = {jumpI,branchM};
    mux4_1 pc_mux(
        .in0(pcplus4F),.in1(pc_branchM),.in2(pc_jumpI),.in3({32'b0}),
        .sel({jumpI,branchM}),.out(pc)
    );
    
    output wire [31:0] pcF;    //pc�Ĵ������
    //pc�Ĵ�������
    dffe_32 pc_reg(
        .d(pc),
        .clk(clk),
        .clrn(clrn),
        .q(pcF),
        .e(~load_use & ~keepmdE)
    );
    
    //ָ��洢������
    output wire [31:0] instrF;      //ָ��Ĵ����������
//    wire [31:0] instrF;      //ָ��Ĵ����������
    prgrom instrmem(
        .clka(clk),
        .addra(pcF[15:2]),
        .douta(instrF)
    );
    
    //add4�ӷ�������
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
