`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/06 22:36:50
// Design Name: 
// Module Name: regfile_sim
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


module regfile_sim();
   	reg [4:0] rna=5'b0,rnb=5'b0,wn=5'b0;
    reg [31:0] d=32'b0;
    reg we=1,clk=0,clrn=0;

    wire [31:0] qa,qb;
    regfile_dataflow regfile_dataflow(
            .rna(rna),.rnb(rnb),.d(d),
            .wn(wn),.we(we),.clk(clk),.clrn(clrn),.qa(qa),.qb(qb));
   
   initial begin
   forever
    #5 clk = ~clk;
    end
    
    always begin
    #10 clrn=1;
    #10 wn=12;d=12;
    #10 wn=5;d=5;
    #10 wn=10;d=10;
    #10 wn=10;d=30;rna=10;rnb=5;
    #10 rna=0;rnb=12;
    end
    
endmodule
