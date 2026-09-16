//Esteban Gonzalez 9/12/2026
//estgonzalez@g.hmc.edu
//Testbench for scanner module. Tests that it correctly shows it's four output transitions and that reset/enable work.


`timescale 1ns/1ns

module scanning_testbench();

    logic       clk;
    logic       reset;
    logic       enable;
    logic [3:0] rows;

    scanning dut(
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .rows   (rows)
    );

    //defparam dut.matrix_time.max = 20;   // shrink for fast simulation

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    //Begin the testing
    initial begin
        reset  = 1;
        enable = 0;
        #10;
        assert (rows == 4'b0000)
            $display("PASSED! rows resets low at time: %0t.", $time);
        else
            $error("FAILED! rows did not reset low at time: %0t.", $time);

        reset  = 0;
        enable = 1;

        #10;   
		
        assert (rows == 4'b0001)
            $display("PASSED! rows toggled high at time: %0t.", $time);
        else
            $error("FAILED! rows did not toggle high at time: %0t.",  $time);

        #750_0000;   
		
        assert (rows == 4'b0010)
            $display("PASSED! rows toggled low at time: %0t.",  $time);
        else
            $error("FAILED! rows did not toggle low at time: %0t.",  $time);

        #750_0000; 
		
        assert (rows == 4'b0100)
            $display("PASSED! rows toggled high at time: %0t.", $time);
        else
            $error("FAILED! rows did not toggle high at time: %0t.",  $time);

        #750_0000;  
		
        assert (rows == 4'b1000)
            $display("PASSED! rows toggled low at time: %0t.",  $time);
        else
            $error("FAILED! rows did not toggle low at time: %0t.",  $time);

        #500;
        #20 $stop;
    end

endmodule
