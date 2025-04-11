// Receiver Module: RECEIVER
// Description:
// This is the top-level UART receiver module that integrates all submodules:
// 1. Start bit detector
// 2. SIPO (Serial In Parallel Out shift register)
// 3. Parity checker
// 4. Stop bit checker
// 5. Receiver FSM for controlling data flow and sampling

`include "detect_start.v"
`include "SIPO.v"
`include "parity_checker.v"
`include "stop_bit_checker.v"
`include "RXFSM.v"

module RECEIVER(
  input clk,               // System clock
  input rst,               // Active-high reset
  input rx_data_in,        // Serial data input from transmitter

  output [7:0] rx_data_out,// Final received 8-bit data
  output parity_error,     // Error flag: parity mismatch
  output stop_error,       // Error flag: invalid stop bit
  output rx_done           // Reception complete signal
);

  // Internal signal wires
  wire start_bit_detected;   // Goes high when start bit (0) is detected
  wire [9:0] sipo_out;       // Output from SIPO: {stop, parity, data[7:0]}
  wire parity_load;          // Enable signal for parity check
  wire [7:0] parity_out;     // Output after parity check
  wire sample_done;          // Signal: one sample complete
  wire run_shift;            // Enable shifting in SIPO
  wire chk_stop;             // Enable signal for stop bit checker
  wire stop_bit_error;       // Stop bit validation flag

  // Signal that indicates data reception is complete
  assign rx_done = chk_stop;

  // Detect start bit from rx_data_in (start bit is logic 0)
  detect_start dut_start (
    .rx_in(rx_data_in),
    .start_bit_detected(start_bit_detected)
  );

  // Serial-In Parallel-Out shift register
  SIPO dut_sipo (
    .clk(clk),
    .rst(rst),
    .rx_in(rx_data_in),
    .sample_done(sample_done),
    .run_shift(run_shift),
    .data_out(sipo_out)           // 10-bit: {stop_bit, parity_bit, data[7:0]}
  );

  // Parity checker to verify correctness of parity bit
  parity_checker dut_parity (
    .parity_in(sipo_out[8]),       // Extract parity bit
    .data_in(sipo_out[7:0]),       // Extract 8-bit data
    .parity_load(parity_load),
    .parity_error(parity_error),
    .data_out(parity_out)          // Data passed through if parity is valid
  );

  // Stop bit checker
  stop_bit_checker dut_stop (
    .stop_bit_in(sipo_out[9]),     // Extract stop bit
    .data_in(parity_out),
    .chk_stop(chk_stop),
    .stop_bit_error(stop_error),
    .data_out(rx_data_out)         // Final valid 8-bit output data
  );

  // Receiver Finite State Machine
  RX_FSM dut_fsm (
    .clk(clk),
    .rst(rst),
    .start_bit_detected(start_bit_detected),
    .run_shift(run_shift),
    .parity_load(parity_load),
    .parity_error(parity_error),
    .chk_stop(chk_stop),
    .sample_done(sample_done)
  );

endmodule
