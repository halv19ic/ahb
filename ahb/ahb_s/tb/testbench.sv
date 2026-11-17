
module testbench;

    import ahb_pkg::*;
    import test_pkg::*;

    //==========================================================================
    // Interface
    //==========================================================================
    dut_if d_if();

    //==========================================================================
    // DUT
    //==========================================================================
    ahb_s_top #(
        .ADDR_W    (32),
        .DATA_W    (32),
        .WAIT_NUM  (0),
        .ADDR_BASE (0),
        .DEPTH     (512)
    ) u_dut (
        .clk          (d_if.clk),
        .rstn         (d_if.rstn),

        .hsel_i       (d_if.hsel_i),
        .haddr_i      (d_if.haddr_i),
        .hwdata_i     (d_if.hwdata_i),
        .hwrite_i     (d_if.hwrite_i),
        .hburst_i     (d_if.hburst_i),
        .hsize_i      (d_if.hsize_i),
        .htrans_i     (d_if.htrans_i),
        .hprot_i      (d_if.hprot_i),
        .hsmartlock_i (d_if.hsmartlock_i),
        .hready_i     (d_if.hready_i),

        .hrdata_o     (d_if.hrdata_o),
        .hresp_o      (d_if.hresp_o),
        .hreadyout_o  (d_if.hreadyout_o)
    );

    //==========================================================================
    // Clock generation
    //==========================================================================
    initial begin
        d_if.clk = 1'b0;
        forever #5 d_if.clk = ~d_if.clk;
    end

    //==========================================================================
    // Reset generation
    //==========================================================================
    initial begin
        d_if.rstn = 1'b0;
        #100;
        d_if.rstn = 1'b1;
    end

    //==========================================================================
    // HREADY connection
    //==========================================================================
    assign d_if.hready_i = d_if.hreadyout_o;

    //==========================================================================
    // Testcase selection
    //==========================================================================
    base_test      test;
    ahb_burst_test burst_test;
    ahb_error_test error_test;

    string test_name;

    initial begin

        // Get testcase name from command line
        if (!$value$plusargs("TESTNAME=%s", test_name)) begin
            test_name = "ahb_burst_test";
        end

        $display("========================================");
        $display("[TESTBENCH] Selected test: %s", test_name);
        $display("========================================");

        // Create selected testcase
        case (test_name)

            "ahb_burst_test": begin
                burst_test = new();
                test = burst_test;
            end

            "ahb_error_test": begin
                error_test = new();
                test = error_test;
            end

            default: begin
                $fatal(1,
                    "[TESTBENCH] Unknown testcase: %s",
                    test_name
                );
            end

        endcase

        // Connect virtual interface
        test.dut_vif = d_if;

        // Run selected testcase
        test.run_test();

    end

endmodule

