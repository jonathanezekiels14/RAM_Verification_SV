class ram_driver;
        ram_transaction drv_trans;
        mailbox #(ram_transaction) gen_2_drv;
        mailbox #(ram_transaction) drv_2_ref;

        covergroup drv_cg;
                WRITE: coverpoint drv_trans.write_enb {
                        bins wrt[] = {0,1};
                }
                READ: coverpoint drv_trans.read_enb {
                        bins rd[] = {0,1};
                }
                DATA_IN: coverpoint drv_trans.data_in {
                        bins data = {[0:255]};
                }
                ADDRESS: coverpoint drv_trans.address {
                        bins addr = {[0:31]};
                }
                WRXRD: cross WRITE,READ;
        endgroup

        virtual ram_if.DRV vif;
        
        function new(mailbox #(ram_transaction) gen_2_drv, mailbox #(ram_transaction) drv_2_ref, virtual ram_if.DRV vif);
                this.gen_2_drv = gen_2_drv;
                this.drv_2_ref = drv_2_ref;
                this.vif = vif;
                drv_cg = new();
        endfunction

        task run();
                repeat (3) @ (vif.drv_cb);

                for(int i=0; i<`num_of_transactions; i++) begin
                        gen_2_drv.get(drv_trans);
                        
                        // FIXED: Changed reset check from == 1 to == 0 to match top module
                        if(vif.reset == 0) begin
                                @(vif.drv_cb);
                                vif.drv_cb.data_in <= 'hz;
                                vif.drv_cb.address <= 0;
                                vif.drv_cb.write_enb <= 0;
                                vif.drv_cb.read_enb <= 0;
                                
                                drv_2_ref.put(drv_trans);
                                @(vif.drv_cb);
                                
                                $display("[DRIVER] [%0t] Driving RESET to Interface: DATA_IN = %0H | WRITE_ENB = 0 | READ_ENB = 0 | ADDR = 0", $time, 8'hz);
                        end
                        else begin
                                @(vif.drv_cb);
                                vif.drv_cb.data_in <= drv_trans.data_in;
                                vif.drv_cb.address <= drv_trans.address;
                                vif.drv_cb.write_enb <= drv_trans.write_enb;
                                vif.drv_cb.read_enb <= drv_trans.read_enb;
                                
                                drv_2_ref.put(drv_trans);
				@(vif.drv_cb);
                                
                                $display("[DRIVER] [%0t] to INTERFACE DATA_IN = %0H | ADDR = %0h | WRITE_ENB = %0b | READ_ENB = %0b", $time, drv_trans.data_in, drv_trans.address, drv_trans.write_enb, drv_trans.read_enb);
                                
                                drv_cg.sample();
                                $display("I/P Functional Coverage = %f%%", drv_cg.get_coverage());
                        end
                end
        endtask
endclass
