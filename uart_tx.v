// UART Transmitter Top Module: UART_TX
// Description:
// This module transmits 8-bit serial data with 1 start bit, 1 parity bit, and 1 stop bit
// using the following submodules:
// 1. TX_PISO - Parallel In Serial Out shift register
// 2. TX_PARITY - Parity bit generator
// 3. TX_MUX - Multiplexes between data, parity, and stop/start bits
// 4. TX_FSM - Controls the transmission flow and timing

`include "TX_MUX.v"
`include "TX_PARITY.v"
`include "TX_PISO.v"
`include "TX_FSM.v"

module UART_TX(
  input clk,                // System clock
  input rst,                // Active-high reset
  input TX_start,           // Start signal to begin transmission
  input [7:0] TX_data_in,   // 8-bit parallel input data

  output TX_data_out,       // Serial output data
  output TX_busy            // High when transmitter is active
);

  // Internal wires for communication between modules
  wire parity_out;          // Output from parity generator
  wire piso_op;             // Serial output from PISO
  wire [1:0] mux_sel;       // Selector for TX_MUX
  wire piso_load;           // Control: load signal for TX_PISO
  wire piso_shift;          // Control: shift signal for TX_PISO
  wire parity_load;         // Control: load signal for TX_PARITY

  // 1. TX_MUX: Chooses between data bit, parity bit, or fixed bits
  TX_MUX inst_mux (
    .select(mux_sel),
    .data_bit(piso_op),
    .parity_bit(parity_out),
    .tx_out(TX_data_out)
  );

  // 2. TX_PARITY: Computes the parity bit based on input data
  TX_PARITY inst_parity (
    .clk(clk),
    .rst(rst), 
    .parity_load(parity_load),
    .parity_data_in(TX_data_in),
    .parity_out(parity_out)
  );

  // 3. TX_PISO: Converts 8-bit data to serial format
  TX_PISO inst_PISO (
    .clk(clk),
    .rst(rst),
    .load(piso_load),
    .shift(piso_shift),
    .piso_in(TX_data_in),
    .piso_out(piso_op)
  );

  // 4. TX_FSM: Finite State Machine controls the timing and enables
  TX_FSM int_FSM (
    .clk(clk),
    .rst(rst),
    .TX_start(TX_start),
    .select(mux_sel),         // Controls mux: start/data/parity/stop
    .load(piso_load),         // Load data into PISO
    .shift(piso_shift),       // Shift data in PISO
    .parity_load(parity_load),// Load data into parity generator
    .TX_busy(TX_busy)         // Status signal: high while transmitting
  );

endmodule
