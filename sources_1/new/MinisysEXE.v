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
    
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,
    op_beqE,op_bneE,
//    zero,
    zeroM,carryM,overflowM,//����㣬��λ��λ�����
    alu_outM,write_dataM,write_regM,pc_branchM,     //����MEM��������
    pcplus4M,op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,jumpM
    
    );
    
    input clk,clrn;
    input regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    input [3:0] memwriteE;      //�ĸ��洢�׶��ж�����д�����ź�
    input [3:0] alucontrolE;
    input [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    input [4:0] rtE,rdE;
    input op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E;
    input op_beqE,op_bneE;

    output zeroM,carryM,overflowM;
    output regwriteM,mem2regM,branchM;
    output [3:0] memwriteM;
    output [4:0] write_regM;   
    output [31:0] alu_outM,write_dataM,pc_branchM,pcplus4M;
    output op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,jumpM;
    
    /* �м���� */
    wire zeroE;
    wire [31:0] alu_srcaE,alu_srcbE,alu_outE,writr_dataE,pc_branchE;
    wire [4:0] write_regE;   
    assign alu_srcaE = rd1E;
    assign writr_dataE = rd2E;
    assign alu_srcbE = alusrcE ? signImmeE : rd2E ;           //alusrcΪ0ʱѡ��rd2   
    assign write_regE = regdstE ? rtE : rdE;   //regdstΪ1ʱѡ��rt
    
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
    wire beq,bne,branch;
    assign beq = op_beqE & zeroE;
    assign bne = op_bneE & ~zeroE;
    assign branch = branchE | bne | beq;
    
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
    assign cu_zero_writeE = {12'b0,op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,jumpE,regwriteE,mem2regE,branch,zeroE,write_regE,memwriteE};
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
    assign {op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,jumpM} = cu_zero_writeM[19:13]; 

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
    
    //�Ĵ�������pc+4
    dff_32 pcplus4(
        .d(pcplus4E),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4M)
    );

endmodule
