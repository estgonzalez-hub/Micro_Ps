`timescale 1ns/1ns

module key_press_tb();

    logic       clk;
    logic       reset;
    logic [3:0] cols;
    logic [3:0] rows;
    logic       debounced_key;
    logic       debounce_idle;
    logic       scan_enable;
    logic [3:0] d0;
    logic [3:0] d1;

    key_press dut (
        .clk(clk), .reset(reset), .cols(cols), .rows(rows),
        .debounced_key(debounced_key), .debounce_idle(debounce_idle),
        .scan_enable(scan_enable), .d0(d0), .d1(d1)
    );

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Testing Sequence
    initial begin
        // Step 1: Test Reset State
        reset         = 1;
        cols          = 4'b1111; // No key pressed (active low)
        rows          = 4'b1110;
        debounced_key = 0;
        debounce_idle = 1;
        #10; #1;
        assert (d0 == 4'b0000 && d1 == 4'b0000 && scan_enable == 1'b1)
            $display("PASSED! Reset to SCAN, d0=0, d1=0, scan_enable=1 at %0t.", $time);
        else $error("FAILED! Reset state incorrect at %0t.", $time);

        reset = 0;
        #10;

        // ---- Step 2: Key press detected (row0/col0 -> should decode "1") ----
        cols = 4'b1110;   // col 0 active
        debounce_idle = 0;
        #5; #1;
        assert (scan_enable == 1'b0)
            $display("PASSED! Key press detected, scan_enable paused low at %0t.", $time);
        else $error("FAILED! scan_enable did not disable on key press at %0t.", $time);

        // ---- Step 3: Debounce confirms -> SCAN->PRESS->HOLD, d0 gets real decode ----
        debounced_key = 1;
        #20; #1;
        assert (d0 == 4'b0001)   // row0/col0 = "1", per number_assign table
            $display("PASSED! Key registered in d0 (%0h) at %0t.", d0, $time);
        else $error("FAILED! Expected d0=1, got d0=%0h at %0t.", d0, $time);

        
        #20;#1;
        assert (d1 == 4'b0000)
            $display("PASSED! HOLD state preventing duplicate key shifts at %0t.", $time);
        else $error("FAILED! Digits shifted unexpectedly during HOLD at %0t.", $time);

        
        cols = 4'b1111;  // bounce dip
        #5; #3;
        assert (scan_enable == 1'b0)
            $display("PASSED! scan_enable held low through bounce dip at %0t.", $time);
        else $error("FAILED! scan_enable glitched high during bounce at %0t.", $time);
        cols = 4'b1110;  // bounce settles back
        #5;#4;
        assert (scan_enable == 1'b0)
            $display("PASSED! scan_enable still low after bounce settles at %0t.", $time);
        else $error("FAILED! scan_enable incorrect after bounce settle at %0t.", $time);


        cols          = 4'b1111;
        debounced_key = 0;
        debounce_idle = 0;   
        #10; #2; 
        assert (scan_enable == 1'b0)
            $display("PASSED! Lock still held mid-release-debounce at %0t.", $time);
        else $error("FAILED! Lock released too early at %0t.", $time);

        debounce_idle = 1;   
        #10; #3;
        assert (scan_enable == 1'b1)
            $display("PASSED! Key released, scan_enable re-enabled at %0t.", $time);
        else $error("FAILED! scan_enable did not re-enable after release at %0t.", $time);

        
        #10; #3;
        assert (scan_enable == 1'b1)
            $display("PASSED! No deadlock -- scan_enable stable high at idle at %0t.", $time);
        else $error("FAILED! key_locked stuck -- deadlock regression at %0t.", $time);

        
        cols = 4'b1101;   // col 1 active
        #5;
        debounced_key = 1;
        debounce_idle = 0;
        #20; #3;
        assert (d1 == 4'b0001 && d0 == 4'b0010)
            $display("PASSED! Digit shift correct (d1=%0h, d0=%0h) at %0t.", d1, d0, $time);
        else $error("FAILED! Expected d1=1,d0=2, got d1=%0h,d0=%0h at %0t.", d1, d0, $time);

        #50;
        #20 $stop;
    end

endmodule
