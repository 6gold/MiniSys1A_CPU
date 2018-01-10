`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 存储器读写模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysMEM(
    /* input*/
    clk,clrn,
    //from【EXE阶段】
    regwriteM,mem2regM,memwriteM,//branchM,
    zeroM,io_data,
    alu_outM,write_dataM,write_regM, 
    op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M,pcplus4M,
    hi2rdataM,lo2rdataM,
    mfhiM,mfloM,  
    /* output */
    //to【WB阶段】
    regwriteW,      //该信号作为下一个【ID阶段】的输入
    mem2regW,
    alu_outW,       //alu_out作为读写存储器的地址
    read_dataW,
    write_regW,     //该组信号作为下一个【ID阶段】的输入
    //pc_srcM,         //该信号作为下一个【IF阶段】的输入
    write_$31W,
    pcplus4W,
    hi2rdataW,lo2rdataW,
    mfhiW,mfloW
    );
    
    input clk,clrn;
    input regwriteM,mem2regM,zeroM;
    input [3:0] memwriteM;
    input [31:0] alu_outM,write_dataM,pcplus4M,io_data;
    input [4:0] write_regM; 
    input op_lbM,op_lbuM,op_lhM,op_lhuM,op_lwM,write_$31M;
    input [31:0] hi2rdataM,lo2rdataM;
    input mfhiM,mfloM;
           
    output regwriteW,mem2regW,write_$31W;//pc_srcM;
    output [31:0] read_dataW,alu_outW,pcplus4W;  //alu_out作为读写存储器的地址
    output [4:0] write_regW;
    output [31:0] hi2rdataW,lo2rdataW;
    output mfhiW,mfloW;
    
    /* 中间变量 */ 
    wire [31:0] read_dataM;             //读出数据
    wire [7:0] read_data3,read_data2,read_data1,read_data0;
    /* 元件例化 */
       
    //数据存储器例化
    wire clk_reverse;
    assign clk_reverse = !clk;
    //因为使用芯片的固有延迟，RAM的地址线来不及在时钟上升沿准备好
    //使得时钟上升沿数据读出有误，所以采用反向时钟，使得读出数据比地址准备好要晚大约半个时钟
    //从而得到正确的地址
    //比较地址
    wire [31:0] write_data,io_data;
    assign write_data = (alu_outM[31:24]==8'hff) ? io_data : write_dataM;
    ram0 ram0(
        .clka(clk_reverse),
        .wea(memwriteM[3]),
        .addra(alu_outM[15:2]),
        .dina(write_data[7:0]),//小端存储
        .douta(read_data0[7:0])
    );    
    ram1 ram1(
        .clka(clk_reverse),
        .wea(memwriteM[2]),
        .addra(alu_outM[15:2]),
        .dina(write_data[15:8]),
        .douta(read_data1[7:0])
    );    
    ram2 ram2(
        .clka(clk_reverse),
        .wea(memwriteM[1]),
        .addra(alu_outM[15:2]),
        .dina(write_data[23:16]),
        .douta(read_data2[7:0])
    );
    ram3 ram3(
        .clka(clk_reverse),
        .wea(memwriteM[0]),
        .addra(alu_outM[15:2]),
        .dina(write_data[31:24]),
        .douta(read_data3[7:0])
    );
    
    //寄存器：存alu_outM
    dff_32 alu_out_reg(
        .d(alu_outM),
        .clk(clk),
        .clrn(clrn),
        .q(alu_outW)
    );
    
    //寄存器：存read_dataW
    dff_32 read_data_reg(
        .d(read_dataM),
        .clk(clk),
        .clrn(clrn),
        .q(read_dataW)
    );

    //寄存器：存write_regM,regwriteM,mem2regM,mfhiM,mfloM
    wire [31:0] write_regW_32;
    dff_32 write_reg_reg(
        .d({22'b0,mfhiM,mfloM,write_$31M,regwriteM,mem2regM,write_regM}),
        .clk(clk),
        .clrn(clrn),
        .q(write_regW_32)
    );
    assign write_regW = write_regW_32[4:0];
    assign mem2regW = write_regW_32[5];
    assign regwriteW = write_regW_32[6];
    assign write_$31W = write_regW_32[7];
    assign mfloW = write_regW_32[8];
    assign mfhiW = write_regW_32[9];
    
    //lw输出32位 lh 16位符号扩展 lhu 零扩展 lb 8位符号 lbu 8位零扩展
    wire [31:0] in0,in1;
    extend_8 extend_8(.in(read_data0),.ExtOp(op_lbM),.result(in0));
    extend extend(.imm({read_data1,read_data0}),.ExtOp(op_lhM),.result(in1));
    mux4_1 mux4_1(.in0(in0),.in1(in1),.in2({read_data3,read_data2,read_data1,read_data0}),
                  .in3({read_data3,read_data2,read_data1,read_data0}),.sel({op_lwM,(op_lhM|op_lhuM)}),.out(read_dataM));
                  
    //寄存器：存pc+4
    dff_32 pcplus4(
         .d(pcplus4M),
         .clk(clk),
         .clrn(clrn),
         .q(pcplus4W)
        ); 
        
    dff_32 hi2reg(.d(hi2rdataM),.clk(clk),.clrn(clrn),.q(hi2rdataW));
    dff_32 lo2reg(.d(lo2rdataM),.clk(clk),.clrn(clrn),.q(lo2rdataW));                  
endmodule
