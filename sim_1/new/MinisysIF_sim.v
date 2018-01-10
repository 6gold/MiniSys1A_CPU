`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: MinisysIF·ÂÕæ
//////////////////////////////////////////////////////////////////////////////////

module MinisysIF_sim();
    reg clk=0,clrn=0;
    
    wire [31:0] instrD,pcplus4F,pcplus4D,pc,pcF,instrF;
    
    wire [1:0] sel;
    MinisysIF MinisysIF(
        .branchM(1'b0),.pc_branchM({32'b0}),
        .clk(clk),.clrn(clrn),.load_use({1'b0}),
        .jumpI({1'b0}),.pc_jumpI({32'b0}),.keepmdE({1'b0}),
        /* output */
        .instrD(instrD),.pcplus4F(pcplus4F),.pcplus4D(pcplus4D),
        .pc(pc),.pcF(pcF),.instrF(instrF),.sel(sel)//to¡¾ID¡¿        
    );
        
    initial begin

    forever
    #5 clk = ~clk;
    end
    always begin
    #5 clrn=1;
    end
endmodule
