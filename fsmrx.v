module RX_FSM ( clk,rst,start_bit_detected,run_shift,parity_load,parity_error,chk_stop,sample_done);
  input clk;
  input rst;
  input start_bit_detected;
  input parity_error;
  
  
  output reg run_shift;
  output reg parity_load;
  output reg chk_stop;
  output  sample_done;
  
  //...................................
  reg [3:0] bcount;// to chk the middle of data
  reg [3:0] count;// to check howmany data I have receievd
  wire data_done;
  reg count_en; // to enable the count
  
  //......................................
  parameter IDLE =2'b00,
            DATA=2'b01,
            PARITY=2'b10,
            STOP=2'b11;
  reg [1:0] present_state,next_state;
  //...................................
  
  always @ (posedge clk, posedge rst) begin
    if(rst) bcount<=0;
    else begin 
      if (present_state!=IDLE) bcount<=bcount+1;
      else bcount<=0;
    end
  end
  assign sample_done=(bcount==7);// Rx 8 clk have passed
  //................................................
  
  always @(posedge clk,posedge rst)
begin
  if(rst) count<=0;
   else begin
	  if(count_en) begin 
	    if(sample_done) count<=count+1;
		 else count<=count;
		end
		else count<=0;
	end
end

  assign data_done=(count==11);// when SIPO has rececined all 11 data, at that time data Rx is done
  //.....................................
  always @ (posedge clk,posedge rst) begin 
    if(rst) present_state<=IDLE;
    else present_state<=next_state;
  end
  //............................................
  
  always @ (*) begin 
    case(present_state) 
      IDLE:if(start_bit_detected) next_state=DATA;
            else next_state=IDLE;
      
      DATA:if (data_done) next_state=PARITY;
              else next_state=DATA;
      
      PARITY: if (parity_error) next_state=IDLE;
               else next_state=STOP;
      
      STOP:  next_state=IDLE; // after STOP id there is any furthurs recive of data, then RX should detect the startbit.this is possible at idle state.
    endcase
  end
  
  //.............................
  always @ (present_state) begin 
    case(present_state) 
      IDLE:begin 
           count_en=0;
           run_shift=0;
           parity_load=0;
           chk_stop=0;
          end
      
      
      DATA:begin 
           count_en=1;
           run_shift=1;
           parity_load=0;
           chk_stop=0;
          end
      
      PARITY: begin 
           count_en=0;
           run_shift=0;
           parity_load=1;
           chk_stop=0;
          end
      
      STOP:  begin 
           count_en=0;
           run_shift=0;
           parity_load=0;
           chk_stop=1;
          end
    endcase
  end
endmodule
  
      
          
   