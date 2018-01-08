`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module WatchDog (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input clk,
    output reg w_reset
);

reg[2:0] ct_rst;
reg[15:0] ct_watch;

always@ (negedge clk) begin
    if (isReset || (isCS && isW)) begin
        w_reset <= 1'b0;
        ct_rst <= 3'h0;
        ct_watch <= 16'hffff;
    end else if (w_reset) begin
        ct_rst <= ct_rst + 1'b1;
        if (ct_rst == 3'h3) begin
            w_reset <= 1'b0;
            ct_watch <= 16'hffff;
        end
    end else begin
        ct_watch <= ct_watch - 1'b1;
        if (ct_watch == 16'h0000) begin
            w_reset <= 1'b1;
            ct_rst <= 3'h0;
        end
    end
end

endmodule
