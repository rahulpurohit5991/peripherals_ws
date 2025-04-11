// Module: detect_start
// Description: 
// Detects the start bit in a serial communication protocol UART.
// In UART, the line is idle (logic high), and a start bit is a logic low (0).
// This module simply outputs a signal when the start bit is detected.

module detect_start(rx_in, start_bit_detected);
  input rx_in;                 // Serial input line

  output start_bit_detected;   // High when start bit (logic 0) is detected

  // Combinational logic: detect low level on rx_in
  assign start_bit_detected = !(rx_in); // start bit is detected when rx_in is 0

endmodule
