`timescale 1ns/1ns
module top_tb();
  logic       reset;
  logic       enable;
  logic [3:0] cols;
  logic       a1;
  logic       a2;
  logic [6:0] seg;
  logic [3:0] row;
  logic [3:0] row_before_freeze;


  top dut (.reset (reset),
         .enable (enable),
         .cols (cols),
         .a1 (a1),
         .a2 (a2),
        .seg (seg),
        .row (row)
  );

  initial begin 
    forever begin
    force dut.int_osc = 0; #5;
    force dut.int_osc = 1; #5;
  end
  end

  //Begin the testing
  initial begin
      reset  = 1;
        enable = 1'b0;      
        cols   = 4'b1111;
        #10; #1;
        assert (dut.sel == 1'b0)
            $display("PASSED! sel resets to 0 at %0t.", $time);
        else $error("FAILED! sel did not reset at %0t.", $time);

        assert (dut.row_int == 4'b1111)
            $display("PASSED! scanner resets row_int to 1111 at %0t.", $time);
        else $error("FAILED! row_int did not reset at %0t.", $time);

        assert (dut.cols_sync == 4'b1111)
            $display("PASSED! synchronizer resets cols_sync to 1111 at %0t.", $time);
        else $error("FAILED! cols_sync did not reset at %0t.", $time);

        assert (a1 == 1'b0 && a2 == 1'b1)
            $display("PASSED! a1/a2 reflect sel=0 at reset (a1=%0b, a2=%0b) at %0t.", a1, a2, $time);
        else $error("FAILED! a1/a2 incorrect at reset at %0t.", $time);

        reset = 0;
        #10; #1;
        enable = 1;

        
        force dut.row_int = 4'b1011;
        #30;
        assert (row == 4'b1011)
            $display("PASSED! row tracks row_int (row=%0b) at %0t.", row, $time);
        else $error("FAILED! row not wired to row_int (row=%0b) at %0t.", row, $time);
        release dut.row_int;

        cols = 4'b1111;
        #20; #1;

        force dut.seg_count = 21'd199_999;
        @(posedge dut.int_osc); #1;
        assert (dut.sel == 1'b1)
            $display("PASSED! sel toggled on seg_count rollover at %0t.", $time);
        else $error("FAILED! sel did not toggle on rollover at %0t.", $time);
        release dut.seg_count;

        assert (a1 == 1'b1 && a2 == 1'b0)
            $display("PASSED! a1/a2 follow sel after toggle (a1=%0b, a2=%0b) at %0t.", a1, a2, $time);
        else $error("FAILED! a1/a2 did not follow sel (a1=%0b, a2=%0b) at %0t.", a1, a2, $time);

        force dut.d0 = 4'h3;
        force dut.d1 = 4'h7;
        #1;
        assert (dut.s == 4'h7)   
            $display("PASSED! s = d1 when sel=1 at %0t.", $time);
        else $error("FAILED! s incorrect when sel=1 (s=%0h) at %0t.", dut.s, $time);

        force dut.sel = 1'b0;
        #1;
        assert (dut.s == 4'h3)
            $display("PASSED! s = d0 when sel=0 at %0t.", $time);
        else $error("FAILED! s incorrect when sel=0 (s=%0h) at %0t.", dut.s, $time);

        release dut.sel;
        release dut.d0;
        release dut.d1;

       
        force dut.s = 4'h0;
        #1;
        assert (seg != 7'b0000000)
            $display("PASSED! seg reflects s via seven_segment instance at %0t.", $time);
        else $error("FAILED! seg did not respond to s -- display possibly unconnected at %0t.", $time);
        release dut.s;


        reset = 1; #10; reset = 0; #10; #1;
        force dut.scan_enable = 1'b0;
        #1;
        row_before_freeze = dut.row_int;
        #50;
        assert (dut.row_int == row_before_freeze)
            $display("PASSED! scan_enable=0 freezes row_int via scanner.enable at %0t.", $time);
        else $error("FAILED! row_int changed despite scan_enable=0 at %0t.", $time);
        release dut.scan_enable;

        #20;
        $stop;
    end
endmodule 