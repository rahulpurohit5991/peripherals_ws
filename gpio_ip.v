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
module gpio_ip (
    input wire clk_i,  // Clock
    input wire rst_ni, // Reset (active-low)

    // Control signals from register interface
    input wire [31:0] reg2hw_direct_out_q,
    input wire        reg2hw_direct_out_qe,
    input wire [31:0] reg2hw_direct_oe_q,
    
    input wire [15:0] reg2hw_masked_out_upper_data_q,
    input wire [15:0] reg2hw_masked_out_upper_mask_q,
    input wire        reg2hw_masked_out_upper_qe,

    input wire [15:0] reg2hw_masked_out_lower_data_q,
    input wire [15:0] reg2hw_masked_out_lower_mask_q,
    input wire        reg2hw_masked_out_lower_qe,

    input wire [15:0] reg2hw_masked_oe_upper_data_q,
    input wire [15:0] reg2hw_masked_oe_upper_mask_q,
    input wire        reg2hw_masked_oe_upper_qe,

    input wire [15:0] reg2hw_masked_oe_lower_data_q,
    input wire [15:0] reg2hw_masked_oe_lower_mask_q,
    input wire        reg2hw_masked_oe_lower_qe,

    // GPIO Outputs
    output reg [31:0] cio_gpio_q,
    output reg [31:0] cio_gpio_en_q,
    
    // GPIO inputs
    input wire[31:0] data_in_d,
    output reg [31:0] data_in_q
);
//gpio_reg2hw_t reg2hw;
//gpio_hw2reg_t hw2reg;
// GPIO Output Logic
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
    end else if (reg2hw_masked_out_upper_qe) begin
        cio_gpio_q[31:16] <= (cio_gpio_q[31:16] & ~reg2hw_masked_out_upper_mask_q) |
                             (reg2hw_masked_out_upper_mask_q & reg2hw_masked_out_upper_data_q);
    end else if (reg2hw_masked_out_lower_qe) begin
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
    end else if (reg2hw_masked_oe_upper_qe) begin
        cio_gpio_en_q[31:16] <= (cio_gpio_en_q[31:16] & ~reg2hw_masked_oe_upper_mask_q) |
                                (reg2hw_masked_oe_upper_mask_q & reg2hw_masked_oe_upper_data_q);
    end else if (reg2hw_masked_oe_lower_qe) begin
        cio_gpio_en_q[15:0] <= (cio_gpio_en_q[15:0] & ~reg2hw_masked_oe_lower_mask_q) |
                               (reg2hw_masked_oe_lower_mask_q & reg2hw_masked_oe_lower_data_q);
    end
end

//GPIO_IN
assign hw2reg_data_in_de=1'b1;
assign hw2reg_data_in_d= data_in_d;
always@(posedge clk_i) begin
 data_in_q <= data_in_d;end
 

endmodule

 


