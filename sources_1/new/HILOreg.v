`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module HILOreg(clk,rst,cs_hi,cs_lo,WHIdata,WLOdata,RHIdata,RLOdata);
    input clk,rst;
    input cs_hi,cs_lo;                  //From WB module CS_HI,CS_LO
    input [31:0] WHIdata,WLOdata;       //WHIData,WLOData From WB module WB_WHI[31:0],WB_WLO[31:0]
    output [31:0] RHIdata,RLOdata;      //to CONFLICT Module
    
    wire nclk;
    assign nclk = ~clk;                 //Ê±ÖÓÏÂ½µÑØÐ´¼Ä´æÆ÷
    
    dffe_32 HI(.d(WHIdata),.clk(nclk),.clrn(rst),.e(cs_hi),.q(RHIdata));  //HI¼Ä´æÆ÷
    dffe_32 LO(.d(WLOdata),.clk(nclk),.clrn(rst),.e(cs_lo),.q(RLOdata));  //LO¼Ä´æÆ÷
endmodule
