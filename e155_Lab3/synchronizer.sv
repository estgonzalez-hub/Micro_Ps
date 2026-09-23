module synchronizer#(
    //Set the paremeters depending on the module needing it
    parameter int width = 4
    )(
    input  logic clk,
    input  logic reset,
    input  logic [width-1:0] async_in,
    output logic [width-1:0] sync_out
  );
          logic [width-1:0] w1;

          //stabilizes the cols before calculating the disable
          always_ff @(posedge clk or posedge reset) begin
            if (reset) begin
            w1       <= '1;
            sync_out <= '1;
            end
            else begin
            w1 <= async_in;
            sync_out <= w1;
            end
            end

  endmodule