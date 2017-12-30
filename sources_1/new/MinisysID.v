`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ָ������ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysID(
    /* input */
    instrD,pcplus4D,clk,clrn,
    /* output */
    regwrite,mem2reg,memwrite,branch,jump,alucontrol,alusrc,regdst,lwsw,pcplus4E
    );
    
    /* �м���� */
    wire [5:0] op,func;
    wire [4:0] rs,rt,rd,shamt;
    wire [15:0] imme;
    assign op = instrD[31:26];
    assign rs = instrD[25:21];
    assign rt = instrD[20:16];
    assign rd = instrD[15:11];
    assign shamt = instrD[10:6];
    assign func = instrD[5:0];
    
    //����������
    controller controller(
        //����������Ҫ����decoder������decoder���������regwrite���ź�
    );
    
    //32*32bit�Ĵ���������
    wire [31:0] rd1D,rd2D;
    regfile_dataflow regfile(
        .rna(rs),
        .rnb(rt),
        .d(),//д������
        .wn(),//д���ַ
        .we(),//д��ʹ�ܶ�
        .clk(clk),
        .clrn(clrn),
        .qa(rd1D),
        .qb(rd2D)
    );
    
    //λ��չ���������з�����չ��
    wire [31:0] signImmeD;
    extend imme_extend_reg(
        .imm(imme),
        .ExtOp(1'b1),
        .result(signImmeD)
    );
    
    //�Ĵ��������cu�����ĸ������ź�
    wire [31:0] cu_out,cu_outE;
    assign cu_out = {regwrite,mem2reg,memwrite,branch,jump,alucontrol,alusrc,regdst,lwsw,pcplus4E,22'b0};
    dff_32 cu_out_reg(
        .d(cu_out),
        .clk(clk),
        .clrn(clrn),
        .q(cu_outE)      
    );
    
    //�Ĵ�������żĴ������ж�������rd1
    wire [31:0] rd1E;
    dff_32 rd1_reg(
        .d(rd1D),
        .clk(clk),
        .clrn(clrn),
        .q(rd1E)
    );
    
    //�Ĵ�������żĴ������ж�������rd2
    wire [31:0] rd2E;
    dff_32 rd2_reg(
        .d(rd2D),
        .clk(clk),
        .clrn(clrn),
        .q(rd2E)
    );
    
    //�Ĵ��������rt�����ݣ���32λ�Ĵ�����������
    dff_32 rt_reg(
        d,clk,clrn,q
    );
    
    //�Ĵ��������rd�����ݣ���32λ�Ĵ�����������
    dff_32 rd_reg(
        d,clk,clrn,q
    );
    
    //�Ĵ����������չ���32λ������
    wire [31:0] signImmeE;
    dff_32 signImme_reg(
        .d(signImmeD),
        .clk(clk),
        .clrn(clrn),
        .q(signImmeE)
    );
    
    //�Ĵ��������pcplus4������
    wire [31:0] pcplus4E;
    dff_32 pcplus4_reg(
        .d(pcplus4D),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4E)
    );
    
endmodule
