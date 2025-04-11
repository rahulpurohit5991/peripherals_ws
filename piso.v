
// Module: TX_PISO (Parallel-In Serial-Out Shift Register)
// This module takes an 8-bit parallel input and shifts it out serially, 1 bit at a time.

module TX_PISO (clk, rst, load, shift, piso_in, piso_out);
  
  // Inputs
  input clk;              // Clock signal
  input rst;              // Asynchronous reset
  input load;             // Load signal - when high, loads the input data into the register
  input shift;            // Shift signal - when high, shifts the register contents right
  input [7:0] piso_in;    // 8-bit parallel input

  // Output
  output piso_out;        // Serial output (1 bit at a time)
  
  // Internal 8-bit register to hold data
  reg [7:0] temp;

  // Assign the least significant bit (LSB) of temp to the output
  assign piso_out = temp[0];
  
  // Always block triggered on rising edge of clock or reset
  always @ (posedge clk, posedge rst) begin
    if (rst)
      temp <= 0;  // Clear the register on reset
    else begin
      if (load)
        temp <= piso_in;  // Load the parallel input into temp when load is high
      else begin
        if (shift)
          temp <= {1'b0, temp[7:1]};  // Shift right by 1, insert 0 at MSB
        else
          temp <= temp;  // Hold current value (no operation)
      end
    end
  end

endmodule
        
