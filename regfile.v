`include "defines.v"

module regfile(
	input wire rst,
	input wire clk,
	// write
	input wire we,
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus] wdata,
	// read #1
	input wire re1,
	input wire[`RegAddrBus] raddr1,
	output reg[`RegBus] rdata1,
	// read #2
	input wire re2,
	input wire[`RegAddrBus] raddr2,
	output reg[`RegBus] rdata2
);
	reg[`RegBus] res[0 : `RegNum - 1];
	reg i;
	// init
	initial begin
		for (i = 0; i < `RegNum; i = i + 1)
			res[i] = `ZeroWord;
	end
	// write
	always @ (posedge clk) begin
		if (rst == `Zero && we == `One && waddr != `RegNumLog2'h0) begin
			res[waddr] <= wdata;
		end
	end
	// read #1
	always @ (*) begin
		if (rst == `One || raddr1 == `RegNumLog2'h0 || re1 == `Zero) begin
			rdata1 <= `ZeroWord;
		end else if (raddr1 == waddr && we == `One) begin
			rdata1 <= wdata;
		end else begin
			rdata1 <= res[raddr1];
		end
	end
	// read #2
	always @ (*) begin
		if (rst == `One || raddr2 == `RegNumLog2'h0 || re2 == `Zero) begin
			rdata2 <= `ZeroWord;
		end else if (raddr2 == waddr && we == `One) begin
			rdata2 <= wdata;
		end else begin
			rdata2 <= res[raddr2];
		end
	end
endmodule
