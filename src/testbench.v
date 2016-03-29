`include "defines.v"
`timescale 1ns/1ps

module testbench();
	reg CLOCK;
	reg rst;

	initial begin
		CLOCK = 1'b0;
		forever begin
			#10 CLOCK = ~CLOCK;
		end
	end
      
	initial begin
	  #100 rst = `One;
	  #195 rst= `Zero;
	  #100000 $stop;
	end
       
	binder_rom_ram binder_rom_ram0(
		.clk(CLOCK),
		.rst(rst)
	);
endmodule

