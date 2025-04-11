// Module: parity_checker
// Description:
// This module checks the parity of received data against the received parity bit.
// If parity does not match and checking is enabled, it flags an error and clears the data.

module parity_checker (
  parity_in,       // Received parity bit
  data_in,         // 8-bit received data
  parity_load,     // Enable signal to perform parity check
  parity_error,    // Output flag: 1 if parity mismatch
  data_out         // Output data: 0 if error, otherwise data_in
);

  input parity_in;
  input [7:0] data_in;
  input parity_load;
  output parity_error;
  output [7:0] data_out;

  // Perform parity check when enabled:
  // XOR all bits of data_in (^data_in) and compare with parity_in
  // If mismatch, flag a parity error
  assign parity_error = parity_load && (parity_in != (^data_in));

  // Output data: 
  // If parity error is detected, output 0
  // Otherwise, forward the received data
  assign data_out = parity_error ? 0 : data_in;

endmodule
