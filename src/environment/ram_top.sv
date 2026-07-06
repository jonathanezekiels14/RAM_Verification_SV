`include "ram_interface.sv"
module top;
	import ram_package::*;

	bit clock;
	bit reset;

	initial begin
		forever #10 clock = ~clock;
	end

	initial begin
		@(posedge clock);
		reset = 0;
		@(posedge clock);
		reset = 1;
	end

	ram_if intrf(clock,reset);

	RAM DUV(.data_in(intrf.data_in),
		.write_enb(intrf.write_enb),
		.read_enb(intrf.read_enb),
		.data_out(intrf.data_out),
		.address(intrf.address),
		.clk(clock),
		.reset(reset)
	);
	ram_test_regression tb; 
	initial begin
		tb= new(intrf.DRV,intrf.MON,intrf.REF);
		tb.run();
		$finish;
	end
endmodule


