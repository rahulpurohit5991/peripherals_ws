// Module: stop_bit_checker
// Description:
// Checks the stop bit received in a UART frame. 
// If the stop bit is invalid (i.e., 0 when it should be 1), an error is flagged.
// If there's a stop bit error, the output data is cleared to 0.

module stop_bit_checker (
  stop_bit_in,     // Received stop bit (should be 1 in UART)
  data_in,         // Received 8-bit data
  chk_stop,        // Enable signal to perform the stop bit check
  stop_bit_error,  // Output flag: 1 if stop bit error detected
  data_out         // Output data (0 if error, else passes data_in)
);

  input stop_bit_in;
  input [7:0] data_in;
  input chk_stop;
  output stop_bit_error;
  output [7:0] data_out;

  // Detect stop bit error: 
  // If checker is enabled (chk_stop == 1) and stop bit is 0 → error
  assign stop_bit_error = chk_stop && (!stop_bit_in);

  // If there's a stop bit error, set output to 0. Otherwise, pass the data through.
  assign data_out = stop_bit_error ? 0 : data_in;

endmodule
