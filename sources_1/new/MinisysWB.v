`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 写回模块
//////////////////////////////////////////////////////////////////////////////////

module MinisysWB(
    /* input */   
    mem2regW,
    alu_outW,read_dataW,
    /* output */
    result_to_writeW
    );
    
    input mem2regW;
    input [31:0] alu_outW,read_dataW;    
    output [31:0] result_to_writeW;
    
    assign result_to_writeW = mem2regW ? alu_outW : read_dataW;//mem2regW为0时选alu_outW
    
endmodule
