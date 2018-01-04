`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/05 00:22:57
// Design Name: 
// Module Name: MinisysWB_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MinisysWB_sim();
    wire [4:0] write_regD;

    MinisysWB MinisysWB(
        .write_$31W({1'b1}),
        .write_regW({5'b10000}),
        /* output */
        .write_regD(write_regD)
    );
endmodule
