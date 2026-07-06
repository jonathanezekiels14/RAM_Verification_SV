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
		reset = 0;
		@(posedge clk);
		reset = 1;
	end

	ram_if intrf(clk,reset);

	RAM DUV(.data_in(intrf.data_in),
		.write_enb(intrf.write_enb),
		.read_enb(intrf.read_enb),
		.data_out(intrf.data_out),
		.address(intrf.address),
		.clk(clk),
		.reset(reset);
	);
	
	ram_regressio_test tb= new(intrf.DRV,intrf.MON,intrf.REF);

	initial begin
		tb.run();
		$finish;
	end
endmodule


