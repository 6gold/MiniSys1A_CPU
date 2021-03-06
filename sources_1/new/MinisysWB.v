`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 写回模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysWB(
    /* input */   
    mem2regW,
    alu_outW,read_dataW,write_$31W,pcplus4W,write_regW,
    mdcsE2W,
    mdhidataE2W,mdlodataE2W,//乘除法运算结果后推到WB级
    hi2rdataW,lo2rdataW,
    mfhiW,mfloW,
    /* output */
    result_to_writeW,write_regD,
    mdcsW,mdhidataW,mdlodataW,//WB级写回的乘除法运算结果
    hi2regdataW,lo2regdataW
    );
    
    input mem2regW,write_$31W;
    input [4:0] write_regW;
    input [31:0] alu_outW,read_dataW,pcplus4W;
    input mdcsE2W;
    input [31:0] mdhidataE2W,mdlodataE2W;
    input mfhiW,mfloW;//分别是op_mfhi与op_mflo指令的信号
    input [31:0] hi2rdataW,lo2rdataW;
    output [31:0] result_to_writeW;
    output [4:0] write_regD;
    output mdcsW;
    output [31:0] mdhidataW,mdlodataW;
    output [31:0] hi2regdataW,lo2regdataW;
    
    assign write_regD = write_$31W ? {5'b11111} : write_regW;
    wire [31:0] resultsel;
    mux4_1 mux_reg_wrre(.in0(alu_outW),.in1(read_dataW),.in2(pcplus4W),.in3(pcplus4W),.sel({write_$31W,mem2regW}),.out(resultsel));  
    
    assign mdcsW = mdcsE2W;
    assign mdhidataW = mdhidataE2W;
    assign mdlodataW = mdlodataE2W;
    
    //hilo写给通用寄存器的数据
    wire [31:0] mfhilodataW;
    wire mfhilo = mfhiW|mfloW;
    assign hi2regdataW = hi2rdataW;
    assign lo2regdataW = lo2rdataW;
    mux2_1 mux2_1(.in0(hi2rdataW),.in1(lo2rdataW),.sel({mfhilo&mfloW}),.out(mfhilodataW));
    
    //写回reg的数据选择
    mux2_1 result2write(.in0(resultsel),.in1(mfhilodataW),.sel(mfhilo),.out(result_to_writeW));

endmodule
