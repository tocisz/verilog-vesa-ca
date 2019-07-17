`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:10 02/21/2019 
// Design Name: 
// Module Name:    sync_gen_1024x1080 
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
module sync_gen_1024x1080(
	input  wire      clk,
	output reg       vga_h_sync,
	output reg       vga_v_sync,
	output reg       inDisplayArea,
	output reg [10:0] CounterX,
	output reg [10:0] CounterY
);

`define FRONT 16

/*
reg [10:0] CounterX;
reg [10:0] CounterY;

// Delay X-Y coordinates to match inDisplayArea signal
always @(posedge clk)
begin
	OutCounterX <= CounterX;
	OutCounterY <= CounterY;
end
*/

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
wire CounterXmaxed = (CounterX == 11'd 1687);
wire CounterYmaxed = (CounterY == 11'd 1065);

always @(posedge clk)
begin
	if (CounterXmaxed)
		CounterX <= 0;
	else
		CounterX <= CounterX + 1'b1;

	if (CounterXmaxed && CounterYmaxed)
		CounterY <= 0;
	else if (CounterXmaxed && !CounterYmaxed)
		CounterY <= CounterY + 1'b1;
end

always @(posedge clk)
begin
   // polarity of sync pulse is positive
	vga_h_sync <= (CounterX >= 11'd 1344 && CounterX < 11'd 1456);
	vga_v_sync <= (CounterY >= 11'd 1025 && CounterY < 11'd 1028);
end

// true for (1 <= x <= 1280) and (0 <= y <= 1023)
// that is fine, that's when we expect signal generated in next clock cycle after 0
// TODO add front porch (e.g. 16 px) to make prefetch easier
always @(posedge clk)
inDisplayArea <= (CounterX >= 16 && CounterX < 11'd 1296) && CounterY < 11'd 1024;

endmodule
