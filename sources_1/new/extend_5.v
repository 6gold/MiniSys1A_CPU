`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/04 00:10:21
// Design Name: 
// Module Name: extend_5
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


module extend_5
(
    input [4:0] in,
    output reg[31:0] result
);

    always@(in)
    begin
        if (imm[15]&ExtOp)
            result = {16'hffff, imm};
        else
            result = {16'h0000, imm};
     end                  
endmodule
