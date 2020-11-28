`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:26:10 02/21/2019
// Design Name:
// Module Name:    sync_gen_1280x1024
// Project Name:
// Target Devices:
// Tool versions:
// Description: 
//////////////////////////////////////////////////////////////////////////////////
module sync_gen_1280x1024(
	input  wire      clk,
	output reg       vga_h_sync,
	output reg       vga_v_sync,
	output reg       inDisplayArea,
	output reg       inPrefetchArea,
	output reg [10:0] prefetchCounterX, // aligned to visible area (minus FRONT_MARGIN)
	output reg [10:0] counterY // aligned to visible area
);

reg [10:0] counterX; // aligned to sync signal
`define FRONT_MARGIN 16

/*
STANDARD
Pixel clock: 108.0
Horizontal:
 - visible area - 1280 0
 - front porch  - 48   1280
 - sync pulse   - 112  1328
 - back porch   - 248  1440
 - line         - 1688

Vertical:
 - visible area - 1024 0
 - front porch  - 1    1024
 - sync pulse   - 3    1025
 - back porch   - 38   1028
 - line         - 1066

*/

//////////////////////////////////////////////////
wire counterXmaxed = (counterX == 11'd 1687);
wire counterYmaxed = (counterY == 11'd 1065);

always @(posedge clk)
begin
	if (counterXmaxed)
		counterX <= 0;
	else
		counterX <= counterX + 1'b1;

	if (counterXmaxed && counterYmaxed)
		counterY <= 0;
	else if (counterXmaxed && !counterYmaxed)
		counterY <= counterY + 1'b1;
end

wire [10:0] xShift     = 112 + 248 - `FRONT_MARGIN;
// wire [10:0] hSyncStart = 248 + 1280 + 48;
always @(posedge clk)
begin
   // polarity of sync pulse is positive
	vga_h_sync <= counterX < 112;

	if (counterX == xShift)
		prefetchCounterX <= 0;
	else
		prefetchCounterX <= prefetchCounterX + 1'b1;
end

always @(posedge vga_h_sync)
begin
	vga_v_sync <= counterY >= 11'd 1025 && counterY < 11'd 1028;
end

always @(posedge clk)
begin
	inDisplayArea <= prefetchCounterX >= 11'd 15 && prefetchCounterX < 11'd 1295
	                 && counterY < 11'd 1024;

   inPrefetchArea <= prefetchCounterX < 11'd 1280 && counterY < 11'd 1024;
end



endmodule
