`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/30 16:03:32
// Design Name: 
// Module Name: uart_top
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


module UART_top(clk,rst_n,tx_int,rx_int,RS232_rx,data_in,RS232_tx,data_out);
    input clk,rst_n,RS232_rx;
    input [7:0] data_in;
    input tx_int;     //接收数据中断信号,接收过程中一直为高
    output rx_int;
    output RS232_tx;
    output [7:0] data_out;
    
    wire bps_start_rx,bps_start_tx;
    wire clk_bps_rx,clk_bps_tx;
    wire clk_rx,clk_tx;
    wire [7:0] rx_data;   //接收数据存储器,用来存储接收到的数据,直到下一个数据接收

    //parameter BAUD_RATE = 9600;

clk_bluetooth ins_clk_bt(
// Clock out ports
.clk_txd(clk_tx),
.clk_rxd(clk_rx),
// Status and control signals
.resetn(rst_n),
// Clock in ports
.clk_in1(clk)
);

//////////////////////////////////子模块端口申明///////////////////////////////////
speed_select speed_rx(   //数据接收波特率选择模块
.clk(clk_rx),
.rst_n(rst_n),
.bps_start(bps_start_rx),
.clk_bps(clk_bps_rx)
);
            
UART_rx ins_UART_rx(    //数据接收模块
.clk(clk_rx),
.rst_n(rst_n),
.bps_start(bps_start_rx),
.clk_bps(clk_bps_rx),
.RS232_rx(RS232_rx),
.rx_data(rx_data),
.rx_int(rx_int),
.data_out(data_out)
);

speed_select speed_tx(   //数据发送波特率控制模块
.clk(clk_tx),
.rst_n(rst_n),
.bps_start(bps_start_tx),
.clk_bps(clk_bps_tx)         
);

UART_tx ins_UART_tx(
.clk(clk),
.rst_n(rst_n),
.bps_start(bps_start_tx),
.clk_bps(clk_bps_tx),
.RS232_tx(RS232_tx),
.tx_data(data_in),
.tx_int(tx_int)        
);

//wire flag_fifo_empty,flag_fifo_full;

//// Instantiate the Character FIFO - Core generator module
//fifo_bt_txd char_fifo_io (
//    .din    (fifo_din), // Bus [7:0] 
//    .rd_clk (clk_tx),
//    .rd_en  (fifo_rd_en),
//    .rst    (rst_n),          // ASYNCHRONOUS reset - to both sides
//    .wr_clk (clk),
//    .wr_en  (fifo_wr_en),
//    .dout   (fifo_dout), // Bus [7 : 0] 
//    .empty  (flag_fifo_empty),
//    .full   (flag_fifo_full)
//);



endmodule
