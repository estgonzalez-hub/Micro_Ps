module top(
        input  logic [3:0] s0,
        input  logic [3:0] s1, 
        input  logic       reset, 
        input  logic       enable,
        input  logic [3:0] cols, 
        output logic [3:0] led,
        output logic       c1,
        output logic       c2,
        output logic [6:0] seg,
        output logic [3:0] row
        );
        
        logic int_osc; 
        logic sel;
        logic [3:0] dip_switch;
        logic [1:0] matrix_sel;
        
        //Internal high-speed oscillator 
        HSOSC #(.CLKHF_DIV(2'b01))
            hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc)); 
            
        
        //Instantiating modules 
        counter #(.width(21), .max(200000), .outWidth(1)) segment_time (.clk  (int_osc),  .reset (1'b0), .enable (1'b1), .out (sel));
        counter #(.width(22), .max(3000000), .outWidth(2)) matrix_time(.clk  (int_osc),  .reset (reset), .enable (enable), .out (matrix_sel));
        
        seven_segment  display(.s (dip_switch), .seg (seg)); 
        scanning scanner(.sel (matrix_sel), .reset (reset), .enable(enable), .rows (row));
        
        //Assign statements to implement the multiplexing and scanning 
        assign dip_switch = sel ? s0 : s1;
        assign c1 = sel ? 1 : 0;
        assign c2 = sel ? 0 : 1; 
        
        assign led[0] = ~cols[0];
        assign led[1] = ~cols[1];
        assign led[2] = ~cols[2];
        assign led[3] = ~cols[3];
endmodule 