`timescale 1ns/1ns

module scanning_tb();

    logic       clk;
    logic       reset;
    logic       enable;
    logic [3:0] rows;
    logic       scan_done;

  localparam int TEST_WIDTH = 6;
localparam int TEST_MAX   = 20;

scanner #(
    .width (TEST_WIDTH),  
    .max   (TEST_MAX)    
    ) dut (
    .clk       (clk),
    .reset     (reset),
    .enable    (enable),
    .rows      (rows),
    .scan_done (scan_done)
);

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Begin the testing
    initial begin
        reset  = 1;
        enable = 0;
        #10;
        assert (rows == 4'b0000)
            $display("PASSED! rows resets low at time: %0t.", $time);
        else
            $error("FAILED! rows did not reset low at time: %0t.", $time);
        #50;

        reset  = 0;
        #50;
        enable = 1;

        #10;   
        assert (rows == 4'b0001)
            $display("PASSED! rows toggled high at time: %0t.", $time);
        else
            $error("FAILED! rows did not toggle high at time: %0t.", $time);

        // Quarter cycle = max/4 = 5 clock cycles = 50ns
        #50;   
        assert (rows == 4'b0010)
            $display("PASSED! rows toggled to 4'b0010 at time: %0t.", $time);
        else
            $error("FAILED! rows did not toggle to 4'b0010 at time: %0t.", $time);

        #50;  
        assert (rows == 4'b0100)
            $display("PASSED! rows toggled to 4'b0100 at time: %0t.", $time);
        else
            $error("FAILED! rows did not toggle to 4'b0100 at time: %0t.", $time);

        #50;  
        assert (rows == 4'b1000)
            $display("PASSED! rows toggled to 4'b1000 at time: %0t.", $time);
        else
            $error("FAILED! rows did not toggle to 4'b1000 at time: %0t.", $time);

        #50;
        #20 $stop;
    end

endmodule