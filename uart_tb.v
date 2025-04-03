// Code your testbench here
// or browse Examples
module TEST_UART_RX;
  
  reg clk;
  reg rst;
  reg TX_start;
  reg [7:0] DATA_in;
  
  wire [7:0] DATA_out;
  wire parity_error;
  wire stop_error;
  wire op_valid;
  
  
  
  UART dut (clk,rst,TX_start,DATA_in,TX_busy,DATA_out,parity_error,stop_error,op_valid);
   
    always #5 clk=!clk; 
    
    task initialize;
      begin
      clk=0;
      rst=0;
     DATA_in=0;
     TX_start=0;
      end
    endtask
    
    task reset;
      begin
        rst=1;
        #0.002;
        rst=0;
      end
    endtask
    
    task data;
      begin
        @(negedge clk); 
       TX_start=1;
        DATA_in=8'hdd;
        @ (posedge op_valid);
         @(negedge clk); 
        TX_start=1;
        DATA_in=8'hda;
        @ (posedge op_valid);
         @(negedge clk);
        TX_start = 1;
        DATA_in=8'hd0;
        @ (posedge op_valid);
         @(negedge clk); 
     
       #1000 $finish;
      end
    endtask
    
    initial begin 
      $dumpfile("UART.vcd");
      $dumpvars;
      initialize;
      reset;
      data;
     
    end
  always @ (posedge op_valid) $strobe ("op_data=%h",DATA_out);
  endmodule