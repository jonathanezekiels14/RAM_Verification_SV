`include "defines.svh"
interface ram_if(input bit clk, input bit reset);
	logic [DATA_WIDTH-1:0] data_in;
	logic [ADDR_WIDTH-1:0] address;
	logic write_enb;
	logic read_enb;
	logic [DATA_WIDTH-1:0] data_out;


	clocking drv_cb @(posedge clk);
		default input #0 output #0;
		input reset;
		output data_in,address,write_enb,read_enb;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #0 output #0;
		input data_out;
	endclocking

	clocking ref_cb @(posedge clk);
		default input #0 output #0;
	endclocking

	modport DRV(clocking drv_cb);
	modport MON(clocking mon_cb);
	modport REF_SB(clocking ref_cb);

endinterface
