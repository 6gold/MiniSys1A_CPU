`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Switch module for Minisys-1
// 
//////////////////////////////////////////////////////////////////////////////////


module Switch (
    input isReset, input isCS, input isW,
    input[15:0] dR, output[15:0] dW,
    input[15:0] data
);

assign dW = isReset ? 16'hzzzz :
            (isCS && ~isW) ? data : 16'hzzzz;

endmodule
