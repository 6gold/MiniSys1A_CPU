`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/30 20:54:28
// Design Name: 
// Module Name: dff_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32Î»D´¥·¢Æ÷
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dff_32(d,clk,clrn,q);
    input [31:0] d;
    input clk,clrn;
    output [31:0] q;
    reg [31:0] q;
    
    always@(negedge clrn or posedge clk)
    begin
        if(clrn == 0) begin
            q<=0;
        end else begin
            q<=d;
        end
    end
endmodule
