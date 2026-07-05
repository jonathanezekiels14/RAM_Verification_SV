`include "defines.svh"

class ram_scoreboard;

	ram_transaction ref_trans,mon_trans;
	mailbox #(ram_transaction) ref_2_scb,mon_2_scb;
	logic [`DATA_WIDTH-1:0] ref_mem [`DATA_DEPTH-1:0];
	logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH-1:0];
	int pass_count,fail_count;

	function new(mailbox #(ram_transaction) ref_2_scb, mailbox #(ram_transaction));
		this.ref_2_scb = ref_2_scb;
		this.mon_2_scb = mon_2_scb;
	endfunction

	task run();
		for(int i=0;i<num_of_transactions;i++) begin
			mon_trans = new();
			ref_trans = new();

			fork
				begin
					ref_2_scb.get(ref_trans);
					ref_mem[ref_trans.address] = ref_trans.data_out;
					$display("*****SCOREBOARD REF data_out = %h | address = %h *****",ref_mem[ref_trans.address],ref_trans.address,$time);
				end
				begin
					mon_2_scb.get(mon_trans);
					mon_mem[mon_trans.address] = mon_trans.data_out;
					$display("*****SCOREBOARD DUT data_out = %h | address = %h *****",mon_mem[mon_trans.address],mon_trans.address,$time);
				end
			join

			if( i != (`num_of_transactions - 1))
				compare_report();
		end
	endtask

	task compare_report();
		if(ref_mem[ref_trans.address] === mon_mem[mon_trans.address]) begin
			$display("SCOREBOARD REF data_out = %0h | MON data_out = %0h",ref_mem[ref_trans.address],mon_mem[mon_trans.address],$time);
			pass_count++;
			$display("DATA MATCH SUCCESSFUL. pass_count = %0d",pass_count);
		end

		else begin
			$display("SCOREBOARD REF data_out = %0h | MON data_out = %0h", ref_mem[ref_trans.address], mon_mem[mon_trans.address], $time); 
			fail_count++;	
			$display("DATA MATCH FAILURE. fail_count = %0d",fail_count);
		end
	endtask

endclass

