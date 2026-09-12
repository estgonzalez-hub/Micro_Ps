//Esteban Gonzalez 9/11/2026
//estgonzalez@g.hmc.edu
//Top module that instantiates all the modules.


module top(
		input  logic [3:0] s0,
		input  logic [3:0] s1, 
		input  logic       reset, 
		input  logic       enable,
		output logic       c1,
		output logic       c2,
		output logic [6:0] seg
		);
		
		logic int_osc; 
		logic sel;
		logic dip_switch;
		
		//Internal high-speed oscillator 
		HSOSC #(.CLKHF_DIV(2'b01))
			hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc)); 
			
		
		//Instantiating modules 
		counter #(21, 2000000) segment_time (.clk  (int_osc),  .reset (1'b0), .enable (1'b1), .out (sel));
		//counter #(24, 10000000) matrix_time(.clk  (int_osc),  .reset (1'b0), .enable (1'b1), .out (sel));
		seven_segment (.s (dip_switch), .seg (seg)); 
		
		//Assign statements to implement the multiplexing and scanning 
		assign dip_switch = sel ? s0 : s1;
		assign c1 = sel ? 1 : 0;
		assign c2 = sel ? 0 : 1; 
		
		
		
endmodule 