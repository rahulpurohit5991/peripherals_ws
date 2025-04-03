//UART transmitter MUX

module TX_MUX (select,data_bit,parity_bit,tx_out);
  input [1:0] select;
  input data_bit; // output of PISO
  input parity_bit; // output of parity block
  output reg tx_out;
  
  always @ (select,data_bit,parity_bit) begin 
    case(select)
      2'b00: tx_out=1'b0; // TX will send start bit
      2'b01: tx_out=data_bit; // TX will send data bit
      2'b10: tx_out=parity_bit; // TX will send parity bit
      2'b11: tx_out=1'b1; // TX will send stop bit
    endcase
  end
endmodule

  