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
module uart_sram_bridge
#(
  parameter LATCH_DELAY = 1,
  parameter LATCH_DELAY_W = 1
)
(
  input  wire clk50_dup,

	input	 wire [15:0] uart_address,	// address bus to register file
  output wire  [7:0] uart_read_data,	// write data to register file
	input	 wire  [7:0] uart_write_data,	// write data to register file
	input	 wire        uart_write,		// write control to register file
	input	 wire        uart_read,		// read control to register file
	input  wire        uart_req,		// bus access request signal
	output wire        uart_gnt,		// bus access grant signal

	output reg  [9:0] sram_address,
  input  wire [7:0] sram_read_data,
	output reg  [7:0] sram_write_data,
	output wire       sram_write_enable
);

// as for now - hardwire uart to memory
assign uart_read_data = sram_read_data;

wire write_req_granted;
assign write_req_granted = uart_write & uart_gnt;

// count from 0 to LATCH_DELAY starting on write_req_granted signal
reg [LATCH_DELAY_W-1:0] wr_latch_delay;
initial wr_latch_delay = LATCH_DELAY;
always @(posedge clk50_dup)
begin
  if (write_req_granted)
    wr_latch_delay <= 0;
  else if (wr_latch_delay != LATCH_DELAY)
    wr_latch_delay <= wr_latch_delay + 1'b1;
end

assign sram_write_enable = wr_latch_delay < LATCH_DELAY; // set sram_write_enable for LATCH_DELAY clock cycles
assign uart_gnt = !sram_write_enable; // block bus while we write

always @(posedge clk50_dup) // also works with @* (latches instead of flip-flops)
begin
  if (uart_req) // read or write - anyway - address is necessary
  begin
    sram_address <= uart_address[9:0];
  end
  if (write_req_granted)
  begin // latch data and address on write_req_granted signal
	 sram_write_data <= uart_write_data;
  end
end

endmodule
