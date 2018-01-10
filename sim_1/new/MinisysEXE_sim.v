`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module MinisysEXE_sim();
    reg clk=0,clrn=0;
    
    wire multbusy,divbusy,multover,divover;
    wire mdcsE2D,mdcsE2W,keepmdE;
    wire [31:0] mdhidataE2W,mdlodataE2W,mdhidataE2D,mdlodataE2D;//�˳������������Ƶ�WB��
    
    MinisysEXE MinisysEXE(
        /* input��from��ID�׶Ρ��� */
        .clk(clk),.clrn(clrn),  
        .regwriteE(/*�Ƿ�д�ؼĴ���*/),
        .mem2regE(/*�Ƿ��mem��������д�ؼĴ���*/),
        .memwriteE(/*�Ƿ�дmem*/),
        .branchE(/*�Ƿ���������ת*/),
        .alucontrolE(/*alu�����ź�*/),
        .alusrcE(/*alusrcΪ0ʱѡ��rd2,Ϊ1ѡ������*/{1'b0}),//CU�����Ŀ����ź�
        .rd1E({32'h00000001}),.rd2E({32'hf0000002}),      //alu������������    
        .rsE(),.rtE(),.rdE(),    //����д���ַ
        .signImmeE(),      //��չ���������
        .pcplus4E(),       //pcplus4
        .result_to_writeW(),.write_regE(),.regwriteW(),
        .alu_mdE(/*ѡ�����ĳ˳�������*/{2'b00}),.mdE(/*��ʾ��ǰָ���ǳ˳���*/{1'b1}),//�˳������
        .hi2rdataE(),.lo2rdataE(),
        .mfhiE(),.mfloE(),
        /* output��to��ID�׶Ρ��� */
        .regwriteM(),.mem2regM(),.memwriteM(),.branchM(),
        .op_lbE(),.op_lbuE(),.op_lhE(),.op_lhuE(),.op_lwE(),.write_$31E(),
        .op_beqE(),.op_bneE(),
        .zeroM(),.carryM(),.overflowM(),//����㣬��λ��λ�����
        .alu_outM(),.write_dataM(),.write_regM(),.pc_branchM(),     //����MEM��������
        .pcplus4M(),.op_lbM(),.op_lbuM(),.op_lhM(),.op_lhuM(),.op_lwM(),.write_$31M(),
        //�˳������
        .multbusy(),.divbusy(),.multover(),.divover(),                  //�˳���æ�źźͽ����ź�
        .mdcsE2D(),.mdcsE2W(),.keepmdE(),
        .mdhidataE2W(),.mdlodataE2W(),                            //�˳������������Ƶ�WB��
        .mdhidataE2D(),.mdlodataE2D(),                            //�˳���������ǰ�Ƶ�ID��     
        .hi2rdataM(),.lo2rdataM(),
        .mfhiM(),.mfloM(),.rd1M()//rd1M��Ϊmthi mtloָ����Ҫ ��������һ��     
    );
        
    initial begin
    #5 clrn=1;
    forever
    #5 clk = ~clk;
    end
endmodule
