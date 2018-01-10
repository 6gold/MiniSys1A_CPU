`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module alu_32_sim();
    reg clk=0;
    reg [31:0] alu_a,alu_b;
    wire [31:0] q;
    reg [3:0] alu_control;
    
    alu_32 alu_32(
        .alu_a(alu_a),.alu_b(alu_b),.alu_control(alu_control),.q(q)
    );
    
    always begin
    #10 alu_a = 32'h00000000;
        alu_b = 32'h00000001;
        alu_control = 3;
    #10 alu_control = 1;
    #10 alu_control = 4;
    #10 alu_control = 7;
    #10 alu_control = 12;
    #10 alu_control = 13;
    #10 alu_control = 5;
    #10 alu_control = 8;
    #10 alu_control = 9;   
    end

endmodule
