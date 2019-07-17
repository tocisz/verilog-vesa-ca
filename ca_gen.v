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
module ca_gen(
	input wire         clk,
	input wire         start,
	input wire         direction,
	output reg         read,
	output reg   [7:0] raddr,
	input  wire [15:0] rdata,
	output reg         write,
	output reg   [7:0] waddr,
	output wire [15:0] wdata // do we need to buffer it?
);

reg        buffer0;
reg [15:0] buffer1;
reg [15:0] buffer2;

always @ ( posedge clk )
begin
	buffer0 <= buffer1[0];
	buffer1 <= buffer2;
end

comb_ca
#(
	.WIDTH(16)
) ca (
	.rule(8'd 30),
	.left(buffer0),
	.state(buffer1),
	.right(buffer2[15]),
	.out(wdata)
);


/*
1. buffer[2] <= mem[rbegin+79]
2. buffer[2] <= mem[rbegin]
3. buffer[2] <= mem[rbegin+1]
4. left  = buffer[0][0]
   right = buffer[2][15]
	mem[wptr++] <= comb_ca(left, buffer[1], right)
	buffer[2] <= mem[rptr++]
... (as above)
84. mem[wptr] <= result
*/
reg [6:0] step;
initial step = 7'd 83;

function [7:0] increment_addr;
input [7:0] addr;
begin
	if (addr == 8'd 79)
		increment_addr = 8'd 0;
	else if (addr == 8'd 159)
		increment_addr = 8'd 80;
	else
		increment_addr = addr + 1'b1;
end
endfunction

always @ ( posedge clk )
begin
	if (start)
		begin
			write <= 0;
			step <= 0;
			read <= 1; // should we set address before setting read to 1? (not on the same clock cycle)
			raddr <= direction ? 8'd 159 : 8'd 79;
		end
	else
	begin
		if (step < 7'd 83)
			step <= step + 1'b1;

		if (step == 0) // read request sent (79)
		begin
			read <= 1;
			raddr <= increment_addr(raddr); // 0
			write <= 0;
		end
		else if (step == 1) // read request sent (0)
		begin
			read <= 1;
			raddr <= increment_addr(raddr); // 1
			buffer2 <= rdata; // 79 received
			write <= 0;
		end
		else if (step == 2) // read req sent (1), buffer2 = mem[79]
		begin
			read <= 1;
			raddr <= increment_addr(raddr); // 2
			buffer2 <= rdata;
			write <= 0;
		end
		else if (step == 3) // read req sent (2), buffer1 = mem[79], buffer2 = mem[0]
		begin
			read <= 1;
			raddr <= increment_addr(raddr); // 3
			buffer2 <= rdata;
			write <= 1;
			waddr <= direction ? 8'd 0 : 8'd 80; // should we send address before setting write to 1?
		end
		else if (step < 83) // write request sent, buffer0 = mem[79], buffer2 = mem[0], buffer2 = mem[1]
		begin
			buffer2 <= rdata;
			step <= step + 1'b1;
			read <= 1;
			raddr <= increment_addr(raddr);
			write <= 1;
			waddr <= waddr + 1'b1;
		end
		else
		begin // step == 83
			read <= 0;
			write <= 0;
		end
	end

end

endmodule
