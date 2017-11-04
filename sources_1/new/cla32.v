`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: cla32
// Description: 最终封装的32位并行加法器
//              输入：两个32位数据a[31:0]，b[31:0]和一个低位进位c_in
//              输出：32位加法结果s[31:0]，最终进位输出ci
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