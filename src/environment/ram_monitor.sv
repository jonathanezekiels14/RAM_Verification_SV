`inlcude "defines.svh"

class ram_monitor;

	ram_transaction mon_trans;
	mailbox #(ram_transaction) mon_2_scb;
	virtual ram_if.MON vif;

	function new(mailbox #(ram_transaction) mon_2_scb, virtual ram_if.REF vif);
		this.mon_2_scb = mon_2_scb;
		this.vif = vif;
		mon_cg = new();
	endfunction

	covergroup mon_cg;

		DATA_OUT: coverpoint mon_trans.data_out
		{
			bins b1 = {[0:255]};
		}
	endgroup

	task run();
		repeat (4) @(vif.mon_cb);

		for(int i=0;i<num_of_transactions;i++) begin
			mon_trans = new();
			repeat (1) @(vif.mon_cb);
			mon_trans.data_out = vif.data_out;
			mon_trans.data_in = vif.data_in;
			mon_trans.address = vif.address;
			mon_trans.write_enb = vif.write_enb;
			mon_trans.read_enb = vif.read_enb;
			$display("[MONITOR] [%0t] OUTPUT DATA_OUT = %h",$time,mon_trans.data_out);
			mon_2_scb.put(mon_trans);
			mon_cg.sample();
			repeat(1) @(vif.mon_cb);
		end
	endtask
endclass

