`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/30 16:36:30
// Design Name: 
// Module Name: uart_tx
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


module UART_tx(clk,rst_n,bps_start,clk_bps,RS232_tx,tx_data,tx_int);
 input clk;
    input rst_n;
    input clk_bps;//�м������
    input [7:0] tx_data;//�������ݼĴ���
    input tx_int;//���ݽ����ж��ź�
    output RS232_tx;//���������ź�
    output bps_start;//�����ź���λ
    
    reg tx_int0,tx_int1,tx_int2;//�źżĴ���,��׽�½���
    wire neg_tx_int;    //�½��ر�־
    
    always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
      tx_int0 <= 1'b0;
      tx_int1 <= 1'b0;
      tx_int2 <= 1'b0;
     end
     else begin
       tx_int0 <= tx_int;
       tx_int1 <= tx_int0;
       tx_int2 <= tx_int1;
     end
    end
 
     assign neg_tx_int = ~tx_int1 & tx_int2;//��׽����
     
     reg [7:0] tx_data_reg;//����������
     reg bps_start_r;
     reg tx_en;//�����ź�ʹ��,����Ч
     reg [3:0] num;
    
    always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
      bps_start_r <= 1'bz;
      tx_en <= 1'b0;
      tx_data_reg <= 8'd0;
     end
  else if(neg_tx_int) begin//����⵽���ص�ʱ��,���ݿ�ʼ����
      bps_start_r <= 1'b1;
      tx_data_reg <= tx_data;
      tx_en <= 1'b1;
     end
     else if(num==4'd11) begin
      bps_start_r <= 1'b0;
      tx_en <= 1'b0;
     end 
    end
 assign bps_start = bps_start_r;
    
    reg RS232_tx_r;
    always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
      num<=4'd0;
      RS232_tx_r <= 1'b1;
     end
     else if(tx_en) begin
      if(clk_bps) begin
       num<=num+1'b1;
       case(num)
       4'd0: RS232_tx_r <= 1'b0;//��ʼλ
       4'd1: RS232_tx_r <= tx_data[0];//����λ ��ʼ
       4'd2: RS232_tx_r <= tx_data[1];
       4'd3: RS232_tx_r <= tx_data[2];
       4'd4: RS232_tx_r <= tx_data[3];
       4'd5: RS232_tx_r <= tx_data[4];
       4'd6: RS232_tx_r <= tx_data[5];
       4'd7: RS232_tx_r <= tx_data[6];
       4'd8: RS232_tx_r <= tx_data[7];
       4'd9: RS232_tx_r <= 1'b1;//���ݽ���λ,1λ
       default: RS232_tx_r <= 1'b1;
     endcase
    end
    else if(num==4'd11)
     num<=4'd0;//�������,��λ
   end
  end
  assign RS232_tx =RS232_tx_r;
endmodule

