module counter #(
	//Set the paremeters depending on the module needing it
	parameter int width = 2,
	parameter int max = 10000000,
	parameter int outWidth = 1
	)(
	input 	logic  		  			clk,
	input 	logic 		   			reset,
	input 	logic 		   			enable,
	output 	logic   [outWidth-1:0]  out    
);
	logic [width-1:0] counter = 0;
	
	// Create counter
	always_ff @(posedge clk)
		begin 
			if(reset) 
				begin 
					counter <= 0;
					out     <= '0;
				end
			
			else  if (enable) begin	
				  if(counter == max - 1) begin
					  counter <= '0;
					  out     <= out + 1'b1;
				 end
				 else 
					    counter <= counter + 1;
				  end
			else begin
						counter <= counter;
		end 
	end
endmodule 