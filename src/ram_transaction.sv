`include "defines.svh"
class ram_transaction;
	rand logic [DATA_WIDTH-1:0] data_in;
	rand logic [ADDR_WIDTH-1:0] adddress;
	rand logic write_enb, read_enb;

	function ram_transaction copy();
		copy = new();
		copy.data_in = this.data_in;
		copy.address = this.address;
		copy.write_enb = this.write_enb;
		copy.read_enb = this.read_enb;
	endfunction
endclass
