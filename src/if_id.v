`include "defines.v"

module if_id(
	input wire rst,
	input wire clk,

	// from CTRL
	input wire[5 : 0] stall,

	input wire[`InstAddrBus] if_pc,
	input wire[`InstBus] if_inst,
	input wire input_isTaken,

	output reg[`InstAddrBus] id_pc,
	output reg[`InstBus] id_inst,
	output reg output_isTaken
);
	
	always @ (posedge clk) begin
		if (rst == `One || (stall[1] == `One && stall[2] == `Zero)) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
			output_isTaken <= `Zero;
		end else if (stall[1] == `Zero) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
			output_isTaken <= input_isTaken;
		end
	end

endmodule
