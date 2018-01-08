`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module Minisys1A_SoC(

    );
    
    wire [31:0] pc_branchM,instrD,pcplus4D;
    wire [31:0] alu_outW,read_dataW,pcplus4W;  //alu_out��Ϊ��д�洢���ĵ�ַ
    wire [31:0] result_to_writeW;
    wire [31:0] rd1E,rd2E,signImmeE,pcplus4E;
    wire [31:0] alu_outM,write_dataM,pcplus4M;
    wire [4:0] write_regD;
    wire [4:0] write_regW;
    wire [4:0] rsE,rtE,rdE;
    wire [4:0] write_regM;
    wire [3:0] memwriteM;
    wire [3:0] alucontrolE,memwriteE;//memwriteEΪ4λ����Ϊ4���洢�������ж�����д�����ź�
    wire clk,clrn,pc_srcM,rst,clk_y;
    wire regwriteW;
    wire regwriteE,mem2regE,branchE,jumpE,alusrcE,regdstE,lwswE;
    wire write_$31E,op_beqE,op_bneE;
    wire op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    wire zeroM,carryM,overflowM;
    wire regwriteM,mem2regM,branchM;
    wire op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,jumpM;  
    wire mem2regW,write_$31W;
    wire load_use;
    wire [4:0] write_regE; 
    
    divclk divclk(.clk(clk_y),.rst(rst),.clk_sys(clk));
    
    MinisysIF MinisysIF(
        /* input */
        .pc_srcM(pc_srcM),.pc_branchM(pc_branchM),  //pc_srcM����ѡ��pc��Դ��pcbranchM��EXEִ�����֮�������branch��ַ
        .clk(clk),.clrn(clrn),.load_use(load_use),
        /* output */
        .instrD(instrD),.pcplus4D(pcplus4D)     //to��ID�׶Ρ�
        );
        
    MinisysID MinisysID(
        /* input */
        .instrD(instrD),.pcplus4D(pcplus4D),    //from��IF�׶Ρ�
        .clk(clk),.clrn(clrn),
        .write_regW(write_regW),         //��WB�׶Ρ���д���ַ��5bits
        .result_to_writeW(result_to_writeW),   //��WB�׶Ρ���д�����ݣ�32bits
        .regwriteW(regwriteW),          //��WB�׶Ρ���дʹ���źţ�1bits
        /* output */
        //to��EXE�׶Ρ�
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.branchE(branchE),
        .jumpE(jumpE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),//.regdstE(regdstE),//lwswE,//cu�����Ŀ����ź�
        .rd1E(rd1E),.rd2E(rd2E),          //�Ĵ����Ѷ�����������
        .rsE(rsE),.rtE(rtE),.rdE(rdE),            //����д�ص�ַ
        .signImmeE(signImmeE),          //��չ�����������32bits
        .pcplus4E(pcplus4E),            //pcplus4
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),.load_use(load_use),.write_regE(write_regE)
        );
 
   MinisysEXE MinisysEXE(
            /* input��from��ID�׶Ρ��� */
        .clk(clk),.clrn(clrn),.write_regE(write_regE), 
        .regwriteE(regwriteE),.mem2regE(mem2regE),.memwriteE(memwriteE),.regwriteW(regwriteW),
        .branchE(branchE),.jumpE(jumpE),.alucontrolE(alucontrolE),.alusrcE(alusrcE),
        .regdstE(regdstE),//lwswE,//CU�����Ŀ����ź�
        .rd1E(rd1E),.rd2E(rd2E),      //alu������������    
        .rsE(rsE),.rtE(rtE),.rdE(rdE),        //����д���ַ
        .signImmeE(signImmeE),      //��չ���������
        .pcplus4E(pcplus4E),       //pcplus4
        .result_to_writeW(result_to_writeW),
        //    regdst,alusrc,alucontrol,
        /* output��to��ID�׶Ρ��� */
        .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),.branchM(branchM),
        .op_lbE(op_lbE),.op_lbuE(op_lbuE),.op_lhE(op_lhE),.op_lhuE(op_lhuE),.op_lwE(op_lwE),
        .write_$31E(write_$31E),.op_beqE(op_beqE),.op_bneE(op_bneE),
        //    zero,
        .zeroM(zeroM),.carryM(carryM),.overflowM(overflowM),//����㣬��λ��λ�����
        .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM),.pc_branchM(pc_branchM),     //����MEM��������
        .pcplus4M(pcplus4M),.op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),
        .op_lwM(op_lwM),.write_$31M(write_$31M),.jumpM(jumpM)
        );
            
   MinisysMEM MinisysMEM(
         /* input*/
         .clk(clk),.clrn(clrn),
         //from��EXE�׶Ρ�
         .regwriteM(regwriteM),.mem2regM(mem2regM),.memwriteM(memwriteM),.branchM(branchM),
         .zeroM(zeroM),.io_data(io_data),
         .alu_outM(alu_outM),.write_dataM(write_dataM),.write_regM(write_regM), 
         .op_lbM(op_lbM),.op_lbuM(op_lbuM),.op_lhM(op_lhM),.op_lhuM(op_lhuM),.op_lwM(op_lwM),
         .write_$31M(write_$31M),.pcplus4M(pcplus4M),    
         /* output */
         //to��WB�׶Ρ�
         .regwriteW(regwriteW),      //���ź���Ϊ��һ����ID�׶Ρ�������
         .mem2regW(mem2regW),.alu_outW(alu_outW),       //alu_out��Ϊ��д�洢���ĵ�ַ
         .read_dataW(read_dataW),
         .write_regW(write_regW),     //�����ź���Ϊ��һ����ID�׶Ρ�������
         .pc_srcM(pc_srcM),         //���ź���Ϊ��һ����IF�׶Ρ�������
         .write_$31W(write_$31W),
         .pcplus4W(pcplus4W)
         );
                
    MinisysWB MinisysWB(
          /* input */   
          .mem2regW(mem2regW),
          .alu_outW(alu_outW),.read_dataW(read_dataW),.write_$31W(write_$31W),
          .pcplus4M(pcplus4M),.write_regW(write_regW),
          /* output */
          .result_to_writeW(result_to_writeW),.write_regD(write_regD)
          ); 
          
    wire rst; 
    wire [31:0] io_data_in,io_data_out;
    wire [15:0] o_led;//led�����
    wire o_wreset;// reset signal from watchdog
    assign io_data_in = write_dataM;//io_data_in[15:0]д��IO
    interfaces interfaces(
          .clk(clk), //ʱ��
          .isReset(rst), //��λ
          .isR(mem2regM), //��IO������Ҫ��һ����mem2regM(mem2regM),.memwriteM
          .isW(memwriteM),//��IDд����Ҫ����һ����
          .addr(alu_outM), //���ӿڵĵ�ַ������Ҫ���ʵĽӿڵĵ�ַ��
          .dR_inst(), //���������ùܣ���������û�µİ�
          .dR_mem(),// ���������ù�
          .dW(io_data_in[15:0]),  //���ӿڵ����� 
          .o_led(o_led), //output:����ĸ������������ʷ˵����
          .i_switch(), //input
          .o_wreset(), //output
          .disp_data(),//out
          .disp_sel(), //out
          .pwm_out(),//out
          .pulse1(),//in
          .pulse2(),//in
          .cout1(),//out
          .cout2(),//out
          .row(),//input
          .col()//output
          );      
        
endmodule
