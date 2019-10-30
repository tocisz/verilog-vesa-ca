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
   input clk50_dup,

	input	[15:0]	uart_address,	// address bus to register file
	input	[7:0]	uart_wr_data,	// write data to register file
	input			uart_write,		// write control to register file
	input			uart_read,		// read control to register file
	//output	[7:0]	int_rd_data,	// data read from register file
	input			uart_req,		// bus access request signal
	output		uart_gnt,		// bus access grant signal

	output reg [9:0] sram_address,
	output reg [7:0] sram_write_data,
	output wire      sram_write_enable
);

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
	 sram_write_data <= uart_wr_data;
  end
end

endmodule
