`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 8位并行加法器
//              输入：两个8位数据a[7:0]，b[7:0]和一个低位进位c_in
//              输出：8位加法结果s[7:0]，进位产生函数g，进位传递函数p
//////////////////////////////////////////////////////////////////////////////////


module cla_8 (a,b,c_in, g_out,p_out,s);
    input [7:0] a,b;
    input c_in;
    output g_out,p_out;
    output [7:0] s;
    wire [1:0] g,p;
    wire c_out;
    cla_4 cla0 (a[3:0],b[3:0],c_in, g[0],p[0],s[3:0]);
    cla_4 cla1 (a[7:4],b[7:4],c_out, g[1],p[1],s[7:4]);
    g_p g_p0 (g,p,c_in, g_out,p_out,c_out);
endmodule
