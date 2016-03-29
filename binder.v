`include "defines.v"

module binder(
	input wire rst,
	input wire clk,

	input wire[`RegBus] rom_data_i,
	input wire[`RegBus] rom_isTaken_i,
	output wire[`RegBus] rom_addr_o,
	output wire[`RegBus] rom_ce_o,
	output wire rom_isTaken_o,

	input wire[`RegBus] ram_data_i,
	input wire ram_hit,
	input wire[`DataBus] ram_cnt_i,
	output wire[`RegBus] ram_addr_o,
	output wire[`RegBus] ram_data_o,
	output wire ram_we_o,
	output wire[3:0] ram_sel_o,
	output wire ram_ce_o,
	output wire[`RegBus] ram_cnt_o
);

	wire[`InstAddrBus] pc;
	wire[`InstAddrBus] id_pc_i;
	wire[`InstBus] id_inst_i;
	
	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	wire id_is_in_delayslot_o;
	wire[`RegBus] id_inst_o;
	
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	wire[`RegBus] ex_inst_i;

	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;
	wire[`AluOpBus] ex_aluop_o;
	wire[`RegBus] ex_mem_addr_o;
	wire[`RegBus] ex_reg1_o;
	wire[`RegBus] ex_reg2_o;	

	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;
	wire[`AluOpBus] mem_aluop_i;
	wire[`RegBus] mem_mem_addr_i;
	wire[`RegBus] mem_reg1_i;
	wire[`RegBus] mem_reg2_i;		

	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
	
	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;

	wire reg1_read;
	wire reg2_read;
	wire[`RegBus] reg1_data;
	wire[`RegBus] reg2_data;
	wire[`RegAddrBus] reg1_addr;
	wire[`RegAddrBus] reg2_addr;

	wire is_in_delayslot_i;
	wire is_in_delayslot_o;
	wire next_inst_in_delayslot_o;
	wire id_branch_flag_o;
	wire[`RegBus] branch_target_address;

	wire[5:0] stall;
	wire stallreq_from_id;	
	wire stallreq_from_ex;
	wire id_isTaken_i;

	assign rom_addr_o = pc;

	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.input_branch_flag(id_branch_flag_o),
		.input_branch_target(branch_target_address),
		.lastInst(rom_data_i),
		.pc(pc),
		.isTaken(rom_isTaken_o),
		.ce(rom_ce_o)
	);

	// IF/ID
	if_id if_id0(
		.rst(rst),
		.clk(clk),
		.stall(stall),
		.if_pc(pc),
		.if_inst(rom_data_i),
		.input_isTaken(rom_isTaken_i),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i),
		.output_isTaken(id_isTaken_i)
	);

	id id0(
		.rst(rst),
		.input_pc(id_pc_i),
		.input_inst(id_inst_i),
		.isTaken(id_isTaken_i),
		.input_ex_aluop(ex_aluop_o),
		.input_ex_wreg(ex_wreg_o),
		.input_ex_wdata(ex_wdata_o),
		.input_ex_wd(ex_wd_o),
		.input_mem_wreg(mem_wreg_o),
		.input_mem_wdata(mem_wdata_o),
		.input_mem_wd(mem_wd_o),
		.input_reg1_data(reg1_data),
		.input_reg2_data(reg2_data),
		.input_inDelayslot(is_in_delayslot_i),
		.output_reg1_read(reg1_read),
		.output_reg2_read(reg2_read),
		.output_reg1_addr(reg1_addr),
		.output_reg2_addr(reg2_addr),
		.output_aluop(id_aluop_o),
		.output_alusel(id_alusel_o),
		.output_reg1(id_reg1_o),
		.output_reg2(id_reg2_o),
		.output_wd(id_wd_o),
		.output_wreg(id_wreg_o),
		.output_inst(id_inst_o),
		.next_inDelayslot(next_inst_in_delayslot_o),
		.output_branch_flag(id_branch_flag_o),
		.output_branch_addr(branch_target_address),
		.stallreq(stallreq_from_id)
	);

	regfile regfile0(
		.rst(rst),
		.clk(clk),
		.we(wb_wreg_i),
		.waddr(wb_wd_i),
		.wdata(wb_wdata_i),
		.re1(reg1_read),
		.raddr1(reg1_addr),
		.rdata1(reg1_data),
		.re2(reg2_read),
		.raddr2(reg2_addr),
		.rdata2(reg2_data)
	);	

	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.id_aluop(id_aluop_o),
		.id_alusel(id_alusel_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_link_address(id_link_address_o),
		.next_inst_in_delayslot_i(next_inst_in_delayslot_o),		
		.id_inst(id_inst_o),
		.ex_aluop(ex_aluop_i),
		.ex_alusel(ex_alusel_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.is_in_delayslot_o(is_in_delayslot_i),
		.ex_inst(ex_inst_i)			
	);
	
	ex ex0(
		.rst(rst),
		.aluop_i(ex_aluop_i),
		.alusel_i(ex_alusel_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
		.inst_i(ex_inst_i),
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),
		.aluop_o(ex_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o)
	);

	ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_aluop(ex_aluop_o),
		.ex_mem_addr(ex_mem_addr_o),
		.ex_reg2(ex_reg2_o),			
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
		.mem_aluop(mem_aluop_i),
		.mem_mem_addr(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i)
	);

	mem mem0(
		.rst(rst),
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
		.aluop_i(mem_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),
		.mem_data_i(ram_data_i),
		.is_hit_i(ram_hit),
		.cnt_i(ram_cnt_i),
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),
		.mem_addr_o(ram_addr_o),
		.mem_we_o(ram_we_o),
		.mem_sel_o(ram_sel_o),
		.mem_data_o(ram_data_o),
		.mem_ce_o(ram_ce_o),
		.cnt_o(ram_cnt_o),
		.stallreq(stallreq_from_mem)
	);

	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),
	    .stall(stall),
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i)
	);

	ctrl ctrl0(
		.rst(rst),
		.stall_from_id(stallreq_from_id),
		.stall_from_mem(stallreq_from_mem),
		.stall(stall)
	);
	
endmodule
