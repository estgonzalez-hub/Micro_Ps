//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26
// Module that contains all the round constants. Takes in the current round and outputs the corresponding round constant

module rcon_lut(
  input  logic [3:0] round,
  output logic [7:0] rcon
);

always_comb
  case (round)
      4'd1: rcon = 8'h01;
      4'd2: rcon = 8'h02;
      4'd3: rcon = 8'h04;
      4'd4: rcon = 8'h08;
      4'd5: rcon = 8'h10;
      4'd6: rcon = 8'h20;
      4'd7: rcon = 8'h40;
      4'd8: rcon = 8'h80;
      4'd9: rcon = 8'h1b;
      4'd10: rcon = 8'h36;
      default: rcon = 8'h00;
  endcase

endmodule
