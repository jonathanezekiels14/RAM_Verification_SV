`include "defines.svh"

class ram_referencemodel;

	ram_transaction ref_trans;
	mailbox #(ram_transaction) drv_2_ref;
	mailbox #(ram_transaction) ref_2_scb;

	virtual ram_if.REF vif;

	reg [`DATA_WIDTH-1:0] mem [`DATA_DEPTH-1:0];

	function new(mailbox #(ram_transaction) drv_2_ref, mailbox #(ram_transaction) ref_2_scb, interface ram_if.REF vif);
		this.drv_2_ref = drv_2_ref;
		this.ref_2_scb = ref_2_scb;
		this.vif = vif;
	endfunction

	task run();
		for(int i = 0;i<num_of_transactions;i++) begin
			ref_trans = new();
			drv_2_ref.get(ref_trans);
			repeat (1) @(vif.ref_cb);
			if(ref_trans.write_enb == 1) begin
				mem[ref_trans.address] = ref_trans.data_in;
				$display("Reference Model Data in mem[%h] = %h",ref_trans.address,ref_trans.data_in);
			end

			if(ref_trans.read_enb == 1) begin
				ref_trans.data_out = mem[ref_trans.address];
				$display("Reference model data out = %h",ref_trans.data_out);
			end
			ref_2_scb.put(ref_trans);
		end
	endtask

endclass


