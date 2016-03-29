`include "defines.v"

module ex_mem(
	input wire clk,
	input wire rst,

	input wire[5:0] stall, //暂停信号

	input wire[`RegAddrBus]	ex_wd, //写入的寄存器地址
	input wire				ex_wreg, //是否要写入
	input wire[`RegBus]		ex_wdata, // 写入的数据

	input wire[`AluOpBus]	ex_aluop, // 子类型
	input wire[`RegBus]		ex_mem_addr, //加载，存储指令的地址
	input wire[`RegBus]		ex_reg2, //要存储的数据

	output reg[`RegAddrBus] mem_wd, //写入的寄存器地址
	output reg 				mem_wreg,
	output reg[`RegBus]		mem_wdata,

	output reg[`AluOpBus] 	mem_aluop,
	output reg[`RegBus] 	mem_mem_addr,
	output reg[`RegBus]		mem_reg2	
	);
		
		always @(posedge clk) begin
			if (rst || (stall[3] == `Stop && stall[4] == `NoStop)) begin
				// reset
				mem_wd <= `NOPRegAddr;
				mem_wreg <= `WriteDisable;
				mem_wdata <= `ZeroWord;
				mem_aluop <= `EXE_NOP_OP;
				mem_mem_addr <= `ZeroWord;
				mem_reg2 <= `ZeroWord;
			end else if (stall[3] == `NoStop) begin
				mem_wd <= ex_wd;
				mem_wreg <= ex_wreg;
				mem_wdata <= ex_wdata;
				mem_aluop <= ex_aluop;
				mem_mem_addr <= ex_mem_addr;
				mem_reg2 <= ex_reg2;
			end
		end
endmodule
