module counter #(
//Set the paremeters depending on the module needing it
parameter int width = 2,
parameter int max = 10000000
)(
input logic     clk,
input logic   reset,
input logic   enable,
output logic   [width-1:0]  counter    
);


// Create counter
always_ff @(posedge clk)
begin
if(reset)
begin
counter <= 0;
end

else  if (enable) begin
 if(counter == max - 1) begin
 counter <= '0;
end
else
   counter <= counter + 1'b1;
end
end

endmodule