`timescale 10ns/1ns
/////////////////////////////////////////////
//   aes_datapath_tb
//   Self-checking testbench for data path
//   On a mismatch it prints the state as a 4x4 grid, laid out like the
//   figures in FIPS-197, and marks each wrong byte with a *. The shape of
//   the error (one byte? a whole row? a whole column?) tells you where to look.
/////////////////////////////////////////////

 module aes_datapath_tb();
     logic clk;
     logic sel_load;
     logic reg_en; 
     logic sel_last;
     logic [3:0] round; 
     logic [127:0] key;
     logic [127:0] plaintext;
     logic [127:0] cyphertext;
     logic [127:0] expected [10:0];
     logic [127:0] got      [10:0]; 
     integer       tests, errors, r;

     // device under test
     aes_datapath dut( .clk(clk),.sel_load(sel_load), .reg_en(reg_en), .sel_last(sel_last), .round(round), .key(key), .plaintext(plaintext),.cyphertext(cyphertext));
     always begin 
       clk = 1'b0; #5;
       clk = 1'b1; #5;
     end
     // byte at row r, column c of a packed state (see the packing in shiftrows.sv)
     function logic [7:0] state_byte(input logic [127:0] s, input integer r, input integer c);
         state_byte = s[127 - 8*(r + 4*c) -: 8];
     endfunction

     // print got and expected side by side as 4x4 grids, starring the bytes that differ
     task print_grids(input logic [127:0] got, input logic [127:0] expected);
         integer r, c;
         $display("         got                  expected");
         for (r = 0; r < 4; r = r + 1) begin
             $write("  ");
             for (c = 0; c < 4; c = c + 1)
                 $write("%h%s", state_byte(got, r, c),
                        (state_byte(got, r, c) === state_byte(expected, r, c)) ? "  " : "* ");
             $write("    ");
             for (c = 0; c < 4; c = c + 1)
                 $write("%h  ", state_byte(expected, r, c));
             $display("");
         end
     endtask

     // apply one test vector and compare against the expected output
     task encrypt( input logic [127:0] p,k);
       integer i;
       begin 
         @(negedge clk); 
         key = k;
         plaintext = p; 
         sel_load = 1; 
         reg_en = 1; 
         sel_last = 0; 
         round = 4'd0; 
         @(negedge clk);
         got[0] = cyphertext;
      for (i = 1; i<= 10; i= i +1) begin 
        sel_load = 0; 
        reg_en = 0;
        round = i[3:0];
        sel_last = (i == 10); 
        @(negedge clk); 
        reg_en = 1; 
        @(negedge clk);
        got[i] = cyphertext;
      end
      reg_en = 0; 
       end 
    endtask

    task check(input string name, input logic [127:0] got_v, input logic [127:0] exp_v);
        tests = tests + 1;
        if (got_v ===exp_v)  $display("PAS %s", name);
        else begin 
            $error("%s: test vector still contains x. Fill in the TODO.", name);
            errors = errors + 1;
        end 
    endtask 

     initial begin
         tests = 0; errors = 0;
         sel_load = 0;
         reg_en = 0;
         sel_last = 0;
         round = 0; 
         key = 0; 
         plaintext = 0; 
         expected[1] = 128'ha49c7ff2689f352b6b5bea43026a5049; 
         expected[2] = 128'haa8f5f0361dde3ef82d24ad26832469a;
         expected[3] = 128'h486c4eee671d9d0d4de3b138d65f58e7;
         expected[4] = 128'he0927fe8c86363c0d9b1355085b8be01;
         expected[5] = 128'hf1006f55c1924cef7cc88b325db5d50c;
         expected[6] = 128'h260e2e173d41b77de86472a9fdd28b25;
         expected[7] = 128'h5a4142b11949dc1fa3e019657a8c040c;
         expected[8] = 128'hea835cf00445332d655d98ad8596b0c5;
         expected[9] = 128'heb40f21e592e38848ba113e71bc342d2;
         expected[10] = 128'h3925841d02dc09fbdc118597196a0b32;


         // Test 1: every byte holds its own position, S[r][c] = 4c + r, so a wrong
         // answer shows you exactly which byte ended up where.
         // TODO: work out the expected output by hand before you run anything.
         encrypt(128'h2b7e151628aed2a6abf7158809cf4f3c,128'h3243f6a8885a308d313198a2e0370734);
         check ("Appendix C.1", got[10], 128'h69c4e0d86a7b0430d8cdb78070b4c55a);

         // Test 2: FIPS-197 Appendix B, Round 1, "After SubBytes" -> "After ShiftRows".
         // Appendix B prints the state as 4x4 grids. Read each grid column by column.
         // TODO: fill in both values.
        //  check("key equals state", 128'h3243f6a8885a308d313198a2e0370734,128'h3243f6a8885a308d313198a2e0370734,
        //        128'h00000000000000000000000000000000
        //        );

        //  // Test 3: FIPS-197 Appendix B, Round 2, "After SubBytes" -> "After ShiftRows".
        //  // TODO: fill in both values.
        //  check("Appendix B round 1", 128'h046681e5e0cb199a48f8d37a2806264c,128'ha0fafe1788542cb123a339392a6c7605,
        //        128'ha49c7ff2689f352b6b5bea43026a5049);

         if (errors == 0) $display("PASSED: all %0d tests", tests);
         else             $display("FAILED: %0d of %0d tests", errors, tests);
         $finish;
     end
 endmodule

