`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:42:53 02/22/2019 
// Design Name: 
// Module Name:    sprite128 
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
module sprite128 #(
   parameter SHIFT_X = 0,
   parameter SHIFT_Y = 0
)
(
   input  wire        clk,
	input  wire [10:0] CounterX,
	input  wire [10:0] CounterY,
	output wire        prefetch_now,
	output wire  [9:0] prefetch_addr,
	input  wire [15:0] prefetch_data,
	output wire        image
);

wire in_ram_area;
wire  [9:0] ram_addr;
reg  [15:0] ram_data;
wire load_to_reg;

assign ram_addr[9:3] = CounterY[6:0];
assign ram_addr[2:0] = CounterX[6:4];
assign prefetch_addr[9:0] = ram_addr[9:0] + 1'b1;
assign in_ram_area        = (CounterX[10:7] == SHIFT_X) && (CounterY[10:7] == SHIFT_Y); // tile address
assign prefetch_now       = in_ram_area && (CounterX[3:0] == 4'b0000);
assign load_to_reg        = in_ram_area && (CounterX[3:0] == 4'b1111);
always @(posedge clk)
begin
	if (load_to_reg)
		ram_data <= prefetch_data;
end

assign image = ram_data[15-CounterX[3:0]] && in_ram_area;

endmodule
