// Module: RX_FSM (Receive Finite State Machine)
// Description:
// Controls the receive operation of a UART receiver,
// handling states: IDLE, DATA, PARITY, and STOP,
// and manages sampling and shifting of incoming serial bits.

module RX_FSM (
  clk,                   // System clock
  rst,                   // Asynchronous reset
  start_bit_detected,    // Asserted when start bit (0) is detected
  run_shift,             // Control to shift data into shift register
  parity_load,           // Load parity for checking
  parity_error,          // Indicates if parity mismatch is found
  chk_stop,              // Signal to check stop bit
  sample_done            // Indicates one full bit has been sampled (mid-bit sampling)
);

  // Inputs
  input clk;
  input rst;
  input start_bit_detected;
  input parity_error;

  // Outputs
  output reg run_shift;
  output reg parity_load;
  output reg chk_stop;
  output sample_done;

  // Internal Registers
  reg [3:0] bcount;       // Counts clocks for mid-bit sampling (e.g., 8 clocks per bit)
  reg [3:0] count;        // Counts received bits (up to 11: 1 start + 8 data + 1 parity + 1 stop)
  wire data_done;         // Asserted when full frame is received
  reg count_en;           // Enables bit counting when in DATA state

  // FSM States
  parameter IDLE   = 2'b00,
            DATA   = 2'b01,
            PARITY = 2'b10,
            STOP   = 2'b11;

  reg [1:0] present_state, next_state;

  // ---------------------------------------
  // bcount: Bit sample clock counter
  // Resets in IDLE, counts up in all other states
  // Used to determine sample_done (i.e., 8 clocks = 1 bit time)
  // ---------------------------------------
  always @ (posedge clk, posedge rst) begin
    if (rst)
      bcount <= 0;
    else if (present_state != IDLE)
      bcount <= bcount + 1;
    else
      bcount <= 0;
  end

  assign sample_done = (bcount == 7);  // Indicates middle of bit time (ideal sample point)

  // ---------------------------------------
  // count: Bit counter to count total received bits
  // Increments only when sample_done is high
  // ---------------------------------------
  always @ (posedge clk, posedge rst) begin
    if (rst)
      count <= 0;
    else if (count_en) begin
      if (sample_done)
        count <= count + 1;
    end else
      count <= 0;
  end

  assign data_done = (count == 11); // 11 bits received (start + 8 data + parity + stop)

  // ---------------------------------------
  // FSM State Register
  // ---------------------------------------
  always @ (posedge clk, posedge rst) begin
    if (rst)
      present_state <= IDLE;
    else
      present_state <= next_state;
  end

  // ---------------------------------------
  // FSM Next State Logic
  // ---------------------------------------
  always @ (*) begin
    case (present_state)
      IDLE: begin
        if (start_bit_detected)
          next_state = DATA;
        else
          next_state = IDLE;
      end

      DATA: begin
        if (data_done)
          next_state = PARITY;
        else
          next_state = DATA;
      end

      PARITY: begin
        if (parity_error)
          next_state = IDLE; // Abort if parity error
        else
          next_state = STOP;
      end

      STOP: next_state = IDLE; // End of frame; return to IDLE
    endcase
  end

  // ---------------------------------------
  // FSM Output Logic
  // ---------------------------------------
  always @ (present_state) begin
    case (present_state)
      IDLE: begin
        count_en     = 0;
        run_shift    = 0;
        parity_load  = 0;
        chk_stop     = 0;
      end

      DATA: begin
        count_en     = 1;
        run_shift    = 1;
        parity_load  = 0;
        chk_stop     = 0;
      end

      PARITY: begin
        count_en     = 0;
        run_shift    = 0;
        parity_load  = 1;
        chk_stop     = 0;
      end

      STOP: begin
        count_en     = 0;
        run_shift    = 0;
        parity_load  = 0;
        chk_stop     = 1; // Check stop bit value
      end
    endcase
  end

endmodule
