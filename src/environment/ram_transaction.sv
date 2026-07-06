`include "defines.svh"
class ram_transaction;
	rand logic [DATA_WIDTH-1:0] data_in;
	rand logic [ADDR_WIDTH-1:0] adddress;
	rand logic write_enb, read_enb;

	constraint wr_rd_constraint{
		{write_enb,read_enb} inside {[1:2]};
		{write_enb,read_enb} != 3;
	}

	virtual function ram_transaction copy();
		copy = new();
		copy.data_in = this.data_in;
		copy.address = this.address;
		copy.write_enb = this.write_enb;
		copy.read_enb = this.read_enb;
	endfunction
endclass

class ram_transaction1 extends ram_transaction;
	constraint wr_rd_constraint{
		{write_enb,read_enb} == 2'b01;
	}

	virtual function ram_transaction copy();
		ram_transaction1 copy1;
		copy1 = new();
		copy1.data_in = this.data_in;
		copy1.address = this.address;
		copy1.write_enb = this.write_enb;
		copy1.read_enb = this.read_enb;
		return copy1;
	endfunction
endclass

class ram_transaction2 extends ram_transaction;
	constraint wr_rd_constraint{
		{write_enb,read_enb} == 2'b10;
	}

	virtual function ram_transaction copy();
		ram_transaction2 copy2;
		copy2 = new();
		copy2.data_in = this.data_in;
		copy2.address = this.address;
		copy2.write_enb = this.write_enb;
		copy2.read_enb = this.read_enb;
		return copy2;
	endfunction
endclass

class ram_transaction3 extends ram_transaction;

	constraint wr_rd_constraint{
		{write_enb,read_enb} == 2'b11;
	}

	virtual function ram_transaction copy();
		ram_transaction3 copy3;
		copy3 = new();
		copy3.data_in = this.data_in;
		copy3.address = this.address;
		copy3.write_enb = this.write_enb;
		copy3.read_enb = this.read_enb;
		return copy3;
	endfunction
endclass

class ram_transaction4 eextends ram_transaction;

	constraint wr_rd_constraint{
		{write_enb,read_enb} == 2'b00;
	}

	virtual function ram_transaction copy();
		ram_transaction4 copy4;
		copy4 = new();
		copy4.data_in = this.data_in;
		copy4.address = this.address;
		copy4.write_enb = this.write_enb;
		copy4.read_enb = this.read_enb;
		return copy4;
	endfunction
endclass


