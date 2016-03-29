`include "defines.v"

`define INT200 200

`define ROW 4
`define ROW_LOG 2

`define BLOCK 16
`define BLOCK_LOG 4

`define TOTAL 127
`define TOTAL_LOG 7


module ram(

	input wire clk,
	input wire ce, //ChipEnable
	input wire we, //WriteAble
	input wire[`DataAddrBus]	addr,
	input wire[3:0]				sel,
	input wire[`DataBus]		data_i,

	output reg					hit1_o,
	output reg 					hit2_o,
	output reg[`DataBus]		data_o


);
	integer state;
	reg[`DataBus] data_ram[0 : `TOTAL];

	reg[`DataBus] cache[0 : `ROW - 1][0 : `BLOCK - 1];
	reg[`TOTAL_LOG - `BLOCK_LOG - 1 : 0] tag[0 : `ROW - 1];
	integer i, j, k, l, iter, tmp;

	initial begin
		$readmemh ("ram.data", data_ram);
		for (i = 0; i < `ROW; i = i + 1) 
			tag[i] = 3'b111;
		iter = 0;
		state = 0;
	end

	always @(posedge clk) begin
		if (ce == `ChipDisable) begin
		end else if (we == `WriteEnable) begin
			hit2_o = 1'b0;
			if (state == `INT200) begin
				data_ram[addr[`TOTAL_LOG + 1 : 2]] = data_i;
				for (j = 0; j < `ROW; j = j + 1)
					if (addr[`TOTAL_LOG + 1 : `BLOCK_LOG + 2] == tag[j]) begin
						cache[j][addr[`BLOCK_LOG + 1 : 2]] = data_i;
					end
				state = 0;
				hit2_o = 1'b1;
			end else begin
				state = state + 1;
			end
		end
	end

	always @ (*) begin
		if (ce == `ChipDisable) begin
			state = 0;
		end
		if (ce != `ChipDisable && we == `WriteDisable) begin
			hit1_o = 1'b0;
			for (k = 0; k < `ROW; k = k + 1)
				if (addr[`TOTAL_LOG + 1 : `BLOCK_LOG + 2] == tag[k]) begin
					hit1_o = 1'b1;
					state = 0;
					data_o = cache[k][addr[`BLOCK_LOG + 1 : 2]];
				end	
		end
	end

	always @(posedge clk) begin
		if (ce == `ChipDisable) begin
			data_o = `ZeroWord;
		end else if (we == `WriteDisable) begin
			hit2_o = 1'b0;
			if (state == `INT200) begin
				tag[iter] = addr[`TOTAL_LOG + 1 : `BLOCK_LOG + 2];
				tmp = tag[iter] * `BLOCK;
				for (l = 0; l < `BLOCK; l = l + 1) 
					cache[iter][l] = data_ram[l + tmp];
				
				data_o = cache[iter][addr[`BLOCK_LOG + 1 : 2]];
				iter = (iter + 1) % `ROW;
				hit2_o = 1'b1;
				state = 0;
			end else begin
				state = state + 1;
			end
		end
	end
endmodule
