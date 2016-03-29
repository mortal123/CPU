`include "defines.v"

`define COUNT200 32'b00000000000000000000000011001000

module ram(

	input wire clk,
	input wire ce, //ChipEnable
	input wire we, //WriteAble
	input wire[`DataAddrBus]	addr,
	input wire[3:0]				sel,
	input wire[`DataBus]		data_i,
	input wire[`RegBus]			cnt_i,

	output wire[`RegBus]		cnt_o,
	output reg					hit_o,
	output reg[`DataBus]		data_o
);

	reg[`DataBus] data_ram[0:127];

	reg[`DataBus] cache[0:63];
	reg tag;
	integer i;

	initial begin
		$readmemh ("ram.data", data_ram);
		tag = 1'b1;
	end

	assign cnt_o = cnt_i;

	always @(posedge clk) begin
		if (ce == `ChipDisable) begin
		end else if (we == `WriteEnable) begin
			if (cnt_i == `COUNT200) begin
				data_ram[addr[8:2]] <= data_i;
				if (addr[8] == tag) begin
					cache[addr[7:2]] <= data_i;
				end
			end else begin
			end
		end
	end

	always @(posedge clk) begin
		if (ce == `ChipDisable) begin
			data_o = `ZeroWord;
		end else if (we == `WriteDisable) begin
			if (addr[8] == tag) begin
				hit_o = 1'b1;
				data_o = cache[addr[7:2]];
			end else if (cnt_i < `COUNT200) begin
				hit_o = 1'b0;
			end else begin
				hit_o = 1'b1;
				tag = addr[8];
				if (addr[8] == 0) begin
					for (i = 0; i < 64; i = i + 1) 
						cache[i] = data_ram[i];
				end else begin
					for (i = 0; i < 64; i = i + 1)
						cache[i] = data_ram[i + 64];
				end
			end
		end
	end
endmodule
