`include "defines.v"

`define COUNT200 32'b00000000000000000000000011001000

module mem(

	input wire rst,

	//写入寄存器
	input wire[`RegAddrBus]	wd_i,
	input wire 				wreg_i,
	input wire[`RegBus]		wdata_i,

	//内存存储或者读入
	input wire[`AluOpBus]	aluop_i,
	input wire[`RegBus]		mem_addr_i,
	input wire[`RegBus]		reg2_i,

	input wire[`RegBus]		mem_data_i, //读取出来的数据
	input wire 				is_hit_i,
	input wire[`RegBus]		cnt_i,


	//写入寄存器
	output reg[`RegAddrBus] wd_o,
	output reg 				wreg_o,
	output reg[`RegBus]		wdata_o,

	output reg[`RegBus]		mem_addr_o,
	output reg				mem_we_o, // 是否为写操作
	output reg[3:0]			mem_sel_o, //选哪些位
	output reg[`RegBus]		mem_data_o,
	output reg 				mem_ce_o, //使能信号 要不要操作RAM

	output reg[`RegBus]		cnt_o,

	output reg 				stallreq
	);

	always @ (*) begin
		if (rst) begin
			// reset
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			wdata_o <= `ZeroWord;
			mem_addr_o <= `ZeroWord;
			mem_we_o <= `WriteDisable;
			mem_sel_o <= 4'b0000;
			mem_data_o <= `ZeroWord;
			mem_ce_o <= `ChipDisable;
			cnt_o <= `ZeroWord;
			stallreq <= 1'b0;
		end else begin
			wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			mem_we_o <= `WriteDisable;
			mem_addr_o <= `ZeroWord;
			mem_sel_o <= 4'b1111;
			mem_ce_o <= `ChipDisable;
			cnt_o <= cnt_i;
			stallreq <= 1'b0;
			case (aluop_i)
				`EXE_LW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we_o <= `WriteDisable;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
					if (is_hit_i == 1'b0) begin
						stallreq = 1'b1;
					end
					if (cnt_i < `COUNT200) begin
						cnt_o = cnt_i + 1;
					end else begin
						cnt_o <= `ZeroWord;
					end
				end
				`EXE_SW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_we_o <= `WriteEnable;
					mem_data_o <= reg2_i;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
					if (cnt_i < `COUNT200) begin
						cnt_o = cnt_i + 1;
					end else begin
						cnt_o <= `ZeroWord;
					end
				end
				default: begin
					
				end
			endcase
		end
	end
endmodule
