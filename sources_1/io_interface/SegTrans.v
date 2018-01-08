`timescale 1ns / 1ps
//number value
module SegTrans (
    input[4:0] code,
    output[6:0] disp
);

assign disp = (code == 5'h10) ? 7'b1000000 :
              (code == 5'h11) ? 7'b1111001 :
              (code == 5'h12) ? 7'b0100100 :
              (code == 5'h13) ? 7'b0110000 :
              (code == 5'h14) ? 7'b0011001 :
              (code == 5'h15) ? 7'b0010010 :
              (code == 5'h16) ? 7'b0000010 :
              (code == 5'h17) ? 7'b1111000 :
              (code == 5'h18) ? 7'b0000000 :
              (code == 5'h19) ? 7'b0010000 :
              (code == 5'h1a) ? 7'b0001000 :
              (code == 5'h1b) ? 7'b0000011 :
              (code == 5'h1c) ? 7'b1000110 :
              (code == 5'h1d) ? 7'b0100001 :
              (code == 5'h1e) ? 7'b0000110 :
              (code == 5'h1f) ? 7'b0001110 :
              7'b1111111;

endmodule
