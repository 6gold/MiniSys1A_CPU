`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/19 16:22:39
// Design Name: 
// Module Name: barrelshifter32_sim
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


module barrelshifter32_sim();
    
     wire [31:0] d;
     reg [31:0] a;
     reg [4:0] b;
     reg [1:0] ctr;//00£∫À„ ı”““∆£ª 01£∫¬ﬂº≠”““∆£ª 10£∫À„ ˝◊Û“∆£ª 11£∫¬ﬂº≠◊Û“∆
     
     barrelshifter32 uut(
     .a(a),
     .d(d),
     .b(b),
     .ctr(ctr)
     );
     always begin
     #10 a=32'hf2220023;
         b=5'b00100;
         ctr=2'b00;
         
     #10 a=32'hf2220023;
         b=5'b00100;
         ctr=2'b01;
         
     #10 a=32'h12220023;
         b=5'b00100;
         ctr=2'b10;
         
     #10 a=32'h12220023;
        b=5'b00100;
         ctr=2'b11;
         
      #10 a=32'h12220023;
         b=5'b00100;
         ctr=2'b00;
         
      #10 a=32'h12220023;
         b=5'b00100;
         ctr=2'b00;
         
      #10 a=32'h12220023;
         b=5'b00100;
         ctr=2'b00;
     end
endmodule


