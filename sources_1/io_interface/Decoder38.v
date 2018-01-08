`timescale 1ns / 1ps
//decimial point

module Decoder38 (
    input[2:0] in,
    output[7:0] out
);

assign out = (in == 3'h0) ? 8'b01111111 :
             (in == 3'h1) ? 8'b10111111 :
             (in == 3'h2) ? 8'b11011111 :
             (in == 3'h3) ? 8'b11101111 :
             (in == 3'h4) ? 8'b11110111 :
             (in == 3'h5) ? 8'b11111011 :
             (in == 3'h6) ? 8'b11111101 :
             (in == 3'h7) ? 8'b11111110 :
             8'h00;

endmodule
