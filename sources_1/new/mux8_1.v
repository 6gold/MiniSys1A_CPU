`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/14 19:36:28
// Design Name: 
// Module Name: mux8_1
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


module mux8_1(
    in0,in1,in2,in3,in4,in5,in6,in7,
    sel,
    out
    );
    
    input[31:0] in0;
    input[31:0] in1;
    input[31:0] in2;
    input[31:0] in3;
    input[31:0] in4;
    input[31:0] in5;
    input[31:0] in6;
    input[31:0] in7;
    input[2:0] sel;
    
    output reg[31:0] out;

	 always @ (*)
	 	begin
			case(sel)
			3'b000:out = in0;
			3'b001:out = in1;
			3'b010:out = in2;
			3'b011:out = in3;
			3'b100:out = in4;
			3'b101:out = in5;
			3'b110:out = in6;
			3'b111:out = in7;
			endcase
		end
    
endmodule
