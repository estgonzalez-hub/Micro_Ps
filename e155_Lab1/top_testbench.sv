//Esteban Gonzalez 9/6/2026
//estgonzalez@g.hmc.edu
//Testbench for top module. Tests higher level things, that modules are wired together correcttly, HSOC is producing a clock signal, and that the assign led works


`timescale 1ns/1ns

module top_tb();

    logic [3:0] s;
    logic [2:0] led;
    logic [6:0] seg;
	
	
    top dut (
        .s   (s),
        .led (led),
        .seg (seg)
    );
	
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

        // Assign statements for leds
        s = 4'b0000;
        #10;
        assert (led[1:0] == 2'b00)
            $display("PASSED! led[1:0] correct for s=0000 at time: %0t.", $time);
        else
            $error("FAILED! led[1:0] incorrect for s=0000 at time: %0t.", $time);

        s = 4'b0001;
        #10;
        assert (led[1:0] == 2'b01)
            $display("PASSED! led[1:0] correct for s=0001 at time: %0t.", $time);
        else
            $error("FAILED! led[1:0] incorrect for s=0001 at time: %0t.", $time);

        s = 4'b0011;
        #10;
        assert (led[1:0] == 2'b00)
            $display("PASSED! led[1:0] correct for s=0011 at time: %0t.", $time);
        else
            $error("FAILED! led[1:0] incorrect for s=0011 at time: %0t.", $time);
			
		s = 4'b1110;
        #10;
        assert (led[1:0] == 2'b11)
            $display("PASSED! led[1:0] correct for s=1110 at time: %0t.", $time);
        else
            $error("FAILED! led[1:0] incorrect for s=1110 at time: %0t.", $time);
			
			s = 4'b1100;
        #10;
        assert (led[1:0] == 2'b10)
            $display("PASSED! led[1:0] correct for s=1100 at time: %0t.", $time);
        else
            $error("FAILED! led[1:0] incorrect for s=1100 at time: %0t.", $time);
			
			
			
			

        // Check that seg is wired through to the display submodule 
        s = 4'b1010;
        #10;
        assert (seg == 7'b0001000)
            $display("PASSED! seg correctly wired through top for s=1010 at time: %0t.", $time);
        else
            $error("FAILED! seg not wired correctly for s=1010 at time: %0t.", $time);
			
			
		
          

        $stop;
    end

endmodule