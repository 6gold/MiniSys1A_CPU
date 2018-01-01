`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: 控制单元CU
//////////////////////////////////////////////////////////////////////////////////


module CU(
    /* input */
    op,func,
    /* output */
    regwriteD,mem2regD,memwriteD,branchD,jumpD,alucontrolD,alusrcD,regdstD,lwswD
    );
    
    input [5:0] op,func;
    output regwriteD,mem2regD,memwriteD,branchD,jumpD,alucontrolD,alusrcD,regdstD,lwswD;
    
    【CU的具体实现】
 
endmodule
