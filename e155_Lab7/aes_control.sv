//Esteban Gonzalez 
//estgonzalez@g.hmc.edu
//10/25/26
//FSM module, controls when registers get enabled. Takes load as an input and outputs round count along with 
//select lines for muxs. 

module aes_control(
  input   logic clk,
  input   logic load,
  output  logic sel_load,
  output  logic reg_en, 
  output  logic out_en, 
  output  logic sel_last,
  output  logic done, 
  output logic [3:0] round
);

typedef enum logic [1:0] {IDLE, LOOKUP, ROUND, DONE} statetype; 
statetype state = IDLE;
statetype nextstate; 

logic start; 
logic load_prev = 1'b0;
logic load_fall;




always_ff @(posedge clk)
      load_prev <= load; 

assign load_fall = load_prev & ~load;
assign start = load & (state == IDLE); 

always_ff @(posedge clk)
    if(load) state <= IDLE;
    else state <= nextstate; 

    always_comb 
      case(state)
          IDLE:   nextstate = load_fall  ? LOOKUP : IDLE;
          LOOKUP: nextstate = ROUND; 
          ROUND:  nextstate = sel_last ? DONE : LOOKUP; 
          DONE:   nextstate = load_fall  ? LOOKUP : DONE; 
          default: nextstate = IDLE;
      endcase
   
    // couldn't get the counter module to work
    // counter #(.width(4)) round_counter(.clk(clk), .reset(start),.enable((state == ROUND) & ~sel_last), .counter(round) ); 
     initial round = 4'd0;
     always_ff @(posedge clk)
       if (start) round <= 4'd1;
       else if (state == ROUND && !sel_last) round <= round + 4'd1;

  assign sel_last = (round == 4'd10);
  assign sel_load = start; 
  assign reg_en  = start | (state == ROUND);
  assign out_en = (state == ROUND) & sel_last;
  assign done    = (state == DONE);

endmodule
