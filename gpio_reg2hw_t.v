`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 01:15:00 PM
// Design Name: 
// Module Name: gpio_reg2hw_t
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



module gpio_reg2hw_t
#(parameter BlockAw=7 ,parameter NumRegs=18,
// Registers Offset
parameter [BlockAw-1:0] GPIO_INTR_STATE_OFFSET=7'h0,// Verilog alternative for System Verilog parameter logic
parameter [BlockAw-1:0] GPIO_INTR_ENABLE_OFFSET=7'h4,
parameter [BlockAw-1:0] GPIO_INTR_TEST_OFFSET=7'h8,
parameter [BlockAw-1:0] GPIO_ALERT_TEST_OFFSET=7'hC,
parameter [BlockAw-1:0] GPIO_DATA_IN_OFFSET=7'h10,
parameter [BlockAw-1:0] GPIO_DIRECT_OUT_OFFSET=7'h14,
parameter [BlockAw-1:0] GPIO_MASKED_OUT_LOWER_OFFSET=7'h18,
parameter [BlockAw-1:0] GPIO_MASKED_OUT_UPPER_OFFSET=7'h1C,
parameter [BlockAw-1:0] GPIO_DIRECT_OE_OFFSET=7'h20,
parameter [BlockAw-1:0] GPIO_MASKED_OE_LOWER_OFFSET=7'h24,
parameter [BlockAw-1:0] GPIO_MASKED_OE_UPPER_OFFSET=7'h28,
parameter [BlockAw-1:0] GPIO_INTR_CTRL_EN_RISING_OFFSET=7'h2C,
parameter [BlockAw-1:0] GPIO_INTR_CTRL_EN_FALLING_OFFSET=7'h30,
parameter [BlockAw-1:0] GPIO_INTR_CTRL_EN_LVLHIGH_OFFSET=7'h34,
parameter [BlockAw-1:0] GPIO_INTR_CTRL_EN_LVLLOW_OFFSET=7'h38,
parameter [BlockAw-1:0] GPIO_CTRL_EN_INPUT_FILTER_OFFSET=7'h3C,
parameter [BlockAw-1:0] GPIO_HW_STRAPS_DATA_IN_VALID_OFFSET=7'h40,
parameter [BlockAw-1:0] GPIO_HW_STRAPS_DATA_IN_OFFSET=7'h44,

//Reset values for hwext registers and their fields
parameter [31:0] GPIO_INTR_TEST_RESVAL=32'h0, // Verilog alternative for System Verilog parameter logic
parameter [31:0] GPIO_INTR_TEST_GPIO_RESVAL=32'h0,
parameter [31:0] GPIO_ALERT_TEST_RESVAL=1'h0,
parameter [31:0] GPIO_ALERT_TEST_FATAL_FAULT_RESVAL=1'h0,
parameter [31:0] GPIO_DIRECT_OUT_RESVAL=32'h0,
parameter [31:0] GPIO_MASKED_OUT_LOWER_RESVAL=32'h0,
parameter [31:0] GPIO_MASKED_OUT_UPPER_RESVAL=32'h0,
parameter [31:0] GPIO_DIRECT_OE_RESVAL=32'h0,
parameter [31:0] GPIO_MASKED_OE_LOWER_RESVAL=32'h0,
parameter [31:0] GPIO_MASKED_OE_UPPER_RESVAL=32'h0,

// Register width imformation to check illegal writes
localparam [3:0] GPIO_PERMIT_0=4'b1111,//Verilog alternative for packed array construct in System Verilog
localparam [3:0] GPIO_PERMIT_1=4'b1111,
localparam [3:0] GPIO_PERMIT_2=4'b1111,
localparam [3:0] GPIO_PERMIT_3=4'b0001,
localparam [3:0] GPIO_PERMIT_4=4'b1111,
localparam [3:0] GPIO_PERMIT_5=4'b1111,
localparam [3:0] GPIO_PERMIT_6=4'b1111,
localparam [3:0] GPIO_PERMIT_7=4'b1111,
localparam [3:0] GPIO_PERMIT_8=4'b1111,
localparam [3:0] GPIO_PERMIT_9=4'b1111,
localparam [3:0] GPIO_PERMIT_10=4'b1111,
localparam [3:0] GPIO_PERMIT_11=4'b1111,
localparam [3:0] GPIO_PERMIT_12=4'b1111,
localparam [3:0] GPIO_PERMIT_13=4'b1111,
localparam [3:0] GPIO_PERMIT_14=4'b1111,
localparam [3:0] GPIO_PERMIT_15=4'b1111,
localparam [3:0] GPIO_PERMIT_16=4'b0001,
localparam [3:0] GPIO_PERMIT_17=4'b1111)

 



(

input wire clk_i,
input wire rst_ni,

output reg[31:0] gpio_reg2hw_intr_state_reg_q,
 
output reg[31:0] gpio_reg2hw_intr_enable_reg_q,

output reg[31:0] gpio_reg2hw_intr_test_reg_q,
output reg gpio_reg2hw_intr_test_reg_qe,

output reg gpio_reg2hw_alert_test_reg_q,
output reg gpio_reg2hw_alert_test_reg_qe,

output reg[31:0] gpio_reg2hw_direct_out_reg_q,
output reg gpio_reg2hw_direct_out_reg_qe,

output reg [15:0] gpio_reg2hw_masked_out_lower_reg_mask_q,
output reg gpio_reg2hw_masked_out_lower_reg_mask_qe,

output reg [15:0] gpio_reg2hw_masked_out_lower_reg_data_q,
output reg gpio_reg2hw_masked_out_lower_reg_data_qe,

output reg [15:0] gpio_reg2hw_masked_out_upper_reg_mask_q,
output reg gpio_reg2hw_masked_out_upper_reg_mask_qe,

output reg [15:0] gpio_reg2hw_masked_out_upper_reg_data_q,
output reg gpio_reg2hw_masked_out_upper_reg_data_qe,

output reg [31:0] gpio_reg2hw_direct_oe_reg_q,
output reg [31:0] gpio_reg2hw_direct_oe_reg_qe,

output reg [15:0] gpio_reg2hw_masked_oe_lower_reg_mask_q,
output reg gpio_reg2hw_masked_oe_lower_reg_mask_qe,

output reg [15:0] gpio_reg2hw_masked_oe_lower_reg_data_q,
output reg gpio_reg2hw_masked_oe_lower_reg_data_qe,

output reg [15:0] gpio_reg2hw_masked_oe_upper_reg_mask_q,
output reg gpio_reg2hw_masked_oe_upper_reg_mask_qe,

output reg [15:0] gpio_reg2hw_masked_oe_upper_reg_data_q,
output reg gpio_reg2hw_masked_oe_upper_reg_data_qe,

output reg [31:0] gpio_reg2hw_intr_ctrl_en_rising_reg_q,// Interrupt Logic

output reg [31:0] gpio_reg2hw_intr_ctrl_en_falling_reg_q,// Interrupt Logic

output reg [31:0] gpio_reg2hw_intr_ctrl_en_lvlhigh_reg_q,// Interupt Logic

output reg [31:0] gpio_reg2hw_intr_ctrl_en_lvllow_reg_q,// Interupt Logic

output reg [31:0] gpio_reg2hw_ctrl_en_input_filter_reg_q,

output reg  gpio_reg2hw_straps_data_in_valid_reg_q,

output reg [31:0] gpio_reg2hw_straps_data_in_reg_q,
//
input wire[31:0] gpio_hw2reg_intr_state_reg_d, 
input wire gpio_hw2reg_intr_state_reg_de,

input wire[31:0] gpio_hw2reg_data_in_reg_d,
input wire gpio_hw2reg_data_in_reg_de,
input wire[31:0] gpio_hw2reg_direct_out_reg_d,
input wire[15:0] gpio_hw2reg_masked_out_lower_reg_data_d, 
input wire[15:0] gpio_hw2reg_masked_out_lower_reg_mask_d,
input wire[15:0] gpio_hw2reg_masked_out_upper_reg_data_d,
input wire[15:0] gpio_hw2reg_masked_out_upper_reg_mask_d,
input wire[31:0] gpio_hw2reg_direct_oe_reg_d,
input wire[15:0] gpio_hw2reg_masked_oe_lower_reg_data_d,
input wire[15:0] gpio_hw2reg_masked_oe_lower_reg_mask_d,
input wire[15:0] gpio_hw2reg_masked_oe_upper_reg_data_d,
input wire[15:0] gpio_hw2reg_masked_oe_upper_reg_mask_d,
input wire gpio_hw2reg_straps_data_in_valid_reg_d,
input wire gpio_hw2reg_straps_data_in_valid_reg_de,
input wire[31:0] gpio_hw2reg_straps_data_in_reg_d,
input wire gpio_hw2reg_straps_data_in_reg_de

 );
 //  gpio_reg2hw_intr_state_reg_q<= intr_state;
      wire intr_enable;//  verilog alternative for Type def wires for assign
      wire intr_test;
      wire  alert_test;
      wire direct_out;
      wire masked_out_lower;
      wire masked_out_upper;
      wire masked_oe_lower;
      wire masked_oe_upper;
      wire intr_ctrl_en_rising;// Interrupt Logic
      wire intr_ctrl_en_falling;// Interrupt Logic
      wire intr_ctrl_en_lvlhigh;// Interupt Logic
      wire intr_ctrl_en_lvllow;// Interupt Logic
      wire ctrl_en_input_filter;
      wire hw_straps_data_in_valid;
      wire hw_straps_data_in;
      wire intr_state;
      wire data_in;
      wire  direct_oe;
      
      wire GPIO_INTR_STATE;// Verilog Alternative for Type def enum SV
      wire GPIO_INTR_ENABLE;
      wire GPIO_INTR_TEST;
      wire GPIO_ALERT_TEST;
      wire GPIO_DATA_IN;
      wire GPIO_DIRECT_OUT;
      wire GPIO_MASKED_OUT_LOWER;
      wire GPIO_MASKED_OUT_UPPER;
      wire GPIO_DIRECT_OE;
      wire GPIO_MASKED_oe_LOWER;
      wire GPIO_MASKED_oe_UPPER;
      wire GPIO_INTR_CTRL_EN_RISING;// Interrupt Logic
      wire GPIO_INTR_CTRL_EN_FALLING;// Interrupt Logic
      wire GPIO_INTR_CTRL_EN_LVLHIGH;// Interupt Logic
      wire GPIO_INTR_CTRL_EN_LVLLOW;// Interupt Logic
      wire GPIO_CTRL_EN_INPUT_FILTER;
      wire GPIO_HW_STRAPS_DATA_IN_VALID;
      wire GPIO_HW_STRAPS_DATA_IN;
   
  always@(posedge clk_i or negedge rst_ni) begin
   if(!rst_ni) begin
     gpio_reg2hw_intr_state_reg_q<= 32'b0;
 
     gpio_reg2hw_intr_enable_reg_q<= 32'b0;

     gpio_reg2hw_intr_test_reg_q<= 32'b0;
     gpio_reg2hw_intr_test_reg_qe<=1'b0;

     gpio_reg2hw_alert_test_reg_q<=1'b0;
     gpio_reg2hw_alert_test_reg_qe<=1'b0;

     gpio_reg2hw_direct_out_reg_q<= 32'b0;
     gpio_reg2hw_direct_out_reg_qe<=1'b0;

     gpio_reg2hw_masked_out_lower_reg_mask_q<=16'b0;
     gpio_reg2hw_masked_out_lower_reg_mask_qe<=1'b0;

     gpio_reg2hw_masked_out_lower_reg_data_q<=16'b0;
     gpio_reg2hw_masked_out_lower_reg_data_qe<=1'b0;

     gpio_reg2hw_masked_out_upper_reg_mask_q<=16'b0;
     gpio_reg2hw_masked_out_upper_reg_mask_qe<=1'b0;

     gpio_reg2hw_masked_out_upper_reg_data_q<=16'b0;
     gpio_reg2hw_masked_out_upper_reg_data_qe<=1'b0;

     gpio_reg2hw_direct_oe_reg_q<= 32'b0;
     gpio_reg2hw_direct_oe_reg_qe<= 32'b0;
 
     gpio_reg2hw_masked_oe_lower_reg_mask_q<=16'b0;
     gpio_reg2hw_masked_oe_lower_reg_mask_qe<=1'b0;

     gpio_reg2hw_masked_oe_lower_reg_data_q<=16'b0;
     gpio_reg2hw_masked_oe_lower_reg_data_qe<=1'b0;
 
     gpio_reg2hw_masked_oe_upper_reg_mask_q<=16'b0;
     gpio_reg2hw_masked_oe_upper_reg_mask_qe<=1'b0;

     gpio_reg2hw_masked_oe_upper_reg_data_q<=16'b0;
     gpio_reg2hw_masked_oe_upper_reg_data_qe<=1'b0;

     gpio_reg2hw_intr_ctrl_en_rising_reg_q<= 32'b0;// Interrupt Logic

     gpio_reg2hw_intr_ctrl_en_falling_reg_q<= 32'b0;// Interrupt Logic

     gpio_reg2hw_intr_ctrl_en_lvlhigh_reg_q<= 32'b0;// Interupt Logic

     gpio_reg2hw_intr_ctrl_en_lvllow_reg_q<= 32'b0;// Interupt Logic

     gpio_reg2hw_ctrl_en_input_filter_reg_q<= 32'b0;

     gpio_reg2hw_straps_data_in_valid_reg_q<=1'b0;

     gpio_reg2hw_straps_data_in_reg_q<= 32'b0;
     
     //
     
     
     end
    else begin
      gpio_reg2hw_intr_state_reg_q<= intr_state;
 
      gpio_reg2hw_intr_enable_reg_q<=intr_enable;

      gpio_reg2hw_intr_test_reg_q<= intr_test;
      gpio_reg2hw_intr_test_reg_qe<=1'b1;

      gpio_reg2hw_alert_test_reg_q<= alert_test;
      gpio_reg2hw_alert_test_reg_qe<=1'b1;

      gpio_reg2hw_direct_out_reg_q<= direct_out;
      gpio_reg2hw_direct_out_reg_qe<=1'b1;

      gpio_reg2hw_masked_out_lower_reg_mask_q<=16'b0;
      gpio_reg2hw_masked_out_lower_reg_mask_qe<=1'b1;

      gpio_reg2hw_masked_out_lower_reg_data_q<=masked_out_lower;
      gpio_reg2hw_masked_out_lower_reg_data_qe<=1'b1;

      gpio_reg2hw_masked_out_upper_reg_mask_q<=16'b0;
      gpio_reg2hw_masked_out_upper_reg_mask_qe<=1'b1;

      gpio_reg2hw_masked_out_upper_reg_data_q<=masked_out_upper;
      gpio_reg2hw_masked_out_upper_reg_data_qe<=1'b0;

      gpio_reg2hw_direct_oe_reg_q<= 32'b0;
      gpio_reg2hw_direct_oe_reg_qe<= 32'b0;
 
      gpio_reg2hw_masked_oe_lower_reg_mask_q<=16'b0;
      gpio_reg2hw_masked_oe_lower_reg_mask_qe<=1'b1;

      gpio_reg2hw_masked_oe_lower_reg_data_q<=masked_oe_lower;
      gpio_reg2hw_masked_oe_lower_reg_data_qe<=1'b1;
 
      gpio_reg2hw_masked_oe_upper_reg_mask_q<=16'b0;
      gpio_reg2hw_masked_oe_upper_reg_mask_qe<=1'b1;

      gpio_reg2hw_masked_oe_upper_reg_data_q<=masked_oe_upper;
      gpio_reg2hw_masked_oe_upper_reg_data_qe<=1'b1;

      gpio_reg2hw_intr_ctrl_en_rising_reg_q<= intr_ctrl_en_rising;// Interrupt Logic

      gpio_reg2hw_intr_ctrl_en_falling_reg_q<= intr_ctrl_en_falling;// Interrupt Logic

      gpio_reg2hw_intr_ctrl_en_lvlhigh_reg_q<= intr_ctrl_en_lvlhigh;// Interupt Logic

      gpio_reg2hw_intr_ctrl_en_lvllow_reg_q<= intr_ctrl_en_lvllow;// Interupt Logic

      gpio_reg2hw_ctrl_en_input_filter_reg_q<= ctrl_en_input_filter;

      gpio_reg2hw_straps_data_in_valid_reg_q<=hw_straps_data_in_valid;

      gpio_reg2hw_straps_data_in_reg_q<=hw_straps_data_in;end
      end
      
      //
     assign gpio_hw2reg_intr_state_reg_d =(rst_ni)?intr_state :32'b0;
     assign gpio_hw2reg_intr_state_reg_de= 1'b1;

     assign gpio_hw2reg_data_in_reg_d=(rst_ni)? data_in :32'b0;
     assign gpio_hw2reg_data_in_reg_de= 1'b1;

     assign gpio_hw2reg_direct_out_reg_d=(rst_ni)? direct_out :32'b0;

     assign gpio_hw2reg_masked_out_lower_reg_data_d=(rst_ni)?masked_out_lower:16'b0;
     assign gpio_hw2reg_masked_out_lower_reg_mask_d = 16'b0;

     assign gpio_hw2reg_masked_out_upper_reg_data_d=(rst_ni)?masked_out_upper:16'b0;
     assign gpio_hw2reg_masked_out_upper_reg_mask_d =16'b0;

     assign gpio_hw2reg_direct_oe_reg_d=(rst_ni)? direct_oe :32'b0;

      assign gpio_hw2reg_masked_oe_lower_reg_data_d=(rst_ni)?masked_oe_lower: 16'b0;
      assign gpio_hw2reg_masked_oe_lower_reg_mask_d = 16'b0;

      assign gpio_hw2reg_masked_oe_upper_reg_data_d=(rst_ni)?masked_oe_upper: 16'b0;
      assign gpio_hw2reg_masked_oe_upper_reg_mask_d =16'b0;

      assign gpio_hw2reg_straps_data_in_valid_reg_d=(rst_ni)?hw_straps_data_in_valid: 1'b0;
      assign gpio_hw2reg_straps_data_in_valid_reg_de=1'b1;

      assign gpio_hw2reg_straps_data_in_reg_d=(rst_ni)?hw_straps_data_in: 32'b0;
      assign gpio_hw2reg_straps_data_in_reg_de=1'b1;
      



      
endmodule











