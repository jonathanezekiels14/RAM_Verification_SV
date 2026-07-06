`include "defines.svh";
class ram_driver;
	ram_transaction drv_trans;
	mailbox #(ram_transaction) gen_2_drv;
	mailbox #(ram_transaction) drv_2_ref;

	virtual ram_if.DRV vif;
	function new(mailbox #(ram_transaction) gen_2_drv, mailbox #(ram_transaction) drv_2_ref, virtual ram_if.DRV vif);
		this.gen_2_drv = gen_2_drv;
		this.drv_2_ref = drv_2_ref;
		this.vif = vif;
		drv_cg = new();
	endfunction

	covergroup drv_cg;
		WRITE: coverpoint drv_trans.write_enb
		{
			bins wrt[] = {0,1};
		}
		READ: coverpoint drv_trans.read_enb
		{
			bins rd[] = {0,1};
		}
		DATA_IN: coverpoint drv_trans.data_in
		{
			bins data = {[0:255]};
		}
		ADDRESS: coverpoint drv_trans.address
		{
			bins addr = {[0:31]};
		}
		WRXRD: cross WRITE,READ;
	endgroup

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
				drv_2_ref.put(drv_trans);
				repeat(1) @(vif.drv_cb);
				$display("[DRIVER] [%0t] Driving data to the Interface DATA_IN = %0H | WRITE_ENB = %0b | READ_ENB = %0b | ADDR = %0H",$time,vif.drv_cb.data_in,vif.drv_cb.write_enb,vif.drv_cb.read_enb,vif.drv_cb.address);
			end
			else begin
				repeat(1) @(vif.drv_cb);
				vif.data_in <= drv_trans.data_in;
				vif.address <= drv_trans.address;
				vif.write_enb <= drv_trans.write_enb;
				vif.read_enb <= drv_trans.read_enb;
				drv_2_ref.put(drv_trans);
				$display("[DRIVER] [%t] to INTERFACE DATA_IN = %0H | ADDR = %0h | WRITE_ENB = %0b | READ_ENB = %0b",vif.drv_cb.data_in,vif.drv_cb.address,vif.drv_cb.write_enb,vif.drv_cb.read_enb);
				drv_cg.sample();
				$display("I/P Functional Coverage = %f%%",drv_cg.get_coverage());
			end
		end
	endtask
endclass


