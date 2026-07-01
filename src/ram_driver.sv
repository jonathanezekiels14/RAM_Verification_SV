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
				repeat (1) @(vif.drv_b);
				vif.data_in <= 'hz;
				vif.address <= 0;
				vif.write_enb <= 0;
				vif.read_enb <= 0;
			end
			else begin
				repeat(1) @(vif.drv_cb);
				vif.data_in <= drv_trans.data_in;
				vif.address <= drv_trans.address;
				vif.write_enb <= drv_trans.write_enb;
				vif.read_enb <= drv_trans.read_enb;
				drv_2_ref.put(drv_trans);
				$display("DRIVER to INTERFACE DATA_IN = %0H | ADDR = %0h | WRITE_ENB = %0b | READ_ENB = %0b",drv_trans.data_in,drv_trans.address,drv_trans.write_enb,drv_trans.read_enb);
				
