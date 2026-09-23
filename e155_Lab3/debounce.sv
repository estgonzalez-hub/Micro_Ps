module debounce#(
parameter int width = 20,
parameter int stable = 524_288)(
  input  logic clk,
  input  logic reset,
  input  logic p,
  output logic debounced_p
);

typedef enum logic [1:0] {IDLE, WAIT, PRESSED} statetype;
statetype state, nextstate;

logic [width-1:0] count;

always_ff @(posedge clk or posedge reset) begin
  if (reset) state <= IDLE;
  else       state <= nextstate;
end

counter #(.width(width), .max(stable))  debounce_counter(
  .clk (clk), .reset (state ==  IDLE), .enable (1'b1), .counter (count)
);

always_comb begin
  case(state)
    IDLE: nextstate = p ? WAIT : IDLE;
    WAIT: if (!p)
          nextstate = IDLE;
          else if (count == stable -1) nextstate = PRESSED;
          else nextstate = WAIT;
    PRESSED: nextstate = p ? PRESSED : IDLE;
    default: nextstate = IDLE;
  endcase
end
    assign debounced_p = (state == PRESSED);
endmodule