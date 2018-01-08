`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 7-seg display module for Minisys-1
//
//////////////////////////////////////////////////////////////////////////////////


module PWMCtrl (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input clk, input[3:0] addr,
    output pwm_out
);

reg en;
reg curr;
reg[15:0] max_v;
reg[15:0] cmp_v;
reg[15:0] ct;

assign dW = 16'hzzzz;
assign pwm_out = en && curr;

always@ (posedge clk) begin
    if (isReset || (isCS && isW)) ct <= 16'h0000;
    else if (ct == max_v) ct <= 0;
    else ct <= ct + 1;
end

always@ (negedge clk) begin
    if (isReset) begin
        en <= 0;
        curr <= 1;
        max_v <= 16'hffff;
        cmp_v <= 16'h7fff;
    end else begin
        if (isCS && isW) begin
            if (addr == 4'h0) max_v <= dR;
            else if (addr == 4'h2) cmp_v <= dR;
            else if (addr == 4'h4) en <= dR[0];
        end
        if (ct == 0) curr <= 1;
        if (ct == cmp_v) curr <= 0;
    end
end

endmodule