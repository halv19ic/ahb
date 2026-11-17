//Task Tomorrow
// Add hsize

module ahb_s #(
    parameter ADDR_W     = 32,
    parameter DATA_W     = 32,
    parameter WAIT_NUM   = 5,
    parameter ADDR_BASE  = 0
)(

    // Clock & Reset Signal
    input  logic                clk,
    input  logic                rstn,

    // Select
    input  logic                hsel_i,

    // Address
    input  logic [ADDR_W-1:0]   haddr_i,

    // Data
    input  logic [DATA_W-1:0]   hwdata_i,

    // Control Signals
    input  logic                hwrite_i,
    input  logic [2:0]          hburst_i,
    input  logic [2:0]          hsize_i,
    input  logic [1:0]          htrans_i,
    input  logic [3:0]          hprot_i,
    input  logic                hsmartlock_i,
    input  logic                hready_i,

    // Output AHB
    output logic [DATA_W-1:0]   hrdata_o,
    output logic                hresp_o,
    output logic                hreadyout_o,

    // Register Interface
    output logic [ADDR_W-1:0]   reg_addr_o,
    output logic [DATA_W-1:0]   reg_wdata_o,
    output logic                reg_wen_o,
    output logic                reg_ren_o,

    input  logic [DATA_W-1:0]   reg_rdata_i,
    input  logic                reg_rdata_vld_i
);

    //This Param to check HSIZE valid
    localparam MAX_HSIZE = $clog2(DATA_W / 8);

    // Internal Logic Declared
    logic                       ap_done;
    logic                       dp_vld_d;
    logic                       dp_vld;

    // Control Signals
    logic [ADDR_W-1:0]          haddr_d;
    logic                       hwrite_d;
    logic [2:0]                 hsize_d;
    logic [1:0]                 htrans_d;

    logic [ADDR_W-1:0]          haddr_r;
    logic                       hwrite_r;
    logic [2:0]                 hsize_r;
    logic [1:0]                 htrans_r;

    logic                       err_vld;
    logic                       hreadyout_d;

    logic                       rd_en;
    logic                       wr_en;

    // Counter
    logic                       wait_cnt_en;
    logic [5:0]                 wait_cnt_d;
    logic [5:0]                 wait_cnt;

    //Error
    logic                       addr_range_err;
    logic                       addr_size_err; 
    logic                       addr_err_d; 
    logic                       addr_err_r; 
    logic                       addr_err; 
    logic                       addr_aligned_err; 

    //Response 
    logic                       hresp;



    // Address Phase Done - Enable enter Data Phase
    // hready_i indicates the DATA PHASE of previouse transfer have done that enables the current transfer enters DATA PHASE
    // htrans_i [1:0] - 00: IDLE, 01:BUSY  -> be ignored by subordinate
    //                - 10: NONSEQ, 11:SEQ -> suitable transfer 
    assign ap_done = hready_i    &
                     htrans_i[1] &
                     hsel_i;

    // Data Phase Valid
    assign dp_vld_d = hready_i ? ap_done : dp_vld;
    dff_rstn #(1) r_dp_vld (.clk(clk), .rstn(rstn), .d(dp_vld_d), .q(dp_vld));

    // Update Control Signasl - New Transfer
    assign haddr_d  = ap_done ? haddr_i  : haddr_r;
    assign hwrite_d = ap_done ? hwrite_i : hwrite_r;
    assign hsize_d  = ap_done ? hsize_i  : hsize_r;
    assign htrans_d = ap_done ? htrans_i : htrans_r;

    dff_rstn #(1) r_hwr (.clk(clk), .rstn(rstn), .d(hwrite_d), .q(hwrite_r));
    dff_rstn #(3) r_hsz (.clk(clk), .rstn(rstn), .d(hsize_d), .q(hsize_r));
    dff_rstn #(2) r_htrans (.clk(clk), .rstn(rstn), .d(htrans_d), .q(htrans_r));

    //Address
    dff_rstn #(ADDR_W) r_haddr (.clk(clk), .rstn(rstn), .d(haddr_d), .q(haddr_r));
    dff_rstn #(ADDR_W) r_addr (.clk(clk), .rstn(rstn), .d(haddr_r), .q(reg_addr_o));

    // Address Check 
    //.Check Range Address - 1KB Address Boundary
    assign addr_range_err =  ((haddr_i<ADDR_BASE) || 
                              (haddr_i >= (ADDR_BASE + 1024)));

    //.Check Address Size   
    assign addr_size_err  =  (hsize_i > MAX_HSIZE); 

    //.Check Aligned Address 
    assign addr_aligned_err = |(haddr_i & ((ADDR_W'(1) << hsize_i) - 1'b1));

    //.Address Error
    assign addr_err =   addr_range_err ||
                        addr_size_err  ||
                        addr_aligned_err;

    assign addr_err_d = ap_done ? addr_err : addr_err_r;
    dff_rstn #(1) r_addr_err (.clk(clk), .rstn(rstn), .d(addr_err_d), .q(addr_err_r));

    //Write Data
    assign wr_en = hwrite_r    &
                   hreadyout_o &
                   ~addr_err_r &
                   dp_vld;
    dff_rstn #(1) r_wen (.clk(clk), .rstn(rstn), .d(wr_en), .q(reg_wen_o));
    dff #(DATA_W) r_wdata (.clk(clk), .d(hwdata_i), .q(reg_wdata_o));

    //Read Data
    logic re_pending_d;
    logic re_pending_r;

    assign rd_en = ~hwrite_r         &
                   ~addr_err_r       &
                   dp_vld            &
                   (wait_cnt_d=='0)  &
                   ~re_pending_r;
    
    assign re_pending_d = hready_i ? 1'b0 : 
                          rd_en  ? 1'b1 : re_pending_r;

    dff_rstn #(1) r_re_pending (.clk(clk), .rstn(rstn), .d(re_pending_d), .q(re_pending_r));

    dff_rstn #(1) r_ren (.clk(clk), .rstn(rstn), .d(rd_en), .q(reg_ren_o));

    logic [DATA_W-1:0] rdata;
    assign rdata = err_vld ? '0 : reg_rdata_i;

    dff_rstn #(DATA_W) r_rdata (.clk(clk), .rstn(rstn), .d(rdata), .q(hrdata_o));


    // Response Error 
    // When err_vld asserted, the hresp_o enable transfer ERROR response
    //The ERROR response requires two cycles.
    //To start the ERROR response, the Subordinate drives HRESP HIGH to indicate ERROR while driving HREADYOUT LOW to extend the transfer for one extra cycle. 
    //In the next cycle HREADYOUT is driven HIGH to end the transfer and HRESP remains driven HIGH to indicate ERROR.
    logic hresp_err_sec;
    logic hresp_err_sec_r;
    assign err_vld = dp_vld_d          &
                     (wait_cnt_d == 0) & 
                     addr_err_d        & 
                     ~hresp_err_sec_r;

    
    // OKAY = 1'b0; ERROR = 1'b1
    dff_rstn #(1) r_resp_0 (.clk(clk), .rstn(rstn), .d(err_vld), .q(hresp_o));

    assign hresp_err_sec  = hresp_o & (~hready_i);
    dff_rstn #(1) r_resp_sec (.clk(clk), .rstn(rstn), .d(hresp_err_sec), .q(hresp_err_sec_r));

    //hreadyout
    assign hreadyout_d = (~dp_vld_d)                ? 1'b1 :
                         hresp_err_sec              ? 1'b1 :
                         addr_err_d & (~hresp_o)    ? 1'b0 :
                         (wait_cnt_d!=0)            ? 1'b0 :  
                         hwrite_d                   ? 1'b1 : reg_rdata_vld_i;

    dff_rstn #(1) r_hrdo (.clk(clk), .rstn(rstn), .d(hreadyout_d), .q(hreadyout_o));

    // Count Wait State
    assign wait_cnt_en = dp_vld_d & (wait_cnt != '0);

    assign wait_cnt_d = ap_done     ? WAIT_NUM :
                        wait_cnt_en ? (wait_cnt - 1'b1) :
                        wait_cnt;
    dff_rstn #(6) r_wcnt (.clk(clk), .rstn(rstn), .d(wait_cnt_d), .q(wait_cnt));

endmodule

