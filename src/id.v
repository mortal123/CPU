`include "defines.v"

module id(
	input wire rst,
	input wire[`InstAddrBus] input_pc,
	input wire[`InstBus] input_inst,
	input wire isTaken,

	// solve for LOAD hazard
	input wire[`AluOpBus] input_ex_aluop,

	// bypassing from EX
	input wire input_ex_wreg,
	input wire[`RegBus] input_ex_wdata,
	input wire[`RegAddrBus] input_ex_wd,

	// bypassing from MA
	input wire input_mem_wreg,
	input wire[`RegBus] input_mem_wdata,
	input wire[`RegAddrBus] input_mem_wd,

	input wire[`RegBus] input_reg1_data,
	input wire[`RegBus] input_reg2_data,

	input wire input_inDelayslot,

	// to regfile
	output reg output_reg1_read,
	output reg output_reg2_read,
	output reg[`RegAddrBus] output_reg1_addr,
	output reg[`RegAddrBus] output_reg2_addr,

	// to ID/EX
	output reg[`AluOpBus] output_aluop,
	output reg[`AluSelBus] output_alusel,
	output reg[`RegBus] output_reg1,
	output reg[`RegBus] output_reg2,
	output reg[`RegAddrBus] output_wd,
	output reg output_wreg,
	output wire[`InstBus] output_inst,
	output reg next_inDelayslot,

	// branch
	output reg output_branch_flag,
	output reg[`RegBus] output_branch_addr,

	// to CTRL
	output wire stallreq
);

	wire[5 : 0] op = input_inst[31 : 26];
	wire[4 : 0] op2 = input_inst[10 : 6];
	wire[5 : 0] op3 = input_inst[5 : 0];
	reg[`RegBus] imm;
	reg flag1, flag2;

	assign pre_inst_is_lw = (input_ex_aluop == `EXE_LW_OP) ? `One : `Zero;
	assign output_inst = input_inst;
	assign stallreq = (flag1 | flag2);

	always @ (*) begin
		if (rst == `One || input_inDelayslot == `One) begin
			output_aluop <= `EXE_NOP_OP;
			output_alusel <= `EXE_RES_NOP;
			output_wd <= `NOPRegAddr;
			output_wreg <= `Zero;
			output_reg1_read <= `Zero;
			output_reg2_read <= `Zero;
			output_reg1_addr <= `NOPRegAddr;
			imm <= `ZeroWord;
			output_branch_addr <= `ZeroWord;
			output_branch_flag <= `Zero;
			next_inDelayslot <= `Zero;
		end else begin
			output_aluop <= `EXE_NOP_OP;
			output_alusel <= `EXE_RES_NOP;
			output_wd <= input_inst[15:11];
			output_wreg <= `Zero;
			output_reg1_read <= `Zero;
			output_reg2_read <= `Zero;
			output_reg1_addr <= input_inst[25:21];
			output_reg2_addr <= input_inst[20:16];	
			imm <= `ZeroWord;
			output_branch_addr <= `ZeroWord;
			output_branch_flag <= `Zero;	
			next_inDelayslot <= `Zero;
			case (op)
				`EXE_SPECIAL_INST : begin
					if (op2 == 5'b0) begin
						case (op3)
							`EXE_OR : begin
								output_wreg <= `ONE; output_aluop <= `EXE_OR_OP; output_alusel <= `EXE_RES_LOGIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_AND : begin
								output_wreg <= `ONE; output_aluop <= `EXE_AND_OP; output_alusel <= `EXE_RES_LOGIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_NOR : begin
								output_wreg <= `ONE; output_aluop <= `EXE_NOR_OP; output_alusel <= `EXE_RES_LOGIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_XOR : begin
								output_wreg <= `ONE; output_aluop <= `EXE_XOR_OP; output_alusel <= `EXE_RES_LOGIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_SLLV_OP : begin
								output_wreg <= `ONE; output_aluop <= `EXE_SLL_OP; output_alusel <= `EXE_RES_SHIFT; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_SRLV_OP : begin
								output_wreg <= `ONE; output_aluop <= `EXE_SRL_OP; output_alusel <= `EXE_RES_SHIFT; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_SLT : begin
								output_wreg <= `ONE; output_aluop <= `EXE_SLT_OP; output_alusel <= `EXE_RES_ARITHMETIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_SLTU : begin
								output_wreg <= `ONE; output_aluop <= `EXE_SLTU_OP; output_alusel <= `EXE_RES_ARITHMETIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_ADD : begin
								output_wreg <= `ONE; output_aluop <= `EXE_ADD_OP; output_alusel <= `EXE_RES_ARITHMETIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_ADDU : begin
								output_wreg <= `ONE; output_aluop <= `EXE_ADDU_OP; output_alusel <= `EXE_RES_ARITHMETIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_SUB : begin
								output_wreg <= `ONE; output_aluop <= `EXE_SUB_OP; output_alusel <= `EXE_RES_ARITHMETIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							`EXE_SUBU : begin
								output_wreg <= `ONE; output_aluop <= `EXE_SUBU_OP; output_alusel <= `EXE_RES_ARITHMETIC; 
								output_reg1_read <= `One; output_reg2_read <= `One;
							end
							default : begin
							end
						endcase
					end
				end
				`EXE_ORI : begin
					output_wreg <= `ONE; output_aluop <= `EXE_OR_OP; output_alusel <= `EXE_RES_LOGIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {16'h0, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_ANDI : begin
					output_wreg <= `ONE; output_aluop <= `EXE_AND_OP; output_alusel <= `EXE_RES_LOGIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {16'h0, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_XORI : begin
					output_wreg <= `ONE; output_aluop <= `EXE_XOR_OP; output_alusel <= `EXE_RES_LOGIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {16'h0, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_LUI : begin
					output_wreg <= `ONE; output_aluop <= `EXE_OR_OP; output_alusel <= `EXE_RES_LOGIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {input_inst[15 : 0], 16'h0}; output_wd <= input_inst[20 : 16];
				end
				`EXE_SLTI : begin
					output_wreg <= `ONE; output_aluop <= `EXE_SLT_OP; output_alusel <= `EXE_RES_ARITHMETIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {{16{input_inst[15]}}, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_SLTIU : begin
					output_wreg <= `ONE; output_aluop <= `EXE_SLTU_OP; output_alusel <= `EXE_RES_ARITHMETIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {{16{input_inst[15]}}, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_ADDI : begin
					output_wreg <= `ONE; output_aluop <= `EXE_ADDI_OP; output_alusel <= `EXE_RES_ARITHMETIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {{16{input_inst[15]}}, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_ADDIU : begin
					output_wreg <= `ONE; output_aluop <= `EXE_ADDIU_OP; output_alusel <= `EXE_RES_ARITHMETIC;
					output_reg1_read <= `One; output_reg2_read <= `Zero; 
					imm <= {{16{input_inst[15]}}, input_inst[15 : 0]}; output_wd <= input_inst[20 : 16];
				end
				`EXE_BNE : begin
					output_wreg <= `Zero; output_aluop <= `EXE_BLEZ_OP; output_alusel <= `EXE_RES_JUMP_BRANCH;
					output_reg1_read <= `One; output_reg2_read <= `One;
					if (output_reg1 != output_reg2 && isTaken == `Zero) begin
						output_branch_addr <= input_pc + 4 + {{14{input_inst[15]}}, input_inst[15:0], 2'b00};
						output_branch_flag <= `One;
						next_inDelayslot <= `One;
					end else if (output_reg1 == output_reg2 && isTaken == `One) begin
						output_branch_addr <= input_pc + 4;
						output_branch_flag <= `One;
						next_inDelayslot <= `One;
					end
				end
				`EXE_LW : begin
					output_wreg <= `One; output_aluop <= `EXE_LW_OP; output_alusel <= `EXE_RES_LOAD_STORE;
					output_reg1_read <= `One; output_reg2_read <= `Zero; output_wd <= input_inst[20 : 16];
				end
				`EXE_SW : begin
					output_wreg <= `Zero; output_aluop <= `EXE_SW_OP; output_alusel <= `EXE_RES_LOAD_STORE;
					output_reg1_read <= `One; output_reg2_read <= `One;
				end
				`EXE_SPECIAL2_INST : begin
					if (op3 == `EXE_MUL) begin
						output_wreg <= `One; output_aluop <= `EXE_MUL_OP; output_alusel <= `EXE_RES_ARITHMETIC;
						output_reg1_read <= `One; output_reg2_read <= `One;
					end
				end
				default : begin 
				end
			endcase
			if (input_inst[31 : 21] == 11'b0) begin
				case (op3)
					`EXE_SLL : begin
						output_wreg <= `One; output_aluop <= `EXE_SLL_OP; output_alusel <= `EXE_RES_SHIFT;
						output_reg1_read <= `Zero; output_reg2_read <= `One; output_wd <= input_inst[15 : 11];
						imm[4 : 0] <= input_inst[10 : 6];
					end
					`EXE_SRL : begin
						output_wreg <= `One; output_aluop <= `EXE_SRL_OP; output_alusel <= `EXE_RES_SHIFT;
						output_reg1_read <= `Zero; output_reg2_read <= `One; output_wd <= input_inst[15 : 11];
						imm[4 : 0] <= input_inst[10 : 6];
					end
					default : begin
					end
				endcase
			end
		end
	end

	always @ (*) begin
		flag1 <= `Zero;
		if (rst == `One) begin
			output_reg1 <= `ZeroWord; 
		end else if (pre_inst_is_lw == `One && output_reg1_read == `One && input_ex_wd == output_reg1_addr) begin
			flag1 <= `One;
		end else if (output_reg1_read == `One && input_ex_wreg == `One && input_ex_wd == output_reg1_addr) begin
			output_reg1 <= input_ex_wdata; 
		end else if (output_reg1_read == `One && input_mem_wreg == `One && input_mem_wd == output_reg1_addr) begin
			output_reg1 <= input_mem_wdata;
		end else if (output_reg1_read == `One) begin
			output_reg1 <= input_reg1_data;
		end else if (output_reg1_read == `Zero) begin
			output_reg1 <= imm;
		end else begin
			output_reg1 <= `ZeroWord;
		end
	end

	always @ (*) begin
		flag2 <= `Zero;
		if (rst == `One) begin
			output_reg2 <= `ZeroWord; 
		end else if (pre_inst_is_lw == `One && output_reg2_read == `One && input_ex_wd == output_reg2_addr) begin
			flag2 <= `One;
		end else if (output_reg2_read == `One && input_ex_wreg == `One && input_ex_wd == output_reg2_addr) begin
			output_reg2 <= input_ex_wdata; 
		end else if (output_reg2_read == `One && input_mem_wreg == `One && input_mem_wd == output_reg2_addr) begin
			output_reg2 <= input_mem_wdata;
		end else if (output_reg2_read == `One) begin
			output_reg2 <= input_reg2_data;
		end else if (output_reg2_read == `Zero) begin
			output_reg2 <= imm;
		end else begin
			output_reg2 <= `ZeroWord;
		end
	end
endmodule

