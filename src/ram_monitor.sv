class ram_monitor;

        ram_transaction mon_trans;
        mailbox #(ram_transaction) mon_2_scb;
        virtual ram_if.MON vif;

        covergroup mon_cg;
                DATA_OUT: coverpoint mon_trans.data_out {
                        bins b1 = {[0:255]};
                }
        endgroup

        function new(mailbox #(ram_transaction) mon_2_scb, virtual ram_if.MON vif);
                this.mon_2_scb = mon_2_scb;
                this.vif = vif;
                mon_cg = new();
        endfunction


        task run();
                repeat (4) @(vif.mon_cb);

                for(int i=0; i<`num_of_transactions; i++) begin
                        mon_trans = new();
                        
                        // Wait for a clock edge to sample
                        @(vif.mon_cb); 
                        
                        // FIXED: All reads must go through the clocking block (.mon_cb.)
                        mon_trans.data_out  = vif.mon_cb.data_out;
                        mon_trans.data_in   = vif.mon_cb.data_in;
                        mon_trans.address   = vif.mon_cb.address;
                        mon_trans.write_enb = vif.mon_cb.write_enb;
                        mon_trans.read_enb  = vif.mon_cb.read_enb;
                        
                        $display("[MONITOR] [%0t] OUTPUT DATA_OUT = %h", $time, mon_trans.data_out);
                        
                        mon_2_scb.put(mon_trans);
                        mon_cg.sample();
                        
                        // Wait for the next clock edge before looping again
                        @(vif.mon_cb);
                end
        endtask
endclass
