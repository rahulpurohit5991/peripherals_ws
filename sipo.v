// Module: SIPO (Serial-In Parallel-Out)
// Description:
// Shifts incoming serial bits into a 10-bit parallel register.
// Captures 8-bit data, 1 parity bit, and 1 stop bit from the serial input.

module SIPO (
  clk,           // System clock
  rst,           // Asynchronous reset
  rx_in,         // Serial data input
  sample_done,   // Indicates valid sampling time (mid-bit)
  run_shift,     // Enable signal for shifting operation
  data_out       // 10-bit parallel output (8 data + 1 parity + 1 stop)
);

  input clk;
  input rst;
  input rx_in;
  input sample_done;
  input run_shift;
  output [9:0] data_out;

  reg [9:0] temp; // Temporary register to hold shifted bits

  // Shift logic
  // On every valid sample (sample_done) and when run_shift is high,
  // shift in rx_in to the MSB of the register, moving previous bits right.
  always @(posedge clk, posedge rst)
  begin
    if (rst)
      temp <= 0; // Clear the register on reset
    else begin
      if (run_shift) begin
        if (sample_done)
          temp <= {rx_in, temp[9:1]}; // Shift right, LSB discarded
        else
          temp <= temp; // Hold current value if not sample time
      end else
        temp <= temp; // Hold value if not shifting
    end
  end

  assign data_out = temp; // Connect internal register to output

endmodule
