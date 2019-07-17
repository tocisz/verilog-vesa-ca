`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:19 02/21/2019 
// Design Name: 
// Module Name:    sync_gen_640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 87 LUTs
//
//////////////////////////////////////////////////////////////////////////////////
module sync_gen_640x480(
	input  wire      clk,
	output reg       vga_h_sync,
	output reg       vga_v_sync,
	output reg       inDisplayArea,
	output reg [9:0] CounterX, // 0-799
	output reg [9:0] CounterY  // 0-524
);

/*
STANDARD
Pixel clock: 25.175
Horizontal:
 - visible area - 640 0
 - front porch  - 16  640
 - sync pulse   - 96  656
 - back porch   - 48  752
 - line         - 800

Vertical:
 - visible area - 480 0
 - front porch  - 10  480
 - sync pulse   - 2   490
 - back porch   - 33  492
 - line         - 525

*/

//////////////////////////////////////////////////
wire CounterXmaxed = (CounterX == 10'd 799);
wire CounterYmaxed = (CounterY == 10'd 524);

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
   // polarity of sync pulse is negative
	vga_h_sync <= !(CounterX >= 10'd 656 && CounterX < 10'd 752);
	vga_v_sync <= !(CounterY >= 10'd 490 && CounterY < 10'd 492);
end

// true for (1 <= x <= 640) and (1 <= y <= 480)
// that is fine, that's when we expect signal generated in next clock cycle after 0
always @(posedge clk)
inDisplayArea <= CounterX < 10'd 640 && CounterY < 10'd 480;

endmodule
