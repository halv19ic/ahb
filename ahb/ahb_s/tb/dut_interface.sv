interface dut_if;

    import ahb_pkg ::*;

    // Clock & Reset
    logic               clk;
    logic               rstn;

    // AHB Slave Interface - Input
    logic               hsel_i;
    logic [ADDR_W-1:0]  haddr_i;
    logic [DATA_W:0]    hwdata_i;
    logic               hwrite_i;
    logic [2:0]         hburst_i;
    logic [2:0]         hsize_i;
    logic [1:0]         htrans_i;
    logic [3:0]         hprot_i;
    logic               hsmartlock_i;
    logic               hready_i;

    // AHB Slave Interface - Output
    logic [31:0]        hrdata_o;
    logic               hresp_o;
    logic               hreadyout_o;

endinterface
