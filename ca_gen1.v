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


wire left = buffer0;
wire right = buffer2[0];
comb_ca
#(
	.WIDTH(16)
) ca (
	.rule(8'd 31),
	.left,
	.state(buffer1),
	.right,
	.out(wdata)
);


/*
reg [1:0]  shift;
reg [15:0] shifted_buffer [2:0];
always @ ( posedge clk )
begin
	if (!start)
		shift <= (shift+1)%3;
end

always @*
begin
	case (shift)
		2'b00: 
		begin
			shifted_buffer[0] = buffer[0];
		   shifted_buffer[1] = buffer[1];
			shifted_buffer[2] = buffer[2];
		end

		2'b01:
		begin
			shifted_buffer[0] = buffer[1];
		   shifted_buffer[1] = buffer[2];
			shifted_buffer[2] = buffer[0];
		end

 		2'b10:
		begin
			shifted_buffer[0] = buffer[2];
 		   shifted_buffer[1] = buffer[0];
 			shifted_buffer[2] = buffer[1];
		end

		default:
		begin
			shifted_buffer[0] = 16'hXX;
			shifted_buffer[1] = 16'hXX;
			shifted_buffer[2] = 16'hXX;
		end
	endcase
end
*/

always @ ( posedge clk )
begin
	buffer0 <= buffer1[15];
	buffer1 <= buffer2;
end

/*
1. buffer[0] <= mem[rbegin+79] // we need only one bit, actully
2. buffer[1] <= mem[rbegin]
3. buffer[2] <= mem[rbegin+1]
4. left  = buffer[0][15]
   right = buffer[2][0]
	mem[wptr++] <= comb_ca(left, buffer[1], right)
	buffer[2] <= mem[rptr++]
... (as above)
84. mem[wptr] <= result
*/
reg [6:0] step;
always @ ( posedge clk )
begin
	if (start)
		begin
			write <= 0;
			step <= 0;
			read <= 1;
			raddr <= 8'd 79;
		end
	else
	begin
		if (step == 0)
		begin
			buffer0 <= rdata[0];
			step <= step + 1'b1;
			read <= 1;
			raddr <= 8'd 0;
			write <= 0;
		end
		else if (step == 1)
		begin
			buffer1 <= rdata;
			step <= step + 1'b1;
			read <= 1;
			raddr <= raddr + 1'b1;
			write <= 0;
		end
		else if (step == 2)
		begin
			buffer2 <= rdata;
			step <= step + 1'b1;
			read <= 1;
			raddr <= raddr + 1'b1;
			write <= 1;
			waddr = 8'd 80;
		end
		else if (step < 82)
		begin
			buffer2 <= rdata;
			step <= step + 1'b1;
			read <= 1;
			raddr <= raddr + 1'b1;
			write <= 1;
			waddr = waddr + 1'b1;
		end
		else
		begin
			read <= 0;
			write <= 0;
		end
	end

end

endmodule
