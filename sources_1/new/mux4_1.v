`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/14 19:36:01
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
    in0,in1,in2,in3,
    sel,
    out
    );
    
    input[31:0] in0;
    input[31:0] in1;
    input[31:0] in2;
    input[31:0] in3;
    input[1:0] sel;
    
    output reg[31:0] out;

	 always @ (*)
	 	begin
			case(sel)
			2'b00:out = in0;
			2'b01:out = in1;
			2'b10:out = in2;
			2'b11:out = in3;
			endcase
		end
    
endmodule
