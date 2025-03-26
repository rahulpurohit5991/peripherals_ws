
//
// Description: UART Transmit and Receive Modules
//

module uart_tx_rx (
  // Clock and Reset Signals
  input               clk_i,
  input               rst_ni,

  // For UART Transmit
  input               tx_enable,
  input               tick_baud_x16,
  input               parity_enable,
  input               wr,
  input               wr_parity,
  input   [7:0]       wr_data,
  output              idle_tx,
  output reg          tx,

  // For UART Receive
  input           rx_enable,
  input           parity_odd,
  output          tick_baud,
  output          rx_valid,
  output [7:0]    rx_data,
  output          idle_rx,
  output          frame_err,
  output          rx_parity_err,
  input           rx
);

  // Internal signals for UART Transmit
  reg    [3:0] baud_div_tx_q;
  reg          tick_baud_tx_q;
  reg    [3:0] bit_cnt_tx_q, bit_cnt_tx_d;
  reg   [10:0] sreg_tx_q, sreg_tx_d;
  reg          tx_q, tx_d;

  // Internal signals for UART Receive
  reg            rx_valid_q;
  reg   [10:0]   sreg_rx_q, sreg_rx_d;
  reg    [3:0]   bit_cnt_rx_q, bit_cnt_rx_d;
  reg    [3:0]   baud_div_rx_q, baud_div_rx_d;
  reg            tick_baud_rx_d, tick_baud_rx_q;
  reg            idle_rx_d, idle_rx_q;

  // Assign outputs
 always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      tx <= 1'b1;  // Idle state for UART TX
    end else if (tx_enable) begin
      tx <= tx_q;  // UART TX is driven based on tx_q
    end
  end
  //assign tx = tx_q;
  assign tick_baud = tick_baud_rx_q;
  assign idle_tx = (tx_enable) ? (bit_cnt_tx_q == 4'h0) : 1'b1;
  assign idle_rx = idle_rx_q;

  // UART Transmit: Baud Divider and State Logic
  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      baud_div_tx_q  <= 4'h0;
      tick_baud_tx_q <= 1'b0;
    end else if (tick_baud_x16) begin
      {tick_baud_tx_q, baud_div_tx_q} <= {1'b0, baud_div_tx_q} + 5'h1;
    end else begin
      tick_baud_tx_q <= 1'b0;
    end
  end

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      bit_cnt_tx_q <= 4'h0;
      sreg_tx_q    <= 11'h7ff;
      tx_q         <= 1'b1;
    end else begin
      bit_cnt_tx_q <= bit_cnt_tx_d;
      sreg_tx_q    <= sreg_tx_d;
      tx_q         <= tx_d;
    end
  end

  always_comb begin
    if (!tx_enable) begin
      bit_cnt_tx_d = 4'h0;
      sreg_tx_d    = 11'h7ff;
      tx_d         = 1'b1;
    end else begin
      bit_cnt_tx_d = bit_cnt_tx_q;
      sreg_tx_d    = sreg_tx_q;
      tx_d         = tx_q;
      if (wr) begin
        sreg_tx_d    = {1'b1, (parity_enable ? wr_parity : 1'b1), wr_data, 1'b0};
        bit_cnt_tx_d = (parity_enable ? 4'd11 : 4'd10);
      end else if (tick_baud_tx_q && (bit_cnt_tx_q != 4'h0)) begin
        sreg_tx_d    = {1'b1, sreg_tx_q[10:1]};
        tx_d         = sreg_tx_q[0];
        bit_cnt_tx_d = bit_cnt_tx_q - 4'h1;
      end
    end
  end

  // UART Receive: Baud Divider and State Logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      sreg_rx_q      <= 11'h0;
      bit_cnt_rx_q   <= 4'h0;
      baud_div_rx_q  <= 4'h0;
      tick_baud_rx_q <= 1'b0;
      idle_rx_q      <= 1'b1;
    end else begin
      sreg_rx_q      <= sreg_rx_d;
      bit_cnt_rx_q   <= bit_cnt_rx_d;
      baud_div_rx_q  <= baud_div_rx_d;
      tick_baud_rx_q <= tick_baud_rx_d;
      idle_rx_q      <= idle_rx_d;
    end
  end

  always_comb begin
    if (!rx_enable) begin
      sreg_rx_d      = 11'h0;
      bit_cnt_rx_d   = 4'h0;
      baud_div_rx_d  = 4'h0;
      tick_baud_rx_d = 1'b0;
      idle_rx_d      = 1'b1;
    end else begin
      tick_baud_rx_d = 1'b0;
      sreg_rx_d      = sreg_rx_q;
      bit_cnt_rx_d   = bit_cnt_rx_q;
      baud_div_rx_d  = baud_div_rx_q;
      idle_rx_d      = idle_rx_q;
      if (tick_baud_x16) begin
        {tick_baud_rx_d, baud_div_rx_d} = {1'b0, baud_div_rx_q} + 5'h1;
      end
      if (idle_rx_q && !rx) begin
        baud_div_rx_d  = 4'd8;
        tick_baud_rx_d = 1'b0;
        bit_cnt_rx_d   = (parity_enable ? 4'd11 : 4'd10);
        sreg_rx_d      = 11'h0;
        idle_rx_d      = 1'b0;
      end else if (!idle_rx_q && tick_baud_rx_q) begin
        if ((bit_cnt_rx_q == (parity_enable ? 4'd11 : 4'd10)) && rx) begin
          idle_rx_d    = 1'b1;
          bit_cnt_rx_d = 4'h0;
        end else begin
          sreg_rx_d    = {rx, sreg_rx_q[10:1]};
          bit_cnt_rx_d = bit_cnt_rx_q - 4'h1;
          idle_rx_d    = (bit_cnt_rx_q == 4'h1);
        end
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) rx_valid_q <= 1'b0;
    else         rx_valid_q <= tick_baud_rx_q & (bit_cnt_rx_q == 4'h1);
  end

  assign rx_valid      = rx_valid_q;
  assign rx_data       = parity_enable ? sreg_rx_q[8:1] : sreg_rx_q[9:2];
  assign frame_err     = rx_valid_q & ~sreg_rx_q[10];
  assign rx_parity_err = parity_enable & rx_valid_q &
                         (^{sreg_rx_q[9:1], parity_odd});

endmodule

