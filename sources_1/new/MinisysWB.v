`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: д��ģ��
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
    
    assign result_to_writeW = mem2regW ? alu_outW : read_dataW;//mem2regWΪ0ʱѡalu_outW
    
endmodule
