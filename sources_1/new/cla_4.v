`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Description: 4λ���мӷ���
//              ���룺����4λ����a[3:0]��b[3:0]��һ����λ��λc_in
//              �����4λ�ӷ����s[3:0]����λ��������g����λ���ݺ���p
//////////////////////////////////////////////////////////////////////////////////


module cla_4 (a,b,c_in, g_out,p_out,s);
    input [3:0] a,b;
    input c_in;
    output g_out,p_out;
    output [3:0] s;
    wire [1:0] g,p; //��cla_2����Ľ�λ��������g�ͽ�λ���ݺ���pͨ��wire����gp��������������һ���gp
    wire c_out;     //��gp�����������c_out��Ϊcla1��c_in
    cla_2 cla0 (a[1:0],b[1:0],c_in, g[0],p[0],s[1:0]);
    cla_2 cla1 (a[3:2],b[3:2],c_out, g[1],p[1],s[3:2]);
    g_p g_p0 (g,p,c_in, g_out,p_out,c_out);
endmodule