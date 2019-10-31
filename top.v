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


wire [9:0] debug_ram_addr;
wire [7:0] debug_ram_data;

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

wire  [15:0]	uart_address_o;	// address bus to register file
wire	[7:0]	  uart_write_data_o;	// write data to register file
wire	[7:0]	  uart_read_data_i;	// write data to register file
wire			uart_write_o;		// write control to register file
wire			uart_read_o;		// read control to register file
wire			uart_req_o;		// bus access request signal
wire      uart_gnt_i;

wire [9:0] sram_address;
wire [7:0] sram_read_data;
wire [7:0] sram_write_data;
wire       sram_write_enable;

uart_sram_bridge bridge (
    .clk50_dup(clk50_dup),

    .uart_address(uart_address_o),
    .uart_write_data(uart_write_data_o),
    .uart_read_data(uart_read_data_i),
    .uart_write(uart_write_o),
    .uart_read(uart_read_o),
    .uart_req(uart_req_o),
    .uart_gnt(uart_gnt_i),

    .sram_address(sram_address),
    .sram_read_data(sram_read_data),
    .sram_write_data(sram_write_data),
    .sram_write_enable(sram_write_enable)
);

uart2bus_top uart1 (
 .clock(clk50_dup),
 .reset(1'b0),
 .ser_in(ser_in),
 .ser_out(ser_out),

 .int_address(uart_address_o),
 .int_wr_data(uart_write_data_o),
 .int_write(uart_write_o),
 .int_rd_data(uart_read_data_i),
 .int_read(uart_read_o),
 .int_req(uart_req_o),
 .int_gnt(uart_gnt_i)
);

my_ram2 debug_ram (
    .clk_a(clk50ps),
    .clk_b(clk108ps),
    .en_a(sram_write_enable),
    .en_b(1'b1),
    .addr_a(sram_address),
    .addr_b(debug_ram_addr),
    .data_in_a(sram_write_data),
    .data_out_b(debug_ram_data),
	  .data_out_a(sram_read_data)
);

endmodule
