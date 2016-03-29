`include "defines.v"

module pc_reg(
	input wire clk,
	input wire rst,

	// from CTRL
	input wire[5 : 0] stall,

	// from ID
	input wire input_branch_flag,
	input wire[`RegBus] input_branch_target,

	// from ROM
	input wire[`InstBus] lastInst,

	output reg[`InstAddrBus] pc,
	output reg isTaken,
	output reg ce
);

	reg[1 : 0] branch_predictor;
	wire[5 : 0] op = lastInst[31 : 26];

	initial begin
		branch_predictor = 2'b11;
	end

	always @ (posedge clk) begin
		if (ce == `Zero) begin
			pc <= `ZeroWord;
		end else if (stall[0] == `Zero) begin
			if (input_branch_flag == `One) begin
				pc <= input_branch_target;
				if (branch_predictor == 2'b11) begin
					branch_predictor <= 2'b10;
				end else if (branch_predictor == 2'b10) begin
					branch_predictor <= 2'b00;
				end else if (branch_predictor == 2'b01) begin
					branch_predictor <= 2'b11;
				end else begin
					branch_predictor <= 2'b01;
				end
			end else begin
				if (op == `EXE_BNE) begin
					if (branch_predictor >= 2'b10) begin
						pc <= pc + 4 + {{14{lastInst[15]}}, lastInst[15:0], 2'b00}; // taken
						isTaken <= `One;
					end else begin
						pc <= pc + 4'h4; // not taken
						isTaken <= `Zero;
					end
				end else begin
					pc <= pc + 4'h4;
				end
			end
		end
	end

	always @ (posedge clk) begin
		if (rst == `One) begin
			ce <= `Zero;
		end else begin
			ce <= `One;
		end
	end

endmodule
