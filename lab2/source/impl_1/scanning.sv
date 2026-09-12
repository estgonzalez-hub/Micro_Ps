//Esteban Gonzalez 9/11/2026
//estgonzalez@g.hmc.edu
//Scanning module for e155 lab 2. Keeps track of the state we are in when pressing the keypad.  

module scanning(
	input   logic clk,
	output 	logic [3:0] row0,
	output  logic [3:0] row1,
	output  logic [3:0] row2,
	output  logic [3:0] row3
	);
	
	  logic col0;
	  logic col1;
	  logic col2;
	  logic col3;
	  logic led0;
	  logic led1;
	  logic led2;
	  logic led3;
	
endmodule