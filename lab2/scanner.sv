//Esteban Gonzalez 9/11/2026
//estgonzalez@g.hmc.edu
//Scanning module for e155 lab 2. Keeps track of the state we are in when pressing the keypad. 

module scanning#(
parameter int width = 22,
parameter int max = 3000000)(
input logic  clk,
input   logic reset,
input   logic enable,
output logic [3:0] rows

);
//Instantiating Clock
 logic [22:0] sel;
 counter #(.width(width), .max(max)) matrix_time(.clk  (clk),  .reset (reset), .enable (enable), .counter (sel));
 
 
 
//Logic for led to blink
	always_comb begin
		rows = 4'b0000;
	if (reset) begin 
		rows = 4'b0000;
	end
	else if (sel < max/4) begin
		rows = 4'b0001;
	end
	else if (sel < max/2) begin
		rows = 4'b0010;
	end
	else if (sel < 3*max/4) begin
		rows = 4'b0100;
	end
	else  begin
		rows = 4'b1000;
		end
	end

endmodule