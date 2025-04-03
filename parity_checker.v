module parity_checker(parity_in,data_in,parity_load,parity_error,data_out);
  input parity_in;
  input [7:0] data_in;
  input parity_load; // enable signal for parity
  output parity_error;
  output [7:0] data_out;
  
  assign parity_error=parity_load && (parity_in!=(^data_in));// if parity load==1 and parity_in!= ^ data_in , parity error =1
  assign data_out=parity_error?0:data_in;
endmodule
