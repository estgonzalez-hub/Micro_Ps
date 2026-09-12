//Esteban Gonzalez 9/11/2026
//estgonzalez@g.hmc.edu
//Scanning module for e155 lab 2. Keeps track of the state we are in when pressing the keypad.  

module scanning(
	input   logic [1:0] sel,
	input   logic reset,
	input   logic enable,
	output 	logic [3:0] rows
	
	);
	
	always_comb begin 
		 rows = 4'b0000;
	if (reset) begin 
		 rows = 4'b0000;
	end
	else if (enable) begin
		case(sel)
				2'b00:   rows = 4'b0001;
				2'b01:   rows = 4'b0010;
				2'b10:   rows = 4'b0100;
				2'b11:   rows = 4'b1000;
				default: rows = 4'b0000;
		endcase
	end 
end
	
endmodule