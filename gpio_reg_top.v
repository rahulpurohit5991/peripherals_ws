`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 12:26:18 PM
// Design Name: 
// Module Name: gpio_reg_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gpio_reg_top
(
  input wire  clk_i,
  input wire rst_ni,
  input  hw2reg_intr_state_de,
  input [31:0] hw2reg_intr_state_d ,
  input hw2reg_data_in_de,
  input [31:0]  hw2reg_data_in_d,
  input [31:0]hw2reg_direct_out_d,
  input  [15:0]hw2reg_masked_out_lower_data_d,
  input [15:0] hw2reg_masked_out_lower_mask_d,
  input [15:0] hw2reg_masked_out_upper_data_d,
  input [15:0] hw2reg_masked_out_upper_mask_d,
  input [31:0] hw2reg_direct_oe_d,
  input [15:0] hw2reg_masked_oe_lower_data_d,
  input [15:0]hw2reg_masked_oe_lower_mask_d,
  input [15:0] hw2reg_masked_oe_upper_data_d,
  input [15:0] hw2reg_masked_oe_upper_mask_d,
  input  hw2reg_hw_straps_data_in_valid_de,
  input  hw2reg_hw_straps_data_in_valid_d,
  input  hw2reg_hw_straps_data_in_de,
  input  [31:0] hw2reg_hw_straps_data_in_d,
// output
   output [31:0] reg2hw_intr_state_q,
   output reg2hw_intr_enable_qe,
   output [31:0]  reg2hw_intr_enable_q,
   output [31:0]  reg2hw_intr_test_q,
   output  reg2hw_intr_test_qe,
   output reg2hw_alert_test_q,
   output  reg2hw_alert_test_qe,
   output  [31:0] reg2hw_direct_out_q,
   output  reg2hw_direct_out_qe,
   output  [15:0] reg2hw_masked_out_lower_data_q,
   output  reg2hw_masked_out_lower_data_qe,
   output [15:0] reg2hw_masked_out_lower_mask_q,
   output  reg2hw_masked_out_lower_mask_qe,
   output [15:0] reg2hw_masked_out_upper_data_q,
   output  reg2hw_masked_out_upper_data_qe,
   output [15:0] reg2hw_masked_out_upper_mask_q,
   output  reg2hw_masked_out_upper_mask_qe,
   output [31:0] reg2hw_direct_oe_q,
   output reg2hw_direct_oe_qe,
   output  [15:0]reg2hw_masked_oe_lower_data_q,
   output reg2hw_masked_oe_lower_data_qe,
   output  [15:0]reg2hw_masked_oe_lower_mask_q,
   output  reg2hw_masked_oe_lower_mask_qe,
   output [15:0] reg2hw_masked_oe_upper_data_q,
   output  reg2hw_masked_oe_upper_data_qe,
   output [15:0] reg2hw_masked_oe_upper_mask_q,
   output  reg2hw_masked_oe_upper_mask_qe,
   output  [31:0] reg2hw_intr_ctrl_en_rising_q,
   output  [31:0] reg2hw_intr_ctrl_en_falling_q,
   output [31:0] reg2hw_intr_ctrl_en_lvlhigh_q,
   output  [31:0]  reg2hw_intr_ctrl_en_lvllow_q,
   output  [31:0] reg2hw_ctrl_en_input_filter_q,
   output  reg2hw_hw_straps_data_in_valid_q,
   output  [31:0] reg2hw_hw_straps_data_in_q,
// input
  
  
output reg intg_err_o
    );
//`include "gpio_reg.vh"
localparam AW=7;
localparam DW=32;
localparam DBW=DW/8;
reg reg_we;
reg reg_re;
reg[AW-1:0] reg_addr;
reg [31:0]reg_wdata;
reg [DBW-1:0]reg_be;
reg[DW-1:0] reg_rdata;
reg reg_error;
reg addrmiss,wr_err;
reg[DW-1:0] reg_rdata_next;
reg reg_busy;



/*
  // incoming payload check
  logic intg_err;
  tlul_cmd_intg_chk u_chk (
    .tl_i(tl_i),
    .err_o(intg_err)
  );

  
  
  prim_reg_we_check #(
    .OneHotWidth(18)
  ) u_prim_reg_we_check (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .oh_i  (reg_we_check),
    .en_i  (reg_we && !addrmiss),
    .err_o (reg_we_err)
  );
  */
// also check for spurious write enables
  wire reg_we_err;
  reg [17:0] reg_we_check;
  reg err_q;
  wire intg_err;
  always@(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      err_q <= 1'b0;
    end else if (intg_err || reg_we_err) begin
      err_q <= 1'b1;
    end
  end

  // integrity error output is permanent and should be used for alert generation
  // register errors are transactional
  assign intg_err_o = err_q | intg_err | reg_we_err;


  // cdc oversampling signals

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = addrmiss | wr_err | intg_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  wire intr_state_we;
  wire [31:0] intr_state_qs;
  wire [31:0] intr_state_wd;
  wire intr_enable_we;
  wire [31:0] intr_enable_qs;
  wire [31:0] intr_enable_wd;
  wire intr_test_we;
  wire [31:0] intr_test_wd;
  wire alert_test_we;
  wire alert_test_wd;
  wire [31:0] data_in_qs;
  wire direct_out_re;
  wire direct_out_we;
  wire [31:0] direct_out_qs;
  wire [31:0] direct_out_wd;
  wire masked_out_lower_re;
  wire masked_out_lower_we;
  wire [15:0] masked_out_lower_data_qs;
  wire [15:0] masked_out_lower_data_wd;
  wire [15:0] masked_out_lower_mask_wd;
  wire masked_out_upper_re;
  wire masked_out_upper_we;
  wire [15:0] masked_out_upper_data_qs;
  wire [15:0] masked_out_upper_data_wd;
  wire [15:0] masked_out_upper_mask_wd;
  wire direct_oe_re;
  wire direct_oe_we;
  wire [31:0] direct_oe_qs;
  wire [31:0] direct_oe_wd;
  wire masked_oe_lower_re;
  wire masked_oe_lower_we;
  wire [15:0] masked_oe_lower_data_qs;
  wire [15:0] masked_oe_lower_data_wd;
  wire [15:0] masked_oe_lower_mask_qs;
  wire [15:0] masked_oe_lower_mask_wd;
  wire masked_oe_upper_re;
  wire masked_oe_upper_we;
  wire [15:0] masked_oe_upper_data_qs;
  wire [15:0] masked_oe_upper_data_wd;
  wire [15:0] masked_oe_upper_mask_qs;
  wire [15:0] masked_oe_upper_mask_wd;
  wire intr_ctrl_en_rising_we;
  wire [31:0] intr_ctrl_en_rising_qs;
  wire [31:0] intr_ctrl_en_rising_wd;
  wire intr_ctrl_en_falling_we;
  wire [31:0] intr_ctrl_en_falling_qs;
  wire [31:0] intr_ctrl_en_falling_wd;
  wire intr_ctrl_en_lvlhigh_we;
  wire [31:0] intr_ctrl_en_lvlhigh_qs;
  wire [31:0] intr_ctrl_en_lvlhigh_wd;
  wire intr_ctrl_en_lvllow_we;
  wire [31:0] intr_ctrl_en_lvllow_qs;
  wire [31:0] intr_ctrl_en_lvllow_wd;
  wire ctrl_en_input_filter_we;
  wire [31:0] ctrl_en_input_filter_qs;
  wire [31:0] ctrl_en_input_filter_wd;
  wire hw_straps_data_in_valid_qs;
  wire [31:0] hw_straps_data_in_qs;
//

   

     

  // Register instances
  // R[intr_state]: V(False)
  
  
  prim_subreg #(
    .DW      (32),
  
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_intr_state (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_wd),

    // from internal hardware
    .de     (hw2reg_intr_state_de),
    .d      (hw2reg_intr_state_d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_intr_state_q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_qs)
  );


  // R[intr_enable]: V(False)
  prim_subreg #(
    .DW      (32),

    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_intr_enable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('b0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_intr_enable_q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_qs)
  );


  // R[intr_test]: V(True)
  wire intr_test_qe;
  wire [0:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_intr_test (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_wd),
    .d      ('b0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw_intr_test_q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw_intr_test_qe = intr_test_qe;


  // R[alert_test]: V(True)
  wire  alert_test_qe;
  wire  [0:0] alert_test_flds_we;
  assign alert_test_qe = &alert_test_flds_we;
  prim_subreg_ext #(
    .DW    (1)
  ) u_alert_test (
    .re     (1'b0),
    .we     (alert_test_we),
    .wd     (alert_test_wd),
    .d      ('b0),
    .qre    (),
    .qe     (alert_test_flds_we[0]),
    .q      (reg2hw_alert_test_q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw_alert_test_qe = alert_test_qe;


  // R[data_in]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_data_in (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('b0),

    // from internal hardware
    .de     (hw2reg_data_in_de),
    .d      (hw2reg_data_in_d),

    // to internal hardware
    .qe     (),
    .q      (),
    .ds     (),

    // to register interface (read)
    .qs     (data_in_qs)
  );


  // R[direct_out]: V(True)
  wire direct_out_qe;
  wire [0:0] direct_out_flds_we;
  assign direct_out_qe = & direct_out_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_direct_out (
    .re     (direct_out_re),
    .we     (direct_out_we),
    .wd     (direct_out_wd),
    .d      (hw2reg_direct_out_d),
    .qre    (),
    .qe     (direct_out_flds_we[0]),
    .q      (reg2hw_direct_out_q),
    .ds     (),
    .qs     (direct_out_qs)
  );
  assign reg2hw_direct_out_qe = direct_out_qe;


  // R[masked_out_lower]: V(True)
  wire masked_out_lower_qe;
  wire [1:0] masked_out_lower_flds_we;
  assign masked_out_lower_qe = &masked_out_lower_flds_we;
  //   F[data]: 15:0
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_out_lower_data (
    .re     (masked_out_lower_re),
    .we     (masked_out_lower_we),
    .wd     (masked_out_lower_data_wd),
    .d      (hw2reg_masked_out_lower_data_d),
    .qre    (),
    .qe     (masked_out_lower_flds_we[0]),
    .q      (reg2hw_masked_out_lower_data_q),
    .ds     (),
    .qs     (masked_out_lower_data_qs)
  );
  assign reg2hw_masked_out_lower_data_qe = masked_out_lower_qe;

  //   F[mask]: 31:16
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_out_lower_mask (
    .re     (1'b0),
    .we     (masked_out_lower_we),
    .wd     (masked_out_lower_mask_wd),
    .d      (hw2reg_masked_out_lower_mask_d),
    .qre    (),
    .qe     (masked_out_lower_flds_we[1]),
    .q      (reg2hw_masked_out_lower_mask_q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw_masked_out_lower_mask_qe = masked_out_lower_qe;


  // R[masked_out_upper]: V(True)
  wire masked_out_upper_qe;
  wire [1:0] masked_out_upper_flds_we;
  assign masked_out_upper_qe = &masked_out_upper_flds_we;
  //   F[data]: 15:0
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_out_upper_data (
    .re     (masked_out_upper_re),
    .we     (masked_out_upper_we),
    .wd     (masked_out_upper_data_wd),
    .d      (hw2reg_masked_out_upper_data_d),
    .qre    (),
    .qe     (masked_out_upper_flds_we[0]),
    .q      (reg2hw_masked_out_upper_data_q),
    .ds     (),
    .qs     (masked_out_upper_data_qs)
  );
  assign reg2hw_masked_out_upper_data_qe = masked_out_upper_qe;

  //   F[mask]: 31:16
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_out_upper_mask (
    .re     (1'b0),
    .we     (masked_out_upper_we),
    .wd     (masked_out_upper_mask_wd),
    .d      (hw2reg_masked_out_upper_mask_d),
    .qre    (),
    .qe     (masked_out_upper_flds_we[1]),
    .q      (reg2hw_masked_out_upper_mask_q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw_masked_out_upper_mask_qe = masked_out_upper_qe;


  // R[direct_oe]: V(True)
  wire direct_oe_qe;
  wire [0:0] direct_oe_flds_we;
  assign direct_oe_qe = &direct_oe_flds_we;
  prim_subreg_ext #(
    .DW    (32)
  ) u_direct_oe (
    .re     (direct_oe_re),
    .we     (direct_oe_we),
    .wd     (direct_oe_wd),
    .d      (hw2reg_direct_oe_d),
    .qre    (),
    .qe     (direct_oe_flds_we[0]),
    .q      (reg2hw_direct_oe_q),
    .ds     (),
    .qs     (direct_oe_qs)
  );
  assign reg2hw_direct_oe_qe = direct_oe_qe;


  // R[masked_oe_lower]: V(True)
  wire masked_oe_lower_qe;
  wire [1:0] masked_oe_lower_flds_we;
  assign masked_oe_lower_qe = &masked_oe_lower_flds_we;
  //   F[data]: 15:0
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_oe_lower_data (
    .re     (masked_oe_lower_re),
    .we     (masked_oe_lower_we),
    .wd     (masked_oe_lower_data_wd),
    .d      (hw2reg_masked_oe_lower_data_d),
    .qre    (),
    .qe     (masked_oe_lower_flds_we[0]),
    .q      (reg2hw_masked_oe_lower_data_q),
    .ds     (),
    .qs     (masked_oe_lower_data_qs)
  );
  assign reg2hw_masked_oe_lower_data_qe = masked_oe_lower_qe;

  //   F[mask]: 31:16
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_oe_lower_mask (
    .re     (masked_oe_lower_re),
    .we     (masked_oe_lower_we),
    .wd     (masked_oe_lower_mask_wd),
    .d      (hw2reg_masked_oe_lower_mask_d),
    .qre    (),
    .qe     (masked_oe_lower_flds_we[1]),
    .q      (reg2hw_masked_oe_lower_mask_q),
    .ds     (),
    .qs     (masked_oe_lower_mask_qs)
  );
  assign reg2hw_masked_oe_lower_mask_qe = masked_oe_lower_qe;


  // R[masked_oe_upper]: V(True)
  wire  masked_oe_upper_qe;
  wire [1:0] masked_oe_upper_flds_we;
  assign masked_oe_upper_qe = &masked_oe_upper_flds_we;
  //   F[data]: 15:0
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_oe_upper_data (
    .re     (masked_oe_upper_re),
    .we     (masked_oe_upper_we),
    .wd     (masked_oe_upper_data_wd),
    .d      (hw2reg_masked_oe_upper_data_d),
    .qre    (),
    .qe     (masked_oe_upper_flds_we[0]),
    .q      (reg2hw_masked_oe_upper_data_q),
    .ds     (),
    .qs     (masked_oe_upper_data_qs)
  );
  assign reg2hw_masked_oe_upper_data_qe = masked_oe_upper_qe;

  //   F[mask]: 31:16
  prim_subreg_ext #(
    .DW    (16)
  ) u_masked_oe_upper_mask (
    .re     (masked_oe_upper_re),
    .we     (masked_oe_upper_we),
    .wd     (masked_oe_upper_mask_wd),
    .d      (hw2reg_masked_oe_upper_mask_d),
    .qre    (),
    .qe     (masked_oe_upper_flds_we[1]),
    .q      (reg2hw_masked_oe_upper_mask_q),
    .ds     (),
    .qs     (masked_oe_upper_mask_qs)
  );
  assign reg2hw_masked_oe_upper_mask_qe = masked_oe_upper_qe;


  // R[intr_ctrl_en_rising]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_intr_ctrl_en_rising (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_ctrl_en_rising_we),
    .wd     (intr_ctrl_en_rising_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('b0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_intr_ctrl_en_rising_q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_ctrl_en_rising_qs)
  );


  // R[intr_ctrl_en_falling]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_intr_ctrl_en_falling (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_ctrl_en_falling_we),
    .wd     (intr_ctrl_en_falling_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('b0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_intr_ctrl_en_falling_q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_ctrl_en_falling_qs)
  );


  // R[intr_ctrl_en_lvlhigh]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_intr_ctrl_en_lvlhigh (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_ctrl_en_lvlhigh_we),
    .wd     (intr_ctrl_en_lvlhigh_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('b0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_intr_ctrl_en_lvlhigh_q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_ctrl_en_lvlhigh_qs)
  );


  // R[intr_ctrl_en_lvllow]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_intr_ctrl_en_lvllow (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_ctrl_en_lvllow_we),
    .wd     (intr_ctrl_en_lvllow_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('b0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_intr_ctrl_en_lvllow_q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_ctrl_en_lvllow_qs)
  );


  // R[ctrl_en_input_filter]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_ctrl_en_input_filter (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (ctrl_en_input_filter_we),
    .wd     (ctrl_en_input_filter_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('b0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_ctrl_en_input_filter_q),
    .ds     (),

    // to register interface (read)
    .qs     (ctrl_en_input_filter_qs)
  );


  // R[hw_straps_data_in_valid]: V(False)
  prim_subreg #(
    .DW      (1),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_hw_straps_data_in_valid (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('b0),

    // from internal hardware
    .de     (hw2reg_hw_straps_data_in_valid_de),
    .d      (hw2reg_hw_straps_data_in_valid_d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_hw_straps_data_in_valid_q),
    .ds     (),

    // to register interface (read)
    .qs     (hw_straps_data_in_valid_qs)
  );


  // R[hw_straps_data_in]: V(False)
  prim_subreg #(
    .DW      (32),
    .RESVAL  (32'h0),
    .Mubi    (1'b0)
  ) u_hw_straps_data_in (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('b0),

    // from internal hardware
    .de     (hw2reg_hw_straps_data_in_de),
    .d      (hw2reg_hw_straps_data_in_d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw_hw_straps_data_in_q),
    .ds     (),

    // to register interface (read)
    .qs     (hw_straps_data_in_qs)
  );



  reg [17:0] addr_hit;
      `define GPIO_INTR_STATE
      `define GPIO_INTR_ENABLE
      `define GPIO_INTR_TEST
      `define GPIO_ALERT_TEST
      `define GPIO_DATA_IN
      `define GPIO_DIRECT_OUT
      `define GPIO_MASKED_OUT_LOWER
      `define GPIO_MASKED_OUT_UPPER
      `define GPIO_DIRECT_OE
      `define GPIO_MASKED_oe_LOWER
      `define GPIO_MASKED_oe_UPPER
      `define GPIO_INTR_CTRL_EN_RISING// Interrupt Logic
      `define GPIO_INTR_CTRL_EN_FALLING// Interrupt Logic
      `define GPIO_INTR_CTRL_EN_LVLHIGH// Interupt Logic
      `define GPIO_INTR_CTRL_EN_LVLLOW// Interupt Logic
      `define GPIO_CTRL_EN_INPUT_FILTER
      `define GPIO_HW_STRAPS_DATA_IN_VALID
      `define GPIO_HW_STRAPS_DATA_IN


  always@(*) begin
    addr_hit = 'b0;
    addr_hit[ 0] = (reg_addr == GPIO_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == GPIO_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == GPIO_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == GPIO_ALERT_TEST_OFFSET);
    addr_hit[ 4] = (reg_addr == GPIO_DATA_IN_OFFSET);
    addr_hit[ 5] = (reg_addr == GPIO_DIRECT_OUT_OFFSET);
    addr_hit[ 6] = (reg_addr == GPIO_MASKED_OUT_LOWER_OFFSET);
    addr_hit[ 7] = (reg_addr == GPIO_MASKED_OUT_UPPER_OFFSET);
    addr_hit[ 8] = (reg_addr == GPIO_DIRECT_OE_OFFSET);
    addr_hit[ 9] = (reg_addr == GPIO_MASKED_OE_LOWER_OFFSET);
    addr_hit[10] = (reg_addr == GPIO_MASKED_OE_UPPER_OFFSET);
    addr_hit[11] = (reg_addr == GPIO_INTR_CTRL_EN_RISING_OFFSET);
    addr_hit[12] = (reg_addr == GPIO_INTR_CTRL_EN_FALLING_OFFSET);
    addr_hit[13] = (reg_addr == GPIO_INTR_CTRL_EN_LVLHIGH_OFFSET);
    addr_hit[14] = (reg_addr == GPIO_INTR_CTRL_EN_LVLLOW_OFFSET);
    addr_hit[15] = (reg_addr == GPIO_CTRL_EN_INPUT_FILTER_OFFSET);
    addr_hit[16] = (reg_addr == GPIO_HW_STRAPS_DATA_IN_VALID_OFFSET);
    addr_hit[17] = (reg_addr == GPIO_HW_STRAPS_DATA_IN_OFFSET);
    end
// Register width imformation to check illegal writes
localparam [3:0] GPIO_PERMIT_0=4'b1111;//Verilog alternative for packed array construct in System Verilog
localparam [3:0] GPIO_PERMIT_1=4'b1111;
localparam [3:0] GPIO_PERMIT_2=4'b1111;
localparam [3:0] GPIO_PERMIT_3=4'b0001;
localparam [3:0] GPIO_PERMIT_4=4'b1111;
localparam [3:0] GPIO_PERMIT_5=4'b1111;
localparam [3:0] GPIO_PERMIT_6=4'b1111;
localparam [3:0] GPIO_PERMIT_7=4'b1111;
localparam [3:0] GPIO_PERMIT_8=4'b1111;
localparam [3:0] GPIO_PERMIT_9=4'b1111;
localparam [3:0] GPIO_PERMIT_10=4'b1111;
localparam [3:0] GPIO_PERMIT_11=4'b1111;
localparam [3:0] GPIO_PERMIT_12=4'b1111;
localparam [3:0] GPIO_PERMIT_13=4'b1111;
localparam [3:0] GPIO_PERMIT_14=4'b1111;
localparam [3:0] GPIO_PERMIT_15=4'b1111;
localparam [3:0] GPIO_PERMIT_16=4'b0001;
localparam [3:0] GPIO_PERMIT_17=4'b1111;









  // Check sub-word write is permitted
  always@(*) begin
    wr_err = (reg_we &
              ((|(GPIO_PERMIT_0 & ~reg_be)) |
               (|(GPIO_PERMIT_1 & ~reg_be)) |
               (|(GPIO_PERMIT_2 & ~reg_be)) |
               (|(GPIO_PERMIT_3 & ~reg_be)) |
               (|(GPIO_PERMIT_4 & ~reg_be)) |
               (|(GPIO_PERMIT_5 & ~reg_be)) |
               (|(GPIO_PERMIT_6 & ~reg_be)) |
               (|(GPIO_PERMIT_7 & ~reg_be)) |
               (|(GPIO_PERMIT_8 & ~reg_be)) |
               (|(GPIO_PERMIT_9 & ~reg_be)) |
               (|(GPIO_PERMIT_10 & ~reg_be)) |
               (|(GPIO_PERMIT_11 & ~reg_be)) |
               (|(GPIO_PERMIT_12 & ~reg_be)) |
               (|(GPIO_PERMIT_13 & ~reg_be)) |
               (|(GPIO_PERMIT_14 & ~reg_be)) |
               (|(GPIO_PERMIT_15 & ~reg_be)) |
               (|(GPIO_PERMIT_16 & ~reg_be)) |
               (|(GPIO_PERMIT_17 & ~reg_be))));
  end

  // Generate write-enables
  assign intr_state_we = reg_we & !reg_error;

  assign intr_state_wd = reg_wdata[31:0];
  assign intr_enable_we = reg_we & !reg_error;

  assign intr_enable_wd = reg_wdata[31:0];
  assign intr_test_we = reg_we & !reg_error;

  assign intr_test_wd = reg_wdata[31:0];
  assign alert_test_we = reg_we & !reg_error;

  assign alert_test_wd = reg_wdata[0];
  assign direct_out_re = reg_re & !reg_error;
  assign direct_out_we = reg_we & !reg_error;

  assign direct_out_wd = reg_wdata[31:0];
  assign masked_out_lower_re =  reg_re & !reg_error;
  assign masked_out_lower_we = reg_we & !reg_error;

  assign masked_out_lower_data_wd = reg_wdata[15:0];

  assign masked_out_lower_mask_wd = reg_wdata[31:16];
  assign masked_out_upper_re = reg_re & !reg_error;
  assign masked_out_upper_we = reg_we & !reg_error;

  assign masked_out_upper_data_wd = reg_wdata[15:0];

  assign masked_out_upper_mask_wd = reg_wdata[31:16];
  assign direct_oe_re = reg_re & !reg_error;
  assign direct_oe_we = reg_we & !reg_error;

  assign direct_oe_wd = reg_wdata[31:0];
  assign masked_oe_lower_re = reg_re & !reg_error;
  assign masked_oe_lower_we = reg_we & !reg_error;

  assign masked_oe_lower_data_wd = reg_wdata[15:0];

  assign masked_oe_lower_mask_wd = reg_wdata[31:16];
  assign masked_oe_upper_re = reg_re & !reg_error;
  assign masked_oe_upper_we = reg_we & !reg_error;

  assign masked_oe_upper_data_wd = reg_wdata[15:0];

  assign masked_oe_upper_mask_wd = reg_wdata[31:16];
  assign intr_ctrl_en_rising_we = reg_we & !reg_error;

  assign intr_ctrl_en_rising_wd = reg_wdata[31:0];
  assign intr_ctrl_en_falling_we =reg_we & !reg_error;

  assign intr_ctrl_en_falling_wd = reg_wdata[31:0];
  assign intr_ctrl_en_lvlhigh_we = reg_we & !reg_error;

  assign intr_ctrl_en_lvlhigh_wd = reg_wdata[31:0];
  assign intr_ctrl_en_lvllow_we = reg_we & !reg_error;

  assign intr_ctrl_en_lvllow_wd = reg_wdata[31:0];
  assign ctrl_en_input_filter_we = reg_we & !reg_error;

  assign ctrl_en_input_filter_wd = reg_wdata[31:0];

  // Assign write-enables to checker logic vector.
  always@(*) begin
    reg_we_check = 'b0;
    reg_we_check[0] = intr_state_we;
    reg_we_check[1] = intr_enable_we;
    reg_we_check[2] = intr_test_we;
    reg_we_check[3] = alert_test_we;
    reg_we_check[4] = 1'b0;
    reg_we_check[5] = direct_out_we;
    reg_we_check[6] = masked_out_lower_we;
    reg_we_check[7] = masked_out_upper_we;
    reg_we_check[8] = direct_oe_we;
    reg_we_check[9] = masked_oe_lower_we;
    reg_we_check[10] = masked_oe_upper_we;
    reg_we_check[11] = intr_ctrl_en_rising_we;
    reg_we_check[12] = intr_ctrl_en_falling_we;
    reg_we_check[13] = intr_ctrl_en_lvlhigh_we;
    reg_we_check[14] = intr_ctrl_en_lvllow_we;
    reg_we_check[15] = ctrl_en_input_filter_we;
    reg_we_check[16] = 1'b0;
    reg_we_check[17] = 1'b0;
  end






endmodule
 
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register slice conforming to Comportibility guide.

module prim_subreg #(
  parameter[2:0] SwAccessRW=3'd0,
  parameter[2:0] SwAccessRO = 3'd1,
  parameter[2:0] SwAccessWO = 3'd2,
  parameter[2:0] SwAccessW1C = 3'd3,
  parameter[2:0] SwAccessW1S = 3'd4,
  parameter[2:0] SwAccessW0c = 3'd5,
  parameter[2:0] SwAccessRC = 3'd6,
  parameter [31:0]            DW       = 32,
  parameter     SwAccess = SwAccessRW,
  parameter  [DW-1:0] RESVAL   = '0 ,   // reset value
  parameter             Mubi     = 1'b0) 
(
  input clk_i,
  input rst_ni,

  // From SW: valid for RW, WO, W1C, W1S, W0C, RC
  // In case of RC, Top connects Read Pulse to we
  input          we,
  input [DW-1:0] wd,

  // From HW: valid for HRW, HWO
  input          de,
  input [DW-1:0] d,

  // output to HW and Reg Read
  output wire          qe,
  output reg [DW-1:0] q,

  // ds and qs have slightly different timing.
  // ds is the data that will be written into the flop,
  // while qs is the current flop value exposed to software.
  output wire [DW-1:0] ds,
  output wire [DW-1:0] qs
);

  logic          wr_en;
  logic [DW-1:0] wr_data;

  prim_subreg_arb #(
    .DW       ( DW       ),
    .SwAccess ( SwAccess ),
    .Mubi     ( Mubi     )
  ) wr_en_data_arb (
    .we,
    .wd,
    .de,
    .d,
    .q,
    .wr_en,
    .wr_data
  );

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      q <= RESVAL;
    end else if (wr_en) begin
      q <= wr_data;
    end
  end

  // feed back out for consolidation
  assign ds = wr_en ? wr_data : qs;
  assign qe = wr_en;

  if (SwAccess == SwAccessRC) begin : gen_rc
    // In case of a SW RC colliding with a HW write, SW gets the value written by HW
    // but the register is cleared to 0. See #5416 for a discussion.
    assign qs = de && we ? d : q;
  end else begin : gen_no_rc
    assign qs = q;
  end

endmodule

module prim_subreg_ext #(
    parameter  DW = 16  // Data width (default 16-bit)
) (
    input  wire re,         // Read enable
    input  wire we,         // Write enable
    input  wire [DW-1:0] wd, // Write data
    input  wire [DW-1:0] d,  // Data input from hardware

    output wire qre,        // Read enable output (unused)
    output wire qe,         // Write enable output
    output wire [DW-1:0] q,  // Data output to internal hardware
    output wire ds,         // Unused signal
    output wire [DW-1:0] qs  // Register read output
);

    // Internal register storage
    reg [DW-1:0] reg_data;

    always @(posedge we or posedge re) begin
        if (we) begin
            reg_data <= wd;  // Write new data when write enable is high
        end else if (re) begin
            reg_data <= d;   // Update from hardware when read enable is high
        end
    end

    assign q  = reg_data;   // Output register value
    assign qs = reg_data;   // Read value
    assign qe = we;         // Forward write enable
    assign qre = re;        // Forward read enable (not used in instantiation)
    assign ds = 1'b0;       // Unused signal

endmodule


