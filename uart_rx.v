module RX #(
    parameter DATAWIDTH = 8,
    parameter OVERSAMPLING = 16
)(
    input  wire         bclk,
    input  wire         clk,
    input  wire         rst,
    input  wire         parEnable,
    input  wire         parityType,
    input  wire         rx_in,
    output wire [DATAWIDTH-1:0] rx_out,
    output wire         pCheckError,
    output wire         pCheckValid,
    output wire         rx_done,
    output wire         framingError
);

    // Internal signals
    reg [2:0] current_state, next_state;
    reg [4:0] baud_counter;
    reg [DATAWIDTH-1:0] deserializer_mem;
    reg [$clog2(DATAWIDTH):0] deserializer_ptr;
    reg parity_check_en;
    reg deserializer_en;
    reg receiver_busy;
    reg receiver_done;
    
    // State parameters
    localparam IDLE   = 0,
               START = 1,
               DATA  = 2,
               PARITY = 3,
               STOP  = 4;

    // Main state machine and control logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            baud_counter <= 0;
            deserializer_mem <= 0;
            deserializer_ptr <= 0;
        end else begin
            current_state <= next_state;
            
            // Baud counter handling
            if (bclk) begin
                if (baud_counter == OVERSAMPLING)
                    baud_counter <= 0;
                else
                    baud_counter <= baud_counter + 1;
            end
            
            // Deserializer logic
            if (receiver_done) begin
                deserializer_mem <= 0;
                deserializer_ptr <= 0;
            end
            else if (deserializer_en) begin
                deserializer_mem <= {rx_in, deserializer_mem[DATAWIDTH-1:1]};
                deserializer_ptr <= deserializer_ptr + 1;
            end
        end
    end

    // State transitions
    always @(*) begin
        // Default values
        next_state = current_state;
        deserializer_en = 0;
        receiver_done = 0;
        parity_check_en = 0;
        receiver_busy = 1;
        framingError = 0;

        case (current_state)
            IDLE: begin
                receiver_busy = 0;
                if (!rx_in) begin
                    next_state = START;
                    baud_counter = 0;
                end
            end
            
            START: begin
                if (baud_counter == (OVERSAMPLING/2)) begin
                    next_state = DATA;
                    baud_counter = 0;
                end
            end
            
            DATA: begin
                if (deserializer_ptr == DATAWIDTH) begin
                    next_state = parEnable ? PARITY : STOP;
                    baud_counter = 0;
                end
                else if (baud_counter == OVERSAMPLING) begin
                    deserializer_en = 1;
                    baud_counter = 0;
                end
            end
            
            PARITY: begin
                if (baud_counter == OVERSAMPLING) begin
                    next_state = STOP;
                    parity_check_en = 1;
                    baud_counter = 0;
                end
            end
            
            STOP: begin
                if (baud_counter == OVERSAMPLING) begin
                    next_state = IDLE;
                    receiver_done = 1;
                    framingError = !rx_in;
                end
            end
        endcase
    end

    // Parity check logic
    wire calculated_parity = ^deserializer_mem;
    wire expected_parity = parityType ? ~calculated_parity : calculated_parity;
    reg parity_error;
    
    always @(posedge clk) begin
        if (parity_check_en)
            parity_error <= (rx_in != expected_parity);
    end

    // Output assignments
    assign rx_out = deserializer_mem;
    assign pCheckError = parity_error && parEnable;
    assign pCheckValid = parity_check_en;
    assign rx_done = receiver_done;

endmodule