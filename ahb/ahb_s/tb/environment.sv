
class environment;

    stimulus    stim;
    driver      drv;
    monitor     mon;
    scoreboard  scb;

    mailbox #(packet) s2d_mb;
    mailbox #(packet) m2s_mb;

    virtual dut_if dut_vif;

    // Constructor
    function new(virtual dut_if dut_vif);
        this.dut_vif = dut_vif;
    endfunction

    // Build environment
    function void build();

        $display("%0t: [ENVIRONMENT] Build", $time);

        // Create mailboxes
        s2d_mb = new();
        m2s_mb = new();

        // Create components
        stim = new(s2d_mb);
        drv  = new(dut_vif, s2d_mb);
        mon  = new(dut_vif, m2s_mb);
        scb  = new(m2s_mb);

    endfunction

    // Run environment
    task run();

        $display("%0t: [ENVIRONMENT] Run", $time);

        fork
            stim.run();
            drv.run();
            mon.run();
            scb.run();
        join

    endtask

endclass

