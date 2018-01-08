`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 7-seg display module for Minisys-1
// 
//////////////////////////////////////////////////////////////////////////////////
module SegDisp (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input clk, input[3:0] addr,
    output[7:0] disp_data,
    output reg[7:0] disp_sel
);
reg[2:0] curr_digi;
reg[31:0] digi_data;
reg[15:0] digi_ctl;
reg[5:0] curr_digi_data;
SegTrans st(curr_digi_data[4:0], disp_data[6:0]);
assign disp_data[7] = ~curr_digi_data[5];
wire[7:0] digi_sel_trans;
Decoder38 dec(curr_digi, digi_sel_trans);
always@ (negedge clk) begin
    if (isReset) begin
        digi_data <= 32'h0000;
        digi_ctl <= 16'h0000;
    end else begin
        if (isCS && isW) begin
            if (addr == 4'h0) digi_data[15:0] <= dR;
            else if (addr == 4'h2) digi_data[31:16] <= dR;
            else if (addr == 4'h4) digi_ctl <= dR;
        end
    end
end
assign dW = (~isCS || isW) ? 16'hzzzz :
            (addr == 4'h0) ? digi_data[15:0] :
            (addr == 4'h2) ? digi_data[31:16] :
            (addr == 4'h4) ? digi_ctl :
            16'hzzzz;
reg clk_ds = 0; // 100 MHz / 2^16 = 1.52 KHz
reg[10:0] clk_ct = 11'h0;
always@ (posedge clk) begin
    clk_ct <= clk_ct + 1;
end
always@ (negedge clk) begin
    if (clk_ct == 11'h0) clk_ds <= ~clk_ds;
end
always@ (posedge clk_ds) begin
    if (isReset) curr_digi <= 3'h0;
    else curr_digi <= curr_digi + 1;
end
always@ (negedge clk_ds) begin
    if (isReset) begin
        curr_digi_data <= 6'h00;
        disp_sel <= 8'h00;
    end else begin
        case (curr_digi)
            3'h0: if (digi_ctl[15]) curr_digi_data <= { digi_ctl[7], 1'b1, digi_data[31:28] }; else curr_digi_data <= 6'h00;
            3'h1: if (digi_ctl[14]) curr_digi_data <= { digi_ctl[6], 1'b1, digi_data[27:24] }; else curr_digi_data <= 6'h00;
            3'h2: if (digi_ctl[13]) curr_digi_data <= { digi_ctl[5], 1'b1, digi_data[23:20] }; else curr_digi_data <= 6'h00;
            3'h3: if (digi_ctl[12]) curr_digi_data <= { digi_ctl[4], 1'b1, digi_data[19:16] }; else curr_digi_data <= 6'h00;
            3'h4: if (digi_ctl[11]) curr_digi_data <= { digi_ctl[3], 1'b1, digi_data[15:12] }; else curr_digi_data <= 6'h00;
            3'h5: if (digi_ctl[10]) curr_digi_data <= { digi_ctl[2], 1'b1, digi_data[11:8]  }; else curr_digi_data <= 6'h00;
            3'h6: if (digi_ctl[9])  curr_digi_data <= { digi_ctl[1], 1'b1, digi_data[7:4]   }; else curr_digi_data <= 6'h00;
            3'h7: if (digi_ctl[8])  curr_digi_data <= { digi_ctl[0], 1'b1, digi_data[3:0]   }; else curr_digi_data <= 6'h00;
        endcase
        disp_sel <= digi_sel_trans;
    end
end
endmodule