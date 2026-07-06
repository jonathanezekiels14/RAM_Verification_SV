
class ram_environment;

	virtual ram_if drv_vif;
	virtual ram_if ref_vif;
	virtual ram_if mon_vif;

	mailbox #(ram_transaction) gen_2_drv;
	mailbox #(ram_transaction) drv_2_ref;
	mailbox #(ram_transaction) ref_2_scb;
	mailbox #(ram_transaction) mon_2_scb;

	ram_generator gen;
	ram_driver drv;
	ram_referencemodel ref_m;
	ram_monitor mon;
	ram_scoreboard scb;

	function new(virtual ram_if drv_vif,virtual ram_if ref_vif,virtual ram_if mon_vif);
		this.drv_vif = drv_vif;
		this.ref_vif = ref_vif;
		this.mon_vif = mon_vif;
	endfunction

	task build();
		begin
			gen_2_drv = new();
			drv_2_ref = new();
			ref_2_scb = new();
			mon_2_scb = new();
		
			gen=new(gen_2_drv);
			drv = new(gen_2_drv,drv_2_ref,drv_vif);
			ref_m = new(drv_2_ref,ref_2_scb,ref_vif);
			mon = new(mon_2_scb,mon_vif);
			scb = new(ref_2_scb,mon_2_scb);
		end
	endtask

	task run();
		fork
			gen.run();
			drv.run();
			mon.run();
			ref_m.run();
			scb.run();
		join
		scb.compare_report();
	endtask
endclass
		

