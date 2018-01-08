`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Keyboard module for Minisys-1
// 
//////////////////////////////////////////////////////////////////////////////////
module Keyboard (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input clk, input[3:0] addr,
    input[3:0] row,
    output[3:0] col
);
reg[1:0] step;
reg[3:0] key_value;
reg[15:0] pause_ct;
reg is_pressed;
assign col = isReset ? 4'b1111 :
             (step == 2'h0) ? 4'b0111 :
             (step == 2'h1) ? 4'b1011 :
             (step == 2'h2) ? 4'b1101 :
             4'b1110;
always @(posedge clk) begin
    if (isReset) begin
        step <= 2'h0;
        pause_ct <= 16'h0000;
    end else begin
        if (pause_ct == 16'h0000) begin
            if (is_pressed) pause_ct <= 16'h0001;
            else step <= step + 1;
        end else pause_ct <= pause_ct + 1;
    end
end
always @(negedge clk) begin
    if (isReset) begin
        key_value <= 4'h0;
        is_pressed <= 0;
    end else begin
        if (~row[0]) begin
            is_pressed <= 1;
            key_value <= (step == 2'h0) ? 4'h1 :
                         (step == 2'h1) ? 4'h2 :
                         (step == 2'h2) ? 4'h3 :
                         4'ha;
        end else if (~row[1]) begin
            is_pressed <= 1;
            key_value <= (step == 2'h0) ? 4'h4 :
                         (step == 2'h1) ? 4'h5 :
                         (step == 2'h2) ? 4'h6 :
                         4'hb;
        end else if (~row[2]) begin
            is_pressed <= 1;
            key_value <= (step == 2'h0) ? 4'h7 :
                         (step == 2'h1) ? 4'h8 :
                         (step == 2'h2) ? 4'h9 :
                         4'hc;
        end else if (~row[3]) begin
            is_pressed <= 1;
            key_value <= (step == 2'h0) ? 4'h0 :
                         (step == 2'h1) ? 4'hf :
                         (step == 2'h2) ? 4'he :
                         4'hd;
        end else begin
            is_pressed <= 0;
        end
    end
end
assign dW = (~isCS || isW) ? 16'hzzzz :
            (addr == 4'h0) ? { 12'h000, key_value } :
            (addr == 4'h2) ? { 15'h0000, is_pressed } :
            16'hzzzz;
endmodule