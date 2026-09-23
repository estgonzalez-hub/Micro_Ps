module top(
        input  logic       reset,
        input  logic       enable,
        input  logic [3:0] cols,
        output logic       a1,
        output logic       a2,
        output logic [6:0] seg,
        output logic [3:0] row,
output logic  [3:0]     debug,
output logic     debug1
        );
       
        logic int_osc;
        logic sel;
        logic [3:0] cols_sync;
        logic [3:0] d0, d1;
        logic [3:0] s;
logic [3:0] row_int;
        logic key_before, debounced_key;
        logic scan_enable;
        logic [20:0] seg_count;

      
        
        assign key_before = ~&cols_sync;

        //assign valid_scan = (pressed != 0) && ((pressed & (pressed -1 )) == 0);
       
       
        //Internal high-speed oscillator
        HSOSC #(.CLKHF_DIV(2'b01))
            hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
           
       
        //Instantiating modules
        counter #(.width(21), .max(200_000)) segment_time (.clk  (int_osc),  .reset (reset), .enable (1'b1), .counter (seg_count));

        synchronizer #(.width(4)) coloumn_sync(.clk(int_osc), .reset(reset), .async_in(cols), .sync_out(cols_sync));

        key_press keypad(.clk(int_osc), .reset(reset), .cols(cols_sync),.rows(row_int), .debounced_key (debounced_key),.scan_enable(scan_enable), .d0(d0), .d1(d1));
     
       
        seven_segment  display(.s (s), .seg (seg));

        scanning scanner(.clk (int_osc),  .reset (reset), .enable(scan_enable), .rows (row_int));

        debounce #(.width(20), .stable(524_288)) key_db (.clk (int_osc),  .reset (reset), .p(key_before), .debounced_p (debounced_key));
       
        //Assign statements to implement the multiplexing and scanning
       
  assign row = row_int;

        always_ff @(posedge int_osc or posedge reset) begin
           if (reset)
           sel <= 1'b0;
           else if (seg_count == 200_000 - 1)
           sel <= ~sel;
           
        end
       
        assign a1 = sel;
        assign a2 = ~sel;
        assign s = sel ? d1 : d0;
        assign debug = row;
assign debug1 = key_before;


endmodule