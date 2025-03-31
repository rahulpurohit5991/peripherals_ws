module UART_TOP_TB;

    localparam DATAWIDTH = 8, OVERSAMPLING = 16;
    localparam PERIOD = 10;
    
    // System Signals
    reg clk_tb, rst_tb;
    reg [11:0] DIV = 2;
    
    // Transmitter Signals
    reg tx_parEnable_tb, tx_parityType_tb;
    reg tx_dataValid_tb;
    reg [DATAWIDTH-1:0] tx_dataInput_tb;
    
    // Receiver Signals
    reg rx_parEnable_tb, rx_parityType_tb;
    
    // Common Signals
    wire tx_out_wire;
    wire rx_in_wire = tx_out_wire; // Loopback connection
    
    // Status Signals
    wire tx_busy_tb, tx_done_tb;
    wire [DATAWIDTH-1:0] rx_out_tb;
    wire rx_pCheckError_tb, rx_pCheckValid_tb;
    wire rx_done_tb, rx_framingError_tb;
    
    // Baud Generator
    wire bclk;
    
    // Instantiate UART Modules
    UART_TOP #(
        .DATAWIDTH(DATAWIDTH),
        .OVERSAMPLING(OVERSAMPLING)
    uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .bclk(bclk),
        .tx_parEnable(tx_parEnable_tb),
        .tx_dataValid(tx_dataValid_tb),
        .tx_parityType(tx_parityType_tb),
        .tx_dataInput(tx_dataInput_tb),
        .rx_parEnable(rx_parEnable_tb),
        .rx_parityType(rx_parityType_tb),
        .tx_out(tx_out_wire),
        .rx_in(rx_in_wire),
        .tx_busy(tx_busy_tb),
        .tx_done(tx_done_tb),
        .rx_out(rx_out_tb),
        .rx_pCheckError(rx_pCheckError_tb),
        .rx_pCheckValid(rx_pCheckValid_tb),
        .rx_busy(rx_busy_tb),
        .rx_done(rx_done_tb),
        .rx_framingError(rx_framingError_tb)
    );

    BAUD_RATE_GENERATOR BRG (
        .clk(clk_tb),
        .rst(rst_tb),
        .div(DIV),
        .bclk(bclk)
    );

    // Clock Generation
    always #(PERIOD/2) clk_tb = ~clk_tb;

    // Main Test Sequence
    initial begin
        initialization;
        
        // Test 1: Basic Transmission without Parity
        send_and_verify(8'b10101010, 0, 0, 0, 0);
        
        // Test 2: Even Parity Check
        send_and_verify(8'b11001100, 1, 0, 1, 0);
        
        // Test 3: Odd Parity Check
        send_and_verify(8'b11110000, 1, 1, 1, 1);
        
        // Test 4: Framing Error Test
        force_framing_error;
        
        #100 $stop;
    end

    // Tasks from Reference Testbenches
    task initialization;
        begin
            clk_tb = 0;
            rst_tb = 1;
            tx_parEnable_tb = 0;
            tx_parityType_tb = 0;
            tx_dataValid_tb = 0;
            rx_parEnable_tb = 0;
            rx_parityType_tb = 0;
            tx_dataInput_tb = 0;
            
            #(PERIOD*2) rst_tb = 0;
            #(PERIOD*2) rst_tb = 1;
            $display("System Initialized @%0t", $time);
        end
    endtask

    task send_and_verify;
        input [DATAWIDTH-1:0] data;
        input tx_par_en, tx_par_type;
        input rx_par_en, rx_par_type;
        begin
            // Configure Parity
            tx_parEnable_tb = tx_par_en;
            tx_parityType_tb = tx_par_type;
            rx_parEnable_tb = rx_par_en;
            rx_parityType_tb = rx_par_type;
            
            // Send Data
            writeData(data);
            
            // Receive and Verify
            receiveData(data);
            
            // Additional Verification
            if(rx_pCheckError_tb && rx_par_en)
                $display("Parity Error Detected @%0t (Expected)", $time);
                
            if(rx_framingError_tb)
                $display("Framing Error Detected @%0t", $time);
        end
    endtask

    task writeData;
        input [DATAWIDTH-1:0] data;
        integer timeout;
        begin
            $display("\n[TX] Sending Data: %b @%0t", data, $time);
            tx_dataInput_tb = data;
            tx_dataValid_tb = 1;
            
            // Wait for transmission start
            timeout = 0;
            while(!tx_busy_tb && timeout < 100) begin
                #(PERIOD);
                timeout = timeout + 1;
            end
            tx_dataValid_tb = 0;
            
            // Wait for completion
            wait(tx_done_tb);
            $display("[TX] Transmission Complete @%0t", $time);
        end
    endtask

    task receiveData;
        input [DATAWIDTH-1:0] expected_data;
        integer timeout;
        begin
            $display("[RX] Waiting for Data... @%0t", $time);
            timeout = 0;
            
            // Wait for reception completion
            while(!rx_done_tb && timeout < 1000) begin
                #(PERIOD);
                timeout = timeout + 1;
            end
            
            if(timeout >= 1000) begin
                $display("[RX] Error: Reception Timeout @%0t", $time);
                return;
            end
            
            // Verify Received Data
            $display("[RX] Received Data: %b @%0t", rx_out_tb, $time);
            if(rx_out_tb === expected_data)
                $display("[RX] Data Match Successful!");
            else
                $display("[RX] Data Mismatch! Expected: %b", expected_data);
        end
    endtask

    task force_framing_error;
        begin
            $display("\nTesting Framing Error...");
            writeData(8'b11111111);
            
            // Force stop bit low
            #((DIV*OVERSAMPLING*12)*PERIOD)
            force rx_in_wire = 0;
            #(PERIOD*10)
            release rx_in_wire;
        end
    endtask

    // Monitoring Tasks
    task displayTestbenchData;
        input string prefix;
        begin
            $display("[%s] TX State: %0d, RX State: %0d | TX Data: %b, RX Data: %b | Baud Count: %0d/%0d",
                   prefix,
                   uut.u_tx.current_state,
                   uut.u_rx.current_state,
                   tx_dataInput_tb,
                   rx_out_tb,
                   uut.u_tx.BAUD_COUNTER,
                   uut.u_rx.baud_counter);
        end
    endtask

    // Continuous Monitoring
    always @(posedge clk_tb) begin
        displayTestbenchData("MONITOR");
    end

    
    always @(posedge rx_done_tb) begin
        if(rx_out_tb !== tx_dataInput_tb)
            $display("ERROR: Data mismatch! TX: %b, RX: %b @%0t",
                    tx_dataInput_tb, rx_out_tb, $time);
    end

endmodule