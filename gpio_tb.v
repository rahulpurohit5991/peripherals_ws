
module gpio_tb;
localparam NumRegs=18;
localparam NumIOs=32;
localparam NumInPeriodCounters=0;
localparam NumAlerts=1;
localparam [NumAlerts-1:0]AlertAsynOn={NumAlerts{1'b1}};
localparam GpioAsHwStrapsEn=1;
localparam GpioAsynOn=1;
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
   
    #10 rst_ni= 1;
    #10 rst_ni= 0;
    //
    #10 reg2hw_direct_out_q= 32'hA5a5a5a5;reg2hw_direct_out_qe=1;
    #10 reg2hw_direct_out_qe=0;
    
    //
    #10 reg2hw_masked_out_lower_data_q=16'h00ff;reg2hw_masked_out_lower_mask_q=16'hffff;reg2hw_masked_out_lower_data_qe=1;
    #10 reg2hw_masked_out_lower_data_qe=0;        
     
    //
    #10 reg2hw_masked_out_upper_data_q=16'h00ff;reg2hw_masked_out_upper_mask_q=16'hffff;reg2hw_masked_out_upper_data_qe=1;
    #10 reg2hw_masked_out_upper_data_qe=0;
    //
     #10 reg2hw_direct_oe_q= 32'ha5a5a5a5;reg2hw_direct_oe_qe=1;
    #10 reg2hw_direct_oe_qe=0;
    //
    #10 reg2hw_masked_oe_lower_data_q=16'h00ff;reg2hw_masked_oe_lower_mask_q=16'hffff;reg2hw_masked_oe_lower_data_qe=1;
    #10 reg2hw_masked_oe_lower_data_qe=0;        
    
    //
    #10 reg2hw_masked_oe_upper_data_q=16'h00ff; reg2hw_masked_oe_upper_mask_q=16'hffff; reg2hw_masked_oe_upper_data_qe=1;
    #10 reg2hw_masked_oe_upper_data_qe=0;
    //        
    #10 cio_gpio_i=32'ha4a4a4a4;
    #10 cio_gpio_i=32'ha3a3a3a3;
    //
    #10 strap_en_i=1;
    #10 strap_en_i=0;
    //
    #10 alert_rx_i=1;
    #10 alert_rx_i=0;
    
//
    #60 $finish;
end

 initial begin

  $display(" time= %ts, cio_gpio_o= %b, cio_gpio_en_o=%b, sampled_straps_o=%b, intr_gpio_o=%b, alert_tx_o=%b", $time,cio_gpio_o, cio_gpio_en_o,sampled_straps_o,intr_gpio_o,alert_tx_o);
end

endmodule

 

 
 
