`timescale 1ns / 1ps

module uart_tb;

  // Parameters
  parameter CLK_PERIOD = 20;      // 50 MHz clock (20 ns period)
  parameter BAUD_RATE = 115200;   // Baud rate
  parameter BAUD_PERIOD = 1000000000 / BAUD_RATE; // Baud period in ns

  // Signals
  reg clk;
  reg rst_n;
  reg tx_enable;
  reg rx_enable;
  reg wr;
  reg [7:0] tx_data;
  wire tx;
  reg rx;
  wire [7:0] rx_data;
  wire tx_idle;
  wire rx_valid;

  // Instantiate UART Transmitter
  uart_tx uart_tx_inst (
    .clk_i(clk),
    .rst_ni(rst_n),
    .tx_enable(tx_enable),
    .wr(wr),
    .wr_data(tx_data),
    .idle(tx_idle),
    .tx(tx)
  );

  // Instantiate UART Receiver
  uart_rx uart_rx_inst (
    .clk_i(clk),
    .rst_ni(rst_n),
    .rx_enable(rx_enable),
    .rx(rx),
    .rx_data(rx_data),
    .rx_valid(rx_valid)
  );

  // Clock Generation
  always #(CLK_PERIOD / 2) clk = ~clk; // Toggle clock every 10 ns

  // Test Sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    tx_enable = 0;
    rx_enable = 0;
    wr = 0;
    tx_data = 8'h00;
    rx = 1;

    // Apply reset
    #50;
    rst_n = 1;  // Release reset

    // Enable TX and RX
    #10;
    tx_enable = 1;
    rx_enable = 1;

    // Send a byte over UART
    #10;
    tx_data = 8'hA5; // Data to send
    wr = 1;  // Assert write signal
    #10;
    wr = 0;  // Deassert write signal

    // Simulate Reception (loopback)
    #100;
    rx = 0; // Start bit
    #(BAUD_PERIOD);
    rx = 1; // Data bit 0
    #(BAUD_PERIOD);
    rx = 0; // Data bit 1
    #(BAUD_PERIOD);
    rx = 1; // Data bit 2
    #(BAUD_PERIOD);
    rx = 0; // Data bit 3
    #(BAUD_PERIOD);
    rx = 1; // Data bit 4
    #(BAUD_PERIOD);
    rx = 0; // Data bit 5
    #(BAUD_PERIOD);
    rx = 1; // Data bit 6
    #(BAUD_PERIOD);
    rx = 0; // Data bit 7
    #(BAUD_PERIOD);
    rx = 1; // Stop bit
    #(BAUD_PERIOD);

    // Wait for reception to complete
    #100;

    // Check received data
    if (rx_data == 8'hA5) begin
      $display("Test Passed: Received data matches transmitted data.");
    end else begin
      $display("Test Failed: Received data does not match transmitted data.");
    end

    // End simulation
    $finish;
  end

endmodule

