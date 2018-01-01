`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ָ��ִ��ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysEXE(
    /* input��from��ID�׶Ρ��� */
    clk,clrn,  
    regwriteE,mem2regE,memwriteE,branchE,jumpE,alucontrolE,alusrcE,regdstE,lwswE,//CU�����Ŀ����ź�
    rd1E,rd2E,      //alu������������    
    rtE,rdE,        //����д���ַ
    signImmeE,      //��չ���������
    pcplus4E,       //pcplus4
//    regdst,alusrc,alucontrol,
    /* output��to��ID�׶Ρ��� */
    regwriteM,mem2regM,memwriteM,branchM,
//    zero,
    zeroM,carryM,overflowM,//����㣬��λ��λ�����
    alu_outM,write_dataM,write_regM,pc_branchM     //����MEM��������
    );
    
    input clk,clrn;
    input regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    input [3:0] memwriteE;      //�ĸ��洢�׶��ж�����д�����ź�
    input [3:0] alucontrolE;
    input [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    input [4:0] rtE,rdE;

    output zeroM,carryM,overflowM;
    output regwriteM,mem2regM,branchM;
    output [3:0] memwriteM;
    output [4:0] write_regM;   
    output [31:0] alu_outM,write_dataM,pc_branchM;
    
    /* �м���� */
    wire zeroE;
    wire [31:0] alu_srcaE,alu_srcbE,alu_outE,writr_dataE,pc_branchE;
    wire [4:0] write_regE;   
    assign alu_srcaE = rd1E;
    assign writr_dataE = rd2E;
    assign alu_srcbE = alusrc ? rd2E : signImmeE;           //alusrcΪ0ʱѡ��rd2   
    assign write_regE = regdst ? rtE : rdE;   //regdstλ0ʱѡ��rt
    
    /* Ԫ������ */
    
    //alu������aluҪ��һ�£��ĳ�����������������
    alu_32 alu(
        .alu_a(alu_srcaE),
        .alu_b(alu_srcbE),
        .alu_control(alucontrolE),
        .q(alu_outE),   //������
        .cf(carryM),    //��λ��λ
        .of(overflowM), //���
        .zf(zeroE)      //����Ƿ�Ϊ��
    );
    
    //addsub_32����
    addsub_32 imme_pcplus4(
        .a({signImmeE[29:0],2'b00}),
        .b(pcplus4E),
        .sub_ctrl(1'b0),
        .s(pc_branchE),
        .cf(),
        .of()
    );

    //�Ĵ��������cu�����ĸ������źš�zeroֵ��write_reg
    wire [31:0] cu_zero_writeE,cu_zero_writeM;
    assign cu_zero_writeE = {19'b0,regwriteE,mem2regE,branchE,zeroE,write_regE,memwriteE};
    dff_32 cu_zero_write_reg(
        .d(cu_zero_writeE),
        .clk(clk),
        .clrn(clrn),
        .q(cu_zero_writeM)
    );
    assign memwriteM = cu_zero_writeM[3:0];
    assign write_regM = cu_zero_writeM[8:4];
    assign zeroM = cu_zero_writeM[9];
    assign branchM = cu_zero_writeM[10];
    assign mem2regM = cu_zero_writeM[11];
    assign regwriteM = cu_zero_writeM[12];

    //�Ĵ�������alu_out
    dff_32 alu_out_reg(
        .d(alu_outE),
        .clk(clk),
        .clrn(clrn),
        .q(alu_outM)
    );
    
    //�Ĵ�������write_data
    dff_32 write_data_reg(
        .d(writr_dataE),
        .clk(clk),
        .clrn(clrn),
        .q(write_dataM)
    );
    
    //�Ĵ�������pcbranch
    dff_32 pcbranch_reg(
        .d(pc_branchE),
        .clk(clk),
        .clrn(clrn),
        .q(pc_branchM)
    );
    
endmodule
