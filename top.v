`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:31:51 02/21/2019
// Design Name:
// Module Name:    top
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
module top
(
   input  wire clk50,
   output wire vga_h_sync,
   output wire vga_v_sync,
   output wire vga_R,
   output wire vga_G,
   output wire vga_B,
   output wire led1,
   output wire led2,	
//input 			reset;			// global reset input 
   input  wire ser_in,			// serial data input 
   output wire ser_out		// serial data output 
);

assign led1 = 1'b1;
assign led2 = 1'b1;

wire [9:0] debug_ram_addr;
wire [7:0] debug_ram_data;
wire [9:0] test_ram_addr;
wire [7:0] test_ram_data;

wire clk108;
wire clk108ps;
clkdiv clkdiv
(
  .CLK_IN1(clk50),
  .CLK_OUT1(clk108),
  .CLK_OUT2(clk108ps),
  .CLK_OUT3(clk50_dup),
  .CLK_OUT4(clk50ps)
);

wire  [15:0]	int_address;	// address bus to register file 
wire	[7:0]	   int_wr_data;	// write data to register file 
wire	[7:0]	   int_rd_data;	// write data to register file 
wire			int_write;		// write control to register file 
wire			int_read;		// read control to register file 
wire			int_req;		// bus access request signal

reg [9:0] write_addr;
reg [7:0] write_data;
wire      write_enable;

wire int_gnt;

uart2bus_top uart1 (
 .clock(clk50_dup), 
 .reset(1'b0), 
 .ser_in(ser_in), 
 .ser_out(ser_out), 

 .int_address(int_address), 
 .int_wr_data(int_wr_data), 
 .int_write(int_write), 
 .int_rd_data(int_rd_data), //(write_addr[7:0]), 
 .int_read(int_read), 
 .int_req(int_req),
 .int_gnt(int_gnt)
);

wire int_wr_req_gnt;
assign int_wr_req_gnt = int_write & int_gnt;

`define LATCH_DELAY 1
// count from 0 to LATCH_DELAY starting on int_wr_req_gnt signal
reg [0:0] wr_latch_delay;
initial wr_latch_delay = `LATCH_DELAY;
always @(posedge clk50_dup)
begin
  if (int_wr_req_gnt)
    wr_latch_delay <= 0;
  else if (wr_latch_delay != `LATCH_DELAY)
    wr_latch_delay <= wr_latch_delay + 1'b1;
end

assign write_enable = wr_latch_delay < `LATCH_DELAY; // set write_enable for LATCH_DELAY clock cycles
assign int_gnt = !write_enable; // block bus while we write

always @(posedge clk50_dup) // also works with @* (latches instead of flip-flops)
begin
  if (int_req) // read or write - anyway - address is necessary
  begin
    write_addr <= int_address[9:0];
  end
  if (int_wr_req_gnt)
  begin // latch data and address on int_wr_req_gnt signal
	 write_data <= int_wr_data;
  end
end

binary_display display
(
    .clk(clk108), 
    .vga_h_sync(vga_h_sync), 
    .vga_v_sync(vga_v_sync), 
    .vga_R(vga_R), 
    .vga_G(vga_G), 
    .vga_B(vga_B),
    .ram_addr(debug_ram_addr), 
    .ram_data(debug_ram_data)
);

my_ram2 debug_ram (
    .clk_a(clk50ps),
    .clk_b(clk108ps),
    .en_a(write_enable),
    .en_b(1'b1),
    .addr_a(write_addr),
    .addr_b(debug_ram_addr),
    .data_in_a(write_data),
    .data_out_b(debug_ram_data),
	 .data_out_a(int_rd_data)
);

endmodule
