`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ָ��ִ��ģ��
//////////////////////////////////////////////////////////////////////////////////

module MinisysEXE(
    /* input��from��ID�׶Ρ��� */
    clk,clrn,  
    regwriteE,mem2regE,memwriteE,branchE,alucontrolE,alusrcE,//CU�����Ŀ����ź�
    rd1E,rd2E,      //alu������������    
    rsE,rtE,rdE,    //����д���ַ
    signImmeE,      //��չ���������
    pcplus4E,       //pcplus4
    result_to_writeW,write_regE,regwriteW,write_regD,
    alu_mdE,mdE,//�˳������
    hi2rdataE,lo2rdataE,
    mfhiE,mfloE,
    /* output��to��ID�׶Ρ��� */
    regwriteM,mem2regM,memwriteM,branchM,
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,
    op_beqE,op_bneE,
//    zero,
    zeroM,carryM,overflowM,//����㣬��λ��λ�����
    alu_outM,write_dataM,write_regM,pc_branchM,     //����MEM��������
    pcplus4M,op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,
    //�˳������
    multbusy,divbusy,multover,divover,                  //�˳���æ�źźͽ����ź�
    mdcsE2D,mdcsE2W,keepmdE,
    mdhidataE2W,mdlodataE2W,                            //�˳������������Ƶ�WB��
    mdhidataE2D,mdlodataE2D,                            //�˳���������ǰ�Ƶ�ID��     
    hi2rdataM,lo2rdataM,
    mfhiM,mfloM,rd1M,//rd1M��Ϊmthi mtloָ����Ҫ ��������һ��
    alu_srcaE,alu_srcbE,alu_b,fwda,fwdb,alu_outE
    );
    
    input clk,clrn;
    input regwriteE,mem2regE,branchE,alusrcE;
    input [3:0] memwriteE;      //�ĸ��洢�����ж�����д�����ź�
    input [3:0] alucontrolE;
    input [31:0] rd1E,rd2E,signImmeE,pcplus4E,result_to_writeW;
    input [4:0] rsE,rtE,rdE,write_regE,write_regD;
    input op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E;
    input op_beqE,op_bneE,regwriteW;
    input [1:0] alu_mdE;
    input mdE;
    input [31:0] hi2rdataE,lo2rdataE;
    input mfhiE,mfloE;

    output zeroM,carryM,overflowM;
    output regwriteM,mem2regM,branchM;
    output [3:0] memwriteM;
    output [4:0] write_regM;   
    output [31:0] alu_outM,write_dataM,pc_branchM,pcplus4M;
    output op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M;

    //�˳������
    output multbusy,divbusy,multover,divover;                        //�˳���æ�źźͽ����ź�
    output [31:0] mdhidataE2W,mdlodataE2W;                           //�˳���������
    output [31:0] mdhidataE2D,mdlodataE2D;                           //�˳���������ǰ�Ƶ�ID��
    output mdcsE2D,mdcsE2W,keepmdE;                                  //keepmdE:�˳�����������У�mdcs:HILOдʹ��    

    output [31:0] hi2rdataM,lo2rdataM,rd1M;
    output mfhiM,mfloM;
    
    output [31:0] alu_srcaE,alu_srcbE,alu_b,alu_outE;

    /* �м���� */
    wire zeroE;
    reg [31:0] alu_srcbE;
    wire [31:0] alu_srcaE,alu_outE,writr_dataE,pc_branchE,alu_outM,alu_b;
    wire [4:0] write_regE,write_regM;
    output reg [1:0] fwda,fwdb;
    mux4_1 fda(.in0(rd1E),.in1(alu_outM),.in2(result_to_writeW),.in3(32'b0),
               .sel(fwda),.out(alu_srcaE));   
    assign writr_dataE = rd2E;
    mux4_1 fdb(.in0(rd2E),.in1(alu_outM),.in2(result_to_writeW),.in3(32'b0),
               .sel(fwdb),.out(alu_b));
    //assign alu_srcbE = alusrcE ? signImmeE : alu_b ;           //alusrcΪ0ʱѡ��rd2   
    always @(*)begin
     if(alusrcE==1) alu_srcbE=signImmeE;
     else alu_srcbE=alu_b;
    end
    /* Ԫ������ */
    
    //alu����
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
    assign cu_zero_writeE = {10'b0,mfhiE,mfloE,op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,1'b0,regwriteE,mem2regE,branch,zeroE,write_regE,memwriteE};
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
    assign {op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M} = cu_zero_writeM[19:14]; 
    assign mfloM = cu_zero_writeM[20];
    assign mfhiM = cu_zero_writeM[21];

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
    //��rs
    wire [31:0] rd1M;
    dff_32 reg_rs32(
        .d(rd1E),
        .clk(clk),
        .clrn(clrn),
        .q(rd1M)
    );
    
     //��������ð��
    //wb��
    wire [31:0] result_to_writeW;
//    wire [4:0] write_regD;
//    reg [1:0] fwda,fwdb;
    //EXE�� alu_outM,write_regM      rd1E,rd2E,      //alu������������    
    always @ (*)begin
      if( regwriteM && (rsE == write_regM) && ~mem2regM )
         fwda = 2'b01 ;
      else if( regwriteW && (rsE == write_regD) )
         fwda = 2'b10 ;
      else 
         fwda = 2'b00 ;
    end
        
    always @ (*)begin
      if( regwriteM && (rdE == write_regM) && ~mem2regM )
         fwdb = 2'b01 ;
      else if( regwriteW && (rdE == write_regD) )
         fwdb = 2'b10 ;
      else 
         fwdb = 2'b00 ;
    end
    
    //�˳�������    
    wire mdcsE;												    //HILO�洢��дʹ���ź�
    wire [31:0] mdhi,mdlo,multdivhires,multdivlores;                //�˳���������
    multdiv_32 multdiv_32(
        .md(mdE),
        .clk(clk),.rst(clrn),
        .ALU_OP(alu_mdE),.ALU_A(alu_srcaE),.ALU_B(alu_srcbE),.ALU_HI(mdhi),.ALU_LO(mdlo),
        .MULTBUSY(multbusy),.DIVBUSY(divbusy),.MULTWRITE(multover),.DIVWRITE(divover)
    );
    assign keepmdE = mdE ? 1'b1 : (((~multover)&&multbusy)||((~divover)&&divbusy))?1'b1:1'b0;     //Ϊ1��ʾ���ڽ��г˳�������,ת����ID��
    assign mdcsE = (multover||divover) ?1'b1:1'b0;                                        //Ϊ1��ʾ�˳����������
    assign multdivhires = (multover||divover) ? mdhi:32'h00000000;                         //�õ�����������HI���
    assign multdivlores = (multover||divover) ? mdlo:32'h00000000;                         //�õ�����������LO���endmodule
    
    //ת����ID��
    assign mdcsE2D = mdcsE;
    assign mdhidataE2D = multdivhires;
    assign mdlodataE2D = multdivlores;
    
    //�˳�������EXE/WB��ˮ�߼Ĵ���������MEM����
    dff_1 mdcs_reg(.d(mdcsE),.clk(clk),.clrn(clrn),.q(mdcsE2W));
    dff_32 HIRes_reg(.d(multdivhires),.clk(clk),.clrn(clrn),.q(mdhidataE2W));
    dff_32 LORes_reg(.d(multdivlores),.clk(clk),.clrn(clrn),.q(mdlodataE2W));
   
    dff_32 hi2reg(.d(hi2rdataE),.clk(clk),.clrn(clrn),.q(hi2rdataM));
    dff_32 lo2reg(.d(lo2rdataE),.clk(clk),.clrn(clrn),.q(lo2rdataM));    
endmodule