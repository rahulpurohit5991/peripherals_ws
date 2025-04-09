
module gpio_tb
(
output reg  clk_i,  // Clock
output reg rst_ni, // Reset (active-low)
output reg strap_en_i,
output reg[NumAlerts-1:0] alert_rx_i,
output reg[NumIOs-1:0] cio_gpio_i,
output reg[31:0] reg2hw_direct_out_q,
output reg reg2hw_direct_out_qe,
output reg [15:0] reg2hw_masked_out_lower_mask_q,
output reg reg2hw_masked_out_lower_mask_qe,
output reg [15:0]reg2hw_masked_out_lower_data_q,
output reg reg2hw_masked_out_lower_data_qe,
output reg [15:0] reg2hw_masked_out_upper_mask_q,
output reg reg2hw_masked_out_upper_mask_qe,
output reg [15:0] reg2hw_masked_out_upper_data_q,
output reg reg2hw_masked_out_upper_data_qe,
output reg [31:0] reg2hw_direct_oe_q,
output reg reg2hw_direct_oe_qe,
output reg [15:0] reg2hw_masked_oe_lower_mask_q,
output reg reg2hw_masked_oe_lower_mask_qe,
output reg [15:0] reg2hw_masked_oe_lower_data_q,
output reg reg2hw_masked_oe_lower_data_qe,
output reg reg2hw_masked_oe_upper_mask_qe,
output reg [15:0]reg2hw_masked_oe_upper_mask_q,
output reg [15:0] reg2hw_masked_oe_upper_data_q,
output reg reg2hw_masked_oe_upper_data_qe,
output reg [31:0] data_in_d,
//
//output reg[NumIOs-1:0] event_intr_combined,
output reg reg2hw_intr_enable_qe,
output reg [NumIOs-1:0] reg2hw_intr_enable_q,
output reg reg2hw_intr_test_qe,
output reg [NumIOs-1:0]reg2hw_intr_test_q,
output reg [NumIOs-1:0]reg2hw_intr_state_q,
output reg [NumIOs-1:0] reg2hw_intr_ctrl_en_rising_q,
output reg [NumIOs-1:0]reg2hw_intr_ctrl_en_falling_q,
output reg [NumIOs-1:0] reg2hw_intr_ctrl_en_lvlhigh_q,
output reg [NumIOs-1:0] reg2hw_intr_ctrl_en_lvllow_q,


//
input wire [31:0] hw2reg_intr_state_d,
input wire hw2reg_intr_state_de,// hardcoded to 1
input wire [31:0] hw2reg_data_in_d,
input wire hw2reg_data_in_de,
//
input wire [31:0] hw2reg_direct_out_d,
input wire [15:0] hw2reg_masked_out_lower_data_d,
input wire [15:0] hw2reg_masked_out_upper_data_d,
input wire [31:0] hw2reg_direct_oe_d,
input wire [15:0] hw2reg_masked_oe_lower_data_d,
input wire [15:0] hw2reg_masked_oe_upper_data_d,

input wire  [NumIOs-1:0] cio_gpio_o,
input wire  [NumIOs-1:0] cio_gpio_en_o,
input wire  sampled_straps_o,
input wire [NumIOs-1:0] intr_gpio_o,
input wire  [NumAlerts-1:0] alert_tx_o
);
localparam NumRegs=18;
localparam NumIOs=32;
localparam NumInPeriodCounters=0;
localparam NumAlerts=1;
localparam [NumAlerts-1:0]AlertAsynOn={NumAlerts{1'b1}};
localparam GpioAsHwStrapsEn=1;
localparam GpioAsynOn=1;
/*
reg  clk_i;  // Clock
reg rst_ni; // Reset (active-low)
reg strap_en_i;
reg[NumAlerts-1:0] alert_rx_i;
reg[NumIOs-1:0] cio_gpio_i;
reg[31:0] reg2hw_direct_out_q;
reg reg2hw_direct_out_qe;
reg [15:0] reg2hw_masked_out_lower_mask_q;
reg reg2hw_masked_out_lower_mask_qe;
reg [15:0]reg2hw_masked_out_lower_data_q;
reg reg2hw_masked_out_lower_data_qe;
reg [15:0] reg2hw_masked_out_upper_mask_q;
reg reg2hw_masked_out_upper_mask_qe;
reg [15:0] reg2hw_masked_out_upper_data_q;
reg reg2hw_masked_out_upper_data_qe;
reg [31:0] reg2hw_direct_oe_q;
reg reg2hw_direct_oe_qe;
reg [15:0] reg2hw_masked_oe_lower_mask_q;
reg reg2hw_masked_oe_lower_mask_qe;
reg [15:0] reg2hw_masked_oe_lower_data_q;
reg reg2hw_masked_oe_lower_data_qe;
reg reg2hw_masked_oe_upper_mask_qe;
reg [15:0]reg2hw_masked_oe_upper_mask_q;
reg [15:0] reg2hw_masked_oe_upper_data_q;
reg reg2hw_masked_oe_upper_data_qe;
wire  [NumIOs-1:0] cio_gpio_o;
wire  [NumIOs-1:0] cio_gpio_en_o;
wire  sampled_straps_o;
wire [NumIOs-1:0] intr_gpio_o;
wire  [NumAlerts-1:0] alert_tx_o;
/*
initial begin
clk_i=0;
forever #5 clk_i=~clk_i;
end
*/
always #5 clk_i=~clk_i;


   /* // Instantiate the gpio_ip module
    gpio_ip #(
        .NumRegs(NumRegs),
        .NumIOs(NumIOs),
        .NumAlerts(NumAlerts),
        .GpioAsyncOn(GpioAsyncOn)
    ) uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .strap_en_i(strap_en_i),
        .sampled_straps_o(sampled_straps_o),
        .intr_gpio_o(intr_gpio_o),
        .alert_rx_i(alert_rx_i),
        .alert_tx_o(alert_tx_o),
        .cio_gpio_i(cio_gpio_i),
        .cio_gpio_o(cio_gpio_o),
        .cio_gpio_en_o(cio_gpio_en_o)
    );
*/
    // Stimulus
    initial begin
    clk_i=0;
    rst_ni=0; // Reset (active-low)
    strap_en_i=0;
    alert_rx_i=0;
    cio_gpio_i=32'b0;
    reg2hw_direct_out_q=32'b0;
    reg2hw_direct_out_qe=0;
    reg2hw_masked_out_lower_mask_q=16'b0;
    reg2hw_masked_out_lower_mask_qe=0;
    reg2hw_masked_out_lower_data_q=16'b0;
    reg2hw_masked_out_lower_data_qe=0;
    reg2hw_masked_out_upper_mask_q=16'b0;
    reg2hw_masked_out_upper_data_q=16'b0;
    reg2hw_masked_out_upper_data_qe=0;
    reg2hw_direct_oe_q=32'b0;
    reg2hw_direct_oe_qe=0;
    reg2hw_masked_oe_lower_mask_q=16'b0;
    reg2hw_masked_oe_lower_mask_qe=0;
    reg2hw_masked_oe_lower_data_q=16'b0;
    reg2hw_masked_oe_lower_data_qe=0;
    reg2hw_masked_oe_upper_mask_qe=0;
    reg2hw_masked_oe_upper_mask_q=16'b0;
    reg2hw_masked_oe_upper_data_q=16'b0;
    reg2hw_masked_oe_upper_data_qe=0;
    reg2hw_intr_enable_qe=0;
    reg2hw_intr_enable_q=32'h00000000;
    reg2hw_intr_test_qe=0;
    reg2hw_intr_test_q=32'h00000000;
    reg2hw_intr_state_q=32'h00000000;
    reg2hw_intr_ctrl_en_rising_q=32'h00000000;
    reg2hw_intr_ctrl_en_falling_q=32'h00000000;
    reg2hw_intr_ctrl_en_lvlhigh_q=32'h00000000;
    reg2hw_intr_ctrl_en_lvllow_q=32'h00000000; 
   
    #10 rst_ni= 1;
    //
    #10 reg2hw_direct_out_q= 32'hA5a5a5a5;reg2hw_direct_out_qe=1;
    #10 reg2hw_direct_out_qe=0;reg2hw_direct_out_q= 0;
    
    //
    #10 reg2hw_masked_out_lower_data_q=16'h00ff;reg2hw_masked_out_lower_mask_q=16'hffff;reg2hw_masked_out_lower_data_qe=1;
    #10 reg2hw_masked_out_lower_data_qe=0;reg2hw_masked_out_lower_data_q=0;       
     
    //
    #10 reg2hw_masked_out_upper_data_q=16'h00ff;reg2hw_masked_out_upper_mask_q=16'hffff;reg2hw_masked_out_upper_data_qe=1;
    #10  reg2hw_masked_out_upper_data_qe=0; reg2hw_masked_out_upper_data_q=0;
    //
     #10  reg2hw_direct_oe_q= 32'ha5a5a5a5;reg2hw_direct_oe_qe=1;
    #10  reg2hw_direct_oe_qe=0; reg2hw_direct_oe_q=0;
    //
    #10  reg2hw_masked_oe_lower_data_q=16'h00ff;reg2hw_masked_oe_lower_mask_q=16'hffff;reg2hw_masked_oe_lower_data_qe=1;
    #10  reg2hw_masked_oe_lower_data_qe=0; reg2hw_masked_oe_lower_data_q=0;        
    
    //
    #10  reg2hw_masked_oe_upper_data_q=16'h00ff; reg2hw_masked_oe_upper_mask_q=16'hffff; reg2hw_masked_oe_upper_data_qe=1;
    #10  reg2hw_masked_oe_upper_data_qe=0;reg2hw_masked_oe_upper_data_q=0;
    //        
    #10  cio_gpio_i=32'ha4a4a4a4;
    #10  cio_gpio_i=0;
    //
    #10  data_in_d=32'haaaaaaaa;
    

    #10 reg2hw_intr_test_qe=1;
        reg2hw_intr_test_q=32'hccccaaaa;
    #10  reg2hw_intr_test_qe=0;
    #10 reg2hw_intr_ctrl_en_rising_q=32'hbbbbbbbb;
        reg2hw_intr_ctrl_en_falling_q=32'h55555555;
        reg2hw_intr_ctrl_en_lvlhigh_q=32'haaaaaaaa;
        reg2hw_intr_ctrl_en_lvllow_q=32'hdddddddd;

    #10 reg2hw_intr_enable_qe=1;
    #10 reg2hw_intr_enable_q=32'h33333333;

    #10 reg2hw_intr_state_q=32'h33333333;
    #10 reg2hw_intr_ctrl_en_rising_q=32'h00;
        reg2hw_intr_ctrl_en_falling_q=32'h00;
        reg2hw_intr_ctrl_en_lvlhigh_q=32'h00;
        reg2hw_intr_ctrl_en_lvllow_q=32'h00;
    #10 reg2hw_intr_enable_q=32'h00;

    #10 data_in_d=32'h00;
    
   
 



 






    /*
    #10  strap_en_i=1;
    #10  strap_en_i=0;
    //
    #10  alert_rx_i=1;
    #10  alert_rx_i=0;
    
    
*/
    #200 $finish;
end

 initial begin

  $display(" time= %ts, cio_gpio_o= %b, cio_gpio_en_o=%b, sampled_straps_o=%b, intr_gpio_o=%b, alert_tx_o=%b, hw2reg_direct_out_d=%b, hw2reg_masked_out_lower_data_d=%b, hw2reg_masked_out_upper_data_d=%b, hw2reg_direct_oe_d=%b; hw2reg_masked_oe_lower_data_d=%b,hw2reg_masked_oe_upper_data_d=%b,hw2reg_intr_state_d=%b; hw2reg_data_in_d=%b;hw2reg_data_in_de=%b ", $time,cio_gpio_o, cio_gpio_en_o,sampled_straps_o,intr_gpio_o,alert_tx_o,hw2reg_direct_out_d, hw2reg_masked_out_lower_data_d, hw2reg_masked_out_upper_data_d, hw2reg_direct_oe_d, hw2reg_masked_oe_lower_data_d,hw2reg_masked_oe_upper_data_d, hw2reg_intr_state_d, hw2reg_data_in_d, hw2reg_data_in_de );
end

endmodule

 

 
 

