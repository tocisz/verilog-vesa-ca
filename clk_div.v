`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:38 02/21/2019 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div
#(parameter BITS = 25)
(
    input  wire clk_in,
    output wire clk_out
);

/*
wire clk_in1;
IBUFG clkin1_buf
(
 .O (clk_in1),
 .I (clk_in)
);
*/

reg [BITS:1] cnt;

initial
begin
	cnt = 0;
end;

//assign clk_out = cnt[BITS];
BUFG buffer (
 .O(clk_out),
 .I(cnt[BITS])
);

always@(posedge clk_in)
begin
	cnt[BITS:1] <= cnt[BITS:1] + 1'b1;
end;

endmodule 