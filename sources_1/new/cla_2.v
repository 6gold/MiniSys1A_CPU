`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 2位并行加法器
//              输入：两个2位数据a[1:0]，b[1:0]和一个低位进位c_in
//              输出：2位加法结果s[1:0]，进位产生函数g，进位传递函数p
//////////////////////////////////////////////////////////////////////////////////


module cla_2 (a,b,c_in, g_out,p_out,s);
    input [1:0] a,b;
    input c_in;
    output g_out,p_out;
    output [1:0] s;
    wire [1:0] g,p;
    wire c_out;
    add_1 add0 (a[0],b[0],c_in, g[0],p[0],s[0]);
    add_1 add1 (a[1],b[1],c_out, g[1],p[1],s[1]);
    g_p g_p0 (g,p,c_in, g_out,p_out,c_out);
endmodule
