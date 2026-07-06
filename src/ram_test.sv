`include "defines.svh"

class ram_test;
	virtual ram_if drv_vif;
	virtual ram_if mon_vif;
	virtual ram_if ref_vif;

	ram_environment env;

	function new(virtual ram_if drv_vif, virtual ram_if mon_vif, virtual ram_if ref_vif);
		this.drv_vif = drv_vif;
		this.mon_vif = mon_vif;
		this.ref_vif = ref_vif;
	endfunction

	virtual task run();
		env = new(drv_vif,mon_vif,ref_vif);
		env.build();
		env.run();
	endtask
endclass

class ram_test1 extends ram_test;
	ram_transaction1 trans;
	function new(virtual ram_if drv_if,virtual ram_if mon_if virtual ram_if ref_if);
		super.new(drv_if,mon_if,ref_if);
	endfunction

	virtual task run();
		$display("Running Test ID: 1");
		env=new(drv_vif,mon_vif,ref_vif);
		env.build();
		begin
			trans = new();
			env.gen.gen_trans = trans;
		end
		env.run();
	endtask
endclass


class ram_test2 extends ram_test;
	ram_transaction2 trans;
	function new(virtual ram_if drv_if,virtual ram_if mon_if virtual ram_if ref_if);
		super.new(drv_if,mon_if,ref_if);
	endfunction

	virtual task run();
		$display("Running Test ID: 2");
		env=new(drv_vif,mon_vif,ref_vif);
		env.build();
		begin
			trans = new();
			env.gen.gen_trans = trans;
		end
		env.run();
	endtask
endclass
class ram_test3 extends ram_test;
	ram_transaction3 trans;
	function new(virtual ram_if drv_if,virtual ram_if mon_if virtual ram_if ref_if);
		super.new(drv_if,mon_if,ref_if);
	endfunction

	virtual task run();
		$display("Running Test ID: 3");
		env=new(drv_vif,mon_vif,ref_vif);
		env.build();
		begin
			trans = new();
			env.gen.gen_trans = trans;
		end
		env.run();
	endtask
endclass
class ram_test4 extends ram_test;
	ram_transaction4 trans;
	function new(virtual ram_if drv_if,virtual ram_if mon_if virtual ram_if ref_if);
		super.new(drv_if,mon_if,ref_if);
	endfunction

	virtual task run();
		$display("Running Test ID: 4");
		env=new(drv_vif,mon_vif,ref_vif);
		env.build();
		begin
			trans = new();
			env.gen.gen_trans = trans;
		end
		env.run();
	endtask
endclass


class ram_test_regression extends ram_test;
	ram_transaction q[$];
	ram_transaction t0;
	ram_transaction1 t1;
	ram_transaction2 t2;
	ram_transaction3 t3;
	ram_transaction4 t4;

	function new(virtual ram_if drv_vif,virtual ram_if mon_vif, virtual ram_if ref_vif);
		super.new(drv_if,mon_vif,ref_vif);
	endfunction

	virtual task run();
		env = new(drv_vif,mon_vif,ref_vif);
		env.build();
		t0 = new();
		q.push_back(t0);
		t1 = new();
		q.push_back(t1);
		t2 = new();
		q.push_back(t2);
		t3 = new();
		t3.push_back(t3);
		t4 = new();
		t4.push_back(t4);

		foreach(q[i]) begin
			env.gen.gen_trans = q[i];
			env.run();
		end
	endtask
endclass






