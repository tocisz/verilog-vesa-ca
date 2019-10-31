`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:33:35 03/24/2019
// Design Name:
// Module Name:    uart_sram_bridge
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
module uart_sram_bridge0
(
  input  wire clk50_dup,

	input	 wire [15:0] uart_address,	// address bus to register file
  output wire  [7:0] uart_read_data,	// write data to register file
	input	 wire  [7:0] uart_write_data,	// write data to register file
	input	 wire        uart_write,		// write control to register file
	input	 wire        uart_read,		// read control to register file
	input  wire        uart_req,		// bus access request signal
	output wire        uart_gnt,		// bus access grant signal

	output wire [9:0] sram_address,
  input  wire [7:0] sram_read_data,
	output wire [7:0] sram_write_data,
	output wire       sram_write_enable
);

assign sram_address      = uart_address[9:0];
assign sram_write_data   = uart_write_data;
assign uart_read_data    = sram_read_data;
assign sram_write_enable = uart_write;
assign uart_gnt = 1;

endmodule
