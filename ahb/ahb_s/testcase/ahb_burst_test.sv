//==============================================================================
// File         : ahb_burst_test.sv
// Description  : Legal AHB INCR bursts with variable lengths.
//                Write each region, then read the same region.
//                32-bit word transfers, no intentional protocol errors.
//==============================================================================
class ahb_burst_test extends base_test;

    packet pkt;

    function new();
        super.new();
    endfunction

    // One undefined-length INCR burst, with test-selected number of beats.
    // The following NONSEQ or IDLE terminates the previous INCR burst.
    task send_incr(
        input bit          write_mode,
        input int unsigned num_beats,
        input bit [31:0]   start_addr
    );
        if (num_beats == 0)
            $fatal(1, "[AHB_BURST_TEST] num_beats must be > 0");

        // Each transfer is 4 bytes; keep the whole burst inside one 1KB region.
        if ((start_addr % 4) != 0 ||
            ((start_addr % 1024) + num_beats * 4) > 1024)
            $fatal(1, "[AHB_BURST_TEST] Invalid INCR address range");

        for (int unsigned i = 0; i < num_beats; i++) begin
            pkt = new();
            pkt.hsel       = 1'b1;
            pkt.hwrite     = write_mode;
            pkt.hburst     = INCR;
            pkt.hsize      = 3'b010; // 4 bytes / beat
            pkt.htrans     = (i == 0) ? 2'b10 : 2'b11; // NONSEQ, then SEQ
            pkt.haddr      = start_addr + (i * 4);
            pkt.hwdata     = write_mode ? $urandom : '0;
            pkt.hprot      = 4'b0011;
            pkt.hsmartlock = 1'b0;
            pkt.hready     = 1'b1;

            $display("[AHB_BURST_TEST] %s INCR beat=%0d/%0d addr=%08h data=%08h",
                     write_mode ? "WRITE" : "READ ",
                     i + 1, num_beats, pkt.haddr, pkt.hwdata);

            send_pkt(pkt);
        end
    endtask

    virtual task run_scenario();
        int unsigned burst_len[7] = '{1, 2, 3, 4, 8, 16, 32};
        bit [31:0] start_addr;

        // A 512-entry word-addressed-style test region is not assumed;
        // these byte addresses lie in 0x100..0x17C, within current DEPTH=512.
        start_addr = 32'h0000_0100;

        foreach (burst_len[i]) begin
            $display("=============================================");
            $display("[AHB_BURST_TEST] INCR %0d BEATS: WRITE", burst_len[i]);
            send_incr(1'b1, burst_len[i], start_addr);

            $display("[AHB_BURST_TEST] INCR %0d BEATS: READ", burst_len[i]);
            send_incr(1'b0, burst_len[i], start_addr);
        end

        $display("[AHB_BURST_TEST] All INCR packets queued");
    endtask

endclass

