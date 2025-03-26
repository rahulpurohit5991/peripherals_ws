//Tilelink wrapper

`include "uart.v"
module uart_tilelink_wrapper (
  // TileLink Channel A (Master to Slave)
  input  wire        a_valid,
  output reg        a_ready,
  input  wire [2:0]  a_opcode,  // 3-bit opcode
  input  wire [2:0]  a_param,   // 3-bit parameter
  input  wire [2:0]  a_size,    // Log2 of operation size
  input  wire [31:0] a_address,
  input  wire [3:0]  a_mask,    // Byte lane select
  input  wire [31:0] a_data,

  // TileLink Channel D (Slave to Master)
  output reg         d_valid,
  input          d_ready,
  output reg  [2:0]  d_opcode,  // 3-bit opcode
  output reg  [31:0] d_data,

  // UART Interface
  input          uart_rx,
  output reg     uart_tx,
  input          clk,
  input          rst_n
);


    // UART Operation Codes
  localparam READ_OP  = 3'b000;
  localparam WRITE_OP = 3'b001;

  // UART Register Addresses
  localparam CTRL_REG_ADDR   = 32'h00;
  localparam STATUS_REG_ADDR = 32'h04;
  localparam RDATA_REG_ADDR  = 32'h08;
  localparam WDATA_REG_ADDR  = 32'h0C;

  // State Machine States
  parameter IDLE    = 2'b00;
  parameter READ    = 2'b01;
  parameter WRITE   = 2'b10;
  parameter RESPOND = 2'b11;

  // UART Registers
  reg [31:0] uart_ctrl;
  reg [31:0] uart_status;
  reg [31:0] uart_rdata;
  reg [31:0] uart_wdata;

  // State Machine Registers
  reg [1:0] state, next_state;

uart_tx_rx u_uart_tx_rx (
    .clk_i(clk),
    .rst_ni(rst_n),
    .tx_enable(1'b1),               // Enable UART TX
    .tick_baud_x16(1'b1),           // Provide baud tick for TX
    .parity_enable(1'b0),           // No parity for this example
    .wr(1'b0),                      // No write operation for this example
    .wr_parity(1'b0),               // No write parity
    .wr_data(8'hA5),                // Example write data (unused in this case)
    .idle_tx(),                     // Idle signal for TX
    .tx(uart_tx),                   // Output UART TX data

    .rx_enable(1'b1),               // Enable UART RX
    .parity_odd(1'b0),              // No odd parity for this example
    .tick_baud(),                   // Baud tick for RX (connected internally)
    .rx_valid(),                    // Signal to indicate valid data received
    .rx_data(),                     // Received data (unused in this case)
    .idle_rx(),                     // Idle signal for RX
    .frame_err(),                   // Frame error flag
    .rx_parity_err(),               // Parity error flag
    .rx(uart_rx)                    // Input UART RX data
  );



  // State Transition
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= IDLE;
    else
      state <= next_state;
  end

  // State Logic
  always @ (*) begin
    next_state = state;
    a_ready = 1'b0;
    d_valid = 1'b0;
    d_opcode = 3'b000;
    d_data = 32'b0;
    case (state)
      IDLE: begin
        if (a_valid) begin
          a_ready = 1;
          case (a_opcode)
            READ_OP: next_state = READ;
            WRITE_OP: next_state = WRITE;
            default: next_state = IDLE;
          endcase
        end
      end
      READ: begin
        // Perform UART read operation
        case (a_address)
          CTRL_REG_ADDR: d_data = uart_ctrl;
          STATUS_REG_ADDR: d_data = uart_status;
          RDATA_REG_ADDR: d_data = uart_rdata;
          default: d_data = 32'b0;
        endcase
        d_valid = 1;
        d_opcode = 3'b000; // AccessAck
        next_state = RESPOND;
      end
      WRITE: begin
        // Perform UART write operation
        case (a_address)
          CTRL_REG_ADDR: uart_ctrl = a_data;
          STATUS_REG_ADDR: uart_status = a_data;
          WDATA_REG_ADDR: uart_wdata = a_data;
          default: ;
        endcase
        d_valid = 1;
        d_opcode = 3'b000; // AccessAck
        next_state = RESPOND;
      end
      RESPOND: begin
        // Wait for response acknowledgment
        if (d_ready) begin
          next_state = IDLE;
        end
      end
    endcase
  end

  // UART Transmit Logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      uart_tx <= 1'b1; // Idle state
    else if (state == WRITE && a_address == WDATA_REG_ADDR)
      uart_tx <= uart_wdata[0]; // Transmit LSB first
  end

  // UART Receive Logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      uart_rdata <= 32'b0;
    else if (state == READ && a_address == RDATA_REG_ADDR)
      uart_rdata <= {24'b0, uart_rx,7'b0}; // Receive data
  end

endmodule

