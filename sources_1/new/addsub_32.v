`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: addsub_32
// Description: 32位加减法器
//////////////////////////////////////////////////////////////////////////////////

module addsub_32 (a,b,sub_ctrl, s,cf,of);
    input [31:0] a,b;
    input sub_ctrl;
    output [31:0] s;
    output cf,of;
    wire c_out;
    wire [31:0] bb = b^{32{sub_ctrl}};      // sub_ctrl为1时表示做减法，此时求出的bb是b的补码
    
    cla32 cla (
        .a(a),
        .b(bb),
        .c_in(sub_ctrl),
        .s(s),
        .c_out(c_out)
    );
    // 判断无符号数加减是否进位借位，cf = 1表示有进位借位
    assign cf = sub_ctrl^c_out;
    // 判断有符号数加减是否溢出，of = 1表示溢出
    assign of = ~a[31]&~bb[31]&s[31] | a[31]&bb[31]&~s[31];
endmodule
