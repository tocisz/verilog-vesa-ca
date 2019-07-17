`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:53:30 02/22/2019 
// Design Name: 
// Module Name:    two_lines 
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
module two_lines(
   input  wire        clk,
	input  wire [10:0] CounterX,
	input  wire        CounterYparity,
	input  wire        inDisplayArea,
	input  wire        inPrefetchArea,
	output reg         read,
	output reg   [7:0] addr, // valid range 0-160
	input  wire [15:0] data,
	output reg         image
);

reg  [15:0] display_reg;
reg load_to_reg;

always @*
begin
   // ram_addr[7:0] = {CounterYparity,CounterX[10:4]}; // one LUT less, 96 words wasted...
	if (CounterYparity)
		addr[7:0] = CounterX[10:4] + 7'd 80;
	else
		addr[7:0] = CounterX[10:4];

	read         = inPrefetchArea && (CounterX[3:0] == 4'b0001); // on 0000 inDisplayArea is still false
	load_to_reg  = inPrefetchArea && (CounterX[3:0] == 4'b1111);
	image        = inDisplayArea && display_reg[15-CounterX[3:0]];
end

always @(posedge clk)
begin
	if (load_to_reg)
		display_reg <= data;
end

endmodule
