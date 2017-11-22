`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/20 18:33:09
// Design Name: 
// Module Name: aa
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


module aa(

    );
    
    reg [31:0] alu_a,alu_b;
    wire [31:0] and_res,or_res,nor_res,xor_res;
    c cc(.alu_a(alu_a),.alu_b(alu_b),.and_res(and_res),.or_res(or_res),
    .nor_res(nor_res),.xor_res(xor_res));
    
    always begin
    #10 alu_a=32'h80000010; alu_b=32'h81000000;
    #10 alu_a=32'h30000010;alu_b=32'h41002000;
    #10 alu_a=32'h20000010;alu_b=32'h81023000;
    end
    
endmodule
