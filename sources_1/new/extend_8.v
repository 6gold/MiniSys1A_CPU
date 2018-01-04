`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/03 23:27:21
// Design Name: 
// Module Name: extend_8
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


module extend_8(
	input [7:0] in,
	input ExtOp,
	output reg[31:0] result
    );    
        always@(ExtOp, in)
        begin
            if (in[7]&ExtOp)
                result = {24'hffff, in};
            else
                result = {24'h0000, in};
         end                  
endmodule
