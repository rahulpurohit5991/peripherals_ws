`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2025 12:13:29 PM
// Design Name: 
// Module Name: prim_subreg_arb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module prim_subreg_arb
// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Write enable and data arbitration logic for register slice conforming to Comportibility guide.





#(
//`include "prim_subreg_pkg.vh"
parameter          DW       = 32,
parameter[2:0] SwAccessRW=3'd0,
parameter[2:0] SwAccessRO = 3'd1,
parameter[2:0] SwAccessWO = 3'd2,
parameter[2:0] SwAccessW1C = 3'd3,
parameter[2:0] SwAccessW1S = 3'd4,
parameter[2:0] SwAccessW0C = 3'd5,
parameter[2:0] SwAccessRC = 3'd6,
parameter          Mubi     = 1'b0,
parameter  SwAccess = SwAccessRW

  
)( 
input          we,
  input [DW-1:0] wd,

  // From HW: valid for HRW, HWO.
  input          de,
  input [DW-1:0] d,

  // From register: actual reg value.
  input [DW-1:0] q,

  // To register: actual write enable and write data.
  output wire          wr_en,
  output wire [DW-1:0] wr_data
);
  `include "prim_mubi_pkg.v"

  if (SwAccess ==SwAccessRW ||SwAccess==SwAccessWO) begin : gen_w
    assign wr_en   = we | de;
    assign wr_data = (we == 1'b1) ? wd : d; // SW higher priority
    // Unused q - Prevent lint errors.
    wire [DW-1:0] unused_q;
    //VCS coverage off
    // pragma coverage off
    assign unused_q = q;
    //VCS coverage on
    // pragma coverage on
  end else if (SwAccess == SwAccessRO) begin : gen_ro
    assign wr_en   = de;
    assign wr_data = d;
    // Unused we, wd, q - Prevent lint errors.
    wire          unused_we;
    wire [DW-1:0] unused_wd;
    wire [DW-1:0] unused_q;
    //VCS coverage off
    // pragma coverage off
    assign unused_we = we;
    assign unused_wd = wd;
    assign unused_q  = q;
    //VCS coverage on
    // pragma coverage on
  end else if (SwAccess == SwAccessW1S) begin : gen_w1s
    // If SwAccess is W1S, then assume hw tries to clear.
    // So, give a chance HW to clear when SW tries to set.
    // If both try to set/clr at the same bit pos, SW wins.
    assign wr_en   = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = mubi4_or_hi((de ? d : q),
                                                    (we ? (wd) :
                                                          MuBi4False));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = mubi8_or_hi((de ? d : q),
                                                    (we ? (wd) :
                                                          MuBi8False));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = mubi12_or_hi((de ? d : q),
                                                     (we ? (wd) :
                                                           MuBi12False));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = mubi16_or_hi((de ? d : q),
                                                     (we ? (wd) :
                                                           MuBi16False));
      end 
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) | (we ? wd : 'b0);
    end
  end else if (SwAccess == SwAccessW1C) begin : gen_w1c
    // If SwAccess is W1C, then assume hw tries to set.
    // So, give a chance HW to set when SW tries to clear.
    // If both try to set/clr at the same bit pos, SW wins.
    assign wr_en   = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = mubi4_and_hi((de ? d : q),
                                                     (we ? (~wd) :
                                                           MuBi4True));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data =mubi8_and_hi((de ? d : q),
                                                     (we ? (~wd) :
                                                           MuBi8True));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = mubi12_and_hi((de ? d : q),
                                                      (we ? (~wd) :
                                                            MuBi12True));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = mubi16_and_hi((de ? d : q),
                                                      (we ? (~wd) :
                                                           MuBi16True));
      end 
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) & (we ? ~wd : 'b1);
    end
  end else if (SwAccess == SwAccessW0C) begin : gen_w0c
    assign wr_en   = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = mubi4_and_hi((de ? d : q),
                                                     (we ?(wd) :
                                                           MuBi4True));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = mubi8_and_hi((de ? d : q),
                                                     (we ? (wd) :
                                                           MuBi8True));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = mubi12_and_hi((de ? d : q),
                                                      (we ? (wd) :
                                                            MuBi12True));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = mubi16_and_hi((de ? d : q),
                                                      (we ? (wd) :
                                                            MuBi16True));
      end 
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) & (we ? wd : 'b1);
    end
  end else if (SwAccess == SwAccessRC) begin : gen_rc
    // This swtype is not recommended but exists for compatibility.
    // WARN: we signal is actually read signal not write enable.
    assign wr_en  = we | de;
    if (Mubi) begin : gen_mubi
      if (DW == 4) begin : gen_mubi4
        assign wr_data = mubi4_and_hi((de ? d : q),
                                                     (we ? MuBi4False :
                                                           MuBi4True));
      end else if (DW == 8) begin : gen_mubi8
        assign wr_data = mubi8_and_hi((de ? d : q),
                                                     (we ? MuBi8False :
                                                           MuBi8True));
      end else if (DW == 12) begin : gen_mubi12
        assign wr_data = mubi12_and_hi((de ? d : q),
                                                      (we ? MuBi12False :
                                                            MuBi12True));
      end else if (DW == 16) begin : gen_mubi16
        assign wr_data = mubi16_and_hi((de ? d : q),
                                                      (we ? (wd) :
                                                            MuBi16True));
      end 
    end else begin : gen_non_mubi
      assign wr_data = (de ? d : q) & (we ? 'b0 : 'b1);
    end
    // Unused wd - Prevent lint errors.
    wire [DW-1:0] unused_wd;
    //VCS coverage off
    // pragma coverage off
    assign unused_wd = wd;
    //VCS coverage on
    // pragma coverage on
  end else begin : gen_hw
    assign wr_en   = de;
    assign wr_data = d;
    // Unused we, wd, q - Prevent lint errors.
    wire          unused_we;
    wire [DW-1:0] unused_wd;
    wire [DW-1:0] unused_q;
    //VCS coverage off
    // pragma coverage off
    assign unused_we = we;
    assign unused_wd = wd;
    assign unused_q  = q;
    //VCS coverage on
    // pragma coverage on
  end

endmodule
