`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: CPU�����ļ�
//////////////////////////////////////////////////////////////////////////////////

module Minisys1A_CPU(
    clk,clrn,io_data,
    /*������out*/
    //��IF��
    clk,pc_branchM,load_use,jumpI,keepmdE,pc_jumpI,instrD,pcplus4F,pcplus4D,pc,pcF,
    //��ID��
    write_regW,result_to_writeW,regwriteW,mdcsE2D,mdcsW,multbusyE,multoverE,divbusyE,divoverE,
    mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW,regwriteE,mem2regE,branchE,alusrcE,
    memwriteE,alucontrolE,rd1E,rd2E,rsE,rtE,rdE,signImmeE,pcplus4E,
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,op_beqE,op_bneE,
    write_regE,alu_mdE,mdE,MDPause,hi2rdataE,lo2rdataE,mfhiE,mfloE,rd11,
    //��EXE��
    mdcsE2W,mdhidataE2W,mdlodataE2W,hi2rdataM,lo2rdataM,
    mfhiM,mfloM,rd1M,regwriteM,mem2regM,branchM,memwriteM,zeroM,carryM,overflowM,
    op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,alu_outM,write_dataM,pcplus4M,write_regM,
    alu_srcaE,alu_srcbE,alu_b,fwda,fwdb,alu_outE,
    //��MEM��
    mem2regW,write_$31W,alu_outW,read_dataW,pcplus4W,hi2rdataW,lo2rdataW,mfhiW,mfloW, 
    //��WB��
    write_regD,hi2regdataW,lo2regdataW,
    rs,rt,rd,rd1D,rd2D
    );
    input clk,clrn;
    input [31:0] io_data;
  
//    output wire clk;   
//    divclk divclk(.clk(clk),.rst(clrn),.clk_sys(clk));
    
    //��IF��
    output wire branchM;               //����ѡ��pc��Դ
    output wire [31:0] pc_branchM;     //EXEִ�����֮�������branch��ַ
    output wire load_use;
    output wire jumpI,keepmdE;         //keepmdE���˳���������
    output wire [31:0] pc_jumpI;
    output wire [31:0] instrD,pcplus4F,pcplus4D,pc,pcF;//to��ID��
    MinisysIF MinisysIF(
        /* input */
        .branchM(branchM),.pc_branchM(pc_branchM),
        .clk(clk),.clrn(clrn),.load_use(load_use),
        .jumpI(jumpI),.pc_jumpI(pc_jumpI),.keepmdE(keepmdE),
        /* output */
        .instrD(instrD),.pcplus4D(pcplus4D),.pcplus4F(pcplus4F),.pc(pc),.pcF(pcF)
        );

    //��ID��
    output wire [4:0] write_regW;          //from��WB����reg��д���ַ
    output wire [31:0] result_to_writeW;   //from��WB�׶Ρ�reg��д������
    output wire regwriteW;                 //from��WB��reg��дʹ���ź�
    /*EXE��WB�˳�����ؽ��ǰ��*/
    output wire mdcsE2D,mdcsW,multbusyE,multoverE,divbusyE,divoverE;
    output wire [31:0] mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW;
    /*������EXE�׶�*/
    output wire regwriteE,mem2regE,branchE,alusrcE;
    output wire [3:0] memwriteE;           //4���洢�������ж�����д�����ź�
    output wire [3:0] alucontrolE;
    output wire [31:0] rd1E,rd2E;
    output wire [4:0] rsE,rtE,rdE;
    output wire [31:0] signImmeE,pcplus4E;
    output wire op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    output wire write_$31E,op_beqE,op_bneE;
    output wire [4:0] write_regE;          //to��EXE����reg��д���ַ
    output wire [1:0] alu_mdE;             //ѡ���������ֳ˳�������
    output wire mdE,MDPause;               //mdE:��ʾ�ǳ˳���;MDPause:�˳��������ź�
    output wire [31:0] hi2rdataE,lo2rdataE;//hilo�Ĵ�����ͨ�üĴ���������
    output wire mfhiE,mfloE;
    output wire [4:0] rs,rt,rd;
    output wire [31:0] rd1D,rd2D,rd11;
    MinisysID MinisysID(
        /* input */
        .instrD(instrD),.pcplus4D(pcplus4D),//from��IF��
        .clk(clk),.clrn(clrn),
        .write_regW(write_regW),
        .result_to_writeW(result_to_writeW),
        .regwriteW(regwriteW),
        //EXE��WB�˳�����ؽ��ǰ��
        .mdcsE2D(mdcsE2D),.keepmdE(keepmdE),
        .mdhidataE2D(mdhidataE2D),.mdlodataE2D(mdlodataE2D),
        .mdcsW(mdcsW),.mdhidataW(mdhidataW),.mdlodataW(mdlodataW),
        .multbusyE(multbusyE),.multoverE(multoverE),.divbusyE(divbusyE),.divoverE(divoverE),
        /* output */
        //to��EXE�׶Ρ�
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.branchE(branchE),
        .alucontrolE(alucontrolE),.alusrcE(alusrcE),//cu�����Ŀ����ź�
        .rd1E(rd1E),.rd2E(rd2E),          //�Ĵ����Ѷ�����������
        .rsE(rsE),.rtE(rtE),.rdE(rdE),    //����д�ص�ַ
        .signImmeE(signImmeE),            //��չ�����������32bits
        .pcplus4E(pcplus4E),              //pcplus4
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),.load_use(load_use),.write_regE(write_regE),
        .alu_mdE(alu_mdE),.mdE(mdE),.MDPause(MDPause),
        .hi2rdataE(hi2rdataE),.lo2rdataE(lo2rdataE),
        .mfhiE(mfhiE),.mfloE(mfloE),
        .pc_jumpI(pc_jumpI),.jumpI(jumpI),
        /*����*/
        .rs(rs),.rt(rt),.rd(rd),.rd1D(rd1D),.rd2D(rd2D),.rd11(rd11)
        );

   //��EXE��
   output wire mdcsE2W;
   output wire [31:0] mdhidataE2W,mdlodataE2W,hi2rdataM,lo2rdataM;
   output wire mfhiM,mfloM,rd1M;
   output wire regwriteM,mem2regM;
   output wire [3:0] memwriteM;
   output wire zeroM,carryM,overflowM;
   output wire op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M;
   output wire [31:0] alu_outM,write_dataM,pcplus4M;    
   output wire [4:0] write_regM;
   output [31:0] alu_srcaE,alu_srcbE,alu_b,alu_outE;
   output [1:0] fwda,fwdb;
   MinisysEXE MinisysEXE(
        /* input��from��ID�׶Ρ��� */
        .clk(clk),.clrn(clrn), 
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),
        .branchE(branchE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),//���Ͼ�ΪCU�����Ŀ����ź�
        .rd1E(rd1E),.rd2E(rd2E),        //alu������������    
        .rsE(rsE),.rtE(rtE),.rdE(rdE),  //����д���ַ
        .signImmeE(signImmeE),          //��չ���������
        .pcplus4E(pcplus4E),            //pcplus4
        .result_to_writeW(result_to_writeW),.write_regE(write_regE),.regwriteW(regwriteW),
        .alu_mdE(alu_mdE),.mdE(mdE),//�˳������
        .hi2rdataE(hi2rdataE),.lo2rdataE(lo2rdataE),
        .mfhiE(mfhiE),.mfloE(mfloE),                
        /* output��to��ID�׶Ρ��� */
        .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),.branchM(branchM),
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),
        .zeroM(zeroM),.carryM(carryM),.overflowM(overflowM),//����㣬��λ��λ�����
        .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM),.pc_branchM(pc_branchM),     //����MEM��������
        .pcplus4M(pcplus4M),.op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),
        .op_lwM(op_lwM),.write_$31M(write_$31M),
        .multbusy(multbusyE),.divbusy(divbusyE),.multover(multoverE),.divover(divoverE),//�˳���æ�źźͽ����ź�
        .mdcsE2D(mdcsE2D),.mdcsE2W(mdcsE2W),.keepmdE(keepmdE),//hiloдʹ���źźͳ˳����������ź�
        .mdhidataE2W(mdhidataE2W),.mdlodataE2W(mdlodataE2W),//�˳������������Ƶ�WB��
        .mdhidataE2D(mdhidataE2D),.mdlodataE2D(mdlodataE2D),//�˳���������ǰ�Ƶ�ID��
        .hi2rdataM(hi2rdataM),.lo2rdataM(lo2rdataM),//hilo�͵�reg������
        .mfhiM(mfhiM),.mfloM(mfloM),.rd1M(rd1M),//rd1M��Ϊmthi mtloָ����Ҫ ��������һ��
        .fwda(fwda),.fwdb(fwdb),
        .alu_srcaE(alu_srcaE),.alu_srcbE(alu_srcbE),.alu_b(alu_b),.alu_outE(alu_outE)
        );
 
   //��MEM��
   output wire mem2regW,write_$31W;
   output wire [31:0] alu_outW,read_dataW,pcplus4W;  //alu_out��Ϊ��д�洢���ĵ�ַ
   output wire [31:0] hi2rdataW,lo2rdataW;
   output wire mfhiW,mfloW;       
   MinisysMEM MinisysMEM(
         /* input*/
         .clk(clk),.clrn(clrn),
         //from��EXE�׶Ρ�
         .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),
         .zeroM(zeroM),.io_data(io_data),
         .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM), 
         .op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),.op_lwM(op_lwM),
         .write_$31M(write_$31M),.pcplus4M(pcplus4M),
         .hi2rdataM(hi2rdataM),.lo2rdataM(lo2rdataM),
         .mfhiM(mfhiM),.mfloM(mfloM),        
         /* output */
         //to��WB�׶Ρ�
         .regwriteW(regwriteW),      //���ź���Ϊ��һ����ID�׶Ρ�������
         .mem2regW(mem2regW),.alu_outW(alu_outW),       //alu_out��Ϊ��д�洢���ĵ�ַ
         .read_dataW(read_dataW),
         .write_regW(write_regW),     //�����ź���Ϊ��һ����ID�׶Ρ�������
         .write_$31W(write_$31W),
         .pcplus4W(pcplus4W),
         .hi2rdataW(hi2rdataW),.lo2rdataW(lo2rdataW),
         .mfhiW(mfhiW),.mfloW(mfloW)
         );
    
    //��WB��
    output wire [4:0] write_regD;
    output wire [31:0] hi2regdataW,lo2regdataW;            
    MinisysWB MinisysWB(
          /* input */   
          .mem2regW(mem2regW),
          .alu_outW(alu_outW),.read_dataW(read_dataW),.write_$31W(write_$31W),
          .pcplus4W(pcplus4W),.write_regW(write_regW),
          .mdcsE2W(mdcsE2W),
          .mdhidataE2W(mdhidataE2W),.mdlodataE2W(mdlodataE2W),//�˳������������Ƶ�WB��
          .hi2rdataW(hi2rdataW),.lo2rdataW(hi2rdataW),
          .mfhiW(mfhiW),.mfloW(mfhiW),
          /* output */
          .result_to_writeW(result_to_writeW),.write_regD(write_regD),
          .mdcsW(mdcsW),.mdhidataW(mdhidataW),.mdlodataW(mdlodataW),//WB��д�صĳ˳���������
          .hi2regdataW(hi2regdataW),.lo2regdataW(lo2regdataW)   
          ); 
         
      wire [31:0] io_data;
//    wire rst; 
//    wire [31:0] io_data_in,io_data_out;
//    wire [15:0] i_switch;//���뿪������
//    wire [15:0] o_led;//led�����
//    wire o_wreset;// reset signal from watchdog
//    wire [7:0] disp_data,disp_sel;//��������
//    wire pwm_out;//�������
//    wire cout1,cout2;//��ʱ�����
//    wire [3:0] row,col;
//    wire pulse1,pulse2;
//    assign io_data_in = write_dataM;//io_data_in[15:0]д��IO
//    interfaces interfaces(
//          .clk(clk), //ʱ��
//          .isReset(rst), //��λ
//          .isR(mem2regM), //��IO������Ҫ��һ����mem2regM(mem2regM),.memwriteM
//          .isW(memwriteM),//��IDд����Ҫ����һ����
//          .addr(alu_outM), //���ӿڵĵ�ַ������Ҫ���ʵĽӿڵĵ�ַ��
//          .dR_inst(), //���������ùܣ���������û�µİ�
//          .dR_mem(),// ���������ù�
//          .dW(io_data_in[15:0]),  //���ӿڵ����� 
//          .o_led(o_led), //output:����ĸ������������ʷ˵����
//          .i_switch(), //input
//          .o_wreset(o_wreset), //output
//          .disp_data(disp_data),//out
//          .disp_sel(disp_sel), //out
//          .pwm_out(pwm_out),//out
//          .pulse1(pulse1),//in
//          .pulse2(pulse2),//in
//          .cout1(cout1),//out
//          .cout2(cout2),//out
//          .row(row),//input
//          .col(col)//output
//          );      
        
endmodule
