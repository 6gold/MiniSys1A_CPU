// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
// Date        : Thu Jan 11 10:46:34 2018
// Host        : Lenovo-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/MIPSfpga_Fundamentals/Xilinx/VivadoProject/SoC/cla/cla.srcs/sources_1/ip/ram0/ram0_stub.v
// Design      : ram0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1157-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_1,Vivado 2015.4" *)
module ram0(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[13:0],dina[7:0],douta[7:0]" */;
  input clka;
  input [0:0]wea;
  input [13:0]addra;
  input [7:0]dina;
  output [7:0]douta;
endmodule
