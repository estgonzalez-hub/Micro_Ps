//Esteban Gonzalez 9/12/2026
//estgonzalez@g.hmc.edu
//Testbench for top module. Tests higher level things, that modules are wired together correcttly, has multiplexing functionality, and 
//that the LED is driving 


`timescale 1ns/1ns

module top_testbench();

    logic [3:0] s0;
    logic [3:0] s1;
    logic       reset;
    logic       enable;
    logic [3:0] cols;
    logic [3:0] led;
    logic       c1;
    logic       c2;
    logic [6:0] seg;
    logic [3:0] row;

    top dut (
        .s0     (s0),
        .s1     (s1),
        .reset  (reset),
        .enable (enable),
        .cols   (cols),
        .led    (led),
        .c1     (c1),
        .c2     (c2),
        .seg    (seg),
        .row    (row)
    );
	
	defparam dut.segment_time.max = 5;
	defparam dut.matrix_time.max = 5;

    //HSOSC check 	
	initial begin 
		forever 
			begin
			@(dut.int_osc);
			$display("[%t] Internal HSOSC Toggle! Value = %b", $realtime, dut.int_osc);
			end
		end
    //Begin the testing
    initial begin

        reset  = 1;
        enable = 0;
        s0     = 4'b0000;
        s1     = 4'b0000;
        cols   = 4'b0000;
        #30;
        reset  = 0;
		enable = 1;
		#30;

        // Assign statements for leds (led is a direct pass-through of cols)
        cols = 4'b0000;
        #20;
        assert (led == 4'b0000)
            $display("PASSED! led correct for cols=0000 at time: %0t.", $time);
        else
            $error("FAILED! led incorrect for cols=0000 at time: %0t.", $time);

        cols = 4'b0001;
        #20;
        assert (led == 4'b0001)
            $display("PASSED! led correct for cols=0001 at time: %0t.", $time);
        else
            $error("FAILED! led incorrect for cols=0001 at time: %0t.", $time);

        cols = 4'b0010;
        #20;
        assert (led == 4'b0010)
            $display("PASSED! led correct for cols=0011 at time: %0t.", $time);
        else
            $error("FAILED! led incorrect for cols=0011 at time: %0t.", $time);

        cols = 4'b0100;
        #20;
        assert (led == 4'b0100)
            $display("PASSED! led correct for cols=1110 at time: %0t.", $time);
        else
            $error("FAILED! led incorrect for cols=1110 at time: %0t.", $time);

        cols = 4'b1000;
        #20;
        assert (led == 4'b1000)
            $display("PASSED! led correct for cols=1100 at time: %0t.", $time);
        else
            $error("FAILED! led incorrect for cols=1100 at time: %0t.", $time);

        // Check multiplexing: c1 and c2 must always be complementary
        assert (c1 == ~c2)
            $display("PASSED! c1/c2 complementary at time: %0t.", $time);
        else
            $error("FAILED! c1/c2 not complementary at time: %0t.", $time);

        // Drive s0/s1 values and confirm the multiplexed dip_switch
        // follows whichever half is currently selected
        s0 = 4'b1101;
        s1 = 4'b0011;
        #20;
        assert (dut.dip_switch == (dut.sel ? s0 : s1))
            $display("PASSED! dip_switch correctly muxed at time: %0t.", $time);
        else
            $error("FAILED! dip_switch mux incorrect at time: %0t.", $time);

        $stop;
    end

endmodule