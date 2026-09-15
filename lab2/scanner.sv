module scanning(
	input   logic [1:0] sel,
	input   logic reset,
	input   logic enable,
	output 	logic [3:0] rows
	
	);
	
	always_comb begin 
		 rows = 4'b1111;
	if (reset) begin 
		 rows = 4'b1111;
	end
	else if (enable) begin
		case(sel)
				2'b00:   rows = 4'b1110;
				2'b01:   rows = 4'b1101;
				2'b10:   rows = 4'b1011;
				2'b11:   rows = 4'b0111;
				default: rows = 4'b1111;
		endcase
	end 
end
	
endmodule