`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 写回模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysWB(
    /* input */   
    mem2regW,
    alu_outW,read_dataW,write_$31W,pcplus4M,write_regW,
    /* output */
    result_to_writeW,write_regD
    );
    
    input mem2regW,write_$31W;
    input [4:0] write_regW;
    input [31:0] alu_outW,read_dataW,pcplus4M;    
    output [31:0] result_to_writeW;
    output [4:0] write_regD;
//    wire [31:0] write_test;
//    dff_32 regf(
//        .d({32'hffffffff}),
//        .clk(clk),
//        .clrn(clrn),
//        .q(write_test)
//    );
    assign write_regD = write_$31W ? {5'b11111} : write_regW;
    mux4_1 mux_reg_wrre(.in0(alu_outW),.in1(read_dataW),.in2(pcplus4M),.in3(pcplus4M),.sel({write_$31W,mem2regW}),.out(result_to_writeW));  
//    assign result_to_writeW = mem2regW ? alu_outW : read_dataW;//mem2regW为0时选alu_outW
    
endmodule
