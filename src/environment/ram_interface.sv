`include "defines.svh"
interface ram_if(input bit clock, input bit reset);
        logic [`DATA_WIDTH-1:0] data_in;
        logic [`ADDR_WIDTH-1:0] address;
        logic write_enb;
        logic read_enb;
        logic [`DATA_WIDTH-1:0] data_out;

        clocking drv_cb @(posedge clock);
                default input #1step output #1ns;
                input reset;
                output data_in, address, write_enb, read_enb;
        endclocking

        clocking mon_cb @(posedge clock);
                default input #1step;
                input data_out, data_in, address, write_enb, read_enb;
        endclocking

        clocking ref_cb @(posedge clock);
                default input #1step;
                input data_in, address, write_enb, read_enb;
        endclocking

        modport DRV(clocking drv_cb,input clock,input reset);
        modport MON(clocking mon_cb,input clock,input reset);
	modport REF(clocking ref_cb,input clock,input reset);

endinterface
