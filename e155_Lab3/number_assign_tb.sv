`timescale 1ns/1ns

module number_assign_testbench();

    logic [3:0] rows;
    logic [3:0] cols;
    logic [3:0] left_digit;

    number_assign dut (
        .rows       (rows),
        .cols       (cols),
        .left_digit (left_digit)
    );

    // Begin the Testing 
    initial begin
        // Row 0 Tests (rows = 4 b1110 -> ~rows = 4 b0001)

        // Key 1
        rows = 4'b1110; cols = 4'b1110; #10;
        assert (left_digit == 4'b0001)
            $display("PASSED! Key  1  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  1  failed to decode at time: %0t.", $time);

        // Key 2
        rows = 4'b1110; cols = 4'b1101; #10;
        assert (left_digit == 4'b0010)
            $display("PASSED! Key  2  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  2  failed to decode at time: %0t.", $time);

        // Key  3  
        rows = 4'b1110; cols = 4'b1011; #10;
        assert (left_digit == 4'b0011)
            $display("PASSED! Key  3  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  3  failed to decode at time: %0t.", $time);

        // Key  A  
        rows = 4'b1110; cols = 4'b0111; #10;
        assert (left_digit == 4'b1010)
            $display("PASSED! Key  A  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  A  failed to decode at time: %0t.", $time);


        // Row 1 Tests (rows = 4 b1101 -> ~rows = 4 b0010)

        // Key  4  
        rows = 4'b1101; cols = 4'b1110; #10;
        assert (left_digit == 4'b0100)
            $display("PASSED! Key  4  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  4  failed to decode at time: %0t.", $time);

        // Key  5  
        rows = 4'b1101; cols = 4'b1101; #10;
        assert (left_digit == 4'b0101)
            $display("PASSED! Key  5  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  5  failed to decode at time: %0t.", $time);

        // Key  6  
        rows = 4'b1101; cols = 4'b1011; #10;
        assert (left_digit == 4'b0110)
            $display("PASSED! Key  6  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  6  failed to decode at time: %0t.", $time);

        // Key  B  
        rows = 4'b1101; cols = 4'b0111; #10;
        assert (left_digit == 4'b1011)
            $display("PASSED! Key  B  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  B  failed to decode at time: %0t.", $time);



        // Key  7  
        rows = 4'b1011; cols = 4'b1110; #10;
        assert (left_digit == 4'b0111)
            $display("PASSED! Key  7  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  7  failed to decode at time: %0t.", $time);

        // Key  8  
        rows = 4'b1011; cols = 4'b1101; #10;
        assert (left_digit == 4'b1000)
            $display("PASSED! Key  8  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  8  failed to decode at time: %0t.", $time);

        // Key  9  
        rows = 4'b1011; cols = 4'b1011; #10;
        assert (left_digit == 4'b1001)
            $display("PASSED! Key  9  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  9  failed to decode at time: %0t.", $time);

        // Key  C  
        rows = 4'b1011; cols = 4'b0111; #10;
        assert (left_digit == 4'b1100)
            $display("PASSED! Key  C  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  C  failed to decode at time: %0t.", $time);



        // Key  E  
        rows = 4'b0111; cols = 4'b1110; #10;
        assert (left_digit == 4'b1110)
            $display("PASSED! Key  E  (*) decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  E  (*) failed to decode at time: %0t.", $time);

        // Key  0  
        rows = 4'b0111; cols = 4'b1101; #10;
        assert (left_digit == 4'b0000)
            $display("PASSED! Key  0  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  0  failed to decode at time: %0t.", $time);

        // Key  F  
        rows = 4'b0111; cols = 4'b1011; #10;
        assert (left_digit == 4'b1111)
            $display("PASSED! Key  F  (#) decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  F  (#) failed to decode at time: %0t.", $time);

        // Key  D  
        rows = 4'b0111; cols = 4'b0111; #10;
        assert (left_digit == 4'b1101)
            $display("PASSED! Key  D  decoded correctly at time: %0t.", $time);
        else
            $error("FAILED! Key  D  failed to decode at time: %0t.", $time);


        // Default 

        // No key pressed 
        rows = 4'b1111; cols = 4'b1111; #10;
        assert (left_digit == 4'b0000)
            $display("PASSED! Default (no key pressed) defaulted to 0 at time: %0t.", $time);
        else
            $error("FAILED! Default case failed at time: %0t.", $time);

        rows = 4'b0000; cols = 4'b0000; #10;
        assert (left_digit == 4'b0000)
            $display("PASSED! Invalid pattern defaulted to 0 at time: %0t.", $time);
        else
            $error("FAILED! Invalid pattern failed to default to 0 at time: %0t.", $time);

        #50;
        #20 $stop;
    end

endmodule