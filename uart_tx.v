// Code your design here
`include "TX_MUX.v"
`include "TX_PARITY.v"
`include "TX_PISO.v"
`include "TX_FSM.v"

module UART_TX( clk,rst,TX_start,TX_data_in,TX_data_out,TX_busy);
  input clk;
  input rst;
  input TX_start;
  input [7:0] TX_data_in;
  output TX_data_out;
  output TX_busy;
  //.................
  wire parity_out;
  wire piso_op;
  wire [1:0] mux_sel;
  wire  piso_load;
  wire piso_shift;
  wire  parity_load;
  //................
  
  
  // TX_MUX..
  TX_MUX inst_mux (.select(mux_sel),
                   .data_bit(piso_op),
                   .parity_bit(parity_out),
                   .tx_out(TX_data_out));
  
  // TX_parity
  TX_PARITY  inst_parity(.clk(clk),
                         .rst(rst), 
                         .parity_load(parity_load),
                         .parity_data_in(TX_data_in),
                         .parity_out(parity_out));
  
  // TX_PISO
  TX_PISO inst_PISO (.clk(clk),
                     .rst(rst),
                     .load(piso_load),
                     .shift(piso_shift),
                     .piso_in(TX_data_in),
                     .piso_out(piso_op));
  // TX_FSM
   TX_FSM  int_FSM (.clk(clk),
                .rst(rst),
                .TX_start(TX_start),
                .select(mux_sel),
                .load(piso_load),
                .shift(piso_shift),
                .parity_load(parity_load),
                .TX_busy(TX_busy));
  endmodule
                         
                         
