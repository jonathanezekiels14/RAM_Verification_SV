
class ram_scoreboard;

	ram_transaction ref_trans,mon_trans;
	mailbox #(ram_transaction) ref_2_scb;
	mailbox #(ram_transaction) mon_2_scb;
	logic [`DATA_WIDTH-1:0] ref_mem [`DATA_DEPTH];
	logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH];
	int pass_count,fail_count;

	function new(mailbox #(ram_transaction) ref_2_scb, mailbox #(ram_transaction) mon_2_scb);
		this.ref_2_scb = ref_2_scb;
		this.mon_2_scb = mon_2_scb;
	endfunction

	task run();
		for(int i=0;i<`num_of_transactions;i++) begin
			fork
				begin
					ref_2_scb.get(ref_trans);
					ref_mem[ref_trans.address] = ref_trans.data_out;
					$display("[SCOREBOARD] [%0t] REF DATA_OUT = %h | ADDRESS = %h",$time,ref_mem[ref_trans.address],ref_trans.address);
				end
				begin
					mon_2_scb.get(mon_trans);
					mon_mem[mon_trans.address] = mon_trans.data_out;
					$display("[SCOREBOARD] [%0t] DUT DATA_OUT = %h | ADDRESS = %h",$time,mon_mem[mon_trans.address],mon_trans.address);
				end
			join

			compare_report();
		end
	endtask

	task compare_report();
		if(ref_mem[ref_trans.address] === mon_mem[mon_trans.address]) begin
			$display("[SCOREBOARD] [%0t] REF DATA_OUT = %0h | MON DATA_OUT = %0h",$time,ref_mem[ref_trans.address],mon_mem[mon_trans.address]);
			pass_count++;
			$display("[SCOREBOARD] DATA MATCH SUCCESSFUL. pass_count = %0d",pass_count);
		end

		else begin
			$display("[SCOREBOARD] [%0t] REF DATA_OUT = %0h | MON DATA_OUT = %0h",$time, ref_mem[ref_trans.address], mon_mem[mon_trans.address]); 
			fail_count++;	
			$display("[SCOREBOARD] DATA MATCH FAILURE. fail_count = %0d",fail_count);
		end
	endtask
endclass

