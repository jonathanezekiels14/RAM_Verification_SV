`include "defines.svh"

module top;
	import ram_package::*;

	bit clk;
	bit reset;

	initial begin
		forever #10 clk = ~clk;
	end

	initial begin
		@(posedge clk);
		reset = 1;
		@(posedge clk);
		reset = 0;
	end

	ram_if intrf(clk,reset);

	// DUT
	
	ram_test test = new(intrf.DRV,intrf.MON,intrf.REF);

	initial begin
		test.run();
		$finish;
	end
endmodule


