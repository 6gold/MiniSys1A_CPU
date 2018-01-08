`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/08 20:19:29
// Design Name: 
// Module Name: dff_1
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


module dff_1(d,clk,clrn,q);
    input d;
    input clk,clrn;
    output q;
    reg q;

    always@(negedge clrn or posedge clk)
    begin
        if(clrn == 0) begin
            q<=0;
        end else begin
            q<=d;
        end
    end
endmodule
