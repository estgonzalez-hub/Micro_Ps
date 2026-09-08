//Esteban Gonzalez 9/6/2026
//estgonzalez@g.hmc.edu
//Counter module for e155 lab 1. This counter blinks led[2]. 

module counter(
	input 	logic  		   clk,
	input 	logic 		   reset,
	input 	logic 		   enable,
	output 	logic          led
	
);
	logic [31:0] counter = 0;
	logic led_two = 0;
	
	//Change the frequency from the HSOC to ~ 2 Hz
	parameter signal = 10000000;
	// Create counter
	always_ff @(posedge clk)
		begin 
			if(reset) 
				begin 
					counter <= 32'd0;
					led_two <= 1'b0;
				end
			
			else  if (enable) begin	
			      if (counter == signal - 1) begin 
					    counter <= 32'd0;
						led_two <= ~led_two;
				  end
		
			else 
				begin 
						counter <= counter + 1;
				end
				
		end 
	end
		
		assign led = led_two;
endmodule 
