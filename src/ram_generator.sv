`include "defines.svh"
class ram_generator;

	ram_transaction gen_trans;

	mailbox #(ram_transaction) gen_2_drv;

	function new(mailbox #(ram_transaction) gen_2_drv);
		this.gen_2_drv = gen_2_drv;
		gen_trans = new();
	endfunction

	task run();
		for(int i=0;i<`num_of_transactions;i++) begin
			assert(gen_trans.randomize() == 1);
			gen_2_drv.put(gen_trans);
			$display("GENERATOR Randomized data DATA_IN = %0H | ADDR = %0h | WRITE_ENB = %0b | READ_ENB = %0b",gen_trans.data_in,gen_trans.address,gen_trans.write_enb,gen_trans.read_enb);
		end
	endtask
endclass


			

