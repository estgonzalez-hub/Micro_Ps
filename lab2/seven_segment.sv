//Esteban Gonzalez 9/11/2026
//estgonzalez@g.hmc.edu
//seven_segment module for e155 lab 2. Combinational logic where it takes switch inputs and 
//generates the corresponding hexadecimal digit on the segment display

module seven_segment( 
		input 	logic 	[3:0] s,
		output 	logic 	[6:0] seg
);

	logic [6:0] segment; 
//Case for decoding the swtich inputs and displaying the corresponding hexadecimal digit
	always_comb 
	begin 
		case(s)
				4'b0000:  segment = 7'b1111110;
				4'b0001:  segment = 7'b0110000;
				4'b0010:  segment = 7'b1101101;
				4'b0011:  segment = 7'b1111001;
				4'b0100:  segment = 7'b0110011;
				4'b0101:  segment = 7'b1011011;
				4'b0110:  segment = 7'b1011111;
				4'b0111:  segment = 7'b1110000;
				4'b1000:  segment = 7'b1111111;
				4'b1001:  segment = 7'b1111011;
				4'b1010:  segment = 7'b1110111;
				4'b1011:  segment = 7'b0011111;
			    4'b1100:  segment = 7'b1001110;
				4'b1101:  segment = 7'b0111101;
				4'b1110:  segment = 7'b1001111;
				4'b1111:  segment = 7'b1000111;
			
			default:  segment = 7'b0000000;
		endcase
	end 
	
	//Invert because the display has a common anode, so it lights on with a 0 and turns off with 1
	assign seg = ~segment;
endmodule
