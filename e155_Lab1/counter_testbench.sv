//Esteban Gonzalez 9/6/2026
//estgonzalez@g.hmc.edu
//Testbench for counter. Ensures that the counter is blinking led[2] on and off at a rate of 2 Hz


`timescale 1ns/1ns

module counter_tb();

    logic clk;
	logic reset;
	logic enable;
    logic led;



    counter dut (
        .clk (clk),
		.reset (reset),
		.enable (enable),
        .led (led)
    );

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
	
	//Begin the testing 
    initial begin
		reset = 1;
		enable = 0;
        assert (led == 1'b0)
            $display("PASSED! led resets low at time: %0t.", $time);
        else
            $error("FAILED! led did not reset low at time: %0t.", $time);

      #10
        assert (led == 1'b1)
            $display("PASSED! led toggled high at time: %0t.", $time);
        else
            $error("FAILED! led did not toggle high at time: %0t.",  $time);

        #10
        assert (led == 1'b0)
            $display("PASSED! led toggled low at time: %0t.",  $time);
        else
            $error("FAILED! led did not toggle low at time: %0t.",  $time);

       #1_000_000_000;
	    reset = 0;
		enable = 1;
			assert (led == 1'b0)
            $display("PASSED! led resets low at time: %0t.", $time);
        else
            $error("FAILED! led did not reset low at time: %0t.", $time);

        
        assert (led == 1'b1)
            $display("PASSED! led toggled high at time: %0t.", $time);
        else
            $error("FAILED! led did not toggle high at time: %0t.",  $time);

       
        assert (led == 1'b0)
            $display("PASSED! led toggled low at time: %0t.",  $time);
        else
            $error("FAILED! led did not toggle low at time: %0t.",  $time);

    
        assert (led == 1'b1)
            $display("PASSED! led toggled high at time: %0t.", $time);
        else
            $error("FAILED! led did not toggle high at time: %0t.", $time);
			#1_000_000_000;

        #20 $stop;
    end

endmodule