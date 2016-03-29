`include "defines.v"

module ctrl(

	input wire rst,
	input wire stall_from_id,
	input wire stall_from_mem,

	output reg[5:0] stall
);

	always @ (*) begin
		if (rst) begin
			// reset
			stall <= 6'b000000;
		end else if (stall_from_mem == `Stop) begin
			stall <= 6'b011111;
		end else if (stall_from_id == `Stop) begin
			stall <= 6'b000111;
		end else begin
			stall <= 6'b000000;
		end
	end
endmodule
