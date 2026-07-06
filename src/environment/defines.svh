`timescale 1ns/100ps

`define DATA_WIDTH 8
`define DATA_DEPTH 32


`define num_of_transactions 8
function integer log2(int n);
	begin
		log2 = 0;
		while(2**log2 < 0)
			log2 = log2 + 1;
	end
endfunction

parameter ADDR_WIDTH = log2(`DATA_DEPTH)


