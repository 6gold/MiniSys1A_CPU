`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 32Î»D´¥·¢Æ÷
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
