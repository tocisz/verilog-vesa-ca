module comb_cell (
  input wire [7:0] rule,

  input wire       left,
  input wire       state,
  input wire       right,

  output wire      out
);

  assign out = rule[{left,state,right}];

endmodule
