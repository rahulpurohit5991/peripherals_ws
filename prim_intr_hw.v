
//
`timescale 1ns / 1ps
// Module for Interrupt to instantiate to the top module
module prim_intr_hw #(
  parameter Width = 1,
  parameter USE_EVENT_TYPE = 1,
  parameter USE_STATUS_TYPE = 0,
  parameter FLOPOUTPUT = 1
)(
  // Event
  input clk_i,
  input rst_ni,
  input [Width-1:0] event_intr_i,

  // Register Interface
  
  input reg2hw_intr_enable_qe_i,
  input [Width-1:0] reg2hw_intr_enable_q_i,
  input reg2hw_intr_test_qe_i,
  input [Width-1:0] reg2hw_intr_test_q_i,
  input [Width-1:0] reg2hw_intr_state_q_i,
  

  output hw2reg_intr_state_de_o,
  output [Width-1:0] hw2reg_intr_state_d_o,
  output[Width-1:0]  hw2reg_data_in_d,

  // Outgoing Interrupt
  output [Width-1:0] intr_o
);

  // Internal signals
  reg [Width-1:0] status;
  reg [Width-1:0] hw2reg_intr_state_d_o_reg;
  reg hw2reg_intr_state_de_o_reg;
  reg [Width-1:0] intr_o_reg;
  reg [Width-1:0] test_q;

assign hw2reg_intr_state_d_o = hw2reg_intr_state_d_o_reg;
assign hw2reg_intr_state_de_o = hw2reg_intr_state_de_o_reg;
assign intr_o = intr_o_reg;

  // Latch test_q if test_qe is high
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      test_q <= {Width{1'b0}};
    else if (reg2hw_intr_test_qe_i)
      test_q <= reg2hw_intr_test_q_i;
  end

  // Main status and register update logic
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      hw2reg_intr_state_de_o_reg <= 1'b0;// SCALER
      hw2reg_intr_state_d_o_reg  <= {Width{1'b0}};//VECTOR
      status                     <= {Width{1'b0}};
    end else begin
      if (USE_EVENT_TYPE) begin
        hw2reg_intr_state_de_o_reg <= |((reg2hw_intr_test_qe_i ? reg2hw_intr_test_q_i : {Width{1'b0}}) | event_intr_i);
        hw2reg_intr_state_d_o_reg  <= ((reg2hw_intr_test_qe_i ? reg2hw_intr_test_q_i : {Width{1'b0}}) | event_intr_i)
                                       | reg2hw_intr_state_q_i;
        status <= reg2hw_intr_state_q_i;
      end else if (USE_STATUS_TYPE) begin
        hw2reg_intr_state_de_o_reg <= 1'b1;
        hw2reg_intr_state_d_o_reg  <= test_q | event_intr_i;
        status <= test_q | event_intr_i;
      end else begin
        hw2reg_intr_state_de_o_reg <= 1'b0;
        hw2reg_intr_state_d_o_reg  <= {Width{1'b0}};
        status                     <= {Width{1'b0}};
      end
    end
  end

  // Final interrupt output generation
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      intr_o_reg <= {Width{1'b0}};
    else if (FLOPOUTPUT)
      intr_o_reg <= reg2hw_intr_enable_q_i & status;
    else
      intr_o_reg <= reg2hw_intr_enable_q_i & reg2hw_intr_state_q_i;
  end

endmodule

