`timescale 1ns/1ns

module key_press_tb();

    logic       clk;
    logic       reset;
    logic [3:0] cols;
    logic [3:0] rows;
    logic       debounced_key;
    logic       scan_enable;
    logic [3:0] d0;
    logic [3:0] d1;

    key_press dut (
        .clk(clk), .reset(reset), .cols(cols), .rows(rows),
        .debounced_key(debounced_key),
        .scan_enable(scan_enable), .d0(d0), .d1(d1)
    );

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        // 
        reset         = 1;
        cols          = 4'b1111;
        rows          = 4'b1110;
        debounced_key = 0;
        #10; #1;
        assert (d0 == 4'b0000 && d1 == 4'b0000 && scan_enable == 1'b1)
            $display("PASSED! Reset to SCAN, d0=0, d1=0, scan_enable=1 at %0t.", $time);
        else $error("FAILED! Reset state incorrect at %0t.", $time);

        reset = 0;
        #10; #1;

        // 
        cols = 4'b1111;
        @(posedge clk); #1;
        cols = 4'b1110;
        #10; #1;
        assert (scan_enable == 1'b0)
            $display("PASSED! scan_enable reacts to one-hot col press, offset=1ns at %0t.", $time);
        else $error("FAILED! scan_enable incorrect, offset=1ns at %0t.", $time);

        cols = 4'b1111; #10; #1;

        //
        @(posedge clk);
        cols = 4'b1101;
        #10; #1;
        assert (scan_enable == 1'b0)
            $display("PASSED! scan_enable reacts correctly to edge-coincident col change at %0t.", $time);
        else $error("FAILED! scan_enable incorrect for edge-coincident change at %0t.", $time);

        cols = 4'b1111; #10; #1;

        // 
        @(posedge clk); #9;
        cols = 4'b1011;
        #10; #1;
        assert (scan_enable == 1'b0)
            $display("PASSED! scan_enable reacts correctly, offset=9ns at %0t.", $time);
        else $error("FAILED! scan_enable incorrect, offset=9ns at %0t.", $time);

        cols = 4'b1111; #10; #1;

        // 
        #7  cols = 4'b1110;
        #2  cols = 4'b1111;
        #3  cols = 4'b1110;
        #1  cols = 4'b1111;
        #4  cols = 4'b1110;
        #6  cols = 4'b1111;
        #2  cols = 4'b1110;   
        #10; #1;
        assert (scan_enable == 1'b0)
            $display("PASSED! scan_enable correctly low after bounce settles pressed at %0t.", $time);
        else $error("FAILED! scan_enable incorrect after bounce settle at %0t.", $time);

        cols = 4'b1111; #10; #1;
        assert (scan_enable == 1'b1)
            $display("PASSED! scan_enable returns high at idle after bounce test at %0t.", $time);
        else $error("FAILED! scan_enable did not return high at idle at %0t.", $time);

        // 
        cols = 4'b1100;   
        #10; #1;
        assert (scan_enable == 1'b1)
            $display("PASSED! Multi-key press (non-one-hot) correctly ignored, scan_enable stays high at %0t.", $time);
        else $error("FAILED! scan_enable reacted to a non-one-hot (multi-key) cols pattern at %0t.", $time);

        // release down to a single key -> should now register
        cols = 4'b1110;
        #1;
        assert (scan_enable == 1'b0)
            $display("PASSED! Releasing down to a single held key is now detected at %0t.", $time);
        else $error("FAILED! Single remaining key not detected after multi-key release at %0t.", $time);

        cols = 4'b1111; #10; #1;

        // 
        rows = 4'b1110;
        cols = 4'b1110;   
        #1;
        debounced_key = 1;
        #20; #1;
        assert (d0 == 4'b0001)
            $display("PASSED! Key registered in d0 (%0h) at %0t.", d0, $time);
        else $error("FAILED! Expected d0=1, got d0=%0h at %0t.", d0, $time);

        #20; #1;
        assert (d1 == 4'b0000)
            $display("PASSED! HOLD state preventing duplicate key shifts at %0t.", $time);
        else $error("FAILED! Digits shifted unexpectedly during HOLD at %0t.", $time);

        cols          = 4'b1111;
        debounced_key = 0;
        #20; #1;

        cols = 4'b1101;   
        #1;
        debounced_key = 1;
        #20; #1;
        assert (d1 == 4'b0001 && d0 == 4'b0010)
            $display("PASSED! Digit shift correct (d1=%0h, d0=%0h) at %0t.", d1, d0, $time);
        else $error("FAILED! Expected d1=1,d0=2, got d1=%0h,d0=%0h at %0t.", d1, d0, $time);

        #50;
        $stop;
    end

endmodule