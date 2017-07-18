## Clock signal
set_property PACKAGE_PIN P17 [get_ports clock]							
	set_property IOSTANDARD LVCMOS33 [get_ports clock]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clock]
	
## Reset signal
set_property PACKAGE_PIN R10 [get_ports reset]					
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
 
## PWM signal List
##set_property PACKAGE_PIN P18 [get_ports pwm_out]	
set_property PACKAGE_PIN K6 [get_ports pwm_out]
	set_property IOSTANDARD LVCMOS33 [get_ports pwm_out]
