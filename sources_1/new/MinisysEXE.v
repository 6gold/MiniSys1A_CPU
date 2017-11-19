`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module MinisysEXE(
    //input
    clk,rst,control,srca,srcb,shamt,immi,hi2regdata,lo2regdata,mfc0data,pc_in,intr,runoverflow,icmisspause,dcmisspause,dtlbRefill_exc,
    //output
    exepwreg,exepmem2reg,exepwaddreg,exepalu,exeresult,exewmdata,execontrol,overflow,                                          
    prerror,mulbusy,divbusy,keepmd,mulover,divover,exepmdcs,exepmdhidata,exepmdlodata,exemdhidata,exemdlodata,exemdcs,         //output
    /*md,*/exebranch,pctoid,exetomempc);
    
    //处理各种运算
    /* 与ALU相关的 */
    //sub_add
    //逻辑运算
    
    
    
    /* 与ALU相关的 */
    //mult_div
    
    
    
    //运算结果选择
endmodule
