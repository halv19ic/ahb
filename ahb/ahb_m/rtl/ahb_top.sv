//==============================================================================
// Company      : 
// File         : ahb_top.sv
// Author       : vinhha
// Created      : 2026-11-15
// Last Modified: 2026-11-18
//==============================================================================
// Description  :
//
//==============================================================================
module ahb_top #(
    parameter DATA_W   = 32,
    parameter ADDR_W   = 32,
    parameter BEAT_LEN = 5,
    parameter WAIT_NUM = 0,
    parameter ADDR_BASE = 0,
    parameter DEPTH = 512
)(
    input  logic                clk,
    input  logic                rstn,

    // User command interface
    output logic                cmd_ready_o,
    input  logic                cmd_vld_i,
    input  logic [3:0]          cmd_id_i,
    input  logic [BEAT_LEN-1:0] len_i,
    input  logic [2:0]          burst_i,
    input  logic                write_i,
    input  logic [2:0]          size_i,
    input  logic [3:0]          prot_i,
    input  logic                busy_i,
    input  logic [ADDR_W-1:0]   addr_i
);

//===================================
// AHB Interconnect Signals
//===================================
logic [ADDR_W-1:0] haddr;
logic [2:0]        hburst;
logic [2:0]        hsize;
logic [1:0]        htrans;
logic [3:0]        hprot;
logic              hsmartlock;
logic              hwrite;
logic [DATA_W-1:0] hwdata;
logic [DATA_W-1:0] hrdata;
logic              hresp;
logic              hready;

//===================================
// AHB Master
//===================================
ahb_m #(
    .DATA_W(DATA_W),
    .ADDR_W(ADDR_W),
    .BEAT_LEN(BEAT_LEN)
) u_ahb_m (
    .clk(clk),
    .rstn(rstn),
    .cmd_ready_o(cmd_ready_o),
    .cmd_vld_i(cmd_vld_i),
    .cmd_id_i(cmd_id_i),
    .len_i(len_i),
    .burst_i(burst_i),
    .write_i(write_i),
    .size_i(size_i),
    .prot_i(prot_i),
    .busy_i(busy_i),
    .addr_i(addr_i),
    .HADDR_o(haddr),
    .HBURST_o(hburst),
    .HSIZE_o(hsize),
    .HTRANS_o(htrans),
    .HPROT_o(hprot),
    .HSMARTLOCK_o(hsmartlock),
    .HWRITE_o(hwrite),
    .HWDATA_o(hwdata),
    .HREADY_i(hready),
    .HRDATA_i(hrdata),
    .HRESP_i(hresp)
);

//===================================
// AHB Slave
//===================================
ahb_s_top #(
    .ADDR_W(ADDR_W),
    .DATA_W(DATA_W),
    .WAIT_NUM(WAIT_NUM),
    .ADDR_BASE(ADDR_BASE),
    .DEPTH(DEPTH)
) u_ahb_s (
    .clk(clk),
    .rstn(rstn),
    .hsel_i(1'b1),
    .haddr_i(haddr),
    .hwdata_i(hwdata),
    .hwrite_i(hwrite),
    .hburst_i(hburst),
    .hsize_i(hsize),
    .htrans_i(htrans),
    .hprot_i(hprot),
    .hsmartlock_i(hsmartlock),
    .hready_i(hready),
    .hrdata_o(hrdata),
    .hresp_o(hresp),
    .hreadyout_o(hready)
);

endmodule

