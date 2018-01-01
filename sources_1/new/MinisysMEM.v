`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: �洢����дģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysMEM(
    /* input*/
    clk,clrn,
    //from��EXE�׶Ρ�
    regwriteM,mem2regM,memwriteM,branchM,
    zeroM,
    alu_outM,write_dataM,write_regM,     
    /* output */
    //to��WB�׶Ρ�
    regwriteW,      //���ź���Ϊ��һ����ID�׶Ρ�������
    mem2regW,
    alu_outW,       //alu_out��Ϊ��д�洢���ĵ�ַ
    read_dataW,
    write_regW,     //�����ź���Ϊ��һ����ID�׶Ρ�������
    pc_srcM         //���ź���Ϊ��һ����IF�׶Ρ�������
    );
    
    input clk,clrn;
    input regwriteM,mem2regM,branchM,zeroM;
    input [3:0] memwriteM;
    input [31:0] alu_outM,write_dataM;
    input [4:0] write_regM;        
    output regwriteW,mem2regW;
    output [31:0] alu_outW,read_dataW;  //alu_out��Ϊ��д�洢���ĵ�ַ
    output [4:0] write_regW;
    
    assign pc_srcM = branchM & zeroM;
    
    /* �м���� */ 
    wire [31:0] read_dataM;             //��������
    
    /* Ԫ������ */
       
    //���ݴ洢������
    wire clk_reverse;
    assign clk_reverse = !clk;
    //��Ϊʹ��оƬ�Ĺ����ӳ٣�RAM�ĵ�ַ����������ʱ��������׼����
    //ʹ��ʱ�����������ݶ����������Բ��÷���ʱ�ӣ�ʹ�ö������ݱȵ�ַ׼����Ҫ���Լ���ʱ��
    //�Ӷ��õ���ȷ�ĵ�ַ
    ram0 ram0(
        .clka(clk_reverse),
        .wea(memwriteM[0]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[7:0]),//С�˴洢
        .douta(read_dataM[7:0])
    );    
    ram1 ram1(
        .clka(clk_reverse),
        .wea(memwriteM[1]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[15:8]),
        .douta(read_dataM[15:8])
    );    
    ram2 ram2(
        .clka(clk_reverse),
        .wea(memwriteM[2]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[23:16]),
        .douta(read_dataM[23:16])
    );
    ram3 ram3(
        .clka(clk_reverse),
        .wea(memwriteM[3]),
        .addra(alu_outM[15:2]),
        .dina(write_dataM[31:24]),
        .douta(read_dataM[31:24])
    );
    
    //�Ĵ�������alu_outM
    dff_32 alu_out_reg(
        .d(alu_outM),
        .clk(clk),
        .clrn(clrn),
        .q(alu_outW)
    );
    
    //�Ĵ�������read_dataW
    dff_32 read_data_reg(
        .d(read_dataM),
        .clk(clk),
        .clrn(clrn),
        .q(read_dataW)
    );

    //�Ĵ�������write_regM,regwriteM,mem2regM,
    wire [31:0] write_regW_32;
    dff_32 write_reg_reg(
        .d({25'b0,regwriteM,mem2regM,write_regM}),
        .clk(clk),
        .clrn(clrn),
        .q(write_regW_32)
    );
    assign write_regW = write_regW_32[4:0];
    assign mem2regW = write_regW_32[5];
    assign regwriteW = write_regW_32[6];
    
endmodule
