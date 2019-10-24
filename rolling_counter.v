`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:27 03/23/2019 
// Design Name: 
// Module Name:    rolling_counter 
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
module rolling_counter
(
   input  wire clk,
	output wire [9:0] ram_addr,
	output wire [7:0] ram_data
);

reg [17:0] count;

always @(posedge clk)
  count <= count + 1'b1;

assign ram_addr = count[17:8];
assign ram_data = count[7:0];

endmodule
