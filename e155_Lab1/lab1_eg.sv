//Esteban Gonzalez 9/6/2026
//estgonzalez@g.hmc.edu
//Top module for e155 lab 1. Runs all the modules together to make a seven segment display
//hexadecimal numbers from 4 switch inputs.


module top( 
	input  logic 	[3:0] s, 
	output logic	[2:0] led,
	output logic	[6:0] seg
);
	logic int_osc;
	
	//Internal high-speed oscillator
	HSOSC #(.CLKHF_DIV(2'b01))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	//Assign switch-to-led outputs
	assign led[0] = s[0] ^ s[1];
	assign led[1] = s[2] & s[3];
	
	//Instantiating modules
	seven_segment_display display(
	.s 		(s),
	.seg	(seg)	
	);
	
	counter blinking_led(
	.clk	(int_osc),
	.reset  (1'b0),
	.enable (1'b1),
	.led 	(led[2])
	);
endmodule 
