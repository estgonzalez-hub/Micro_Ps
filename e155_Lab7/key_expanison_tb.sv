`timescale 1ns/1ps

/////////////////////////////////////////////
// shiftrows_tb
//   Self-checking testbench for shiftrows
//   On a mismatch it prints the state as a 4x4 grid, laid out like the
//   figures in FIPS-197, and marks each wrong byte with a *. The shape of
//   the error (one byte? a whole row? a whole column?) tells you where to look.
/////////////////////////////////////////////

module key_expansion_tb();
    logic clk;
    logic [127:0] key, next_key, expected_key;
    logic [7:0] rcon;   
    integer       tests, errors;

    // device under test
    key_expansion dut(clk, key, rcon, next_key);
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
    task check(input string name, input logic [127:0] in, input logic [7:0] rc, input logic [127:0] expected);
        tests = tests + 1; 
        if ($isunknown(in) || $isunknown(rc) || $isunknown(expected)) begin
            $error("%s: test vector still contains x. Fill in the TODO.", name);
            errors = errors + 1;
        end else begin
           key = in; 
           rcon = rc; 
           expected_key = expected; 
           @(posedge clk); 
           #1; 
          
           if (next_key === expected) $display("passed");
           else begin 
            print_grids(next_key, expected);
            errors = errors + 1; 
               end
              end 
          
        
    endtask

     initial begin
        tests = 0; errors = 0; expected_key = 0; 

        // Test 1: FIPS-197 Appendix A.1 / B key
        check("A.1 round key 1",  128'h2b7e151628aed2a6abf7158809cf4f3c, 8'h01, 128'ha0fafe1788542cb123a339392a6c7605);
        check("A.1 round key 2",  128'ha0fafe1788542cb123a339392a6c7605, 8'h02, 128'hf2c295f27a96b9435935807a7359f67f);
        check("A.1 round key 3",  128'hf2c295f27a96b9435935807a7359f67f, 8'h04, 128'h3d80477d4716fe3e1e237e446d7a883b);
        check("A.1 round key 4",  128'h3d80477d4716fe3e1e237e446d7a883b, 8'h08, 128'hef44a541a8525b7fb671253bdb0bad00);
        check("A.1 round key 5",  128'hef44a541a8525b7fb671253bdb0bad00, 8'h10, 128'hd4d1c6f87c839d87caf2b8bc11f915bc);
        check("A.1 round key 6",  128'hd4d1c6f87c839d87caf2b8bc11f915bc, 8'h20, 128'h6d88a37a110b3efddbf98641ca0093fd);
        check("A.1 round key 7",  128'h6d88a37a110b3efddbf98641ca0093fd, 8'h40, 128'h4e54f70e5f5fc9f384a64fb24ea6dc4f);
        check("A.1 round key 8",  128'h4e54f70e5f5fc9f384a64fb24ea6dc4f, 8'h80, 128'head27321b58dbad2312bf5607f8d292f);
        check("A.1 round key 9",  128'head27321b58dbad2312bf5607f8d292f, 8'h1b, 128'hac7766f319fadc2128d12941575c006e);
        check("A.1 round key 10", 128'hac7766f319fadc2128d12941575c006e, 8'h36, 128'hd014f9a8c9ee2589e13f0cc8b6630ca6);

        if (errors == 0) $display("PASSED: all %0d tests", tests);
        else             $display("FAILED: %0d of %0d tests", errors, tests);
        $finish;
    end
endmodule

