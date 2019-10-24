`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:45:07 03/23/2019 
// Design Name: 
// Module Name:    binary_display 
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
module binary_display(
   input  wire clk50,
   output wire vga_h_sync,
   output wire vga_v_sync,
   output reg  vga_R,
   output reg  vga_G,
   output reg  vga_B,
	output wire ram_clk,
	output wire [9:0] ram_addr,
	input  wire [7:0] ram_data
);

wire clk;
wire clkps;
clkdiv clkdiv
(
  .CLK_IN1(clk50),
  .CLK_OUT1(clk),
  .CLK_OUT2(clkps)
);

assign ram_clk = clkps;

wire inDisplayArea;
wire inPrefetchArea;
wire [10:0] CounterX;
wire [10:0] CounterY;
sync_gen_1280x1024 syncgen
(
  .clk(clk),
  .vga_h_sync(vga_h_sync),
  .vga_v_sync(vga_v_sync),
  .inDisplayArea(inDisplayArea),
  .inPrefetchArea(),
  .prefetchCounterX(CounterX),
  .counterY(CounterY)
);

reg [2:0] rgb;

wire [7:0] blockX;
wire [7:0] blockY;
assign blockX = CounterX[10:3];
assign blockY = CounterY[10:3];

reg [3:0] bXmod9;
reg       bYmod2;
always @*
begin
  bXmod9 = blockX % 9; // 37 / 88 /37
  bYmod2 = blockY % 2; // 37 / 88 /37
end

reg [7:0] rowCnt;
always @(posedge clk)
begin
  if (CounterX[10:0] == 11'd0)
  begin
    if (CounterY[10:0] == 11'd0 || CounterY[10:0] == 11'd16)
   rowCnt <= 8'd0;
    else if (CounterY[3:0] == 4'd0)
   rowCnt <= rowCnt + 1'b1;
  end
end

reg [7:0] colCnt;
always @(posedge clk)
begin
  if (CounterX == 11'd0
    || CounterX == 11'd144
    || CounterX == 11'd216
    || CounterX == 11'd288
    || CounterX == 11'd360
    || CounterX == 11'd432
    || CounterX == 11'd504
    || CounterX == 11'd576
    || CounterX == 11'd648
    || CounterX == 11'd720
    || CounterX == 11'd792
    || CounterX == 11'd864
    || CounterX == 11'd936
    || CounterX == 11'd1008
    || CounterX == 11'd1080
    || CounterX == 11'd1152
    )
  begin
     if (blockX == 7'd0)
      colCnt <= 8'd0;
    else
   colCnt <= colCnt + 1'b1;
  end
end

reg  read_debug_ram; // mark to read debug ram in the next clock cycle
wire [9:0] addr;
assign addr = {rowCnt[5:0],colCnt[3:0]};
assign ram_addr = addr;

always @*
begin
  read_debug_ram = 1'b0; // unless overriden below

  if (bXmod9 == 8 || bYmod2 == 1 // borders
    || blockX >= 17*9 // out of range
    || CounterX[2:0] == 0 || CounterY[2:0] == 0 // grid
  )
    rgb = 3'b000;
  else if (blockX < 8)  // row number
  begin
    if (rowCnt[7-blockX])
      rgb = 3'b110;
   else
      rgb = 3'b001;
  end
  else if (blockY == 0) // column number
  begin
    if (colCnt[7-bXmod9])
      rgb = 3'b110;
   else
      rgb = 3'b001;
  end
  else // data
  begin
    read_debug_ram = 1'b1;
    rgb = 3'bXXX;
  end
end

reg [2:0] rgb_delay1;
reg read_debug_ram_delay1;
reg [2:0] bXmod9_delay1;
always @(posedge clk)
begin
  rgb_delay1 <= rgb;
  read_debug_ram_delay1 <= read_debug_ram;
  bXmod9_delay1 <= bXmod9[2:0];
end

reg [2:0] rgb_stage1;
always @*
begin
  if (read_debug_ram_delay1)
  begin
    if (ram_data[7-bXmod9_delay1])
       rgb_stage1 = 3'b110;
   else
       rgb_stage1 = 3'b001;
  end
  else
    rgb_stage1 = rgb_delay1;
end

always @(posedge clk)
begin
  vga_R <= rgb_stage1[2] & inDisplayArea; // one cycle of delay
  vga_G <= rgb_stage1[1] & inDisplayArea; // (because we want no logic after reading signal from register to minimize output delay)
  vga_B <= rgb_stage1[0] & inDisplayArea;
end

endmodule
