`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: decoder
// Description: ָ��������
//////////////////////////////////////////////////////////////////////////////////

module decoder(
    instruction,
    );
    input instruction;
    //10����������ָ���ź�
    output op_add,op_addu,op_addi,op_addiu,op_sub,op_subu,op_mult,op_multu,op_div,op_divu;
    //8���߼�����ָ���ź�
    output op_and,op_andi,op_or,op_ori,op_xor,op_xori,op_nor,op_lui;
    //6����λָ��
endmodule
