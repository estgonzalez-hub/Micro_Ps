`timescale 1ns/1ns

module debounce_testbench();

    logic clk;
    logic reset;
    logic p;
    logic debounced_p;
    logic idle;


    localparam int TEST_WIDTH  = 4;
    localparam int TEST_STABLE = 5;

    debounce #(
        .width  (TEST_WIDTH),
        .stable (TEST_STABLE)
    ) dut (
        .clk         (clk),
        .reset       (reset),
        .p           (p),
        .debounced_p (debounced_p),
        .idle        (idle)
    );

    // Clock Generation: 10ns period (100 MHz)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Testing Sequence
    initial begin
        // Step 1: Test Reset State
        reset = 1;
        p     = 0;
        #10;
        assert (debounced_p == 1'b0 && idle == 1'b1)
            $display("PASSED! Resets to IDLE with debounced_p low at time: %0t.", $time);
        else
            $error("FAILED! Reset state incorrect at time: %0t.", $time);

        reset = 0;
        #10;

    
        p = 1; #10; // Transitions to WAIT state
        p = 0; #10; // Glitch drops back low before counter hits limit
        assert (debounced_p == 1'b0 && idle == 1'b1)
            $display("PASSED! Press glitch rejected correctly at time: %0t.", $time);
        else
            $error("FAILED! Glitch triggered false debounced_p high at time: %0t.", $time);

        // Step 3: Test Valid Long Press (Hold high past threshold)
        p = 1;
        #10; 
        assert (debounced_p == 1'b0 && idle == 1'b0)
            $display("PASSED! Entered WAIT state for press at time: %0t.", $time);
        else
            $error("FAILED! Failed to enter WAIT state at time: %0t.", $time);

        // Wait for stability counter (5 cycles = 50ns)
        #50;
        assert (debounced_p == 1'b1 && idle == 1'b0)
            $display("PASSED! Debounced press registered high at time: %0t.", $time);
        else
            $error("FAILED! Debounced press failed to transition at time: %0t.", $time);

        // Step 4: Test Release Glitch (Bouncing back high during release)
        p = 0; #10; // State transitions to WAIT
        p = 1; #10; // Glitch back high before counter finishes
        assert (debounced_p == 1'b1)
            $display("PASSED! Release glitch ignored, debounced_p held high at time: %0t.", $time);
        else
            $error("FAILED! Release glitch incorrectly cleared output at time: %0t.", $time);

        // Step 5: Test Valid Long Release
        p = 0;
        #60; // Wait for debounce counter to finish
        assert (debounced_p == 1'b0 && idle == 1'b1)
            $display("PASSED! Debounced release complete, returned to IDLE at time: %0t.", $time);
        else
            $error("FAILED! Debounced release failed at time: %0t.", $time);

        #50;
        #20 $stop;
    end

endmodule