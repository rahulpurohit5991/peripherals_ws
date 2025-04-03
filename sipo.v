module SIPO (clk,rst,rx_in,sample_done,run_shift,data_out);
  input clk;
  input rst;
  input rx_in;
  input sample_done;
  input run_shift;// enable signal to SIPO
  output [9:0] data_out;// 8bit data+1bitparity+1bitstop
  
  reg [9:0] temp;
  
  always @(posedge clk,posedge rst)
begin
  if(rst)
		temp<=0;
	else begin 
	if(run_shift) begin
	  if(sample_done) temp<={rx_in,temp[9:1]};
	  else temp<=temp;
	end
	else temp<=temp;		
 end
end
assign data_out=temp;

endmodule

  