`include "defines.v"
`timescale 1ns/1ps

module testbench();
	reg CLOCK;
	reg rst;

	initial begin
		CLOCK = 1'b0;
		forever #10 CLOCK = ~CLOCK;
	end
      
	initial begin
	   rst = `One;
		#195 rst= `Zero;
	    #20000 $stop;
	end
       
	binder_rom_ram binder_rom_ram(
		.clk(CLOCK),
		.rst(rst)
	);
endmodule

