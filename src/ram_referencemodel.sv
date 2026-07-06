
class ram_referencemodel;

	ram_transaction ref_trans;
	mailbox #(ram_transaction) drv_2_ref;
	mailbox #(ram_transaction) ref_2_scb;

	virtual ram_if.REF vif;

	reg [`DATA_WIDTH-1:0] mem [`ADDR_WIDTH-1:0];

	function new(mailbox #(ram_transaction) drv_2_ref, mailbox #(ram_transaction) ref_2_scb, virtual interface ram_if.REF vif);
		this.drv_2_ref = drv_2_ref;
		this.ref_2_scb = ref_2_scb;
		this.vif = vif;
	endfunction

	task run();
		for(int i = 0;i<`num_of_transactions;i++) begin
			ref_trans = new();
			drv_2_ref.get(ref_trans);
			repeat (1) @(vif.ref_cb);
			if(ref_trans.write_enb == 0) begin
				mem[ref_trans.address] = ref_trans.data_in;
				$display("[REF] [%0t] Reference Model Data in MEM[%h] = %h",$time,ref_trans.address,ref_trans.data_in);
			end

			if(ref_trans.read_enb == 0) begin
				ref_trans.data_out = mem[ref_trans.address];
				$display("[REF] [%0t] Reference model DATA_OUT = %h",$time,ref_trans.data_out);
			end
			ref_2_scb.put(ref_trans);
		end
	endtask

endclass


