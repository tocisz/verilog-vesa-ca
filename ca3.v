module comb_ca (
  input wire [7:0] rule,

  input wire left,
  input wire [WIDTH-1 : 0] state,
  input wire right,

  output reg [WIDTH-1 : 0] out
);

  parameter WIDTH = 32;

  reg [5:0] i;
  always @*
  begin
	 for (i=0; i < WIDTH; i=i+1)
	 begin
		out[i] = rule[{i == 0 ? right : state[i-1],
		               state[i],
							i == WIDTH-1 ? left : state[i+1]}];
	 end
  end

endmodule
