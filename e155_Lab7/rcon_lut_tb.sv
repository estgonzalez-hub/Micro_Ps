`timescale 1ns/1ps
module rcon_lut_tb();
  logic clk;

  // dut instance here

  always begin
    clk = 1; #5;
    clk = 0; #5;
  end

  initial begin
    #100;
    $finish;
  end
endmodule
