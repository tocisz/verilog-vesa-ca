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
   output wire led2
);

assign led1 = 1'b0;
assign led2 = 1'b0;

wire       debug_ram_clk;
wire [9:0] debug_ram_addr;
wire [7:0] debug_ram_data;

binary_display display
(
    .clk50(clk50), 
    .vga_h_sync(vga_h_sync), 
    .vga_v_sync(vga_v_sync), 
    .vga_R(vga_R), 
    .vga_G(vga_G), 
    .vga_B(vga_B),
	 .ram_clk(debug_ram_clk),
    .ram_addr(debug_ram_addr), 
    .ram_data(debug_ram_data)
);

my_ram2 debug_ram (
    .clk_a(1'b0),
    .clk_b(debug_ram_clk),
    .en_a(1'b0),
    .en_b(1'b1),
    .addr_a(10'b0),
    .addr_b(debug_ram_addr),
    .data_in_a(8'b0),
    .data_out_b(debug_ram_data)
);

endmodule
