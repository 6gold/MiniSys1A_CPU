`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: decoder
// Description: 指令译码器
//////////////////////////////////////////////////////////////////////////////////

module decoder(
    instruction,
    );
    input instruction;
    //10个算术运算指令信号
    output op_add,op_addu,op_addi,op_addiu,op_sub,op_subu,op_mult,op_multu,op_div,op_divu;
    //8个逻辑运算指令信号
    output op_and,op_andi,op_or,op_ori,op_xor,op_xori,op_nor,op_lui;
    //6个移位指令
endmodule
