
class monitor;

    mailbox #(packet) m2s_mb;
    virtual dut_if dut_vif;

    packet addr_pkt;

    // Constructor
    function new(
        virtual dut_if dut_vif,
        mailbox #(packet) m2s_mb
    );
        this.dut_vif = dut_vif;
        this.m2s_mb  = m2s_mb;
    endfunction

    // Monitor DUT interface
    task run();

        packet pkt;

        addr_pkt = null;

        $display("%0t: [MONITOR] Start", $time);

        forever begin

            @(posedge dut_vif.clk);

            if (!dut_vif.rstn) begin
                addr_pkt = null;
            end

            else if (dut_vif.hready_i === 1'b1) begin

                // ===================================
                // 1. Complete previous data phase
                // ===================================
                if (addr_pkt != null) begin

                    pkt = addr_pkt;

                    if (pkt.hwrite)
                        pkt.hwdata = dut_vif.hwdata_i;
                    else
                        pkt.hrdata = dut_vif.hrdata_o;

                    pkt.hresp = dut_vif.hresp_o;

                    $display(
                        "%0t: [MONITOR] %s ADDR=%08h WDATA=%08h RDATA=%08h RESP=%0b",
                        $time,
                        pkt.hwrite ? "WRITE" : "READ ",
                        pkt.haddr,
                        pkt.hwdata,
                        pkt.hrdata,
                        pkt.hresp
                    );

                    m2s_mb.put(pkt);

                end

                // ===================================
                // 2. Capture current address phase
                // ===================================
                if (dut_vif.hsel_i &&
                    dut_vif.htrans_i[1]) begin

                    addr_pkt = new();

                    addr_pkt.hsel       = dut_vif.hsel_i;
                    addr_pkt.haddr      = dut_vif.haddr_i;
                    addr_pkt.hwrite     = dut_vif.hwrite_i;
                    addr_pkt.hburst     = dut_vif.hburst_i;
                    addr_pkt.hsize      = dut_vif.hsize_i;
                    addr_pkt.htrans     = dut_vif.htrans_i;
                    addr_pkt.hprot      = dut_vif.hprot_i;
                    addr_pkt.hsmartlock = dut_vif.hsmartlock_i;
                    addr_pkt.hready     = dut_vif.hready_i;

                end
                else begin
                    addr_pkt = null;
                end

            end
            // HREADY = 0:
            // Keep previous transaction pending

        end

    endtask

endclass

