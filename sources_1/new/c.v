`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/20 18:30:46
// Design Name: 
// Module Name: c
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module c( alu_a,alu_b,and_res,or_res,nor_res,xor_res

    );
    input [31:0] alu_a, alu_b;
    output wire [31:0] and_res,or_res,nor_res,xor_res;
      assign  and_res = alu_a & alu_b;
      assign  or_res = alu_a|alu_b;
      assign  nor_res = ~(alu_a|alu_b);
      assign  xor_res = alu_a^alu_b;
    
endmodule
