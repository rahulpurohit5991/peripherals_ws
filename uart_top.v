// UART.v - Top-Level UART Module (Transmitter + Receiver)
// Features:
// - Transmits and receives 8-bit serial data
// - Includes start, parity, and stop bits
// - Uses a Baud Rate Generator (BRG) to generate clk_rx and clk_tx

`include "UART_TX.v"
`include "UART_RX.v"
`include "BRG.v"

module UART (
  input clk,               // Master clock
  input rst,               // Active-high reset
  input TX_start,          // Trigger to start UART transmission
  input [7:0] DATA_in,     // 8-bit parallel data to transmit

  output TX_busy,          // Transmitter is busy
  output [7:0] DATA_out,   // Received parallel data
  output parity_error,     // Parity check failed
  output stop_error,       // Stop bit check failed
  output op_valid          // Output data is valid
);

  // Internal wires
  wire tx_data_out;        // Serial data from TX to RX
  wire clk1;               // Generated RX clock
  wire clk2;               // Generated TX clock

  // Instantiate Baud Rate Generator (BRG)
  BRG dut_BRG (
    .clk_in(clk),
    .rst(rst),
    .clk_rx(clk1),
    .clk_tx(clk2)
  );

  // Instantiate Receiver (UART_RX)
  RECEIVER dut_RX (
    .clk(clk1),
    .rst(rst),
    .rx_data_in(tx_data_out),     // Loopback from transmitter
    .rx_data_out(DATA_out),
    .parity_error(parity_error),
    .stop_error(stop_error),
    .rx_done(op_valid)
  );

  // Instantiate Transmitter (UART_TX)
  UART_TX dut_TX (
    .clk(clk2),
    .rst(rst),
    .TX_start(TX_start),
    .TX_data_in(DATA_in),
    .TX_data_out(tx_data_out),    // Serial output sent to receiver
    .TX_busy(TX_busy)
  );

endmodule
