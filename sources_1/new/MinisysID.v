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
    //EXE��WB�˳�����ؽ��ǰ��
    mdcsE2D,keepmdE,
    mdhidataE2D,mdlodataE2D,
    mdcsW,mdhidataW,mdlodataW,
    multbusyE,multoverE,divbusyE,divoverE,
    /* output */
    //to��EXE�׶Ρ�
    regwriteE,mem2regE,memwriteE,branchE,alucontrolE,alusrcE,//lwswE,//cu�����Ŀ����ź�
    rd1E,rd2E,          //�Ĵ����Ѷ�����������
    rsE,rtE,rdE,            //����д�ص�ַ
    signImmeE,          //��չ�����������32bits
    pcplus4E,            //pcplus4
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,
    write_$31E,op_beqE,op_bneE,load_use,write_regE,alu_mdE,mdE,MDPause,
    hi2rdataE,lo2rdataE,
    mfhiE,mfloE,
    //to [IF]
    pc_jumpI,jumpI
    );
    
    input [31:0] instrD,pcplus4D;
    input clk,clrn,regwriteW;
    input [4:0] write_regW;
    input [31:0] result_to_writeW;
    input mdcsE2D,keepmdE;
    input [31:0] mdhidataE2D,mdlodataE2D,mdhidataW,mdlodataW;
    input mdcsW,multbusyE,multoverE,divbusyE,divoverE;

    output regwriteE,mem2regE,branchE,alusrcE;//regdstE,lwswE;
    output [3:0] alucontrolE,memwriteE;//memwriteEΪ4λ����Ϊ4���洢�������ж�����д�����ź�
    output [31:0] rd1E,rd2E,signImmeE,pcplus4E,pc_jumpI;
    output [4:0] rsE,rtE,rdE,write_regE;
    output op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    output write_$31E,op_beqE,op_bneE;
    output load_use;
    output [1:0] alu_mdE;
    output mdE;//��ʾ�ǳ˳���
    output MDPause;//�˳��������ź�
    output [31:0] hi2rdataE,lo2rdataE;
    output mfhiE,mfloE,jumpI;
    
    assign mfhiE = op_mfhi;
    assign mfloE = op_mflo;
    
    reg load_use;
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
    wire op_lbD,op_lbuD,op_lhD,op_lhuD,op_lwD,op_loadD,op_loadE;
    wire op_sll,op_srl,op_sra;
    wire write_$31,write_$31D,branch;
    wire op_beqD,op_bneD,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal,op_mthi,op_mtlo,op_mfhi,op_mflo;
    wire [1:0] alu_mdD;
    wire mdD,op_jal,jump_rs;
    CU controller(
        //����
        .op(op),.func(func),.rt(rt),
        //���
        .regwriteD(regwriteD),.mem2regD(mem2regD),.memwriteD(memwriteD),//.branchD(branch),
        .jumpD(jumpD),.alucontrolD(alucontrolD),.alusrcD(alusrcD),.regdstD(regdstD),.lwswD(lwswD),
        .op_lb(op_lbD),.op_lbu(op_lbuD),.op_lh(op_lhD),.op_lhu(op_lhuD),.op_lw(op_lwD),
        .op_sll(op_sll),.op_srl(op_srl),.op_sra(op_sra),
        .write_$31(write_$31),.op_beq(op_beqD),.op_bne(op_bneD),.op_bgez(op_bgez),
        .op_bgtz(op_bgtz),.op_blez(op_blez),.op_bltz(op_bltz),.op_bgezal(op_bgezal),
        .op_bltzal(op_bltzal),.alu_md(alu_mdD),.md(mdD),
        .op_mthi(op_mthi),.op_mtlo(op_mtlo),.op_mfhi(op_mfhi),.op_mflo(op_mflo),.jump_rs(jump_rs)
          //      ������������Ҫ����decoder������decoder���������regwriteD���źš�
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
        .qa(rd11),
        .qb(rd2D)
    );
    wire [31:0] rd11;
    wire move;
    assign move = op_sra | op_sll | op_srl;
    assign rd1D = move?{27'b0,shamt}:rd11;
    
    wire zero,bgez,bgtz,blez,bltz,bgezal,bltzal,bge_bltzal;
    assign zero = (rd1D == 32'b0) ? 1 : 0;
    assign bgez = op_bgez & ~rd1D[31];
    assign bgtz = op_bgtz & ~rd1D[31] & ~zero;
    assign blez = op_blez & rd1D[31] | zero;
    assign bltz = op_bltz & rd1D[31];
    assign bgezal = op_bgezal & ~rd1D[31];
    assign bltzal = op_bltzal & rd1D[31];
    
    assign branchD = bgez | bgtz | blez | bltz | bgezal | bltzal; 
    assign bge_bltzal = bgezal | bltzal;
    assign write_$31D = write_$31 | bge_bltzal; 
    
    //16to32λ��չ���������˴�Ϊ�з�����չ��
    extend imme_extend_reg(
        .imm(imme),
        .ExtOp(1'b1),
        .result(signImmeD)
    );
    
    //�Ĵ��������cu�����ĸ������ź�
    wire [31:0] cu_outD,cu_outE;
    assign cu_outD = {4'b0,op_mfhi,op_mflo,mdD,alu_mdD,op_beqD,op_bneD,op_lbD,op_lbuD,op_lhD,op_lhuD,op_lwD,write_$31D,regwriteD,mem2regD,branchD,jumpD,alusrcD,op_loadD,lwswD,alucontrolD,memwriteD};
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
    assign op_loadE      = cu_outE[9];
    assign alusrcE      = cu_outE[10];
    assign jumpI        = cu_outE[11];
    assign branchE      = cu_outE[12];    
    assign mem2regE     = cu_outE[13];
    assign regwriteE    = cu_outE[14];
    assign {op_beqE,op_bneE,op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E} = cu_outE[22:15];
    assign alu_mdE = cu_outE[24:23];
    assign mdE = cu_outE[25];
    assign mfloE = cu_outE[26];
    assign mfhiE = cu_outE[27];

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
    assign rtrdD = {12'b0,write_reg,rs,rt,rd};
    dff_32 rt_rd_reg(
        .d(rtrdD),
        .clk(clk),
        .clrn(clrn),
        .q(rtrdE)
    );
    assign write_regE = rtrdE[15:11];
    assign rsE = rtrdE[14:10];
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
    
    wire [4:0] write_reg,write_regE;
    assign write_reg = regdstD ? rt : rd;   //regdstΪ1ʱѡ��rt
    //load-use ָ���ظ�ִ��һ��
    always @ (*) begin
    if( op_loadE && (rsE== write_regE||rdE==write_regE) )
       load_use = 1;
    else
       load_use = 0;
    end 
    
    //�˳������������Ҫ�õ����ź�
    wire cshi,cslo;                                         //HILO�Ĵ���дʹ���ź�
    wire [31:0] HIdataout,Lodataout;                        //�˳����Ĵ������ݶ���
    wire [31:0] whidata,wlodata;                            //д��HILO������
    assign cshi = mdcsW|op_mthi;                           //HIдʹ��
    assign cslo = mdcsW|op_mtlo;                           //LOдʹ��
    assign whidata = op_mthi ? rd1E:mdhidataW;             //дHI����,���mthi����mtlo������д�ؽ׶ε�MD������ͬʱд��HILO����д��д��أ�
                                                            //����mtlo��mthi������׶Σ����ȼ��ߣ�ֱ��дmthi�Ľ����mthi��mtloִ�н���2��ʱ�����ڣ�    
    assign wlodata = op_mtlo ? rd1E:mdlodataW;             //дLO���ݣ���mthi��mtlo��д�ؽ׶ε�MD����֮���ָ����Ҫ���MD������������ͨ��ת����
                                                            //��ʽ��ȡ����˴��ַ�ʽ������ֶ�д���ݴ���
                                                            //rd1EΪ���������غ��rs��������a��������
    HILOreg HILOreg(
        .clk(clk),.rst(clrn),
        .cs_hi(cshi),.cs_lo(cslo),
        .WHIdata(whidata),.WLOdata(wlodata),.RHIdata(HIdataout),.RLOdata(Lodataout)
    );

    //���HILO�Ĵ�����������أ�RAW��أ�����������r_mthi��r_mtloָ��������׶�����ɶ�HILO��д����������HILO���������ֻ���ǳ˳������mflo��mfhi�����
    assign MDPause = (multoverE||divoverE)?1'b0:((op_mfhi|op_mflo|mdD) & keepmdE);   //���г˳���ʱ��Ҫ���������
    reg [31:0] hisrcs,losrcs;        						//mflo��mfhiָ��ȡ���Ĳ�����
    //HI�Ĵ������������
    always @(op_mfhi,mdcsE2D,mdcsW,multbusyE,divbusyE,mdhidataE2D,mdhidataW,HIdataout) begin
        if(mdcsE2D && op_mfhi) begin                                    //��������exe��
            hisrcs <= mdhidataE2D;
        end else if(mdcsW && op_mfhi) begin                            //��������wb������δ���ü�д��HI
            hisrcs <= mdhidataW;
        end else if(((!multbusyE)&&(!divbusyE)) && op_mfhi) begin     //��������HI�Ĵ���
            hisrcs <= HIdataout;
        end
    end
    //LO�Ĵ������������
    always @(op_mflo,mdcsE2D,mdcsW,multbusyE,divbusyE,mdlodataE2D,mdlodataW,Lodataout) begin
    if(mdcsE2D && op_mflo) begin                                     //��������exe��
        losrcs <= mdlodataE2D;
    end else if(mdcsW && op_mflo) begin                             //��������wb������δ���ü�д��LO
        losrcs <= mdlodataW;
    end else if(((!multbusyE)&&(!divbusyE)) && op_mflo) begin     //��������LO�Ĵ���
        losrcs <= Lodataout;
    end
    end
    
    assign hisrcsel = MDPause ? 32'h00000000 : hisrcs;
    assign losrcsel = MDPause ? 32'h00000000 : losrcs;

    //ID/EXE��ˮ�߼Ĵ���    
    dff_32 hi2reg(.d(hisrcsel),.clk(clk),.clrn(rst),.q(hi2rdataE));
    dff_32 lo2reg(.d(losrcsel),.clk(clk),.clrn(rst),.q(lo2rdataE));
    
    //ֱ����ת
//    output [31:0] pc_jumpI;ǰ���Ѿ��������
    wire [31:0] pc_jump;
    assign pc_jump = jump_rs ? rd11 : {14'b0,imme,2'b00};
    dff_32 jump_reg(
        .d(pc_jump),
        .clk(clk),
        .clrn(clrn),
        .q(pc_jumpI)
    ); 
        
    
endmodule
