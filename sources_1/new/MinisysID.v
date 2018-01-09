`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 指令译码模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysID(
    /* input */
    instrD,pcplus4D,    //from【IF阶段】
    clk,clrn,
    write_regW,         //【WB阶段】的写入地址：5bits
    result_to_writeW,   //【WB阶段】的写入数据：32bits
    regwriteW,          //【WB阶段】的写使能信号：1bits
    //EXE和WB乘除法相关结果前推
    mdcsE2D,keepmdE,
    mdhidataE2D,mdlodataE2D,
    mdcsW,mdhidataW,mdlodataW,
    multbusyE,multoverE,divbusyE,divoverE,
    /* output */
    //to【EXE阶段】
    regwriteE,mem2regE,memwriteE,branchE,alucontrolE,alusrcE,//lwswE,//cu产生的控制信号
    rd1E,rd2E,          //寄存器堆读出的两个数
    rsE,rtE,rdE,            //两种写回地址
    signImmeE,          //扩展后的立即数：32bits
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
    output [3:0] alucontrolE,memwriteE;//memwriteE为4位，因为4个存储器各自有独立的写控制信号
    output [31:0] rd1E,rd2E,signImmeE,pcplus4E,pc_jumpI;
    output [4:0] rsE,rtE,rdE,write_regE;
    output op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE;
    output write_$31E,op_beqE,op_bneE;
    output load_use;
    output [1:0] alu_mdE;
    output mdE;//表示是乘除法
    output MDPause;//乘除法阻塞信号
    output [31:0] hi2rdataE,lo2rdataE;
    output mfhiE,mfloE,jumpI;
    
    assign mfhiE = op_mfhi;
    assign mfloE = op_mflo;
    
    reg load_use;
    /* 中间变量 */
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
    
    //控制器例化
    wire op_lbD,op_lbuD,op_lhD,op_lhuD,op_lwD,op_loadD,op_loadE;
    wire op_sll,op_srl,op_sra;
    wire write_$31,write_$31D,branch;
    wire op_beqD,op_bneD,op_bgez,op_bgtz,op_blez,op_bltz,op_bgezal,op_bltzal,op_mthi,op_mtlo,op_mfhi,op_mflo;
    wire [1:0] alu_mdD;
    wire mdD,op_jal,jump_rs;
    CU controller(
        //输入
        .op(op),.func(func),.rt(rt),
        //输出
        .regwriteD(regwriteD),.mem2regD(mem2regD),.memwriteD(memwriteD),//.branchD(branch),
        .jumpD(jumpD),.alucontrolD(alucontrolD),.alusrcD(alusrcD),.regdstD(regdstD),.lwswD(lwswD),
        .op_lb(op_lbD),.op_lbu(op_lbuD),.op_lh(op_lhD),.op_lhu(op_lhuD),.op_lw(op_lwD),
        .op_sll(op_sll),.op_srl(op_srl),.op_sra(op_sra),
        .write_$31(write_$31),.op_beq(op_beqD),.op_bne(op_bneD),.op_bgez(op_bgez),
        .op_bgtz(op_bgtz),.op_blez(op_blez),.op_bltz(op_bltz),.op_bgezal(op_bgezal),
        .op_bltzal(op_bltzal),.alu_md(alu_mdD),.md(mdD),
        .op_mthi(op_mthi),.op_mtlo(op_mtlo),.op_mfhi(op_mfhi),.op_mflo(op_mflo),.jump_rs(jump_rs)
          //      【控制器里面要调用decoder并根据decoder的输出产生regwriteD等信号】
    );
    
    //32*32bit寄存器堆例化
    regfile_dataflow regfile(
        .rna(rs),
        .rnb(rt),
        .d(result_to_writeW),//写入数据
        .wn(write_regW),//写入地址
        .we(regwriteW),//写入使能端
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
    
    //16to32位扩展器例化（此处为有符号扩展）
    extend imme_extend_reg(
        .imm(imme),
        .ExtOp(1'b1),
        .result(signImmeD)
    );
    
    //寄存器：存放cu产生的各控制信号
    wire [31:0] cu_outD,cu_outE;
    assign cu_outD = {4'b0,op_mfhi,op_mflo,mdD,alu_mdD,op_beqD,op_bneD,op_lbD,op_lbuD,op_lhD,op_lhuD,op_lwD,write_$31D,regwriteD,mem2regD,branchD,jumpD,alusrcD,op_loadD,lwswD,alucontrolD,memwriteD};
    dff_32 cu_out_reg(
        .d(cu_outD),
        .clk(clk),
        .clrn(clrn),
        .q(cu_outE)      
    );
    //解析各控制信号
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

    //寄存器：存放寄存器堆中读出的数rd1
    dff_32 rd1_reg(
        .d(rd1D),
        .clk(clk),
        .clrn(clrn),
        .q(rd1E)
    );
    
    //寄存器：存放寄存器堆中读出的数rd2
    dff_32 rd2_reg(
        .d(rd2D),
        .clk(clk),
        .clrn(clrn),
        .q(rd2E)
    );
    
    //寄存器：存放rt和rd的内容
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
    
    //寄存器：存放扩展后的32位立即数
    dff_32 signImme_reg(
        .d(signImmeD),
        .clk(clk),
        .clrn(clrn),
        .q(signImmeE)
    );
    
    //寄存器：存放pcplus4的内容
    dff_32 pcplus4_reg(
        .d(pcplus4D),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4E)
    );
    
    wire [4:0] write_reg,write_regE;
    assign write_reg = regdstD ? rt : rd;   //regdst为1时选择rt
    //load-use 指令重复执行一次
    always @ (*) begin
    if( op_loadE && (rsE== write_regE||rdE==write_regE) )
       load_use = 1;
    else
       load_use = 0;
    end 
    
    //乘除法数据相关需要用到的信号
    wire cshi,cslo;                                         //HILO寄存器写使能信号
    wire [31:0] HIdataout,Lodataout;                        //乘除法寄存器数据读出
    wire [31:0] whidata,wlodata;                            //写入HILO的数据
    assign cshi = mdcsW|op_mthi;                           //HI写使能
    assign cslo = mdcsW|op_mtlo;                           //LO写使能
    assign whidata = op_mthi ? rd1E:mdhidataW;             //写HI数据,如果mthi或者mtlo与来自写回阶段的MD运算结果同时写回HILO属于写后写相关，
                                                            //由于mtlo及mthi在译码阶段，优先级高，直接写mthi的结果（mthi和mtlo执行仅需2个时钟周期）    
    assign wlodata = op_mtlo ? rd1E:mdlodataW;             //写LO数据，在mthi或mtlo与写回阶段的MD运算之间的指令想要或得MD运算结果，可以通过转发的
                                                            //方式获取，因此此种方式不会出现读写数据错误
                                                            //rd1E为解决数据相关后的rs（操作数a）的数据
    HILOreg HILOreg(
        .clk(clk),.rst(clrn),
        .cs_hi(cshi),.cs_lo(cslo),
        .WHIdata(whidata),.WLOdata(wlodata),.RHIdata(HIdataout),.RLOdata(Lodataout)
    );

    //解决HILO寄存器的数据相关（RAW相关）分析：由于r_mthi和r_mtlo指令在译码阶段已完成对HILO的写入操作，因此HILO的数据相关只考虑乘除运算对mflo和mfhi的相关
    assign MDPause = (multoverE||divoverE)?1'b0:((op_mfhi|op_mflo|mdD) & keepmdE);   //运行乘除法时需要阻塞的情况
    reg [31:0] hisrcs,losrcs;        						//mflo和mfhi指令取到的操作数
    //HI寄存器的数据相关
    always @(op_mfhi,mdcsE2D,mdcsW,multbusyE,divbusyE,mdhidataE2D,mdhidataW,HIdataout) begin
        if(mdcsE2D && op_mfhi) begin                                    //数据来自exe级
            hisrcs <= mdhidataE2D;
        end else if(mdcsW && op_mfhi) begin                            //数据来自wb级但仍未来得及写到HI
            hisrcs <= mdhidataW;
        end else if(((!multbusyE)&&(!divbusyE)) && op_mfhi) begin     //数据来自HI寄存器
            hisrcs <= HIdataout;
        end
    end
    //LO寄存器的数据相关
    always @(op_mflo,mdcsE2D,mdcsW,multbusyE,divbusyE,mdlodataE2D,mdlodataW,Lodataout) begin
    if(mdcsE2D && op_mflo) begin                                     //数据来自exe级
        losrcs <= mdlodataE2D;
    end else if(mdcsW && op_mflo) begin                             //数据来自wb级但仍未来得及写回LO
        losrcs <= mdlodataW;
    end else if(((!multbusyE)&&(!divbusyE)) && op_mflo) begin     //数据来自LO寄存器
        losrcs <= Lodataout;
    end
    end
    
    assign hisrcsel = MDPause ? 32'h00000000 : hisrcs;
    assign losrcsel = MDPause ? 32'h00000000 : losrcs;

    //ID/EXE流水线寄存器    
    dff_32 hi2reg(.d(hisrcsel),.clk(clk),.clrn(rst),.q(hi2rdataE));
    dff_32 lo2reg(.d(losrcsel),.clk(clk),.clrn(rst),.q(lo2rdataE));
    
    //直接跳转
//    output [31:0] pc_jumpI;前面已经定义过了
    wire [31:0] pc_jump;
    assign pc_jump = jump_rs ? rd11 : {14'b0,imme,2'b00};
    dff_32 jump_reg(
        .d(pc_jump),
        .clk(clk),
        .clrn(clrn),
        .q(pc_jumpI)
    ); 
        
    
endmodule
