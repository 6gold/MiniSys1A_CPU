`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Description: 4位并行加法器
//              输入：两个4位数据a[3:0]，b[3:0]和一个低位进位c_in
//              输出：4位加法结果s[3:0]，进位产生函数g，进位传递函数p
//////////////////////////////////////////////////////////////////////////////////


module cla_4 (a,b,c_in, g_out,p_out,s);
    input [3:0] a,b;
    input c_in;
    output g_out,p_out;
    output [3:0] s;
    wire [1:0] g,p; //将cla_2算出的进位产生函数g和进位传递函数p通过wire送至gp生成器，产生高一层的gp
    wire c_out;     //将gp生成器算出的c_out作为cla1的c_in
    cla_2 cla0 (a[1:0],b[1:0],c_in, g[0],p[0],s[1:0]);
    cla_2 cla1 (a[3:2],b[3:2],c_out, g[1],p[1],s[3:2]);
    g_p g_p0 (g,p,c_in, g_out,p_out,c_out);
endmodule
