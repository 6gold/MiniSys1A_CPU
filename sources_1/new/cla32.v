`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: cla32
// Description: ���շ�װ��32λ���мӷ���
//              ���룺����32λ����a[31:0]��b[31:0]��һ����λ��λc_in
//              �����32λ�ӷ����s[31:0]�����ս�λ���ci
//////////////////////////////////////////////////////////////////////////////////

module cla32 (a,b,c_in,s,c_out);
    input [31:0] a,b;
    input c_in;
    output [31:0] s;
    output c_out;
    wire g_out,p_out;
    cla_32 cla (a,b,c_in, g_out,p_out,s);
    assign c_out = g_out | p_out & c_in;
endmodule