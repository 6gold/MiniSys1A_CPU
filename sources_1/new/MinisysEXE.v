`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 指令执行模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysEXE(
    /* input（from【ID阶段】） */
    clk,clrn,  
    regwriteE,mem2regE,memwriteE,branchE,alucontrolE,alusrcE,//CU产生的控制信号
    rd1E,rd2E,      //alu的两个操作数    
    rsE,rtE,rdE,    //两种写入地址
    signImmeE,      //扩展后的立即数
    pcplus4E,       //pcplus4
    result_to_writeW,write_regE,regwriteW,write_regD,
    alu_mdE,mdE,//乘除法相关
    hi2rdataE,lo2rdataE,
    mfhiE,mfloE,
    /* output（to【ID阶段】） */
    regwriteM,mem2regM,memwriteM,branchM,
    op_lbE,op_lbuE,op_lhE,op_lhuE,op_lwE,write_$31E,
    op_beqE,op_bneE,
//    zero,
    zeroM,carryM,overflowM,//结果零，借位进位，溢出
    alu_outM,write_dataM,write_regM,pc_branchM,     //送至MEM级的数据
    pcplus4M,op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,
    //乘除法相关
    multbusy,divbusy,multover,divover,                  //乘除法忙信号和结束信号
    mdcsE2D,mdcsE2W,keepmdE,
    mdhidataE2W,mdlodataE2W,                            //乘除法运算结果后推到WB级
    mdhidataE2D,mdlodataE2D,                            //乘除法运算结果前推到ID级     
    hi2rdataM,lo2rdataM,
    mfhiM,mfloM,rd1M,//rd1M因为mthi mtlo指令需要 因此向后推一下
    alu_srcaE,alu_srcbE,alu_b,fwda,fwdb,alu_outE
    );
    
    input clk,clrn;
    input regwriteE,mem2regE,branchE,alusrcE;
    input [3:0] memwriteE;      //四个存储器都有独立的写控制信号
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

    //乘除法相关
    output multbusy,divbusy,multover,divover;                        //乘除法忙信号和结束信号
    output [31:0] mdhidataE2W,mdlodataE2W;                           //乘除法运算结果
    output [31:0] mdhidataE2D,mdlodataE2D;                           //乘除法运算结果前推到ID级
    output mdcsE2D,mdcsE2W,keepmdE;                                  //keepmdE:乘除法运算进行中，mdcs:HILO写使能    

    output [31:0] hi2rdataM,lo2rdataM,rd1M;
    output mfhiM,mfloM;
    
    output [31:0] alu_srcaE,alu_srcbE,alu_b,alu_outE;

    /* 中间变量 */
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
    //assign alu_srcbE = alusrcE ? signImmeE : alu_b ;           //alusrc为0时选择rd2   
    always @(*)begin
     if(alusrcE==1) alu_srcbE=signImmeE;
     else alu_srcbE=alu_b;
    end
    /* 元件例化 */
    
    //alu例化
    alu_32 alu(
        .alu_a(alu_srcaE),
        .alu_b(alu_srcbE),
        .alu_control(alucontrolE),
        .q(alu_outE),   //运算结果
        .cf(carryM),    //进位借位
        .of(overflowM), //溢出
        .zf(zeroE)      //结果是否为零
    );
    wire beq,bne,branch;
    assign beq = op_beqE & zeroE;
    assign bne = op_bneE & ~zeroE;
    assign branch = branchE | bne | beq;
    
    //addsub_32例化
    addsub_32 imme_pcplus4(
        .a({signImmeE[29:0],2'b00}),
        .b(pcplus4E),
        .sub_ctrl(1'b0),
        .s(pc_branchE),
        .cf(),
        .of()
    );

    //寄存器：存放cu产生的各控制信号、zero值、write_reg
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

    //寄存器：存alu_out
    dff_32 alu_out_reg(
        .d(alu_outE),
        .clk(clk),
        .clrn(clrn),
        .q(alu_outM)
    );
    
    //寄存器：存write_data
    dff_32 write_data_reg(
        .d(writr_dataE),
        .clk(clk),
        .clrn(clrn),
        .q(write_dataM)
    );
    
    //寄存器：存pcbranch
    dff_32 pcbranch_reg(
        .d(pc_branchE),
        .clk(clk),
        .clrn(clrn),
        .q(pc_branchM)
    );
    
    //寄存器：存pc+4
    dff_32 pcplus4(
        .d(pcplus4E),
        .clk(clk),
        .clrn(clrn),
        .q(pcplus4M)
    );
    //存rs
    wire [31:0] rd1M;
    dff_32 reg_rs32(
        .d(rd1E),
        .clk(clk),
        .clrn(clrn),
        .q(rd1M)
    );
    
     //处理数据冒险
    //wb级
    wire [31:0] result_to_writeW;
//    wire [4:0] write_regD;
//    reg [1:0] fwda,fwdb;
    //EXE级 alu_outM,write_regM      rd1E,rd2E,      //alu的两个操作数    
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
    
    //乘除法运算    
    wire mdcsE;												    //HILO存储器写使能信号
    wire [31:0] mdhi,mdlo,multdivhires,multdivlores;                //乘除法运算结果
    multdiv_32 multdiv_32(
        .md(mdE),
        .clk(clk),.rst(clrn),
        .ALU_OP(alu_mdE),.ALU_A(alu_srcaE),.ALU_B(alu_srcbE),.ALU_HI(mdhi),.ALU_LO(mdlo),
        .MULTBUSY(multbusy),.DIVBUSY(divbusy),.MULTWRITE(multover),.DIVWRITE(divover)
    );
    assign keepmdE = mdE ? 1'b1 : (((~multover)&&multbusy)||((~divover)&&divbusy))?1'b1:1'b0;     //为1表示正在进行乘除法运算,转发到ID级
    assign mdcsE = (multover||divover) ?1'b1:1'b0;                                        //为1表示乘除法运算结束
    assign multdivhires = (multover||divover) ? mdhi:32'h00000000;                         //得到运算结束后的HI结果
    assign multdivlores = (multover||divover) ? mdlo:32'h00000000;                         //得到运算结束后的LO结果endmodule
    
    //转发到ID级
    assign mdcsE2D = mdcsE;
    assign mdhidataE2D = multdivhires;
    assign mdlodataE2D = multdivlores;
    
    //乘除法运算EXE/WB流水线寄存器（不过MEM级）
    dff_1 mdcs_reg(.d(mdcsE),.clk(clk),.clrn(clrn),.q(mdcsE2W));
    dff_32 HIRes_reg(.d(multdivhires),.clk(clk),.clrn(clrn),.q(mdhidataE2W));
    dff_32 LORes_reg(.d(multdivlores),.clk(clk),.clrn(clrn),.q(mdlodataE2W));
   
    dff_32 hi2reg(.d(hi2rdataE),.clk(clk),.clrn(clrn),.q(hi2rdataM));
    dff_32 lo2reg(.d(lo2rdataE),.clk(clk),.clrn(clrn),.q(lo2rdataM));    
endmodule