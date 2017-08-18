`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/11 11:19:14
// Design Name: 
// Module Name: EEPROM_Top
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

//The driver of EEPROM device 24C02
//It's I2C bus
module EEPROM_Top(  clk, rst_n, rw_en,
                    SCL_en, SCL_o, SCL_i, SDA_en, SDA_o, SDA_i,
                    data_in, data_out);
                    
input clk, rst_n, rw_en;
output reg SCL_en,SCL_o,SDA_en,SDA_o;
input SCL_i,SDA_i;
input data_in;
output wire data_out;

parameter EN_WRITE = 1'b0, EN_READ = 1'b1;

localparam I2CAddr = 7'b1010_000; //Device Address is 000,the LSB is the R/W bit.
localparam  DEVICE_READ = 8'b1010_0001,
            DEVICE_WRITE = 8'b1010_0000;

//Input clock is 100MHz,the working clock is 400kHz.
//400kHz clock generator
reg [15:0] counter;
reg clk_400kHz;

always @ ( posedge clk or negedge rst_n )
if (!rst_n) begin
    counter <= 16'd0;
    clk_400kHz <= 0;
end
else begin
  if( counter == 16'd124 ) begin
    counter <= 16'd0;
    clk_400kHz <= ~clk_400kHz;
  end
  else begin
    counter <= counter + 16'd1;
    clk_400kHz <= clk_400kHz;
  end  
end

localparam  STATE_HIGH    = 2'd0,
            STATE_NEGEDGE = 2'd1,
            STATE_LOW     = 2'd2,
            STATE_POSEDGE = 2'd3;

reg [1:0] SCL_state;

//SCL Controllor
always @ (posedge clk_400kHz or negedge rst_n)
if (rst_n) begin
    SCL_en <= 1'b1;
    SCL_o <= 1'b1;
    SCL_state <= STATE_HIGH;
end
else begin
    case (SCL_state)
        STATE_HIGH: begin
            SCL_o <= 1'b1;
            SCL_state <= STATE_NEGEDGE;
        end
        STATE_NEGEDGE: begin
            SCL_o <= 1'b0;
            SCL_state <= STATE_LOW;
        end
        STATE_LOW: begin
            SCL_o <= 1'b0;
            SCL_state <= STATE_POSEDGE;
        end
        STATE_POSEDGE: begin
            SCL_o <= 1'b1;
            SCL_state <= STATE_HIGH;
        end
    endcase
end

reg [7:0] i2c_state;
localparam Sstop;

reg flag_start,flag_WR;
reg [3:0] shift_counter;
reg [7:0] data_reg;
reg i2c_ack;

//SDA Controllor & Main FSM
always @ (posedge clk_400kHz or negedge rst_n)
if (rst_n) begin
    SDA_en <= 1'b0;
    SDA_o <= 1'b1;
    shift_counter <= 4'd8;
    i2c_ack <= 1'b0;
end
else begin
    case (i2c_state)
        Sidle: begin
            SDA_o <= 1'b1;
            if( flag_start && SCL_state == STATE_POSEDGE ) begin
                SDA_en <= EN_WRITE;
                i2c_state <= Sstart;
            end
            else begin
                SDA_en <= EN_READ;
                i2c_state <= Sidle;
            end
        end
        Sstart: begin
            if(SCL_state == STATE_HIGH) begin
                SDA_o <= 1'b0;
                shift_counter <= 4'd8;
                if (flag_WR == EN_WRITE) begin
                    i2c_state <= Swrite1;
                end
                else begin//if (flag_WR == EN_READ)
                    i2c_state <= Sread1;
                end
            end
            else begin
                i2c_state <= Sstart;
            end
        end
        Swrite1: begin

        end
        Swrite2: begin
            if ( SCL_state == STATE_NEGEDGE ) begin
                if ( shift_counter == 4'd0 ) begin
                    SDA_en <= EN_READ;
                end
            end
            else if ( SCL_state == STATE_LOW ) begin
                case (shift_counter)
                    4'd8: SDA_o <= data_reg[7];
                    4'd7: SDA_o <= data_reg[6];
                    4'd6: SDA_o <= data_reg[5];
                    4'd5: SDA_o <= data_reg[4];
                    4'd4: SDA_o <= data_reg[3];
                    4'd3: SDA_o <= data_reg[2];
                    4'd2: SDA_o <= data_reg[1];
                    4'd1: SDA_o <= data_reg[0];
                    default: shift_counter <= 4'd0;
                endcase
                if ( shift_counter == 4'd0 ) begin
                    i2c_ack <= SDA_i;
                end
                else if ( shift_counter > 4'd0 ) begin
                    
                end
                shift_counter
            end
            else begin
                state <= Swrite
            end
        end
        
        
    endcase
end

endmodule
