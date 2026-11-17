module regfile #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter DEPTH  = 512
)(
    input  logic              clk,
    input  logic              rstn,
    input  logic [ADDR_W-1:0] reg_addr_i,
    input  logic [DATA_W-1:0] reg_wdata_i,
    input  logic              reg_wen_i,
    input  logic              reg_ren_i,

    output logic [DATA_W-1:0] reg_rdata_o,
    output logic              reg_rdta_vld_o
);

    logic [DATA_W-1:0]        mem_d [DEPTH-1:0];
    logic [DATA_W-1:0]        mem_r [DEPTH-1:0];
    logic [DATA_W-1:0]        rdata;

    // Write Data
    generate
        for (genvar i = 0; i < DEPTH; i++) begin
            assign mem_d[i] = (reg_wen_i && (reg_addr_i == i))
                            ? reg_wdata_i : mem_r[i];

            always_ff @(posedge clk)
                mem_r[i] <= mem_d[i];
        end
    endgenerate

    // Read Data
    assign rdata = reg_ren_i ? mem_r[reg_addr_i] : reg_rdata_o;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            reg_rdata_o    <= '0;
            reg_rdta_vld_o <= '0;
        end
        else begin
            reg_rdata_o    <= rdata;
            reg_rdta_vld_o <= reg_ren_i;
        end
    end

endmodule

