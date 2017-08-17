// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.1 (win64) Build 1846317 Fri Apr 14 18:55:03 MDT 2017
// Date        : Tue Aug 15 11:27:47 2017
// Host        : ACER-BLUES running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Design_Project/E_elements/Project_BipedRobot/Project_BipedRobot.srcs/sources_1/ip/clk_bluetooth/clk_bluetooth_stub.v
// Design      : clk_bluetooth
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_bluetooth(clk_txd, clk_rxd, resetn, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_txd,clk_rxd,resetn,locked,clk_in1" */;
  output clk_txd;
  output clk_rxd;
  input resetn;
  output locked;
  input clk_in1;
endmodule
