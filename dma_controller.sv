//DMA ports for communication with high speed TileLink bus, DMA configuration register values as input 


module dma #(
  parameter ADDR_WIDTH   = 32,
  parameter DATA_WIDTH   = 32,
  parameter MASK_WIDTH   = DATA_WIDTH/8,
  parameter SIZE_WIDTH   = 3,
  parameter SRC_WIDTH    = 2,
  parameter SINK_WIDTH   = 1,
  parameter OPCODE_WIDTH = 3,
  parameter PARAM_WIDTH  = 3
);

  (
  // TL-Main Channel-A port connection
  output  logic               a_valid,
  input logic               a_ready,
  output  logic [OPCODE_WIDTH-1:0]  a_opcode,
  output  logic [PARAM_WIDTH-1:0]   a_param,
  output  logic [SIZE_WIDTH-1:0]    a_size,
  output  logic [SRC_WIDTH-1:0]     a_source,
  output  logic [ADDR_WIDTH-1:0]    a_address,
  output  logic [MASK_WIDTH-1:0]    a_mask,
  output  logic [DATA_WIDTH-1:0]    a_data,
  
  
  
  // TL-Main Channel-D port connection
  input logic               d_valid,
  output  logic              d_ready,
  input logic [OPCODE_WIDTH-1:0]  d_opcode,
  input logic [PARAM_WIDTH-1:0]   d_param,
  input logic [SIZE_WIDTH-1:0]    d_size,
  input logic [SRC_WIDTH-1:0]     d_source,
  input logic [SINK_WIDTH-1:0]    d_sink,
  input logic [DATA_WIDTH-1:0]    d_data,
  input logic                d_error,
  

    //DMA config register values, and control/status signals
  
  input logic [ADDR_WIDTH-1:0] src_addr;
  input logic [	ADDR_WIDTH-1:0] dst_addr;
  input logic [TRANSFER_BYTES_WIDTH-1:0] trnsfr_size;
  input logic go;
  output logic done;
  output logic error;
  output logic interrupt;
  output logic bus_rqst;
  input logic bus_grnt;
  
  );
  
  
  localparam TRANSFER_BYTES_WIDTH;
  
  
  logic clear_go;
  logic [2:0] error_code;
  
  
  assign  
  
  //in progress
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
