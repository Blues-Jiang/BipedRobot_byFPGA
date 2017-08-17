-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.1 (win64) Build 1846317 Fri Apr 14 18:55:03 MDT 2017
-- Date        : Mon Aug 14 17:02:30 2017
-- Host        : ACER-BLUES running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/Design_Project/E_elements/Project_BipedRobot/Project_BipedRobot.srcs/sources_1/ip/clk_wiz_1/clk_wiz_1_stub.vhdl
-- Design      : clk_wiz_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_1 is
  Port ( 
    clk_txd : out STD_LOGIC;
    clk_rxd : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_wiz_1;

architecture stub of clk_wiz_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_txd,clk_rxd,resetn,locked,clk_in1";
begin
end;
