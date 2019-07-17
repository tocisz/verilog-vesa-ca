`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    04:54:07 02/22/2019
// Design Name:
// Module Name:    ca_gen
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
module ca_gen0(
	input wire         clk,
	input wire         start,
	output reg         write,
	output reg  [7:0] waddr,
	output reg  [15:0] wdata
);

reg [10:0] position;
initial position = 0;

reg [7:0] cycle;
initial begin
	cycle = 8'd 160;
	wdata = 16'b0;
	waddr = 8'b0;
end

always @ ( posedge clk )
begin
	if (cycle != 8'd 160)
	begin
		if (cycle == position[10:4])
			wdata <= (1 << 15-position[3:0]);
		else
			wdata <= 16'b0;
		write <= 1;
		waddr <= cycle;
		cycle <= cycle + 1'b1;
	end
	else if (start)
	begin
  	   wdata <= 16'b0;
		write <= 0;
		cycle <= 0;
		position <= (position + 1'b1) % 1280;
	end
	else
	begin
		write <= 0;
	end
end

endmodule
