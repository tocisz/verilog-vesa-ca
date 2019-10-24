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
  .CLK_OUT3(clk50_dup)
);

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

wire slow_clk;
clk_div
#(
 .BITS(18)
)
slow_one
(
 .clk_in(clk50_dup),
 .clk_out(slow_clk) // ~191 Hz
);

rolling_counter test
(
 .clk(slow_clk), 
 .ram_addr(test_ram_addr), 
 .ram_data(test_ram_data)
);


my_ram2 debug_ram (
    .clk_a(slow_clk),
    .clk_b(clk108ps),
    .en_a(1'b1),
    .en_b(1'b1),
    .addr_a(test_ram_addr),
    .addr_b(debug_ram_addr),
    .data_in_a(test_ram_data),
    .data_out_b(debug_ram_data)
);

endmodule
