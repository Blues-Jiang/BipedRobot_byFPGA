`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/31 09:57:03
// Design Name: 
// Module Name: Sonic
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


module Sonic(clk,rst_n,trig,echo,distance);
input clk,rst_n,echo;
output trig;
output wire [23:0] distance;

reg [23:0] distance_reg;
//produce trig  signal
//period 60ms


reg [21:0] counter_period;
always @( posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			counter_period<=0;
		end
	else  if(counter_period==22'd3000000)
				begin
					counter_period<=0;
				end
			else	
				counter_period<=counter_period+1'b1;
end

assign trig=((counter_period>=22'd100)&(counter_period<=22'd599))?1:0;

//detect echo  signal,compute the distance
wire start,finish;
reg [23:0]counter;  //compute by the max distance,max time
reg echo_reg1,echo_reg2;
assign start=echo_reg1&~echo_reg2;   //posedge
assign finish=~echo_reg1&echo_reg2;	 //negedge
always @(posedge clk)
if(!rst_n)
    begin
		echo_reg1<=0;
		echo_reg2<=0;
	end
else
	begin
		echo_reg1<=echo;
		echo_reg2<=echo_reg1;
	end

parameter idle=2'b00,state1=2'b01,state2=2'b10;

reg [1:0]state;

always @(posedge clk or negedge rst_n)
    if(!rst_n) begin	
	   state<=idle;
	   counter<=0;
	end
	else begin
	   case(state)
	       idle: begin
	           if(start)
	               state<=state1;
		       else
			       state<=idle;  
			end
			state1:	begin
                if(finish)
                    state<=state2;
				else begin
					counter <= counter + 1'b1;
					state<=state1;
                end
            end
			state2: begin
			     counter<=0;
		         distance_reg <= counter;
				 state<=idle;
			end
			default: state<=idle;
		endcase
    end
	
assign distance=distance_reg;

endmodule
