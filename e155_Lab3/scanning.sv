module scanning#(
parameter int width = 22,
parameter int max = 300_000)(
input  logic  clk,
input  logic reset,
input  logic enable,
output logic [3:0] rows
);
//Instantiating Clock
 logic [width-1:0] sel;
 counter #(.width(width), .max(max)) matrix_time(.clk  (clk),  .reset (reset), .enable (enable), .counter (sel));
 assign scan_done = (sel == max-1);
 
 
 
//Logic for led to blink
always_ff @(posedge clk or posedge reset) begin
if (reset) begin
rows = 4'b1111;
end
else if (enable) begin
    if (sel < max/4)
rows = 4'b1110;
else if (sel < max/2)
rows = 4'b1101;
else if (sel < 3*max/4)
rows = 4'b1011;
else  
rows = 4'b0111;
  end
end

endmodule