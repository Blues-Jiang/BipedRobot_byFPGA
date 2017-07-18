`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/05 09:27:00
// Design Name: 
// Module Name: servo_moving_test
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


module servo_moving_test(clk,rst_n,pwm_angle);
input clk,rst_n;//clk->clk_50Hz
output reg [15:0] pwm_angle;//500~2500

reg [7:0] counter;
reg [3:0] state;
reg flag;//true->add angle;false->minus angle
parameter S0=4'd0,S1=4'd1;
parameter STEP=20;

always @ (posedge clk or negedge rst_n)
if(!rst_n)
	begin
		counter <= 0;
		state <= S0;
		flag <= 1;
		pwm_angle <= 1500;
	end
else
	begin
		case(state)
			S0: begin
				if( counter < 5 ) begin
					counter <= 0;
					state <= S1;
				end
				else begin
					counter <= counter + 1;
					state <= S0;
				end
			end
			S1: begin
				state <= S0;
				if(flag) begin	//flag == 1 -> Add angle
					if(pwm_angle <= (2400 - STEP)) begin
						pwm_angle <= pwm_angle + STEP;
						
					end
					else begin
						pwm_angle <= pwm_angle;
						flag = 0;
					end
				end
				else begin	//flag == 0 -> Minus angle
					if(pwm_angle >= (600 + STEP)) begin
						pwm_angle <= pwm_angle - STEP;
					end
					else begin
						pwm_angle <= pwm_angle;
						flag = 1;
					end
				end
			end

			
		
		endcase
	end

	
    
endmodule
