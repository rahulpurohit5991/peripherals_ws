// Code your design here
module uart_tx (
  input               clk_i,
  input               rst_ni,

  input               tx_enable,
  input               tick_baud_x16,
  input               parity_enable,

  input               wr,
  input               wr_parity,
  input   [7:0]       wr_data,
  output              idle,

  output              tx
);

  // Internal signal declarations using reg and wire instead of logic.
  reg [3:0] baud_div_q;
  reg       tick_baud_q;

  reg [3:0] bit_cnt_q, bit_cnt_d;
  reg [10:0] sreg_q, sreg_d;
  reg       tx_q, tx_d;

  // The output tx is driven by tx_q.
  assign tx = tx_q;

  // Baud rate generator: divides the 16x oversampled tick.
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      baud_div_q  <= 4'h0;
      tick_baud_q <= 1'b0;
    end else if (tick_baud_x16) begin
      {tick_baud_q, baud_div_q} <= {1'b0, baud_div_q} + 5'h1;
    end else begin
      tick_baud_q <= 1'b0;
    end
  end

  // Sequential block for bit counter, shift register, and tx output.
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      bit_cnt_q <= 4'h0;
      sreg_q    <= 11'h7ff;
      tx_q      <= 1'b1;
    end else begin
      bit_cnt_q <= bit_cnt_d;
      sreg_q    <= sreg_d;
      tx_q      <= tx_d;
    end
  end

  // Combinational logic for transmitter operation.
  always @* begin
    if (!tx_enable) begin
      bit_cnt_d = 4'h0;
      sreg_d    = 11'h7ff;
      tx_d      = 1'b1;
    end else begin
      bit_cnt_d = bit_cnt_q;
      sreg_d    = sreg_q;
      tx_d      = tx_q;
      if (wr) begin
        sreg_d    = {1'b1, (parity_enable ? wr_parity : 1'b1), wr_data, 1'b0};
        bit_cnt_d = (parity_enable ? 4'd11 : 4'd10);
      end else if (tick_baud_q && (bit_cnt_q != 4'h0)) begin
        sreg_d    = {1'b1, sreg_q[10:1]};
        tx_d      = sreg_q[0];
        bit_cnt_d = bit_cnt_q - 4'h1;
      end
    end
  end

  // Idle signal indicates whether the transmitter is ready for a new byte.
  assign idle = (tx_enable) ? (bit_cnt_q == 4'h0) : 1'b1;

endmodule


//////////////////////////// Receiver///////////////
module uart_rx (
  input           clk_i,
  input           rst_ni,

  input           rx_enable,
  input           tick_baud_x16,
  input           parity_enable,
  input           parity_odd,

  output          tick_baud,
  output          rx_valid,
  output  [7:0]   rx_data,
  output          idle,
  output          frame_err,
  output          rx_parity_err,

  input           rx
);

  // Internal signal declarations using reg for sequential logic.
  reg         rx_valid_q;
  reg [10:0]  sreg_q, sreg_d;
  reg [3:0]   bit_cnt_q, bit_cnt_d;
  reg [3:0]   baud_div_q, baud_div_d;
  reg         tick_baud_d, tick_baud_q;
  reg         idle_d, idle_q;

  // Continuous assignments for outputs.
  assign tick_baud = tick_baud_q;
  assign idle      = idle_q;

  // Sequential block: registers updated on rising clock or asynchronous reset.
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      sreg_q      <= 11'h0;
      bit_cnt_q   <= 4'h0;
      baud_div_q  <= 4'h0;
      tick_baud_q <= 1'b0;
      idle_q      <= 1'b1;
    end else begin
      sreg_q      <= sreg_d;
      bit_cnt_q   <= bit_cnt_d;
      baud_div_q  <= baud_div_d;
      tick_baud_q <= tick_baud_d;
      idle_q      <= idle_d;
    end
  end

  // Combinational logic.
  always @(*) begin
    if (!rx_enable) begin
      sreg_d      = 11'h0;
      bit_cnt_d   = 4'h0;
      baud_div_d  = 4'h0;
      tick_baud_d = 1'b0;
      idle_d      = 1'b1;
    end else begin
      tick_baud_d = 1'b0;
      sreg_d      = sreg_q;
      bit_cnt_d   = bit_cnt_q;
      baud_div_d  = baud_div_q;
      idle_d      = idle_q;
      if (tick_baud_x16) begin
        {tick_baud_d, baud_div_d} = {1'b0, baud_div_q} + 5'h1;
      end

      if (idle_q && !rx) begin
        // Start of a character: sample in the middle of the bit time.
        baud_div_d  = 4'd8;
        tick_baud_d = 1'b0;
        bit_cnt_d   = (parity_enable ? 4'd11 : 4'd10);
        sreg_d      = 11'h0;
        idle_d      = 1'b0;
      end else if (!idle_q && tick_baud_q) begin
        if ((bit_cnt_q == (parity_enable ? 4'd11 : 4'd10)) && rx) begin
          // Glitch detected on the input (start bit error): abort.
          idle_d    = 1'b1;
          bit_cnt_d = 4'h0;
        end else begin
          sreg_d    = {rx, sreg_q[10:1]};
          bit_cnt_d = bit_cnt_q - 4'h1;
          idle_d    = (bit_cnt_q == 4'h1);
        end
      end
    end
  end

  // Registering the rx_valid signal.
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)
      rx_valid_q <= 1'b0;
    else
      rx_valid_q <= tick_baud_q & (bit_cnt_q == 4'h1);
  end

  // Continuous assignments for remaining outputs.
  assign rx_valid      = rx_valid_q;
  assign rx_data       = parity_enable ? sreg_q[8:1] : sreg_q[9:2];
  assign frame_err     = rx_valid_q & ~sreg_q[10];
  assign rx_parity_err = parity_enable & rx_valid_q & (^{sreg_q[9:1], parity_odd});

endmodule

