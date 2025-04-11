// Module: BRG (Baud Rate Generator)
// Description:
// This module generates two clocks (clk_rx and clk_tx) from a higher-frequency input clock (clk_in).


module BRG (clk_in, rst, clk_rx, clk_tx);
  parameter n = 50; // Clock division factor for clk_rx

  // Inputs
  input clk_in;   // High-frequency input clock
  input rst;      // Asynchronous reset

  // Outputs
  output reg clk_rx;  // Receiver clock
  output reg clk_tx;  // Transmitter clock

  // Internal counters
  reg [11:0] count;   // 12-bit counter for clk_rx generation
  reg [4:0] count1;   // 5-bit counter for clk_tx generation

  // -----------------------------
  // clk_rx generation logic
  // -----------------------------
  always @ (posedge clk_in, posedge rst) begin
    if (rst) begin
      count <= 0;
    end else begin
      count <= count + 1;
      if (count == n - 1) begin
        count <= 0; // Reset count after reaching division factor
      end
    end
  end

  // clk_rx toggling logic based on count
  always @ (count) begin
    if (count == 0)
      clk_rx = 1; // Set clk_rx high at beginning of cycle
    else if (count == (n >> 1)) // halfway point for 50% duty cycle
      clk_rx = 0; // Set clk_rx low at half period
    else
      clk_rx = clk_rx; // Hold current state
  end

  // -----------------------------
  // clk_tx generation logic
  // -----------------------------
  always @ (posedge clk_rx, posedge rst) begin
    if (rst) begin
      count1 <= 0;
    end else begin
      count1 <= count1 + 1;
      if (count1 == 15) begin
        count1 <= 0; // Reset count1 every 16 clk_rx cycles
      end
    end
  end

  // clk_tx toggling logic based on count1
  always @ (count1) begin
    if (count1 == 0)
      clk_tx = 1; // Set clk_tx high at start
    else if (count1 == 8)
      clk_tx = 0; // Set clk_tx low halfway through
    else
      clk_tx = clk_tx; // Hold current state
  end

endmodule
