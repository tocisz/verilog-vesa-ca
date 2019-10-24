`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    00:22:51 02/22/2019
// Design Name:
// Module Name:    my_ram
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module my_ram2(
  input clk_a,
  input clk_b,
  input en_a,
  input en_b,
  input [9:0] addr_a,
  input [9:0] addr_b,
  input  [7:0] data_in_a,
  output [7:0] data_out_b
);

wire [7:0] not_connected1;
wire [1:0] not_connected2;
wire [15:0] not_connected3;
wire [1:0] not_connected4;

wire _unused_ok = &{1'b0,
  not_connected1,
  not_connected2,
  not_connected3,
  not_connected4,
1'b0};

   // RAMB8BWER: 8k-bit Data and 1k-bit Parity Configurable Synchronous Block RAM
   //            Spartan-6
   // Xilinx HDL Language Template, version 14.7

   RAMB8BWER #(
      // DATA_WIDTH_A/DATA_WIDTH_B: 'If RAM_MODE="TDP": 0, 1, 2, 4, 9 or 18; If RAM_MODE="SDP": 36'
      .DATA_WIDTH_A(9),
      .DATA_WIDTH_B(9),
      // DOA_REG/DOB_REG: Optional output register (0 or 1)
      .DOA_REG(0),
      .DOB_REG(1),
      // EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      .EN_RSTRAM_A("TRUE"),
      .EN_RSTRAM_B("TRUE"),
      // INITP_00 to INITP_03: Initial memory contents.
      .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
      // INIT_00 to INIT_1F: Initial memory contents.
      .INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
      .INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
      // INIT_A/INIT_B: Initial values on output port
      .INIT_A(18'h00000),
      .INIT_B(18'h00000),
      // INIT_FILE: Not Supported
      .INIT_FILE("NONE"),                                                               // Do not modify
      // RAM_MODE: "SDP" or "TDP" 
      .RAM_MODE("TDP"),
      // RSTTYPE: "SYNC" or "ASYNC" 
      .RSTTYPE("SYNC"),
      // RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      .RST_PRIORITY_A("CE"),
      .RST_PRIORITY_B("CE"),
      // SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      .SIM_COLLISION_CHECK("ALL"),
      // SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      .SRVAL_A(18'h00000),
      .SRVAL_B(18'h00000),
      // WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST") 
   )
   RAMB8BWER_inst (
      // Port A Data: 16-bit (each) output: Port A data
      .DOADO(not_connected3),             // 16-bit output: A port data/LSB data output
      .DOPADOP(not_connected2),         // 2-bit output: A port parity/LSB parity output
      // Port B Data: 16-bit (each) output: Port B data
      .DOBDO({not_connected1, data_out_b}),             // 16-bit output: B port data/MSB data output
      .DOPBDOP(not_connected4),         // 2-bit output: B port parity/MSB parity output
      // Port A Address/Control Signals: 13-bit (each) input: Port A address and control signals (write port
      // when RAM_MODE="SDP")
      .ADDRAWRADDR({addr_a, 3'b000}),      // 13-bit input: A port address/Write address input
      .CLKAWRCLK(clk_a),         // 1-bit input: A port clock/Write clock input
      .ENAWREN(en_a),            // 1-bit input: A port enable/Write enable input
      .REGCEA(1'b1),             // 1-bit input: A port register enable input
      .RSTA(1'b0),               // 1-bit input: A port set/reset input
      .WEAWEL(2'b11),            // 2-bit input: A port write enable input
      // Port A Data: 16-bit (each) input: Port A data
      .DIADI({8'd0, data_in_a}),             // 16-bit input: A port data/LSB data input
      .DIPADIP(2'b00),         // 2-bit input: A port parity/LSB parity input
      // Port B Address/Control Signals: 13-bit (each) input: Port B address and control signals (read port
      // when RAM_MODE="SDP")
      .ADDRBRDADDR({addr_b, 3'b000}),  // 13-bit input: B port address/Read address input
      .CLKBRDCLK(clk_b),     // 1-bit input: B port clock/Read clock input
      .ENBRDEN(en_b),        // 1-bit input: B port enable/Read enable input
      .REGCEBREGCE(1'b1),    // 1-bit input: B port register enable/Register enable input
      .RSTBRST(1'b0),        // 1-bit input: B port set/reset input
      .WEBWEU(2'b00),        // 2-bit input: B port write enable input
      // Port B Data: 16-bit (each) input: Port B data
      .DIBDI(16'b0),             // 16-bit input: B port data/MSB data input
      .DIPBDIP(2'b0)          // 2-bit input: B port parity/MSB parity input
   );

   // End of RAMB8BWER_inst instantiation

endmodule
