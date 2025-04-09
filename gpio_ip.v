`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 09:45:38 AM
// Design Name: 
// Module Name: gpio_ip
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
`include "/home/rahul/arails/ts40peripherals24a/ts40_p240/rahulp40a/gpio_reg.vh"
`include "/home/rahul/arails/ts40peripherals24a/ts40_p240/rahulp40a/prim_intr_hw"
//`include "/home/rahul/arails/ts40peripherals24a/ts40_p240/rahulp40a/prim_alert_sender"
`include "/home/rahul/arails/ts40peripherals24a/ts40_p240/rahulp40a/gpio_reg_top"
//`include "/home/rahul/arails/ts40peripherals24a/ts40_p240/rahulp40a/prim_filter_ctr"
module gpio_ip#(parameter NumRegs=18,
parameter NumIOs=32,
parameter NumInpPeriodCounters=0,
parameter NumAlerts=1,
parameter [NumAlerts-1:0] AlertAsyncOn= {NumAlerts{1'b1}},
parameter GpioAsHwStrapsEn          = 1,
parameter GpioAsyncOn               = 1,
)

       (input  clk_i,  // Clock
        input  rst_ni, // Reset (active-low)
        input strap_en_i,
        input   [NumAlerts-1:0] alert_rx_i,
        input [NumIOs-1:0] cio_gpio_i,
        input   [31:0] reg2hw_direct_out_q,
        input reg2hw_direct_out_qe,
        input [15:0] reg2hw_masked_out_lower_mask_q,
        input  reg2hw_masked_out_lower_mask_qe,
        input [15:0]reg2hw_masked_out_lower_data_q,
        input  reg2hw_masked_out_lower_data_qe,
        input [15:0] reg2hw_masked_out_upper_mask_q,
        input  reg2hw_masked_out_upper_mask_qe,
        input [15:0] reg2hw_masked_out_upper_data_q,
        input  reg2hw_masked_out_upper_data_qe,
        input [31:0] reg2hw_direct_oe_q,
        input  reg2hw_direct_oe_qe,
        input [15:0] reg2hw_masked_oe_lower_mask_q,
        input reg2hw_masked_oe_lower_mask_qe,
        input [15:0] reg2hw_masked_oe_lower_data_q,
        input reg2hw_masked_oe_lower_data_qe,
        input reg2hw_masked_oe_upper_mask_qe,
        input [15:0]reg2hw_masked_oe_upper_mask_q,
        input [15:0] reg2hw_masked_oe_upper_data_q,
        input  reg2hw_masked_oe_upper_data_qe,
        input [31:0] data_in_d,
        //
        
        input reg2hw_intr_enable_qe,
        input [NumIOs-1:0] reg2hw_intr_enable_q,
        input reg2hw_intr_test_qe,
        input [NumIOs-1:0]reg2hw_intr_test_q,
        input [NumIOs-1:0]reg2hw_intr_state_q,
        input [NumIOs-1:0] reg2hw_intr_ctrl_en_rising_q,
        input [NumIOs-1:0]reg2hw_intr_ctrl_en_falling_q,
        input [NumIOs-1:0] reg2hw_intr_ctrl_en_lvlhigh_q,
        input [NumIOs-1:0] reg2hw_intr_ctrl_en_lvllow_q,

        output wire [NumIOs-1:0] hw2reg_intr_state_d,
        output wire hw2reg_intr_state_de,
        output wire [NumIOs-1:0] intr_gpio_o,
        

        output wire [31:0] hw2reg_data_in_d,
        output wire hw2reg_data_in_de,
        output wire [31:0] hw2reg_direct_out_d,
        output wire [15:0] hw2reg_masked_out_lower_data_d,
        output wire [15:0] hw2reg_masked_out_upper_data_d,
        output wire [31:0] hw2reg_direct_oe_d,
        output wire [15:0] hw2reg_masked_oe_lower_data_d,
        output wire [15:0] hw2reg_masked_oe_upper_data_d,
        
        //
        output wire  [NumIOs-1:0] cio_gpio_o,
        output  [NumIOs-1:0] cio_gpio_en_o,
        output  sampled_straps_o,
      
        output  [NumAlerts-1:0] alert_tx_o);
        reg [31:0] cio_gpio_q;
        reg [31:0] cio_gpio_en_q;
    
 

         wire        gpio_valid;
         wire [31:0] gpio_data;
         wire sampled_straps_o_data;
         wire sampled_straps_o_valid;


        /*reg[31:0] reg2hw_intr_state__q;
        reg reg2hw_intr_enable_qe;
        reg[31:0] reg2hw_intr_enable_q;
        reg[31:0] reg2hw_intr_test_q;*/
        //reg reg2hw_intr_test_qe;
        reg reg2hw_alert_test_q;
        reg reg2hw_alert_test_qe;
        /*reg[31:0] reg2hw_direct_out_q;
        reg reg2hw_direct_out_qe;
        reg[15:0] reg2hw_masked_out_lower_mask_q;
        reg reg2hw_masked_out_lower_mask_qe;
        reg[15:0]reg2hw_masked_out_lower_data_q;
        reg reg2hw_masked_out_lower_data_qe;
        reg[15:0] reg2hw_masked_out_upper_mask_q;
        reg reg2hw_masked_out_upper_mask_qe;
        reg[15:0] reg2hw_masked_out_upper_data_q;
        reg reg2hw_masked_out_upper_data_qe;
        reg[31:0] reg2hw_direct_oe_q;
        reg reg2hw_direct_oe_qe;
        reg[15:0] reg2hw_masked_oe_lower_mask_q;
        reg reg2hw_masked_oe_lower_mask_qe;
        reg[15:0] reg2hw_masked_oe_lower_data_q;
        reg reg2hw_masked_oe_lower_data_qe;
        reg reg2hw_masked_oe_upper_mask_qe;
        reg [15:0]reg2hw_masked_oe_upper_mask_q;
        reg [15:0] reg2hw_masked_oe_upper_data_q;
        reg reg2hw_masked_oe_upper_data_qe; */
      
        reg [31:0]reg2hw_ctrl_en_input_filter_q;
        reg reg2hw_hw_straps_data_in_valid_q;
        reg [31:0] reg2hw_hw_straps_data_in_q;

        reg reg2hw_straps_data_in_valid_q;

       
        wire [15:0] hw2reg_masked_out_lower_mask_d;
        wire [15:0] hw2reg_masked_out_upper_mask_d;
        wire [15:0] hw2reg_masked_oe_lower_mask_d;
        wire [15:0] hw2reg_masked_oe_upper_mask_d;
        wire  hw2reg_hw_straps_data_in_valid_d;
        wire  hw2reg_hw_straps_data_in_valid_de;
        wire [31:0] hw2reg_hw_straps_data_in_d;
        wire hw2reg_hw_straps_data_in_de;

       

// GPIO Output LogiC
assign cio_gpio_o=cio_gpio_q;
assign cio_gpio_en_o=cio_gpio_en_q;
assign hw2reg_direct_out_d= cio_gpio_q;
assign hw2reg_masked_out_upper_data_d=cio_gpio_q[31:16];
assign hw2reg_masked_out_lower_data_d=cio_gpio_q[15:0];
assign hw2reg_masked_out_upper_mask_d=16'b0;
assign hw2reg_masked_out_lower_mask_d=16'b0;

always@(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        cio_gpio_q <= 32'b0;
    end else if (reg2hw_direct_out_qe) begin
        cio_gpio_q <= reg2hw_direct_out_q;
    end else if (reg2hw_masked_out_upper_data_qe) begin
        cio_gpio_q[31:16] <= (cio_gpio_q[31:16] & ~reg2hw_masked_out_upper_mask_q) |
                             (reg2hw_masked_out_upper_mask_q & reg2hw_masked_out_upper_data_q);
    end else if (reg2hw_masked_out_lower_data_qe) begin
        cio_gpio_q[15:0] <= (cio_gpio_q[15:0] & ~reg2hw_masked_out_lower_mask_q) |
                            (reg2hw_masked_out_lower_mask_q & reg2hw_masked_out_lower_data_q);
    end
end

// GPIO Enable Logic
assign hw2reg_direct_oe_d=cio_gpio_en_q;
assign hw2reg_masked_oe_upper_mask_d=16'b0;
assign hw2reg_masked_oe_lower_mask_d=16'b0;
assign hw2reg_masked_oe_upper_data_d=cio_gpio_en_q[31:16];
assign hw2reg_masked_oe_lower_data_d=cio_gpio_en_q[15:0];
//
always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        cio_gpio_en_q <= 32'b0;
    end else if (reg2hw_direct_oe_q) begin
        cio_gpio_en_q <= reg2hw_direct_oe_q;
    end else if (reg2hw_masked_oe_upper_data_qe) begin
        cio_gpio_en_q[31:16] <= (cio_gpio_en_q[31:16] & ~reg2hw_masked_oe_upper_mask_q) |
                                (reg2hw_masked_oe_upper_mask_q & reg2hw_masked_oe_upper_data_q);
    end else if (reg2hw_masked_oe_lower_data_qe) begin
        cio_gpio_en_q[15:0] <= (cio_gpio_en_q[15:0] & ~reg2hw_masked_oe_lower_mask_q) |
                               (reg2hw_masked_oe_lower_mask_q & reg2hw_masked_oe_lower_data_q);
    end
end

//GPIO_IN
assign hw2reg_data_in_de=1'b1;


// Filter Instatiation

 //wire [NumIOs-1:0] data_in_d;
  //localparam CntWidth = 4;
 // for (genvar i = 0 ; i < NumIOs ; i=i+1) begin 
    /*prim_filter_ctr #(
      .AsyncOn(GpioAsyncOn),
      .CntWidth(CntWidth)
    ) u_filter (
      .clk_i,
      .rst_ni,
      .enable_i(reg2hw_ctrl_en_input_filter_q[i]),
      .filter_i(cio_gpio_i[i]),
      .thresh_i({CntWidth{1'b1}}),
      .filter_o(data_in_d[i])
    );*/
 // end
 

if(GpioAsHwStrapsEn) begin: gen_strap_sample
 // Sample at gpio inputs at strap_en_i signal pulse
 wire strap_en;
 assign strap_en=strap_en_i;
 // We guarantee here by design that this will always be done exactly once per reset cycle.
 wire sample_trigger;

 assign sample_trigger= strap_en && !reg2hw_straps_data_in_valid_q;
 assign hw2reg_hw_straps_data_in_valid_de= sample_trigger;
 assign hw2reg_hw_straps_data_in_valid_d= 1'b1;
 assign hw2reg_hw_straps_data_in_de= sample_trigger;
 assign hw2reg_hw_straps_data_in_d= data_in_d;
 assign sampled_straps_o_data= reg2hw_hw_straps_data_in_q;
 assign sampled_straps_o_valid=reg2hw_hw_straps_data_in_valid_q;
end else begin:gen_no_strap_sample
 assign hw2reg_hw_straps_data_in_valid_de= 1'b0;
 assign hw2reg_hw_straps_data_in_valid_d= 1'b0;
 assign hw2reg_hw_straps_data_in_de= 1'b0;
 assign hw2reg_hw_straps_data_in_d= '0;
 assign sampled_straps_o_data= '0;
 assign sampled_straps_o_valid=1'b0;
 wire unused_signals;
 assign unused_signals=^{strap_en_i,reg2hw_hw_straps_data_in_q,reg2hw_hw_straps_data_in_valid_q};
end
/*
  gpio_reg_top u_reg (
    .clk_i,
    .rst_ni,
   .reg2hw_intr_state_q,
   .reg2hw_intr_enable_qe,
   .reg2hw_intr_enable_q,
   .reg2hw_intr_test_q,
   .reg2hw_intr_test_qe,
   .reg2hw_alert_test_q,
   .reg2hw_alert_test_qe,
   .reg2hw_direct_out_q,
   .reg2hw_direct_out_qe,
   .reg2hw_masked_out_lower_data_q,
   .reg2hw_masked_out_lower_data_qe,
   .reg2hw_masked_out_lower_mask_q,
   .reg2hw_masked_out_lower_mask_qe,
   .reg2hw_masked_out_upper_data_q,
   .reg2hw_masked_out_upper_data_qe,
   .reg2hw_masked_out_upper_mask_q,
   .reg2hw_masked_out_upper_mask_qe,
   .reg2hw_direct_oe_qe,
   .reg2hw_direct_oe_q,
   .reg2hw_masked_oe_lower_data_q,
   .reg2hw_masked_oe_lower_data_qe,
   .reg2hw_masked_oe_lower_mask_q,
   .reg2hw_masked_oe_lower_mask_qe,
   .reg2hw_masked_oe_upper_data_q,
   .reg2hw_masked_oe_upper_data_qe,
   .reg2hw_masked_oe_upper_mask_q,
   .reg2hw_masked_oe_upper_mask_qe,
   .reg2hw_intr_ctrl_en_rising_q,
   .reg2hw_intr_ctrl_en_falling_q,
   .reg2hw_intr_ctrl_en_lvlhigh_q,
   .reg2hw_intr_ctrl_en_lvllow_q,
   .reg2hw_ctrl_en_input_filter_q,
   .reg2hw_hw_straps_data_in_valid_q,
   .reg2hw_hw_straps_data_in_q,
// input
  .hw2reg_intr_state_de,
  .hw2reg_intr_state_d,
  .hw2reg_data_in_de,
  .hw2reg_data_in_d,
  .hw2reg_direct_out_d,
  .hw2reg_masked_out_lower_data_d,
  .hw2reg_masked_out_lower_mask_d,
  .hw2reg_masked_out_upper_data_d,
  .hw2reg_masked_out_upper_mask_d,
  .hw2reg_direct_oe_d,
  .hw2reg_masked_oe_lower_data_d,
  .hw2reg_masked_oe_lower_mask_d,
  .hw2reg_masked_oe_upper_data_d,
  .hw2reg_masked_oe_upper_mask_d,
  .hw2reg_hw_straps_data_in_valid_de,
  .hw2reg_hw_straps_data_in_valid_d,
  .hw2reg_hw_straps_data_in_de,
  .hw2reg_hw_straps_data_in_d,
 
   

    // SEC_CM: BUS.INTEGRITY
    .intg_err_o (alerts[0])
  );
*/
// Alert Sender
wire [NumAlerts-1:0] alert_test, alerts;
  assign alert_test = 
    reg2hw_alert_test_q &
    reg2hw_alert_test_qe;

  //for (genvar i = 0; i < NumAlerts; i=i+1) begin : gen_alert_tx
     /*prim_alert_sender #(
      .AsyncOn(AlertAsyncOn[i]),
      .IsFatal(1'b1)
    ) u_prim_alert_sender (
      .clk_i,
      .rst_ni,
      .alert_test_i  ( alert_test[i] ),
      .alert_req_i   ( alerts[0]     ),
      .alert_ack_o   (               ),
      .alert_state_o (               ),
      .alert_rx_i    ( alert_rx_i[i] ),
      .alert_tx_o    ( alert_tx_o[i] )
    );*/
  //end



/*Instantiate intrerrupt hardware primitive
prim_intr_hw # (.Width(NumIOs)) intr_hw(
.event_intr_i(event_intr_combined),
.reg2hw_intr_enable_qe_i(reg2hw_intr_enable_qe),
.reg2hw_intr_enable_q_i(reg2hw_intr_enable_q),
.reg2hw_intr_test_qe_i(reg2hw_intr_test_qe),
.reg2hw_intr_test_q_i(reg2hw_intr_test_q),
.reg2hw_intr_state_q_i(reg2hw_intr_state_q),
.hw2reg_intr_state_de_o(hw2reg_intr_state_de),
.hw2reg_intr_state_d_o(hw2reg_intr_state_d),
.intr_o(intr_gpio_o)
);
*/
assign hw2reg_data_in_d= data_in_d;
reg [Width-1:0] data_in_q;
wire event_rise,event_fall;

always@(posedge clk_i or negedge rst_ni) begin
 if(!rst_ni) begin
   data_in_q <= 0;end
 else begin
   data_in_q <= data_in_d;end
end

assign event_rise=data_in_d & ~data_in_q;
assign event_fall=~data_in_d & data_in_q;

wire [Width-1:0] event_intr_rise,event_intr_fall,event_intr_acthigh,event_intr_actlow;
wire [Width-1:0]event_intr_combined;
assign event_intr_rise=event_rise & reg2hw_intr_ctrl_en_rising_q;
assign event_intr_fall=event_fall & reg2hw_intr_ctrl_en_falling_q;
assign event_intr_acthigh= data_in_d & reg2hw_intr_ctrl_en_lvlhigh_q;
assign event_intr_actlow= ~data_in_d & reg2hw_intr_ctrl_en_lvllow_q;

assign event_intr_combined=event_intr_rise|event_intr_fall|event_intr_acthigh|event_intr_actlow;
assign event_intr_i= event_intr_combined;


endmodule





 



