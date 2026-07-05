`include "defines.svh"

class ram_environment;

	virtual ram_if.DRV drv_vif;
	virtual ram_if.REF ref_vif;
	virtual ram_if.MON mon_vif;

	mailbox #(ram_transaction) gen_2_drv;
	mailbox #(ram_transaction) drv_2_ref;
	mailbox #(ram_transaction) ref_2_scb;
	mailbox #(ram_transaction) mon_2_scb;

	ram_generator gen;
	ram_driver drv;
	ram_referencemodel ref_m;
	ram_monitor mon;
	ram_scoreboard scb;

	function new(virtual ram_if.DRV drv_vif,virtual ram_if.DRV drv_vif,virtual ram_if.REF ref_vif,virtual ram_if.MON mon_vif);
		this.drv_vif = drv_vif;
		this.ref_vif = ref_vif;
		this.mon_vif = mon_vif;
	endfunction

	task build();
		gen_2_drv = new();
		drv_2_scb = new();
		ref_2_scb = new();
		mon_2_scb = new();

		gen=new(

