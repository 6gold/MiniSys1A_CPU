`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Timer module for Minisys-1
// 
//////////////////////////////////////////////////////////////////////////////////


module Timer (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input clk, input[3:0] addr,
    input pulse1, input pulse2,
    output reg cout1,
    output reg cout2
);

reg rep1;
reg mode1;
reg[15:0] curr_ct1;
reg[15:0] curr_tm1;
reg[15:0] init_ct1;
reg[1:0] pulse_samp1;

wire tm_done1;
assign tm_done1 = ~mode1 && ((curr_tm1 == 16'h0001) || (curr_tm1 == 16'h0000));
wire ct_done1;
assign ct_done1 = mode1 && (curr_ct1 == init_ct1);

reg rep2;
reg mode2;
reg[15:0] curr_ct2;
reg[15:0] curr_tm2;
reg[15:0] init_ct2;
reg[1:0] pulse_samp2;

wire tm_done2;
assign tm_done2 = ~mode2 && ((curr_tm2 == 16'h0001) || (curr_tm2 == 16'h0000));
wire ct_done2;
assign ct_done2 = mode2 && (curr_ct2 == init_ct2);

wire is_regW_1;
assign is_regW_1 = isCS && isW && (addr == 4'h0 || addr == 4'h4);

wire is_regW_2;
assign is_regW_2 = isCS && isW && (addr == 4'h2 || addr == 4'h6);

wire is_statR_1;
assign is_statR_1 = isCS && ~isW && addr == 4'h0;

wire is_statR_2;
assign is_statR_2 = isCS && ~isW && addr == 4'h2;
/*
always@ (posedge pulse1) begin
    if (mode1 && (rep1 || ~ct_done1)) curr_ct1 <= curr_ct1 + 1;
end

always@ (posedge pulse2) begin
    if (mode2 && (rep2 || ~ct_done2)) curr_ct2 <= curr_ct2 + 1;
end
*/
always@ (negedge clk) begin
    if (isReset) begin
        curr_ct1 <= 16'h0000;
        curr_ct2 <= 16'h0000;
        curr_tm1 <= 16'h0000;
        curr_tm2 <= 16'h0000;
    end else begin
        if (mode1) begin
            if (is_regW_1 || (ct_done1 && (rep1 || is_statR_1))) curr_ct1 <= 16'h0000;
            else if (pulse_samp1 == 2'h1) begin // posedge pulse1
                if (mode1 && (rep1 || ~ct_done1)) curr_ct1 <= curr_ct1 + 1;
            end
        end else begin
            if (((rep1 || is_statR_1) && curr_tm1 == 16'h0000) || is_regW_1) begin
                curr_tm1 <= init_ct1;
            end else if (~tm_done1 || curr_tm1 == 16'h0001) curr_tm1 <= curr_tm1 - 1;
        end
        if (mode2) begin
            if (is_regW_2 || (ct_done2 && (rep2 || is_statR_2))) curr_ct2 <= 16'h0000;
            else if (pulse_samp2 == 2'h1) begin // posedge pulse2
                if (mode2 && (rep2 || ~ct_done2)) curr_ct2 <= curr_ct2 + 1;
            end
        end else begin
            if (((rep2 || is_statR_2) && curr_tm2 == 16'h0000) || is_regW_2) begin
                curr_tm2 <= init_ct2;
            end else if (~tm_done2 || curr_tm2 == 16'h0001) curr_tm2 <= curr_tm2 - 1;
        end
    end
end

always@ (posedge clk) begin
    if (isReset || is_regW_1) begin
        cout1 <= 1;
        pulse_samp1 <= 2'h0;
    end
    if (isReset || is_regW_2) begin
        cout2 <= 1;
        pulse_samp2 <= 2'h0;
    end 
    if (isReset) begin
        rep1 <= 0;
        mode1 <= 0;
        init_ct1 <= 16'hffff;
        rep2 <= 0;
        mode2 <= 0;
        init_ct2 <= 16'hffff;
    end else if (isCS && isW) begin
        if (addr == 4'h0) begin
            rep1 <= dR[1];
            mode1 <= dR[0];
        end else if (addr == 4'h2) begin
            rep2 <= dR[1];
            mode2 <= dR[0];
        end else if (addr == 4'h4) begin
            init_ct1 <= dR;
        end else if (addr == 4'h6) begin
            init_ct2 <= dR;
        end
    end else begin
        /*if (isCS && ~isW) begin
            if (addr == 4'h0) begin
                dW <= { 14'h0000, ct_done1, tm_done1 };
            end else if (addr == 4'h2) begin
                dW <= { 14'h0000, ct_done2, tm_done2 };
            end else if (addr == 4'h4) begin
                dW <= init_ct1;
            end else if (addr == 4'h6) begin
                dW <= init_ct2;
            end
        end else dW <= 16'hzzzz;*/
        pulse_samp1 <= { pulse_samp1[0], pulse1 };
        pulse_samp2 <= { pulse_samp2[0], pulse2 };
        if (~mode1) begin
            if (curr_tm1 == 16'h0001) cout1 <= 0;
            else if (curr_tm1 == 16'h0000) cout1 <= 1;
        end
        if (~mode2) begin
            if (curr_tm2 == 16'h0001) cout2 <= 0;
            else if (curr_tm2 == 16'h0000) cout2 <= 1;
        end
    end
end

assign dW = (isCS && ~isW) ? (
            (addr == 4'h0) ? { 14'h0000, ct_done1, tm_done1 } :
            (addr == 4'h2) ? { 14'h0000, ct_done2, tm_done2 } :
            (addr == 4'h4) ? ( mode1 ? curr_ct1 : curr_tm1) :
            (addr == 4'h6) ? ( mode2 ? curr_ct2 : curr_tm2) :
            16'hzzzz ) : 16'hzzzz;

endmodule