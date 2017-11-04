`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: addsub_32
// Description: 32λ�Ӽ�����
//////////////////////////////////////////////////////////////////////////////////

module addsub_32 (a,b,sub_ctrl, s,cf,of);
    input [31:0] a,b;
    input sub_ctrl;
    output [31:0] s;
    output cf,of;
    wire c_out;
    wire [31:0] bb = b^{32{sub_ctrl}};      // sub_ctrlΪ1ʱ��ʾ����������ʱ�����bb��b�Ĳ���
    
    cla32 cla (
        .a(a),
        .b(bb),
        .c_in(sub_ctrl),
        .s(s),
        .c_out(c_out)
    );
    // �ж��޷������Ӽ��Ƿ��λ��λ��cf = 1��ʾ�н�λ��λ
    assign cf = sub_ctrl^c_out;
    // �ж��з������Ӽ��Ƿ������of = 1��ʾ���
    assign of = ~a[31]&~bb[31]&s[31] | a[31]&bb[31]&~s[31];
endmodule
