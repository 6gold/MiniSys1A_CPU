`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: add_sub_32����
//////////////////////////////////////////////////////////////////////////////////

module addsub_32_sim ();
    //input   
    reg [31:0] a = 0;
    reg [31:0] b = 0;
    reg sub_ctrl = 0;
    //output
    wire [31:0] s;
    wire cf,of;
    
    //����
    addsub_32 addsub32 (
        .a(a),
        .b(b),
        .sub_ctrl(sub_ctrl),
        .s(s),
        .cf(cf),
        .of(of)
    );
    
    always begin
    #10 a = 32'h80000000;       //�޷������������cou_t = 1��
        b = 32'h80000000;
        sub_ctrl = 1'b0;
    #10 a = 32'h00000000;       //�޷������������cou_t = 1��
        b = 32'h00000001;
        sub_ctrl = 1'b1;
    #10 a = 32'h80000000;       //�з����������(ov = 1)
        b = 32'h80000000;
        sub_ctrl = 1'b0;
    #10 a = 32'h00000001;       //�з����������(ov = 1)
        b = 32'h80000000;
        sub_ctrl = 1'b1;
    #10 a = 32'h12345678;
        b = 32'h01234567;
        sub_ctrl = 1'b1;
    end
    
endmodule
