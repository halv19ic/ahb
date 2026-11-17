`timescale 1ns/1ps

module testbench;

parameter DATA_W   = 32;
parameter ADDR_W   = 32;
parameter BEAT_LEN = 5;
parameter WAIT_NUM = 5;

logic                clk;
logic                rstn;

logic                cmd_ready_o;
logic                cmd_vld_i;
logic [3:0]          cmd_id_i;
logic [BEAT_LEN-1:0] len_i;
logic [2:0]          burst_i;
logic                write_i;
logic [2:0]          size_i;
logic [3:0]          prot_i;
logic                busy_i;
logic [ADDR_W-1:0]   addr_i;

//===================================
//DUT
//===================================
ahb_top #(
    .DATA_W(DATA_W),
    .ADDR_W(ADDR_W),
    .WAIT_NUM(WAIT_NUM),
    .BEAT_LEN(BEAT_LEN)
) dut (
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
    .addr_i(addr_i)
);

//===================================
//Clock Generator
//===================================
initial clk = 1'b0;
always #5 clk = ~clk;

//===================================
//Test Sequence
//===================================
initial begin
    rstn      = 1'b0;
    cmd_vld_i = 1'b0;
    cmd_id_i  = 4'd0;
    len_i     = 5'd1;
    burst_i   = 3'b000;
    write_i   = 1'b0;
    size_i    = 3'b000;
    prot_i    = 4'b0011;
    busy_i    = 1'b0;
    addr_i    = '0;

    //Reset
    repeat(3) @(posedge clk);
    rstn <= 1'b1;

    repeat(2) @(posedge clk);

    //===================================
    //SINGLE WRITE Command
    //===================================
    @(posedge clk);
    cmd_vld_i <= 1'b1;
    cmd_id_i  <= 4'd1;
    len_i     <= 5'd1;
    burst_i   <= 3'b010;
    write_i   <= 1'b1;
    size_i    <= 3'b010;
    addr_i    <= 32'd28;

    //Deassert command valid
    @(posedge clk);
    cmd_vld_i <= 1'b0;

       //Wait for transaction
    repeat(200) @(posedge clk);

    $finish;
end

//===================================
//Monitor
//===================================
initial begin
    $display("Time | CMD_VLD | CMD_READY | STATE | HTRANS | HADDR | HREADY");

    $monitor("%0t | %b | %b | %b | %b | %h | %b",
        $time,
        cmd_vld_i,
        cmd_ready_o,
        dut.u_ahb_m.cur_state,
        dut.htrans,
        dut.haddr,
        dut.hready
    );
end

endmodule



