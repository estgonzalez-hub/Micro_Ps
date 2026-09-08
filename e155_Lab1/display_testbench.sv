//Esteban Gonzalez 9/6/2026
//estgonzalez@g.hmc.edu
//Testbench for seven_segment_display. Tests all 16 cases of the possible inputs


`timescale 1ns/1ns

module seven_segment_display_testbench();

    logic [3:0] s;
    logic [6:0] seg;

    seven_segment_display dut (
        .s   (s),
        .seg (seg)
    );
//Begin the testing. Unfortunately I did these before looking at the example
    initial begin
		

        // test 0
        s = 4'b0000;
        #10;
        assert (seg == 7'b0000001)
            $display("PASSED! seg correct for s=0000 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0000 at time: %0t.", $time);

        // test 1
        s = 4'b0001;
        #10;
        assert (seg == 7'b1001111)
            $display("PASSED! seg correct for s=0001 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0001 at time: %0t.", $time);

        // test 2
        s = 4'b0010;
        #10;
        assert (seg == 7'b0010010)
            $display("PASSED! seg correct for s=0010 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0010 at time: %0t.", $time);

        // test 3
        s = 4'b0011;
        #10;
        assert (seg == 7'b0000110)
            $display("PASSED! seg correct for s=0011 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0011 at time: %0t.", $time);

        // test 4
        s = 4'b0100;
        #10;
        assert (seg == 7'b1001100)
            $display("PASSED! seg correct for s=0100 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0100 at time: %0t.", $time);

        // test 5
        s = 4'b0101;
        #10;
        assert (seg == 7'b0100100)
            $display("PASSED! seg correct for s=0101 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0101 at time: %0t.", $time);

        // test 6
        s = 4'b0110;
        #10;
        assert (seg == 7'b0100000)
            $display("PASSED! seg correct for s=0110 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0110 at time: %0t.", $time);

        // test 7
        s = 4'b0111;
        #10;
        assert (seg == 7'b0001111)
            $display("PASSED! seg correct for s=0111 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=0111 at time: %0t.", $time);

        // test 8
        s = 4'b1000;
        #10;
        assert (seg == 7'b0000000)
            $display("PASSED! seg correct for s=1000 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1000 at time: %0t.", $time);

        // test 9
        s = 4'b1001;
        #10;
        assert (seg == 7'b0000100)
            $display("PASSED! seg correct for s=1001 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1001 at time: %0t.", $time);

        // test A
        s = 4'b1010;
        #10;
        assert (seg == 7'b0001000)
            $display("PASSED! seg correct for s=1010 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1010 at time: %0t.", $time);

        // test B
        s = 4'b1011;
        #10;
        assert (seg == 7'b1100000)
            $display("PASSED! seg correct for s=1011 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1011 at time: %0t.", $time);

        // test C
        s = 4'b1100;
        #10;
        assert (seg == 7'b0110001)
            $display("PASSED! seg correct for s=1100 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1100 at time: %0t.", $time);

        // test D
        s = 4'b1101;
        #10;
        assert (seg == 7'b1000010)
            $display("PASSED! seg correct for s=1101 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1101 at time: %0t.", $time);

        // test E
        s = 4'b1110;
        #10;
        assert (seg == 7'b0110000)
            $display("PASSED! seg correct for s=1110 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1110 at time: %0t.", $time);

        // test F
        s = 4'b1111;
        #10;
        assert (seg == 7'b0111000)
            $display("PASSED! seg correct for s=1111 at time: %0t.", $time);
        else
            $error("FAILED! seg incorrect for s=1111 at time: %0t.", $time);

        #10 $stop;
    end

endmodule