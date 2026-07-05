`include "defines.svh"

class ram_environment;

	virtual ram_if.DRV drv_vif;
	virtual ram_if.REF ref_vif;
	virtual ram_if.MON mon_vif;

	mailbox #(ram_transaction) gen_2_drv;
	mailbox #(ram_transaction) drv_2_ref;
	mailbox #(ram_transaction) ref_2_scb;
	mailbox #(ram_transaction) mon_2_scb;


