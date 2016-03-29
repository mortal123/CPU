`include "defines.v"
module ex(
	input wire rst,

	input wire[`AluOpBus]	aluop_i, //运算子类型
	input wire[`AluSelBus]	alusel_i, //运算类型
	input wire[`RegBus]		reg1_i, //源操作数1
	input wire[`RegBus]		reg2_i, //源操作数2
	input wire[`RegAddrBus]	wd_i,	//写入寄存器地址
	input wire 				wreg_i, //是否要写寄存器
	input wire[`RegBus]		inst_i, //当前的指令

	//input wire[`RegBus]		link_address_i, // branch jump

	output reg[`RegAddrBus]	wd_o, //最终要写入的寄存器             ok 
	output reg 				wreg_o, //是否要写入寄存器				ok
	output reg[`RegBus]		wdata_o, //写入的值					ok

	output wire[`AluOpBus]		aluop_o, //运算子类型                  ok
	output wire[`RegBus]		mem_addr_o, //加载，存储操作的地址         ok
	output wire[`RegBus] 	reg2_o //存储指令要存储的数据           ok

	);

	assign aluop_o = aluop_i;

	assign mem_addr_o = reg1_i + {{16{inst_i[15]}}, inst_i[15:0]};

	assign reg2_o = reg2_i;

	always @ (*) begin
		wd_o <= wd_i;
		wreg_o = wreg_i;
		if (rst == `ONE) begin
			wdata_o = `ZeroWord;
		end else if (alusel_i == `EXE_RES_LOGIC) begin
			case (aluop_i)
				`EXE_OR_OP:	begin
					wdata_o <= reg1_i | reg2_i;
				end
				`EXE_AND_OP: begin
					wdata_o <= reg1_i & reg2_i;
				end
				`EXE_NOR_OP: begin
					wdata_o <= ~(reg1_i | reg2_i);
				end
				`EXE_XOR_OP: begin
					wdata_o = reg1_i ^ reg2_i;
				end
				default: begin
					wdata_o <= `ZeroWord;
				end
			endcase
		end else if (alusel_i == `EXE_RES_SHIFT) begin
			case (aluop_i)
				`EXE_SLL_OP: begin
					wdata_o <= reg2_i << reg1_i[4:0]; //只有32位
				end
				`EXE_SRL_OP: begin
					wdata_o <= reg2_i >> reg1_i[4:0]; 
				end
				default: begin
					wdata_o <= `ZeroWord;
				end
			endcase
		end else if (alusel_i == `EXE_RES_ARITHMETIC) begin
			case (aluop_i)
				`EXE_SLTU_OP: begin
					wdata_o <= (reg1_i < reg2_i);
				end
				`EXE_SLT_OP: begin
					wdata_o <= ((reg1_i[31] && !reg2_i[31]) ||
								(reg1_i[31] == reg2_i[31] && reg1_i < reg2_i));
				end
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP: begin
					wdata_o <= (reg1_i + reg2_i);
				end
				`EXE_SUB_OP, `EXE_SUBU_OP: begin
					wdata_o <= (reg1_i + (~reg2_i) + 1);
				end
				`EXE_MUL_OP: begin
					wdata_o <= (reg1_i * reg2_i);
				end
				default: begin
					wdata_o <= `ZeroWord;
				end
			endcase
		end
	end

endmodule
