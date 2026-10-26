//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26

//Module that contains all the datapath logic. Connects submodules together along with using mux where needed. 


module aes_datapath(
  input  logic clk,
  input  logic sel_load,
  input  logic reg_en, 
  input  logic sel_last,
  input  logic out_en, 
  input  logic [3:0] round, 
  input  logic [127:0] key,
  input  logic [127:0] plaintext,
  output logic [127:0] cyphertext
);
 
logic [127:0] state_r, round_key_r;
logic [127:0] sub_out, shift_out, mix_out, first_mux, last_mux, next_key, key_mux, ark_out;
logic [7:0]   rcon;

sub_bytes sub(.clk(clk), .a(state_r), .y(sub_out));
shiftrows shift(.a(sub_out), .y(shift_out));
mixcolumns mix(.a(shift_out), .y(mix_out)); 

assign last_mux = sel_last ? shift_out : mix_out;
assign first_mux = sel_load ? plaintext : last_mux;

rcon_lut  rcon_r(.round(round), .rcon(rcon));
key_expansion key_r(.clk(clk), .key(round_key_r), .rcon(rcon), .next_key(next_key));

assign key_mux = sel_load ? key : next_key; 

add_round_key add_r(.state(first_mux), .round_key(key_mux), .y(ark_out));

always_ff @(posedge clk)
  if (reg_en) begin 
    state_r  <= ark_out;
    round_key_r <= key_mux;
  end
  //add potential flip flop to output only the final state
  always_ff @(posedge clk)
  if (out_en) cyphertext <= ark_out;


endmodule
