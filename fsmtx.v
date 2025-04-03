module TX_FSM(clk,rst,TX_start,select,load,shift,parity_load,TX_busy);
  input clk;
  inout rst;
  input TX_start;
  output reg [1:0] select; // control the mux
  output reg load; // controll the shift register
  output reg shift;
  output reg parity_load;// controll the parity
  output reg TX_busy;
  ////////////////////////////////////
  
  reg[2:0] count;
  reg count_en;
  wire data_done; //1 when count=7, all 7 bit data shifted serially
  
  
  ////////////////////////////////
  parameter  IDLE=3'b000,
             START=3'b001,
             DATA=3'b010,
             PARITY=3'b011,
             STOP=3'b100;
  reg [2:0] present_state,next_state;
  
  
  assign data_done=(count==7);
  //...................... counter 
  always @ (posedge clk, posedge rst) 
    if(rst) count<=0;
  else  begin 
    if(count_en) count<=count+1; // count at data state
    else count<=0;
  end
  
  //.................................
  always @ (posedge clk, posedge rst) begin 
    if(rst) present_state<=IDLE;
    else present_state<=next_state;
  end
  
  //..............................
  always @ (*) begin
    case (present_state) 
      IDLE:if(TX_start) next_state=START;
            else next_state=IDLE;
      
      START:next_state=DATA; // at start state it remains only for 1 clk cycle to send the start bit;
      
      DATA: if (data_done) next_state=PARITY; // it will remain here for 8 clk cycle
             else  next_state=DATA;
      
      PARITY : next_state=STOP; // remain only for 1 clk cycle to send the parity bit;
      
      STOP: if (TX_start) next_state=START;
            else next_state=IDLE;
    endcase
  end
  
  //...............................................
  always @ (*) begin 
   
      case (present_state) 
        IDLE: begin 
              select=2'b11; // to send 1 during idle state
              load=1'b0;
              shift=1'b0;
              parity_load=1'b0;
              TX_busy=1'b0;
              count_en=1'b0;
              end
             
        START: begin 
              select=2'b00; // to send 0 during start state
              load=1'b1; // during this state data is loaded to shift
              shift=1'b0;
              parity_load=1'b1; // parity load is clauclated
              TX_busy=1'b1;
              count_en=1'b0;
              end
        
         DATA: begin 
              select=2'b01; // to send serial data_out during DATA state
              load=1'b0; 
              shift=1'b1;
              parity_load=1'b0; 
              TX_busy=1'b1;
              count_en=1'b1;
              end
        
        PARITY: begin 
              select=2'b10;  // send parity during parity state
              load=1'b0; 
              shift=1'b0;
              parity_load=1'b0; 
              TX_busy=1'b1;
              count_en=1'b0;
              end
        
         STOP: begin 
              select=2'b11; // to send 1 during stop state
              load=1'b0; // during this state data is loaded to shift
              shift=1'b0;
              parity_load=1'b0; // parity load is clauclated
              TX_busy=1'b1; // transmitter is busy
              count_en=1'b0;
              end
      endcase
  end
  
      endmodule
      
             
             
    
  
  
  