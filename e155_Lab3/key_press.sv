//Esteban Gonzalez 9/20/2026
//estgonzalez@g.hmc.edu
//key_press module for e155 lab 3. This is the fsm module for the key press, ensuring it meets the specs 
//of only one press being read at a time. 

module key_press(
  input  logic clk,
  input  logic reset,
  input  logic [3:0] cols,
  input  logic [3:0] rows,
  input  logic debounced_key,
  output logic scan_enable,
  output logic [3:0] d0,
  output logic [3:0] d1
);

typedef enum logic [1:0] {SCAN, PRESS, HOLD} statetype;
statetype state, nextstate;
      logic key_before;
      logic [3:0] cols_inv;
        assign cols_inv = ~cols;
        assign key_before = (cols_inv != 4'b0000) && ((cols_inv & (cols_inv - 1)) == 4'b0000);



logic [3:0] keys;

number_assign decode(.rows(rows), .cols(cols), .left_digit (keys));

always_ff @(posedge clk or posedge reset) begin
  if (reset) state <= SCAN;
  else       state <= nextstate;
end
 
always_comb begin
    case(state)
      SCAN: nextstate = debounced_key ? PRESS : SCAN;
      PRESS: nextstate = HOLD;
      HOLD: nextstate  = debounced_key ? HOLD : SCAN;
      default:  nextstate = SCAN;
    endcase
end

assign scan_enable = ~key_before;

always_ff @(posedge clk or posedge reset)begin
  if (reset) begin
      d0 <= 4'b0;
      d1 <= 4'b0;
  end
  else if (state == PRESS) begin
      d1 <= d0;
      d0 <= keys;
    end
  end

endmodule
 