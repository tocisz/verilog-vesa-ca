`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:42:53 02/21/2019 
// Design Name: 
// Module Name:    hvsync_generator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 75 LUT
//
//////////////////////////////////////////////////////////////////////////////////
module hvsync_generator(
	input  wire      clk,
	output reg       vga_h_sync,
	output reg       vga_v_sync,
	output reg       inDisplayArea,
	output reg [9:0] CounterX,
	output reg [8:0] CounterY
);

/*
STANDARD
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

ACTUAL
Horizontal:
 - visible area - 640 0
 - front porch  - 80  640
 - sync pulse   - 16  720
 - back porch   - 32  736
 - line         - 768

Vertical:
 - visible area - 480 0
 - front porch  - 20  480
 - sync pulse   - 1   500
 - back porch   - 11  501
 - line         - 512
*/

//////////////////////////////////////////////////
wire CounterXmaxed = (CounterX == 10'd 767);

always @(posedge clk)
if (CounterXmaxed)
begin
	CounterX <= 0;
	CounterY <= CounterY + 1'b1;
end
else
	CounterX <= CounterX + 1'b1;

always @(posedge clk)
begin
   // polarity of sync pulse is negative
	vga_h_sync <= !(CounterX[9:4] == 6'd 45);  // change this value to move the display horizontally
	vga_v_sync <= !(CounterY      == 9'd 500); // change this value to move the display vertically
end

always @(posedge clk)
if (inDisplayArea==0)
	inDisplayArea <= CounterXmaxed && (CounterY < 9'd 480);
else
	inDisplayArea <= !(CounterX == 10'd 639);

endmodule
