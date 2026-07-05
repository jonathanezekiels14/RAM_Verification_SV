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

		cp1: coverpoint mon_trans.data_out
		{
			bins b1 = {[0:`DATA_WIDTH-1]};
		}
	endgroup

	task run();
		repeat (4) @(vif.mon_cb);

		for(int i=0;i<num_of_transactions;i++) begin
			mon_trans = new();
			repeat (1) @(vif.mon_cb);
			mon_trans.data_out = vif.data_out;

			$display("MONITOR OUTPUT data_out = %h",mon_trans.data_out);
			mon_2_scb.put(mon_trans);
			mon_cg.sample();
			repeat(1) @(vif.mon_cb);
		end
	endtask
endclass

