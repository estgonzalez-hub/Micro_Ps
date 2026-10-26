//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26
// Synchronous version of sbox 

 module sbox(
 	input	 	logic 			clk,
  input		logic [7:0] a,
 	output 	logic [7:0] y);
            
  // sbox implemented as a ROM
   // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [7:0] sbox [0:255];

  initial   $readmemh("sbox.txt", sbox);
	
 	// Synchronous version
 	always_ff @(posedge clk) begin
 		y <= sbox[a];
 	end
 endmodule
