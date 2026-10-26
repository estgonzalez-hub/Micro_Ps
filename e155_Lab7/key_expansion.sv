//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26

//Key expansion module. Calls in 10 words (rcon) in order to generate 10 round keys. 

module key_expansion(
  input  logic clk,
  input  logic [127:0] key,
  input  logic [7:0] rcon, 
  output logic [127:0] next_key
);

logic [31:0] w0, w1, w2, w3; //four words
logic [31:0] rot_word, sub_word, temp;
logic [31:0] nw0, nw1, nw2, nw3;


assign {w0, w1, w2, w3} = key;

//ROTWORD([a0,a1,a2,a3]) = [a1,a2,a3,a0]
assign rot_word = ({w3[23:0], w3[31:24]});

sbox s0(clk, rot_word[7:0], sub_word[7:0]);
sbox s1(clk, rot_word[15:8], sub_word[15:8]);
sbox s2(clk, rot_word[23:16], sub_word[23:16]);
sbox s3(clk, rot_word[31:24], sub_word[31:24]);

assign temp = sub_word ^ {rcon, 24'h0};


assign nw0 = w0 ^ temp;
assign nw1 = w1 ^ nw0;
assign nw2 = w2 ^ nw1;
assign nw3 = w3 ^ nw2;

assign next_key = {nw0, nw1, nw2, nw3};

endmodule
