`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: ���Ƶ�ԪCU
//////////////////////////////////////////////////////////////////////////////////


module CU(
    /* input */
    op,func,
    /* output */
    regwriteD,mem2regD,memwriteD,branchD,jumpD,alucontrolD,alusrcD,regdstD,lwswD
    );
    
    input [5:0] op,func;
    output regwriteD,mem2regD,memwriteD,branchD,jumpD,alucontrolD,alusrcD,regdstD,lwswD;
    
    ��CU�ľ���ʵ�֡�
 
endmodule
