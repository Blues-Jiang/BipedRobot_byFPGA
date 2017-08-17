`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 09:50:20
// Design Name: 
// Module Name: pwm
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


module pwm(clk,rst,pwm_duty,pwm_offset,pwm_out);
input clk;//->clock_100kHz
input rst;//->clock_50Hz,posedge trigger
input [7:0] pwm_duty;//Duty Cycle:50(0.5ms)-250(2.5ms)
input [7:0] pwm_offset;//Offset Correction Signal.It's point to the default position of servo
output pwm_out;//It's just the output wire signal,the signal in the always@ block is **pwm_buffer**

reg pwm_buffer;//it's a buffer of pwm signal.
reg [7:0] counter;

parameter [7:0] PWM_DEFAULT = 8'd150;
wire [7:0] duty_temp;
wire [7:0] duty_check;

assign duty_temp = pwm_duty + ( pwm_offset - PWM_DEFAULT );//Corrected Signal by pwm_offset
assign duty_check = ( duty_temp >= 50 && duty_temp <= 250) ? duty_temp : PWM_DEFAULT;//In case of duty cycle is out of range

always @ (posedge clk or posedge rst)
    if(rst)
        begin
            counter <= 0;
            pwm_buffer <= 1;
        end
    else
        begin
            if( counter <= duty_check )
                begin
                    pwm_buffer <= 1;
                    counter <= counter + 1;
                end
            else
                begin
                    pwm_buffer <= 0;
                    counter <= counter;//lock counter
                end
        end
        
    assign pwm_out = pwm_buffer;

endmodule
