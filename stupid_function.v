function [7:0] increment_addr;
input direction;
input [7:0] addr;
begin
	if (direction == 0)
	begin
		if (addr == 8'd 79)
			increment_addr = 8'd 0;
		else
			increment_addr = addr + 1'b1;
	end
	else
	begin
		if (addr == 8'd 159)
			increment_addr = 8'd 80;
		else
			increment_addr = addr + 1'b1;
	end
end
endfunction
