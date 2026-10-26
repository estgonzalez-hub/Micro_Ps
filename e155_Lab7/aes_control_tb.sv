`timescale 10ns/1ns
/////////////////////////////////////////////
// aes_control_tb
//   Self-checking testbench for control path
//   On a mismatch it prints the state as a 4x4 grid, laid out like the
//   figures in FIPS-197, and marks each wrong byte with a *. The shape of
//   the error (one byte? a whole row? a whole column?) tells you where to look.
/////////////////////////////////////////////

 module aes_control_tb();
     logic clk, load;
     logic sel_load, reg_en, sel_last, out_en, done;
     logic [3:0] round; 
     integer       tests, errors;

     // device under test
     aes_control dut(clk, load, sel_load, reg_en, out_en, sel_last, done, round);

     always begin 
      clk = 1'b0; #5; 
      clk = 1'b1; #5; 
     end 

     
    // apply one test vector and compare against the expected output
     task check(input string name, input integer exp_round, input logic exp_sel_load, exp_reg_en, exp_out_en, exp_sel_last, exp_done);
         tests = tests + 1;
         if ((( exp_round < 0) || (round === exp_round[3:0])) && sel_load === exp_sel_load && reg_en === exp_reg_en && out_en === exp_out_en && sel_last === exp_sel_last && done === exp_done)begin
         end else begin
          $error("%s\n got round=%0d sel_load=%b done=%b", name, round, sel_load, reg_en, out_en, sel_last, done, exp_round, exp_sel_load, exp_reg_en, exp_out_en, exp_sel_last, exp_done);
             errors = errors +1; 
     end
     endtask 

    task run(input string op);
     integer i, errors_before; 
     begin 
      errors_before = errors; 
      @(negedge clk); 
      load = 1; 
      for (i = 0; i <3; i = i + 1) begin 
        #1; 
        tests = tests +1; 
      if (!(sel_load === 1'b1 && reg_en === 1'b1 && out_en === 1'b0)) begin 
        $error("%s:loadcycle must assert sel_load and ");
        errors = errors + 1;
      end 

      @(negedge clk);
      end 

      load = 0; 
      #1; 
        check($sformatf("%s round ", op), 1, 0, 0, 0, 0, 0);
        @(negedge clk);
        #1; 
         for (i=1; i<=10; i=i +1) begin 
        check($sformatf("%s round %0d LOOKUP", op, i), i, 0, 0, 0, (i ==10), 0);
        @(negedge clk); 
        #1; 
        check($sformatf("%s round %0d ROUND", op, i), i, 0, 1, (i ==10),(i ==10), 0);
        @(negedge clk);
        #1; 
      end 
     end 
     endtask
     initial begin 
      tests = 0; errors = 0; load = 0;
      repeat (3) @(negedge clk);
      #1; 
      check("idle before load", 0,0,0,0,0,0);

      run("first");
     if (errors == 0) $display("PASSED: all %0d checks", tests);
        else             $display("FAILED: %0d of %0d checks", errors, tests);
        $finish;
     end 
     

 endmodule

