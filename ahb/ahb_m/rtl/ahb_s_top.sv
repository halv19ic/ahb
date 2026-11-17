
module ahb_s_top #(
    parameter ADDR_W     = 32,
    parameter DATA_W     = 32,
    parameter WAIT_NUM   = 5,
    parameter ADDR_BASE  = 0,
    parameter DEPTH      = 512
)(
    // Clock & Reset
    input  logic                clk,
    input  logic                rstn,

    // AHB Slave Interface
    input  logic                hsel_i,
    input  logic [ADDR_W-1:0]   haddr_i,
    input  logic [DATA_W-1:0]   hwdata_i,
    input  logic                hwrite_i,
    input  logic [2:0]          hburst_i,
    input  logic [2:0]          hsize_i,
    input  logic [1:0]          htrans_i,
    input  logic [3:0]          hprot_i,
    input  logic                hsmartlock_i,
    input  logic                hready_i,

    output logic [DATA_W-1:0]   hrdata_o,
    output logic                hresp_o,
    output logic                hreadyout_o
);




    // Internal signals: AHB Slave <-> Register File
    logic [ADDR_W-1:0] reg_addr;
    logic [DATA_W-1:0] reg_wdata;
    logic [DATA_W-1:0] reg_rdata;

    logic reg_wen;
    logic reg_ren;
    logic reg_rdata_vld;

    // AHB Slave
    ahb_s #(
        .ADDR_W    (ADDR_W),
        .DATA_W    (DATA_W),
        .WAIT_NUM  (WAIT_NUM),
        .ADDR_BASE (ADDR_BASE)
    ) u_ahb_s (
        .clk             (clk),
        .rstn            (rstn),

        .hsel_i          (hsel_i),
        .haddr_i         (haddr_i),
        .hwdata_i        (hwdata_i),

        .hwrite_i        (hwrite_i),
        .hburst_i        (hburst_i),
        .hsize_i         (hsize_i),
        .htrans_i        (htrans_i),
        .hprot_i         (hprot_i),
        .hsmartlock_i    (hsmartlock_i),
        .hready_i        (hready_i),

        .hrdata_o        (hrdata_o),
        .hresp_o         (hresp_o),
        .hreadyout_o     (hreadyout_o),

        .reg_addr_o      (reg_addr),
        .reg_wdata_o     (reg_wdata),
        .reg_wen_o       (reg_wen),
        .reg_ren_o       (reg_ren),

        .reg_rdata_i     (reg_rdata),
        .reg_rdata_vld_i (reg_rdata_vld)
    );

    // Register File
    regfile #(
        .ADDR_W (ADDR_W),
        .DATA_W (DATA_W),
        .DEPTH  (DEPTH)
    ) u_regfile (
        .clk            (clk),
        .rstn           (rstn),

        .reg_addr_i     (reg_addr),
        .reg_wdata_i    (reg_wdata),
        .reg_wen_i      (reg_wen),
        .reg_ren_i      (reg_ren),

        .reg_rdata_o    (reg_rdata),
        .reg_rdta_vld_o (reg_rdata_vld)
    );

endmodule

