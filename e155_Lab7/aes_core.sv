//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26

// // aes_core
// //   top level AES encryption module
// //   when load is asserted, takes the current key and plaintext
// //   generates cyphertext and asserts done when complete 11 cycles later
// // 
// //   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
// //
// //   Equivalently, the values are packed into four words as given
// //        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
// /////////////////////////////////////////////

 module aes_core(input  logic         clk, 
                 input  logic         load,
                 input  logic [127:0] key, 
                 input  logic [127:0] plaintext, 
                 output logic         done, 
                 output logic [127:0] cyphertext);

      logic sel_load, reg_en, sel_last, out_en;
      logic [3:0] round;

      aes_control control(.clk(clk), .load(load), .sel_load(sel_load), .reg_en(reg_en), .sel_last(sel_last), .done(done), .round(round), .out_en(out_en));

      aes_datapath path(.clk(clk), .sel_load(sel_load), .reg_en(reg_en), .sel_last(sel_last), .round(round), .key(key), .plaintext(plaintext), .cyphertext(cyphertext), .out_en(out_en));
     
    
 endmodule
