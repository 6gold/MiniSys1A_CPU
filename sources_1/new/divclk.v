`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description:·ÖÆµÆ÷ 
//////////////////////////////////////////////////////////////////////////////////

module divclk(clk,rst,clk_sys);
    input clk,rst;
    output clk_sys;
    reg clk_sys;
    reg [1:0] div_counter;
    
    always @(posedge clk or negedge rst)
        if(!rst) begin
            clk_sys <= 0;
            div_counter <= 0;
        end
        else if(div_counter >= 2) begin
            clk_sys <= ~clk_sys;
            div_counter <= 0;
        end
        else begin
            div_counter <= div_counter + 1;
        end
endmodule
