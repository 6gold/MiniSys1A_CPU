`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ָ������ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysID(
    /* input */
    instrD,pcplus4D,    //from��IF�׶Ρ�
    clk,clrn,
    write_regW,         //��WB�׶Ρ���д���ַ��5bits
    result_to_writeW,   //��WB�׶Ρ���д�����ݣ�32bits
    regwriteW,          //��WB�׶Ρ���дʹ���źţ�1bits
    /* output */
    //to��EXE�׶Ρ�
    regwriteE,mem2regE,memwriteE,branchE,jumpE,alucontrolE,alusrcE,regdstE,lwswE,//cu�����Ŀ����ź�
    rd1E,rd2E,          //�Ĵ����Ѷ�����������
    rtE,rdE,            //����д�ص�ַ
    signImmeE,          //��չ�����������32bits
    pcplus4E            //pcplus4
    );
    
    input [31:0] instrD,pcplus4D;
    input clk,clrn,regwriteW;
    input [4:0] write_regW;
    input [31:0] result_to_writeW;

    output regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    output [3:0] alucontrolE,memwriteE;//memwriteEΪ4λ����Ϊ4���洢�������ж�����д�����ź�
    output [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    output [4:0] rtE,rdE;
    
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
    wire regwriteD,mem2regD,branchD,jumpD,alusrcD,regdstD,lwswD;
    wire [3:0] alucontrolD,memwriteD;
    wire [31:0] rd1D,rd2D,signImmeD,pcplus4D;
    
    //����������
    controller controller(
        //����op,func
        //���regwriteD,mem2regD,memwriteD,branchD,jumpD,alucontrolD,alusrcD,regdstD,lwswD
        
        ������������Ҫ����decoder������decoder���������regwriteD���źš�
    );
    
    //32*32bit�Ĵ���������
    regfile_dataflow regfile(
        .rna(rs),
        .rnb(rt),
        .d(result_to_writeW),//д������
        .wn(write_regW),//д���ַ
        .we(regwriteW),//д��ʹ�ܶ�
        .clk(clk),
        .clrn(clrn),
        .qa(rd1D),
        .qb(rd2D)
    );
    
    //16to32λ��չ���������˴�Ϊ�з�����չ��
    extend imme_extend_reg(
        .imm(imme),
        .ExtOp(1'b1),
        .result(signImmeD)
    );
    
    //�Ĵ��������cu�����ĸ������ź�
    wire [31:0] cu_outD,cu_outE;
    assign cu_outD = {17'b0,regwriteD,mem2regD,branchD,jumpD,alusrcD,regdstD,lwswD,alucontrolD,memwriteD};
    dff_32 cu_out_reg(
        .d(cu_outD),
        .clk(clk),
        .clrn(clrn),
        .q(cu_outE)      
    );
    //�����������ź�
    assign memwriteE    = cu_outE[3:0];
    assign alucontrolE  = cu_outE[7:4];
    assign lwswE        = cu_outE[8];
    assign regdstE      = cu_outE[9];
    assign alusrcE      = cu_outE[10];
    assign jumpE        = cu_outE[11];
    assign branchE      = cu_outE[12];    
    assign mem2regE     = cu_outE[13];
    assign regwriteE    = cu_outE[14];
    
    //�Ĵ�������żĴ������ж�������rd1
    dff_32 rd1_reg(
        .d(rd1D),
        .clk(clk),
        .clrn(clrn),
        .q(rd1E)
    );
    
    //�Ĵ�������żĴ������ж�������rd2
    dff_32 rd2_reg(
        .d(rd2D),
        .clk(clk),
        .clrn(clrn),
        .q(rd2E)
    );
    
    //�Ĵ��������rt��rd������
    wire [31:0] rtrdD,rtrdE;
    assign rtrdD = {22'b0,rt,rd};
    dff_32 rt_rd_reg(
        .d(rtrdD),
        .clk(clk),
        .clrn(clrn),
        .q(rtrdE)
    );
    assign rtE = rtrdE[9:5];
    assign rdE = rtrdE[4:0];
    
    //�Ĵ����������չ���32λ������
    dff_32 signImme_reg(
        .d(signImmeD),
        .clk(clk),
        .clrn(clrn),
        .q(signImmeE)
    );
    
    //�Ĵ��������pcplus4������
    dff_32 pcplus4_reg(
        .d(pcplus4D),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4E)
    );
    
endmodule
