`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////


module LED (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input clk,
    output reg[15:0] data
);

always@ (negedge clk) begin
   if (isReset) data <= 16'h0000;
   else if (isCS && isW) data <= dR;
end

assign dW = isReset ? 16'hzzzz :
            (isCS && ~isW) ? data : 16'hzzzz;

endmodule
