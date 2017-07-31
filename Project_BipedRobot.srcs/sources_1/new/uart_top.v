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


module UART_top(clk,rst_n,tx_int,RS232_rx,data_in,RS232_tx,data_out);
    input clk,rst_n,RS232_rx;
    input [7:0] data_in;
    input tx_int;     //接收数据中断信号,接收过程中一直为高
    output RS232_tx;
    output [7:0] data_out;
    wire bps_start1,bps_start2;
    wire clk_bps1,clk_bps2;
    wire [7:0] rx_data;   //接收数据存储器,用来存储接收到的数据,直到下一个数据接收
       
//    reg [32:0] count=0;  //计数器1用来 
//    reg clk_2s;       //定时器
//    parameter T1S=50000000; //2s更新一次状态 200 000 000 
    
//    always @ (posedge clk)
//    begin
//      count<=count+1;
//      if(count==T1S) 
//          begin 
//          count<=0; 
//          clk_2s<=~clk_2s;      
//          end
//    end
    
//////////////////////////////////子模块端口申明///////////////////////////////////
speed_select speed_rx(   //数据接收波特率选择模块
    .clk(clk),
    .rst_n(rst_n),
    .bps_start(bps_start1),
    .clk_bps(clk_bps1)
);
            
UART_rx ins_UART_rx(    //数据接收模块
    .clk(clk),
    .rst_n(rst_n),
    .bps_start(bps_start1),
    .clk_bps(clk_bps1),
    .RS232_rx(RS232_rx),
    .rx_data(rx_data),
    .rx_int(rx_int),
    .data_out(data_out)
);
speed_select speed_tx(   //数据发送波特率控制模块
    .clk(clk),
    .rst_n(rst_n),
    .bps_start(bps_start2),
    .clk_bps(clk_bps2)         
);
                     
UART_tx UART_tx(
    .clk(clk),
    .rst_n(rst_n),
    .bps_start(bps_start2),
    .clk_bps(clk_bps2),
    .RS232_tx(RS232_tx),
    .rx_data(data_in),
    .rx_int(tx_int)        
);

endmodule
