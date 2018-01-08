`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 写回模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysWB(
    /* input */   
    mem2regW,
    alu_outW,read_dataW,write_$31W,pcplus4M,write_regW,
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
    input [31:0] alu_outW,read_dataW,pcplus4M;
    input mdcsE2W;
    input [31:0] mdhidataE2W,mdlodataE2W;
    input mfhiW,mfloW;
    output [31:0] result_to_writeW;
    output [4:0] write_regD;
    output mdcsW;
    output [31:0] mdhidataW,mdlodataW;
    
    assign write_regD = write_$31W ? {5'b11111} : write_regW;
    mux4_1 mux_reg_wrre(.in0(alu_outW),.in1(read_dataW),.in2(pcplus4M),.in3(pcplus4M),.sel({write_$31W,mem2regW}),.out(result_to_writeW));  
    
    assign mdcsW = mdcsE2W;
    assign mdhidataW = mdhidataE2W;
    assign mdlodataW = mdlodataE2W;
    
    //hilo写给通用寄存器的数据
    mfhiW,mfloW//分别是op_mfhi与op_mflo指令的信号
    assign hi2regdataW = hi2rdataW;
    assign lo2regdataW = lo2rdataW;
    
endmodule
