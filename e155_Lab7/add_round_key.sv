//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26
//Module that combines state with round key by using XOR 


module add_round_key(
  input  logic [127:0]state,
  input  logic [127:0] round_key,
  output logic [127:0] y
);

assign y = state ^ round_key;

endmodule
