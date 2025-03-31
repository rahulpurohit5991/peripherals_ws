module TX #(
    parameter DATAWIDTH = 8,
    parameter OVERSAMPLING = 16
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         bclk,
    input  wire         parEnable,
    input  wire         parityType,
    input  wire         dataValid,
    input  wire [DATAWIDTH-1:0] dataInput,
    output reg          tx_out,
    output wire         tx_done
);

    // Internal signals declaration
    wire [2:0] muxSelector;
    wire       serializerEn;
    wire       SerializerDn;
    wire       parityBit;
    reg  [4:0] BAUD_COUNTER;
    reg  [2:0] current_state, next_state;
    
    // State machine parameters
    localparam IDLE   = 0,
               START  = 1,
               DATA   = 2,
               PARITY = 3,
               STOP   = 4;

    // Serializer signals
    reg [DATAWIDTH-1:0] serializer_mem;
    reg [$clog2(DATAWIDTH):0] serializer_ptr;
    
    // Parity calculator signals
    reg [DATAWIDTH-1:0] parity_mem;

    // FSM Control Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            BAUD_COUNTER <= 0;
        end else begin
            current_state <= next_state;
            if (bclk) BAUD_COUNTER <= BAUD_COUNTER + 1;
            if (BAUD_COUNTER == OVERSAMPLING) BAUD_COUNTER <= 0;
        end
    end

    // State transitions
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (dataValid) next_state = START;
            START:  if (BAUD_COUNTER == OVERSAMPLING) next_state = DATA;
            DATA:   if (SerializerDn) next_state = parEnable ? PARITY : STOP;
            PARITY: if (BAUD_COUNTER == OVERSAMPLING) next_state = STOP;
            STOP:   if (BAUD_COUNTER == OVERSAMPLING) next_state = IDLE;
        endcase
    end

    // Serializer Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            serializer_mem <= 0;
            serializer_ptr <= 0;
        end else begin
            if (dataValid) begin
                serializer_mem <= dataInput;
                serializer_ptr <= 0;
            end
            else if (serializerEn) begin
                serializer_mem <= serializer_mem >> 1;
                serializer_ptr <= serializer_ptr + 1;
            end
        end
    end
    assign SerializerDn = (serializer_ptr == DATAWIDTH);

    // Parity Calculator
    always @(posedge clk or negedge rst) begin
        if (!rst) parity_mem <= 0;
        else if (dataValid) parity_mem <= dataInput;
    end
    wire parity_calc = ^parity_mem;
    assign parityBit = parityType ? ~parity_calc : parity_calc;

    // Output MUX
    always @(*) begin
        case (muxSelector)
            IDLE:   tx_out = 1'b1;
            START:  tx_out = 1'b0;
            DATA:   tx_out = serializer_mem[0];
            PARITY: tx_out = parityBit;
            STOP:   tx_out = 1'b1;
            default: tx_out = 1'b1;
        endcase
    end

    // Control signals
    assign muxSelector = current_state;
    assign serializerEn = (current_state == DATA) && (BAUD_COUNTER == OVERSAMPLING);
    assign tx_done = (current_state == STOP) && (BAUD_COUNTER == OVERSAMPLING);

endmodule