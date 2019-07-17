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
(   input  wire clk50,
	 output wire vga_h_sync,
	 output wire vga_v_sync,
	 output reg  vga_R,
	 output reg  vga_G,
	 output reg  vga_B,
	 output wire led1,
	 output wire led2
);

wire clk;
wire clkps;
clkdiv clkdiv
(
	.CLK_IN1(clk50),
	.CLK_OUT1(clk),
	.CLK_OUT2(clkps)
);

wire bout;
clk_div #(25) blink
(
	.clk_in(clk),
	.clk_out(bout)
);
assign led1 = bout;
assign led2 = bout;

wire inDisplayArea;
wire inPrefetchArea;
wire [10:0] CounterX;
wire [10:0] CounterY;
sync_gen_1024x1080 syncgen
(
	.clk(clk),
	.vga_h_sync(vga_h_sync),
	.vga_v_sync(vga_v_sync),
   .inDisplayArea(inDisplayArea),
   .inPrefetchArea(inPrefetchArea),
	.prefetchCounterX(CounterX),
	.counterY(CounterY)
);

wire        filler_read;
wire  [9:0] filler_addr;
wire [15:0] rdata;
assign filler_addr[9:8] = 0;
two_lines filler
(
    .clk(clk),
    .CounterX(CounterX),
    .CounterYparity(CounterY[0]),
    .inDisplayArea(inDisplayArea),
    .inPrefetchArea(inPrefetchArea),
    .read(filler_read),
    .addr(filler_addr[7:0]),
    .data(rdata),
    .image(image)
);

wire gen_read;
wire gen_write;
wire [9:0]  gen_raddr;
wire [9:0]  gen_waddr;
wire [15:0] gen_wdata;
assign gen_raddr[9:8] = 0;
assign gen_waddr[9:8] = 0;
ca_gen gen
(
	.clk(clk),
	.start(CounterY < 11'd 1023 && CounterX == 11'd 1296),
	.direction(CounterY[0]),
	.read(gen_read),
	.raddr(gen_raddr[7:0]),
	.rdata(rdata),
	.write(gen_write),
	.waddr(gen_waddr[7:0]),
	.wdata(gen_wdata)
);

wire rst_write;
wire [9:0]  rst_waddr;
wire [15:0] rst_wdata;
assign rst_waddr[9:8] = 0;
ca_gen0 reset (
    .clk(clk),
    .start(CounterY == 11'd 1023 && CounterX == 11'd 1296),
    .write(rst_write),
    .waddr(rst_waddr[7:0]),
    .wdata(rst_wdata)
);

my_ram image_ram (
  .clka(clkps), // input clka - has to be shifted from clock that generates data and address
  .ena(filler_read || gen_read), // input ena
  .addra(filler_read ? filler_addr : gen_raddr), // input [9 : 0] addra
  .douta(rdata), // output [15 : 0] douta
  .enb(gen_write || rst_write),
  .addrb(gen_write ? gen_waddr : rst_waddr),
  .dinb(gen_write ? gen_wdata : rst_wdata)
);

always @(posedge clk)
begin
  vga_R <= image & inDisplayArea; // one cycle of delay
  vga_G <= image & inDisplayArea; // (because we want no logic after reading signal from register to minimize output delay)
  vga_B <= image & inDisplayArea;
end

endmodule
