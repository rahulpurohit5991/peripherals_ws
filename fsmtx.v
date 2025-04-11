// Module: TX_FSM (Transmitter Finite State Machine)
// Description: This FSM controls the transmission process for UART
// including start, data, parity, and stop bits.

module TX_FSM(clk, rst, TX_start, select, load, shift, parity_load, TX_busy);

  // Inputs
  input clk;              // Clock signal
  inout rst;              // Asynchronous reset
  input TX_start;         // Trigger to start transmission

  // Outputs
  output reg [1:0] select;      // Controls the MUX to select output bit (start, data, parity, stop)
  output reg load;              // Controls loading data into the shift register
  output reg shift;             // Controls data shifting
  output reg parity_load;       // Triggers parity generation
  output reg TX_busy;           // Indicates transmitter is active/busy

  // Internal counter to track number of data bits transmitted
  reg [2:0] count;              // 3-bit counter (up to 7)
  reg count_en;                 // Counter enable signal

  wire data_done;               // Flag to indicate all 8 bits are transmitted
  assign data_done = (count == 7);

  // FSM States
  parameter IDLE   = 3'b000,    // Idle state
            START  = 3'b001,    // Start bit transmission
            DATA   = 3'b010,    // Data bit transmission
            PARITY = 3'b011,    // Parity bit transmission
            STOP   = 3'b100;    // Stop bit transmission

  reg [2:0] present_state, next_state; // FSM current and next state variables

  // Counter Logic: increments only when enabled, resets on rst or when not enabled
  always @ (posedge clk, posedge rst) begin
    if (rst)
      count <= 0;
    else begin
      if (count_en)
        count <= count + 1;
      else
        count <= 0;
    end
  end

  // State Transition Logic: Updates current state on clock edge or reset
  always @ (posedge clk, posedge rst) begin
    if (rst)
      present_state <= IDLE;
    else
      present_state <= next_state;
  end

  // Next State Logic: Determines the next FSM state based on current state and conditions
  always @ (*) begin
    case (present_state)
      IDLE:   if (TX_start) next_state = START;
              else next_state = IDLE;

      START:  next_state = DATA;              // Remain for 1 cycle to send start bit

      DATA:   if (data_done) next_state = PARITY;
              else next_state = DATA;         // Remain in DATA until all bits are sent

      PARITY: next_state = STOP;              // 1 cycle for parity bit

      STOP:   if (TX_start) next_state = START;
              else next_state = IDLE;         // Transition to IDLE or back to START

      default: next_state = IDLE;
    endcase
  end

  // Output Logic: Generates control signals based on current FSM state
  always @ (*) begin
    case (present_state)
      
      IDLE: begin
        select = 2'b11;       // Send '1' during idle (line high)
        load = 1'b0;
        shift = 1'b0;
        parity_load = 1'b0;
        TX_busy = 1'b0;
        count_en = 1'b0;
      end
      
      START: begin
        select = 2'b00;       // Send '0' as start bit
        load = 1'b1;          // Load data into shift register
        shift = 1'b0;
        parity_load = 1'b1;   // Load/generate parity
        TX_busy = 1'b1;
        count_en = 1'b0;
      end

      DATA: begin
        select = 2'b01;       // Select serial data output
        load = 1'b0;
        shift = 1'b1;         // Enable data shifting
        parity_load = 1'b0;
        TX_busy = 1'b1;
        count_en = 1'b1;      // Enable counter
      end

      PARITY: begin
        select = 2'b10;       // Send parity bit
        load = 1'b0;
        shift = 1'b0;
        parity_load = 1'b0;
        TX_busy = 1'b1;
        count_en = 1'b0;
      end

      STOP: begin
        select = 2'b11;       // Send stop bit (logic high)
        load = 1'b0;
        shift = 1'b0;
        parity_load = 1'b0;
        TX_busy = 1'b1;
        count_en = 1'b0;
      end

    endcase
  end

endmodule
