`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/14 19:34:42
// Design Name: 
// Module Name: mux2_1
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


module mux2_1(
    in0,in1,
    sel,
    out
    );
    input[31:0] in0;
    input[31:0] in1;
    input sel;
    
    output reg[31:0] out;

	 always @ (*)
	 	begin
			case(sel)
			2'b0:out = in0;
			2'b0:out = in1;
			endcase
		end
endmodule
