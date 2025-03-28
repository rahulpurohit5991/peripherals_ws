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
`include "gpio_reg.vh"
module gpio_ip #(parameter NumRegs=18,
parameter NumIOs=32,
parameter NumInpPeriodCounters=0,
parameter NumAlerts=1,
parameter [NumAlerts-1:0] AlertAsyncOn= {NumAlerts{1'b1}},
parameter GpioAsHwStrapsEn          = 1,
parameter GpioAsyncOn               = 1)

    (input  clk_i,  // Clock
    input  rst_ni, // Reset (active-low)
    input strap_en_i,
    output  sampled_straps_o,
    output wire [NumIOs-1:0] intr_gpio_o,
    input   [NumAlerts-1:0] alert_rx_i,
    output  [NumAlerts-1:0] alert_tx_o,

  // GPIOs
    input        [NumIOs-1:0] cio_gpio_i,
    output wire  [NumIOs-1:0] cio_gpio_o,
    output  [NumIOs-1:0] cio_gpio_en_o,

    // GPIO Outputs
    output reg [31:0] cio_gpio_q,
    output reg [31:0] cio_gpio_en_q);
    
 

  wire        gpio_valid;
  wire [31:0] gpio_data;
  wire sampled_straps_o_data;
  wire sampled_straps_o_valid;


        reg[31:0] reg2hw_intr_state__q;
        reg reg2hw_intr_enable_qe;
        reg[31:0] reg2hw_intr_enable_q;
        reg[31:0] reg2hw_intr_test_q;
        reg reg2hw_intr_test_qe;
        reg reg2hw_alert_test_q;
        reg reg2hw_alert_test_qe;
        reg[31:0] reg2hw_direct_out_q;
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
        reg reg2hw_masked_oe_upper_data_qe;
        reg[31:0] reg2hw_intr_ctrl_en_rising_q;
        reg [31:0]reg2hw_intr_ctrl_en_falling_q;
        reg[31:0] reg2hw_intr_ctrl_en_lvlhigh_q;
        reg[31:0] reg2hw_intr_ctrl_en_lvllow_q;
        reg [31:0]reg2hw_ctrl_en_input_filter_q;
        reg reg2hw_hw_straps_data_in_valid_q;
        reg [31:0] reg2hw_hw_straps_data_in_q;

        
        wire [31:0] hw2reg_intr_state_d;
        wire hw2reg_intr_state_de;
        wire [31:0] hw2reg_data_in_d;
        wire hw2reg_data_in_de;
        wire [31:0] hw2reg_direct_out_d;
        wire [15:0] hw2reg_masked_out_lower_data_d;
        wire [15:0] hw2reg_masked_out_lower_mask_d;
        wire [15:0] hw2reg_masked_out_upper_data_d;
        wire [15:0] hw2reg_masked_out_upper_mask_d;
        wire [31:0] hw2reg_direct_oe_d;
        wire [15:0] hw2reg_masked_oe_lower_data_d;
        wire [15:0] hw2reg_masked_oe_lower_mask_d;
        wire [15:0] hw2reg_masked_oe_upper_data_d;
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
assign hw2reg_data_in_d= data_in_d;
reg [NumIOs-1:0] data_in_q,event_rise,event_fall;
always@(*) begin
 data_in_q <= data_in_d;end
assign event_rise=data_in_d & ~data_in_q;
assign event_fall=~data_in_d & data_in_q;

// Filter Instatiation

 wire [NumIOs-1:0] data_in_d;
  localparam CntWidth = 4;
  for (genvar i = 0 ; i < NumIOs ; i=i+1) begin 
    prim_filter_ctr #(
      .AsyncOn(GpioAsyncOn),
      .CntWidth(CntWidth)
    ) u_filter (
      .clk_i,
      .rst_ni,
      .enable_i(reg2hw_ctrl_en_input_filter_q[i]),
      .filter_i(cio_gpio_i[i]),
      .thresh_i({CntWidth{1'b1}}),
      .filter_o(data_in_d[i])
    );
  end
 

if(GpioAsHwStrapsEn) begin: gen_strap_sample
 // Sample at gpio inputs at strap_en_i signal pulse
 wire strap_en;
 assign strap_en=strap_en_i;
 // We guarantee here by design that this will always be done exactly once per reset cycle.
 wire sample_trigger;

 assign sample_trigger=(strap_en && (!reg2hw_straps_data_in_valid_q));
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

// Alert Sender
wire [NumAlerts-1:0] alert_test, alerts;
  assign alert_test = 
    reg2hw_alert_test_q &
    reg2hw_alert_test_qe;

  for (genvar i = 0; i < NumAlerts; i=i+1) begin : gen_alert_tx
    prim_alert_sender #(
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
    );
  end



//Instantiate intrerrupt hardware primitive
prim_intr_hw # (.Width(16)) intr_hw(
.event_intr_i(event_intr_combined),
.reg2hw_intr_enable_qe_i(reg2hw_intr_enable_qe),
.reg2hw_intr_enable_q_i(reg2hw_intr_enable_q),
.reg2hw_intr_test_qe_i(reg2hw_intr_test_qe),
.reg2hw_intr_test_q_i(reg2hw_intr_test_q),
.reg2hw_intr_state_q_i(reg2hw_intr_state_q),
.hw2reg__intr_state_de_o(hw2reg_intr_state_de),
.hw2reg__intr_state_d_o(hw2reg_intr_state_d),
.intr_o(intr_gpio_o)
);
wire[NumIOs-1:0] event_intr_rise,event_intr_fall,event_intr_acthigh,event_intr_actlow;
wire [NumIOs-1:0]event_intr_combined;
assign event_intr_rise=event_rise & reg2hw_intr_ctrl_en_rising_q;
assign event_intr_fall=event_fall & reg2hw_intr_ctrl_en_falling_q;
assign event_intr_acthigh= data_in_d & reg2hw_intr_ctrl_en_lvlhigh_q;
assign event_intr_actlow= ~data_in_d & reg2hw_intr_ctrl_en_lvllow_q;

assign event_intr_combined=event_intr_rise|event_intr_fall|event_intr_acthigh|event_intr_actlow;


endmodule

// Module for Interrupt to instantiate to the top module
module prim_intr_hw #(
parameter Width=1,parameter FlopOutput=1,parameter IntrT = " Event ")
(
// Event
input clk_i,
input rst_ni,
input[Width-1:0]event_intr_i,
// Register Interface
input reg2hw_intr_enable_qe_i,
input[Width-1:0]reg2hw_intr_enable_q_i,
input reg2hw_intr_test_qe_i,
input[Width-1:0]reg2hw_intr_test_q_i,
input[Width-1:0]reg2hw_intr_state_q_i,
output  hw2reg_intr_state_de_o,
output [Width-1:0] hw2reg_intr_state_d_o,
// Outgoing Interrupt
output  [Width-1:0] intr_o);
wire[Width-1:0] status;
if(IntrT== " Event ") begin: g_intr_event
 wire[Width-1:0] new_event;
 assign new_event=(({Width{reg2hw_intr_test_qe_i}} & reg2hw_intr_test_q_i)|event_intr_i);
 assign hw2reg_intr_state_de_o=|new_event;
 assign hw2reg_intr_state_d_o=new_event|reg2hw_intr_state_q_i; 
 assign status= reg2hw_intr_state_q_i;
 end
else if( IntrT== " Status ") begin: g_intr_status
 reg[Width-1:0] test_q;
 always@(posedge clk_i or negedge rst_ni) begin
  if(!rst_ni)
   test_q<=0;
  else if(reg2hw_intr_test_qe_i) 
   test_q<=reg2hw_intr_test_q_i;
   end 
assign hw2reg__intr_state_de_o=1'b1;
assign hw2reg__intr_state_d_o= test_q| event_intr_i;
assign status= test_q| event_intr_i;
wire unused_reg2hw;
assign unused_reg2hw= ^ reg2hw_intr_state_q_i;
end
if(FlopOutput==1) begin: gen_flop_intr_output
  reg[Width-1:0] intr_o_reg;
 // Flop the interrupt output
 always@(posedge clk_i or negedge rst_ni) begin
  if(!rst_ni) begin
   intr_o_reg<= 'b0;end
  else begin
   intr_o_reg<= reg2hw_intr_enable_q_i & status;
   end
   end
   assign intr_o=intr_o_reg;
end else begin: gen_intr_passthrough_output
 wire unused_clk;
 wire unused_rst_n;
 assign unused_clk=clk_i;
 assign unused_rst_n= rst_ni;
 assign intr_o=reg2hw_intr_enable_q_i & reg2hw_intr_state_q_i;
 end
 endmodule


// Primitive counter-based input filter, with enable.
// Configurable number of cycles. Cheaper version of filter for
// large values of #Cycles
//
// when in reset, stored value is zero
// when enable is false, output is input
// when enable is true, output is stored value,
//   new input must be opposite value from stored value for
//   #Cycles before switching to new value.

module prim_filter_ctr #(
  // If this parameter is set, an additional 2-stage synchronizer will be
  // added at the input.
  parameter  AsyncOn = 0,
  parameter [31:0]  CntWidth = 2
) (
  input                clk_i,
  input                rst_ni,
  input                enable_i,
  input                filter_i,
  input [CntWidth-1:0] thresh_i,
  output reg         filter_o
);

  reg [CntWidth-1:0] diff_ctr_q; 
  wire diff_ctr_d;
  reg filter_q, stored_value_q;
  wire update_stored_value;

  wire filter_synced;

  if (AsyncOn) begin 
    // Run this through a 2 stage synchronizer to
    // prevent metastability.
    prim_flop_2sync #(
      .Width(1)
    ) prim_flop_2sync (
      .clk_i,
      .rst_ni,
      .d_i(filter_i),
      .q_o(filter_synced)
    );
  end else begin : gen_sync
    assign filter_synced = filter_i;
  end

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      filter_q <= 1'b0;
    end else begin
      filter_q <= filter_synced;
    end
  end

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      stored_value_q <= 1'b0;
    end else if (update_stored_value) begin
      stored_value_q <= filter_synced;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      diff_ctr_q <= '0;
    end else begin
      diff_ctr_q <= diff_ctr_d;
    end
  end

  // always look for differences, even if not filter enabled
  assign update_stored_value = (diff_ctr_d == thresh_i);
  assign diff_ctr_d = (filter_synced != filter_q) ? '0       :           // restart
                      (diff_ctr_q >= thresh_i)    ? thresh_i :           // saturate
                                                    (diff_ctr_q + 1'b1); // count up

  assign filter_o = enable_i ? stored_value_q : filter_synced;

endmodule


// 2 flop Synchronizers
module prim_flop_2sync #(
parameter Width=1)(
input wire clk_i,
input wire rst_ni,
input wire[Width-1:0] d_i,
output reg[Width-1:0] q_o);
reg [Width-1:0] sync_1;
reg [Width-1:0] sync_2;

always@(posedge clk_i or negedge rst_ni) begin
 if(!rst_ni) begin
  sync_1<= {Width{1'b0}};
  sync_2<= {Width{1'b0}};
  q_o<= {Width{1'b0}};
 end else begin
  sync_1<= d_i;
  sync_2<= sync_1;
  q_o<= sync_2;
 end
 end
endmodule

module prim_alert_sender
#(
  parameter alert_p=1'b0,
  parameter alert_n=1'b1,
  parameter [2:0] Idle= 3'b000,
  parameter [2:0] AlertHsPhase1=3'b001,
  parameter [2:0] AlertHsPhase2=3'b010,
  parameter [2:0] PingHsPhase1= 3'b011,
  parameter [2:0] PingHsPhase2= 3'b100,
  parameter [2:0] Pause0= 3'b101,
  parameter [2:0] Pause1= 3'b110,  

  // enables additional synchronization logic
  parameter  AsyncOn = 1'b1,
  // alert sender will latch the incoming alert event permanently and
  // keep on sending alert events until the next reset.
  parameter  IsFatal = 1'b0
) (
  input             clk_i,
  input             rst_ni,
  // alert test trigger (this will never be latched, even if IsFatal == 1)
  input             alert_test_i,
  // native alert from the peripheral
  input             alert_req_i,
  output logic      alert_ack_o,
  // state of the alert latching register
  output logic      alert_state_o,
  // ping input diff pair and ack diff pair
  input   alert_rx_i,
  // alert output diff pair
  output  alert_tx_o
);


  /////////////////////////////////
  // decode differential signals //
  /////////////////////////////////
  wire ping_sigint, ping_event, ping_n, ping_p;

  // This prevents further tool optimizations of the differential signal.
  prim_sec_anchor_buf #(
    .Width(2)
  ) u_prim_buf_ping (
    .in_i({alert_rx_i.ping_n,
           alert_rx_i.ping_p}),
    .out_o({ping_n,
            ping_p})
  );

  prim_diff_decode #(
    .AsyncOn(AsyncOn)
  ) u_decode_ping (
    .clk_i,
    .rst_ni,
    .diff_pi  ( ping_p      ),
    .diff_ni  ( ping_n      ),
    .level_o  (             ),
    .rise_o   (             ),
    .fall_o   (             ),
    .event_o  ( ping_event  ),
    .sigint_o ( ping_sigint )
  );

  wire ack_sigint, ack_level, ack_n, ack_p;

  // This prevents further tool optimizations of the differential signal.
  prim_sec_anchor_buf #(
    .Width(2)
  ) u_prim_buf_ack (
    .in_i({alert_rx_i.ack_n,
           alert_rx_i.ack_p}),
    .out_o({ack_n,
            ack_p})
  );

  prim_diff_decode #(
    .AsyncOn(AsyncOn)
  ) u_decode_ack (
    .clk_i,
    .rst_ni,
    .diff_pi  ( ack_p      ),
    .diff_ni  ( ack_n      ),
    .level_o  ( ack_level  ),
    .rise_o   (            ),
    .fall_o   (            ),
    .event_o  (            ),
    .sigint_o ( ack_sigint )
  );


  ///////////////////////////////////////////////////
  // main protocol FSM that drives the diff output //
  ///////////////////////////////////////////////////
  reg state_d, state_q;
  wire alert_pq, alert_nq; 
  reg alert_pd, alert_nd;
  wire sigint_detected;

  assign sigint_detected = ack_sigint | ping_sigint;


  // diff pair output
  assign alert_p = alert_pq;
  assign alert_n = alert_nq;

  // alert and ping set regs
  wire alert_set_d; 
  reg alert_set_q; 
  reg alert_clr;
  wire alert_test_set_d; 
  reg alert_test_set_q;
  wire ping_set_d;
  reg ping_set_q, ping_clr;
  wire alert_req_trigger; 
  wire alert_test_trigger, ping_trigger;

  // if handshake is ongoing, capture additional alert requests.
  wire alert_req;
  prim_sec_anchor_buf #(
    .Width(1)
  ) u_prim_buf_in_req (
    .in_i(alert_req_i),
    .out_o(alert_req)
  );

  assign alert_req_trigger = alert_req | alert_set_q;
  if (IsFatal) begin : gen_fatal
    assign alert_set_d = alert_req_trigger;
  end else begin : gen_recov
    assign alert_set_d = (alert_clr) ? 1'b0 : alert_req_trigger;
  end

  // the alert test request is always cleared.
  assign alert_test_trigger = alert_test_i | alert_test_set_q;
  assign alert_test_set_d = (alert_clr) ? 1'b0 : alert_test_trigger;

  wire alert_trigger;
  assign alert_trigger = alert_req_trigger | alert_test_trigger;

  assign ping_trigger = ping_set_q | ping_event;
  assign ping_set_d  = (ping_clr) ? 1'b0 : ping_trigger;


  // alert event acknowledge and state (not affected by alert_test_i)
  assign alert_ack_o = alert_clr & alert_set_q;
  assign alert_state_o = alert_set_q;

  // this FSM performs a full four phase handshake upon a ping or alert trigger.
  // note that the latency of the alert_p/n diff pair is at least one cycle
  // until it enters the receiver FSM. the same holds for the ack_* diff pair
  // input. in case a signal integrity issue is detected, the FSM bails out,
  // sets the alert_p/n diff pair to the same value and toggles it in order to
  // signal that condition over to the receiver.
  always begin : p_fsm
    // default
    state_d   = state_q;
    alert_pd  = 1'b0;
    alert_nd  = 1'b1;
    ping_clr  = 1'b0;
    alert_clr = 1'b0;

    unique case (state_q)
      Idle: begin
        // alert always takes precedence
        if (alert_trigger || ping_trigger) begin
          state_d = (alert_trigger) ? AlertHsPhase1 : PingHsPhase1;
          alert_pd = 1'b1;
          alert_nd = 1'b0;
        end
      end
      // waiting for ack from receiver
      AlertHsPhase1: begin
        if (ack_level) begin
          state_d  = AlertHsPhase2;
        end else begin
          alert_pd = 1'b1;
          alert_nd = 1'b0;
        end
      end
      // wait for deassertion of ack
      AlertHsPhase2: begin
        if (!ack_level) begin
          state_d = Pause0;
          alert_clr = 1'b1;
        end
      end
      // waiting for ack from receiver
      PingHsPhase1: begin
        if (ack_level) begin
          state_d  = PingHsPhase2;
        end else begin
          alert_pd = 1'b1;
          alert_nd = 1'b0;
        end
      end
      // wait for deassertion of ack
      PingHsPhase2: begin
        if (!ack_level) begin
          ping_clr = 1'b1;
          state_d = Pause0;
        end
      end
      // pause cycles between back-to-back handshakes
      Pause0: begin
        state_d = Pause1;
      end
      // clear and ack alert request if it was set
      Pause1: begin
        state_d = Idle;
      end
      // catch parasitic states
      default : state_d = Idle;
    endcase

    // we have a signal integrity issue at one of the incoming diff pairs. this condition is
    // signalled by setting the output diffpair to zero. If the sigint has disappeared, we clear
    // the ping request state of this sender and go back to idle.
    if (sigint_detected) begin
      state_d   = Idle;
      alert_pd  = 1'b0;
      alert_nd  = 1'b0;
      ping_clr  = 1'b1;
      alert_clr = 1'b0;
    end
  end

  // This prevents further tool optimizations of the differential signal.
  prim_sec_anchor_flop #(
    .Width     (2),
    .ResetValue(2'b10)
  ) u_prim_flop_alert (
    .clk_i,
    .rst_ni,
    .d_i({alert_nd, alert_pd}),
    .q_o({alert_nq, alert_pq})
  );

  always @(posedge clk_i or negedge rst_ni) begin : p_reg
    if (!rst_ni) begin
      state_q          <= Idle;
      alert_set_q      <= 1'b0;
      alert_test_set_q <= 1'b0;
      ping_set_q       <= 1'b0;
    end else begin
      state_q          <= state_d;
      alert_set_q      <= alert_set_d;
      alert_test_set_q <= alert_test_set_d;
      ping_set_q       <= ping_set_d;
    end
  end
endmodule

module prim_sec_anchor_buf #(
  parameter[31:0] Width = 1
) (
  input        [Width-1:0] in_i,
  output reg [Width-1:0] out_o
);

  prim_buf #(
    .Width(Width)
  ) u_secure_anchor_buf (
    .in_i,
    .out_o
  );

endmodule

module prim_sec_anchor_flop #(
  parameter [31:0] Width = 1,
  parameter  [Width-1:0] ResetValue = 0
) (
  input                    clk_i,
  input                    rst_ni,
  input        [Width-1:0] d_i,
  output reg [Width-1:0] q_o
);

  prim_flop #(
    .Width(Width),
    .ResetValue(ResetValue)
  ) u_secure_anchor_flop (
    .clk_i,
    .rst_ni,
    .d_i,
    .q_o
  );

endmodule

// Buffer module
module prim_buf#(
parameter Width =1)
(input in_i,
output out_o);
buf(out_o,in_i);
endmodule

// Flip Flop module
module prim_flop#(
parameter Width=1,
parameter[Width-1:0] ResetValue=0)
(input clk_i,
input rst_ni,
input [Width-1:0] d_i,
output reg[Width-1:0] q_o);
always@(posedge clk_i or negedge rst_ni) begin
 if(!rst_ni) begin
  q_o <= 0;
 end else begin
  q_o <= d_i;
 end
 end
endmodule


//
// This module decodes a differentially encoded signal and detects
// incorrectly encoded differential states.
//
// In case the differential pair crosses an asynchronous boundary, it has
// to be re-synchronized to the local clock. This can be achieved by
// setting the AsyncOn parameter to 1'b1. In that case, two additional
// input registers are added (to counteract metastability), and
// a pattern detector is instantiated that detects skewed level changes on
// the differential pair (i.e., when level changes on the diff pair are
// sampled one cycle apart due to a timing skew between the two wires).
//
// See also: prim_alert_sender, prim_alert_receiver, alert_handler



module prim_diff_decode #(
  // enables additional synchronization logic
parameter[1:0]IsStd= 2'b00, 
parameter[1:0]IsSkewed=2'b01,
parameter[1:0]SigInt=2'b10, 
  parameter bit AsyncOn = 1'b0
) (
  input        clk_i,
  input        rst_ni,
  // input diff pair
  input        diff_pi,
  input        diff_ni,
  // logical level and
  // detected edges
  output logic level_o,
  output logic rise_o,
  output logic fall_o,
  // either rise or fall
  output logic event_o,
  //signal integrity issue detected
  output logic sigint_o
);

  wire level_d; 
  reg level_q;

  ///////////////////////////////////////////////////////////////
  // synchronization regs for incoming diff pair (if required) //
  ///////////////////////////////////////////////////////////////
  if (AsyncOn) begin : gen_async

    
    wire state_d;
    reg state_q;
    wire diff_p_edge, diff_n_edge, diff_check_ok, level;

    // 2 sync regs, one reg for edge detection
    reg diff_pq, diff_nq, diff_nd; 
    wire diff_pd;

    prim_flop_2sync_1 #(
      .Width(1),
      .ResetValue('0)
    ) i_sync_p (
      .clk_i,
      .rst_ni,
      .d_i(diff_pi),
      .q_o(diff_pd)
    );

    prim_flop_2sync_2 #(
      .Width(1),
      .ResetValue(1'b1)
    ) i_sync_n (
      .clk_i,
      .rst_ni,
      .d_i(diff_ni),
      .q_o(diff_nd)
    );

    // detect level transitions
    assign diff_p_edge   = diff_pq ^ diff_pd;
    assign diff_n_edge   = diff_nq ^ diff_nd;

    // detect sigint issue
    assign diff_check_ok = diff_pd ^ diff_nd;

    // this is the current logical level
    assign level         = diff_pd;

    // outputs
    assign level_o  = level_d;
    assign event_o = rise_o | fall_o;

    // sigint detection is a bit more involved in async case since
    // we might have skew on the diff pair, which can result in a
    // one cycle sampling delay between the two wires
    // so we need a simple pattern matcher
    // the following waves are legal
    // clk    |   |   |   |   |   |   |   |
    //           _______     _______
    // p _______/        ...        \________
    //   _______                     ________
    // n        \_______ ... _______/
    //              ____     ___
    // p __________/     ...    \________
    //   _______                     ________
    // n        \_______ ... _______/
    //
    // i.e., level changes may be off by one cycle - which is permissible
    // as long as this condition is only one cycle long.


    always begin : p_diff_fsm
      // default
      state_d  = state_q;
      level_d  = level_q;
      rise_o   = 1'b0;
      fall_o   = 1'b0;
      sigint_o = 1'b0;

      unique case (state_q)
        // we remain here as long as
        // the diff pair is correctly encoded
        IsStd: begin
          if (diff_check_ok) begin
            level_d = level;
            if (diff_p_edge && diff_n_edge) begin
              if (level) begin
                rise_o = 1'b1;
              end else begin
                fall_o = 1'b1;
              end
            end
          end else begin
            if (diff_p_edge || diff_n_edge) begin
              state_d = IsSkewed;
            end else begin
              state_d = SigInt;
              sigint_o = 1'b1;
            end
          end
        end
        // diff pair must be correctly encoded, otherwise we got a sigint
        IsSkewed: begin
          if (diff_check_ok) begin
            state_d = IsStd;
            level_d = level;
            if (level) rise_o = 1'b1;
            else       fall_o = 1'b1;
          end else begin
            state_d  = SigInt;
            sigint_o = 1'b1;
          end
        end
        // Signal integrity issue detected, remain here
        // until resolved
        SigInt: begin
          sigint_o = 1'b1;
          if (diff_check_ok) begin
            state_d  = IsStd;
            sigint_o = 1'b0;
          end
        end
        default : ;
      endcase
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin : p_sync_reg
      if (!rst_ni) begin
        state_q  <= IsStd;
        diff_pq  <= 1'b0;
        diff_nq  <= 1'b1;
        level_q  <= 1'b0;
      end else begin
        state_q  <= state_d;
        diff_pq  <= diff_pd;
        diff_nq  <= diff_nd;
        level_q  <= level_d;
      end
    end

  //////////////////////////////////////////////////////////
  // fully synchronous case, no skew present in this case //
  //////////////////////////////////////////////////////////
  end else begin : gen_no_async
    reg diff_pq;
    wire diff_pd;

    // one reg for edge detection
    assign diff_pd = diff_pi;

    // Raise a signal integrity error when the differential signals have equal values.  This is
    // implemented with a `prim_xnor2` instead of behavioral code to prevent the synthesis tool from
    // optimizing away combinational logic on the complementary differential signals.
    prim_xnor2 #(
      .Width (1)
    ) u_xnor2_sigint (
      .in0_i (diff_pi),
      .in1_i (diff_ni),
      .out_o (sigint_o)
    );

    assign level_o = (sigint_o) ? level_q : diff_pi;
    assign level_d = level_o;

    // detect level transitions
    assign rise_o  = (~diff_pq &  diff_pi) & ~sigint_o;
    assign fall_o  = ( diff_pq & ~diff_pi) & ~sigint_o;
    assign event_o = rise_o | fall_o;

    always @(posedge clk_i or negedge rst_ni) begin : p_edge_reg
      if (!rst_ni) begin
        diff_pq  <= 1'b0;
        level_q  <= 1'b0;
      end else begin
        diff_pq  <= diff_pd;
        level_q  <= level_d;
      end
    end
  end

 
endmodule

module prim_xnor2#(
parameter Width=1)
(input in0_i,
input in1_i,
output reg out_o);
always@(*) begin
 out_o <= (in0_i^in1_i);
 end
endmodule

module prim_flop_2sync_1 #(
parameter Width=1,
parameter ResetValue='0)(
input wire clk_i,
input wire rst_ni,
input wire[Width-1:0] d_i,
output reg[Width-1:0] q_o);
reg [Width-1:0] sync_1;
reg [Width-1:0] sync_2;

always@(posedge clk_i or negedge rst_ni) begin
 if(!rst_ni) begin
  sync_1<= ResetValue;
  sync_2<= ResetValue;
  q_o<= ResetValue;
 end else begin
  sync_1<= d_i;
  sync_2<= sync_1;
  q_o<= sync_2;
 end
 end
endmodule

module prim_flop_2sync_2 #(
parameter Width=1,
parameter ResetValue=1'b1)(
input wire clk_i,
input wire rst_ni,
input wire[Width-1:0] d_i,
output reg[Width-1:0] q_o);
reg [Width-1:0] sync_1;
reg [Width-1:0] sync_2;

always@(posedge clk_i or negedge rst_ni) begin
 if(!rst_ni) begin
  sync_1<= ResetValue;
  sync_2<= ResetValue;
  q_o<= ResetValue;
 end else begin
  sync_1<= d_i;
  sync_2<= sync_1;
  q_o<= sync_2;
 end
 end
endmodule


 



