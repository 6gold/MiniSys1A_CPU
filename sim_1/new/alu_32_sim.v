`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module alu_32_sim();
    reg clk=0;
    reg [31:0] alu_a,alu_b;
    reg [3:0] alu_control;
    
    wire [31:0] q;
    wire [2:0] OPctr;
    wire [31:0] add_res,and_res,or_res,xor_res,nor_res,lui_res,comp_res,shift_res;
    
    alu_32 alu_32(
        .alu_a(alu_a),.alu_b(alu_b),.alu_control(alu_control),.q(q),
        .add_res(add_res),.and_res(and_res),.or_res(or_res),.xor_res(xor_res),
        .nor_res(nor_res),.lui_res(lui_res),.comp_res(comp_res),.shift_res(shift_res),.OPctr(OPctr)
    );
    
    always begin
    #10 alu_a = 32'h00000000;
        alu_b = 32'h00000001;
        alu_control = 1;
    #10 alu_control = 2;
    #10 alu_control = 3;
    #10 alu_control = 4;
    #10 alu_control = 5;
    #10 alu_control = 6;
    #10 alu_control = 7;
    #10 alu_control = 8;
    #10 alu_control = 9;
    #10 alu_control = 10;
    #10 alu_control = 11;
    #10 alu_control = 12;
    #10 alu_control = 13;  
    end

endmodule
