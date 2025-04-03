module stop_bit_checker(stop_bit_in,data_in,chk_stop,stop_bit_error,data_out);
  input stop_bit_in;
  input [7:0] data_in;
  input chk_stop; // enable signal for stop bit checker
  output stop_bit_error;
  output [7:0] data_out;
  
  assign stop_bit_error=chk_stop && (!stop_bit_in); // if chk_stop==1, && stop_bit_in==0, stop_error=1;
  assign data_out=stop_bit_error?0:data_in;
endmodule
