`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/30 20:54:42
// Design Name: 
// Module Name: dffe_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 带使能端的32位D触发器
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dffe_32(d,clk,clrn,e,q);
    input [31:0] d;
    input clk,clrn,e;
    output [31:0] q;
    reg [31:0] q;

    always@(negedge clrn or posedge clk)
    begin
        if(clrn == 0) begin
            q<=0;
        end else begin
        if(e == 1) q<=d;
        end
    end
endmodule
