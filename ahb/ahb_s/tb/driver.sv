class driver;

    mailbox #(packet) s2d_mb;
    virtual dut_if dut_vif;

    packet addr_pkt;
    packet data_pkt;
    packet next_pkt;

    // Constructor
    function new(virtual dut_if dut_vif,
                 mailbox #(packet) s2d_mb);

        this.dut_vif = dut_vif;
        this.s2d_mb  = s2d_mb;

    endfunction

    // Run driver
    task run();

        $display("%0t: [DRIVER] Start", $time);

        // Initialize bus
        dut_vif.hsel_i       = 1'b0;
        dut_vif.haddr_i      = '0;
        dut_vif.hwdata_i     = '0;
        dut_vif.hwrite_i     = 1'b0;
        dut_vif.hburst_i     = 1'b0;
        dut_vif.hsize_i      = '0;
        dut_vif.htrans_i     = 2'b00;
        dut_vif.hprot_i      = '0;
        dut_vif.hsmartlock_i = 1'b0;

        addr_pkt = null;
        data_pkt = null;

        // Wait for reset release
        wait (dut_vif.rstn == 1'b1);

        forever begin

            @(posedge dut_vif.clk);

            if (dut_vif.hready_i == 1'b1) begin

                // Move Address Phase to Data Phase
                data_pkt = addr_pkt;

                // Get next packet
                if (s2d_mb.try_get(next_pkt)) begin
                    addr_pkt = next_pkt;

                    $display("%0t: [DRIVER] Get packet",
                             $time);
                end
                else begin
                    addr_pkt = null;
                end

                // Drive Data Phase
                if (data_pkt != null) begin

                    if (data_pkt.hwrite) begin
                        dut_vif.hwdata_i <= data_pkt.hwdata;
                    end
                    else begin
                        dut_vif.hwdata_i <= '0;
                    end

                end
                else begin
                    dut_vif.hwdata_i <= '0;
                end

                // Drive Address Phase
                if (addr_pkt != null) begin

                    dut_vif.hsel_i       <= addr_pkt.hsel;
                    dut_vif.haddr_i      <= addr_pkt.haddr;
                    dut_vif.hwrite_i     <= addr_pkt.hwrite;
                    dut_vif.hburst_i     <= addr_pkt.hburst;
                    dut_vif.hsize_i      <= addr_pkt.hsize;
                    dut_vif.htrans_i     <= addr_pkt.htrans;
                    dut_vif.hprot_i      <= addr_pkt.hprot;
                    dut_vif.hsmartlock_i <= addr_pkt.hsmartlock;

                end
                else begin

                    dut_vif.hsel_i       <= 1'b0;
                    dut_vif.haddr_i      <= '0;
                    dut_vif.hwrite_i     <= 1'b0;
                    dut_vif.hburst_i     <= 1'b0;
                    dut_vif.hsize_i      <= '0;
                    dut_vif.htrans_i     <= 2'b00;
                    dut_vif.hprot_i      <= '0;
                    dut_vif.hsmartlock_i <= 1'b0;

                end

            end

        end

    endtask

endclass
