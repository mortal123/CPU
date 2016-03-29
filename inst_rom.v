`include "defines.v"

module inst_rom(
	input wire ce,
	input wire[`InstAddrBus] addr,
	input wire input_isTaken,

	output reg[`InstBus] inst,
	output reg output_isTaken
);

	reg[`InstBus] res[0 : `InstMemNum - 1];

	initial $readmemh ("MIPS.data", inst_mem);

	always @ (*) begin
		if (ce == `One) begin
			inst <= res[addr[`InstMemNumLog2 + 1 : 2]];
			output_isTaken <= input_isTaken;
		end else begin
			inst <= `ZeroWord;
		end
	end

endmodule
