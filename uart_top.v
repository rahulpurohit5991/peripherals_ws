module UART_TOP #(
    parameter DATAWIDTH = 8,
    parameter OVERSAMPLING = 16
)(
    // Common signals
    input  wire         clk,
    input  wire         rst,
    input  wire         bclk,
    
    // Transmitter controls
    input  wire         tx_parEnable,
    input  wire         tx_dataValid,
    input  wire         tx_parityType,
    input  wire [DATAWIDTH-1:0] tx_dataInput,
    
    // Receiver controls
    input  wire         rx_parEnable,
    input  wire         rx_parityType,
    
    // Serial interface
    output wire         tx_out,
    input  wire         rx_in,
    
    // Status signals
    output wire         tx_busy,
    output wire         tx_done,
    output wire [DATAWIDTH-1:0] rx_out,
    output wire         rx_pCheckError,
    output wire         rx_pCheckValid,
    output wire         rx_busy,
    output wire         rx_done,
    output wire         rx_framingError
);

    // Transmitter instance
    TX #(
        .DATAWIDTH(DATAWIDTH),
        .OVERSAMPLING(OVERSAMPLING)
    ) u_tx (
        .clk(clk),
        .rst(rst),
        .parEnable(tx_parEnable),
        .dataValid(tx_dataValid),
        .parityType(tx_parityType),
        .dataInput(tx_dataInput),
        .bclk(bclk),
        .tx_out(tx_out),
        .busy(tx_busy),
        .tx_done(tx_done)
    );

    // Receiver instance
    RX #(
        .DATAWIDTH(DATAWIDTH),
        .OVERSAMPLING(OVERSAMPLING)
    ) u_rx (
        .clk(clk),
        .rst(rst),
        .parEnable(rx_parEnable),
        .parityType(rx_parityType),
        .rx_in(rx_in),
        .bclk(bclk),
        .rx_out(rx_out),
        .pCheckError(rx_pCheckError),
        .pCheckValid(rx_pCheckValid),
        .busy(rx_busy),
        .rx_done(rx_done),
        .framingError(rx_framingError)
    );

endmodule