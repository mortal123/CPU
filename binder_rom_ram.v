`include "defines.v"

module binder_rom_ram(
	input wire clk,
	input wire rst
);

	wire[`InstAddrBus] inst_addr;
	wire[`InstBus] inst;
	wire rom_ce;
	wire input_isTaken;
	wire output_isTaken;
	wire mem_we_i;
	wire[`RegBus] mem_addr_i;
	wire[`RegBus] mem_data_i;
	wire[`RegBus] mem_data_o;
	wire[`RegBus] mem_cnt_i;
	wire[`RegBus] mem_cnt_o;
	wire mem_hit_o;
	wire[3:0] mem_sel_i;   
	wire mem_ce_i; 
	
	inst_rom inst_rom0(
		.ce(rom_ce),
		.addr(inst_addr),
		.input_isTaken(input_isTaken),
		.inst(inst),
		.output_isTaken(output_isTaken)
	);	

	ram ram0(
		.clk(clk),
		.ce(mem_ce_i),
		.we(mem_we_i),
		.addr(mem_addr_i),
		.sel(mem_sel_i),
		.data_i(mem_data_i),
		.cnt_i(mem_cnt_i),
		.cnt_o(mem_cnt_o),
		.hit_o(mem_hit_o),
		.data_o(mem_data_o)
	);

	binder binder0(
		.clk(clk),
		.rst(rst),
		.rom_data_i(inst),
		.rom_isTaken_i(output_isTaken),
		.rom_addr_o(inst_addr),
		.rom_ce_o(rom_ce),
		.rom_isTaken_o(input_isTaken),
		.ram_data_i(mem_data_o),
		.ram_hit(mem_hit_o),
		.ram_cnt_i(mem_cnt_o),
		.ram_addr_o(mem_addr_i),
		.ram_data_o(mem_data_i),
		.ram_we_o(mem_we_i),
		.ram_sel_o(mem_sel_i),
		.ram_ce_o(mem_ce_i),
		.ram_cnt_o(mem_cnt_i)
	);	
endmodule
