`include "defines.svh"

class ram_driver;

	ram_transaction drv_trans;
	mailbox #(ram_transaction) gen_2_drv;
	mailbox #(ram_transaction) drv_2_ref;

	virtual ram_if.DRV vif;
	function new(mailbox #(ram_transaction) gen_2_drv, mailbox #(ram_transaction) drv_2_ref, virtual ram_if.DRV vif);
		this.gen_2_drv = gen_2_drv;
		this.drv_2_ref = drv_2_ref;
		this.vif = vif;
	endfunction


	task run();

		repeat (3) @ (vif.drv_cb);

		for(int i=0;i<`num_of_transactions;i++) begin
			drv_trans = new();
			gen_2_drv.get(drv_trans);
			if(vif.reset == 1) begin
				vif.data_in <= 'hz;
				vif.address <= 0;
				vif.write_enb <= 0;
				vif.read_enb <= 0;
			end
			else begin
				vif.data_in <= drv_trans.data_in;
				vif.address <= drv_trans.address;

		

