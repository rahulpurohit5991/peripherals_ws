



//Reset values for hwext registers and their fields
parameter [31:0] GPIO_INTR_TEST_RESVAL=32'h0; // Verilog alternative for System Verilog parameter logic
parameter [31:0] GPIO_INTR_TEST_GPIO_RESVAL=32'h0;
parameter [31:0] GPIO_ALERT_TEST_RESVAL=32'h0;
parameter [31:0] GPIO_ALERT_TEST_FATAL_FAULT_RESVAL=32'h0;
parameter [31:0] GPIO_DIRECT_OUT_RESVAL=32'h0;
parameter [31:0] GPIO_MASKED_OUT_LOWER_RESVAL=32'h0;
parameter [31:0] GPIO_MASKED_OUT_UPPER_RESVAL=32'h0;
parameter [31:0] GPIO_DIRECT_OE_RESVAL=32'h0;
parameter [31:0] GPIO_MASKED_OE_LOWER_RESVAL=32'h0;
parameter [31:0] GPIO_MASKED_OE_UPPER_RESVAL=32'h0;

// Address Values
parameter [7-1:0] GPIO_INTR_STATE_OFFSET=7'h0;// Verilog alternative for System Verilog parameter logic
parameter [7-1:0] GPIO_INTR_ENABLE_OFFSET=7'h4;
parameter [7-1:0] GPIO_INTR_TEST_OFFSET=7'h8;
parameter [7-1:0] GPIO_ALERT_TEST_OFFSET=7'hC;
parameter [7-1:0] GPIO_DATA_IN_OFFSET=7'h10;
parameter [7-1:0] GPIO_DIRECT_OUT_OFFSET=7'h14;
parameter [7-1:0] GPIO_MASKED_OUT_LOWER_OFFSET=7'h18;
parameter [7-1:0] GPIO_MASKED_OUT_UPPER_OFFSET=7'h1C;
parameter [7-1:0] GPIO_DIRECT_OE_OFFSET=7'h20;
parameter [7-1:0] GPIO_MASKED_OE_LOWER_OFFSET=7'h24;
parameter [7-1:0] GPIO_MASKED_OE_UPPER_OFFSET=7'h28;
parameter [7-1:0] GPIO_INTR_CTRL_EN_RISING_OFFSET=7'h2C;
parameter [7-1:0] GPIO_INTR_CTRL_EN_FALLING_OFFSET=7'h30;
parameter [7-1:0] GPIO_INTR_CTRL_EN_LVLHIGH_OFFSET=7'h34;
parameter [7-1:0] GPIO_INTR_CTRL_EN_LVLLOW_OFFSET=7'h38;
parameter [7-1:0] GPIO_CTRL_EN_INPUT_FILTER_OFFSET=7'h3C;
parameter [7-1:0] GPIO_HW_STRAPS_DATA_IN_VALID_OFFSET=7'h40;
parameter [7-1:0] GPIO_HW_STRAPS_DATA_IN_OFFSET=7'h44;



 
 



 //  
      `define INTR_ENABLE wire[31:0] intr_enable
      `define INTR_TEST wire[31:0] intr_test
      `define ALERT_TEST wire  alert_test
      `define DIRECT_OUT wire[31:0] direct_out
      `define MASKED_OUT_LOWER wire[15:0] masked_out_lower
      `define MASKED_OUT_UPPER wire [15:0] masked_out_upper
      `define MASKED_OE_LOWER wire[15:0]  masked_oe_lower
      `define MASKED_OE_UPPER wire [15:0] masked_oe_upper
      `define INTR_CTRL_EN_RISING wire[31:0] intr_ctrl_en_rising
      `define INTR_CTRL_EN_FALLING wire[31:0] intr_ctrl_en_falling
      `define INTR_CTRL_EN_LVLHIGH wire[31:0] intr_ctrl_en_lvlhigh
      `define INTR_CTRL_EN_LVLLOW wire[31:0] intr_ctrl_en_lvllow
      `define CTRL_EN_INPUT_FILTER wire[31:0] ctrl_en_input_filter
      `define HW_STRAPS_DATA_IN_VALID wire hw_straps_data_in_valid
      `define INTR_STATE wire[31:0] intr_state
      `define DATA_IN wire[31:0] data_in
      `define DIRECT_OE wire [31:0] direct_oe
      
      `define GPIO_INTR_STATE
      `define GPIO_INTR_ENABLE
      `define GPIO_INTR_TEST
      `define GPIO_ALERT_TEST
      `define GPIO_DATA_IN
      `define GPIO_DIRECT_OUT
      `define GPIO_MASKED_OUT_LOWER
      `define GPIO_MASKED_OUT_UPPER
      `define GPIO_DIRECT_OE
      `define GPIO_MASKED_oe_LOWER
      `define GPIO_MASKED_oe_UPPER
      `define GPIO_INTR_CTRL_EN_RISING// Interrupt Logic
      `define GPIO_INTR_CTRL_EN_FALLING// Interrupt Logic
      `define GPIO_INTR_CTRL_EN_LVLHIGH// Interupt Logic
      `define GPIO_INTR_CTRL_EN_LVLLOW// Interupt Logic
      `define GPIO_CTRL_EN_INPUT_FILTER
      `define GPIO_HW_STRAPS_DATA_IN_VALID
      `define GPIO_HW_STRAPS_DATA_IN
   
       `ifndef REG2HW_REG_VH
       `define REG2HW_REG_VH

       `define REG2HW_INTR_STATE_REG_Q reg[31:0] reg2hw_intr_state_reg_q
       `define REG2HW_INTR_ENABLE_QE reg reg2hw_intr_enable_qe
       `define REG2HW_INTR_ENABLE_REG_Q reg[31:0] reg2hw_intr_enable_reg_q
       `define REG2HW_INTR_TEST_REG_Q reg[31:0] reg2hw_intr_test_reg_q
       `define REG2HW_INTR_TEST_REG_QE reg reg2hw_intr_test_reg_qe
       `define REG2HW_ALERT_TEST_REG_Q reg reg2hw_alert_test_reg_q
       `define REG2HW_ALERT_TEST_REG_QE reg reg2hw_alert_test_reg_qe
       `define REG2HW_DIRECT_OUT_REG_Q reg[31:0] reg2hw_direct_out_reg_q
       `define REG2HW_DIRECT_OUT_REG_QE reg reg2hw_direct_out_reg_qe
       `define REG2HW_MASKED_OUT_LOWER_REG_MASK_Q reg[15:0] reg2hw_masked_out_lower_reg_mask_q
       `define REG2HW_MASKED_OUT_LOWER_REG_MASK_QE reg reg2hw_masked_out_lower_reg_mask_qe
       `define REG2HW_MASKED_OUT_LOWER_REG_DATA_Q reg[15:0]reg2hw_masked_out_lower_reg_data_q
       `define REG2HW_MASKED_OUT_UPPER_REG_MASK_Q reg[15:0] reg2hw_masked_out_upper_reg_mask_q
       `define reg2hw_masked_out_upper_reg_data_q reg[15:0] reg2hw_masked_out_upper_reg_data_q
       `define REG2HW_DIRECT_OE_REG_Q reg[31:0] reg2hw_direct_oe_reg_q
       `define REG2HW_DIRECT_OE_REG_QE reg reg2hw_direct_oe_reg_qe
       `define REG2HW_MASKED_OE_LOWER_REG_MASK_Q reg[15:0] reg2hw_masked_oe_lower_reg_mask_q
       `define REG2HW_MASKED_OE_LOWER_REG_MASK_QE reg reg2hw_masked_oe_lower_reg_mask_qe
       `define REG2HW_MASKED_OE_LOWER_REG_DATA_Q reg[15:0] reg2hw_masked_oe_lower_reg_data_q
       `define REG2HW_MASKED_OE_LOWER_REG_DATA_QE reg reg2hw_masked_oe_lower_reg_data_qe
       `define REG2HW_MASKED_OE_UPPER_REG_MASK_QE reg reg2hw_masked_oe_upper_reg_mask_qe
       `define REG2HW_MASKED_OE_UPPER_REG_DATA_Q reg [15:0] reg2hw_masked_oe_upper_reg_data_q
       `define REG2HW_MASKED_OE_UPPER_REG_DATA_QE reg reg2hw_masked_oe_upper_reg_data_qe
       `define REG2HW_INTR_CTRL_EN_RISING_REG_Q reg[31:0] reg2hw_intr_ctrl_en_rising_reg_q
       `define REG2HW_INTR_CTRL_EN_FALLING_REG_Q reg[31:0] reg2hw_intr_ctrl_en_falling_reg_q
       `define REG2HW_INTR_CTRL_EN_LVLHIGH_REG_Q reg[31:0] reg2hw_intr_ctrl_en_lvlhigh_reg_q
       `define REG2HW_INTR_CTRL_EN_LVLLOW_REG_Q reg[31:0] reg2hw_intr_ctrl_en_lvllow_reg_q
       `define REG2HW_CTRL_EN_INPUT_FILTER_REG_Q reg[31:0] reg2hw_ctrl_en_input_filter_reg_q
       `define REG2HW_STRAPS_DATA_IN_VALID_REG_Q reg reg2hw_hw_straps_data_in_valid_reg_q
       `define REG2HW_STRAPS_DATA_IN_REG_Q reg [31:0] reg2hw_hw_straps_data_in_reg_q

       `endif

        `ifndef HW2REG_REG_VH
        `define HW2REG_REG_VH
        
       `define HW2REG_INTR_STATE_REG_D wire [31:0] hw2reg_intr_state_reg_d
       `define HW2REG_INTR_STATE_REG_DE  wire  hw2reg_intr_state_reg_de
       `define HW2REG_DATA_IN_REG_D  wire [31:0] hw2reg_data_in_reg_d
       `define HW2REG_DATA_IN_REG_DE  wire  hw2reg_data_in_reg_de
       `define HW2REG_DIRECT_OUT_REG_D  wire [31:0] hw2reg_direct_out_reg_d
       `define HW2REG_MASKED_OUT_LOWER_REG_DATA_D wire [15:0] hw2reg_masked_out_lower_reg_data_d
       `define HW2REG_MASKED_OUT_LOWER_REG_MASK_D wire [15:0] hw2reg_masked_out_lower_reg_mask_d
       `define HW2REG_MASKED_OUT_UPPER_REG_DATA_D wire [15:0] hw2reg_masked_out_upper_reg_data_d
       `define HW2REG_MASKED_OUT_UPPER_REG_MASK_D wire [15:0] hw2reg_masked_out_upper_reg_mask_d
       `define HW2REG_DIRECT_OE_REG_D wire [31:0] hw2reg_direct_oe_reg_d
       `define HW2REG_MASKED_OE_LOWER_REG_DATA_D wire [15:0] hw2reg_masked_oe_lower_reg_data_d
       `define HW2REG_MASKED_OE_LOWER_REG_MASK_D wire [15:0] hw2reg_masked_oe_lower_reg_mask_d
       `define HW2REG_MASKED_OE_UPPER_REG_DATA_D wire [15:0] hw2reg_masked_oe_upper_reg_data_d
       `define HW2REG_MASKED_OE_UPPER_REG_MASK_D wire [15:0] hw2reg_masked_oe_upper_reg_mask_d
       `define HW2REG_STRAPS_DATA_IN_VALID_REG_D wire hw2reg_hw_straps_data_in_valid_reg_d
       `define HW2REG_STRAPS_DATA_IN_VALID_REG_DE wire hw2reg_hw_straps_data_in_valid_reg_de
       `define HW2REG_STRAPS_DATA_IN_REG_D wire [31:0] hw2reg_hw_straps_data_in_reg_d
       `define HW2REG_STRAPS_DATA_IN_REG_DE wire hw2reg_hw_straps_data_in_reg_de

       `endif








