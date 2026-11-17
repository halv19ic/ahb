//==============================================================================
// Company      : 
// File         : ffrst.sv
// Author       : vinhha
// Created      : 2026-11-05
// Last Modified: 2026-11-05
//==============================================================================
// Description  :
//
//==============================================================================
module dff_rstn #(
parameter DW = 1)(
input  logic            clk,
input  logic            rstn,
input  logic [DW-1:0]   d, 
output logic [DW-1:0]   q);

always_ff @ (posedge clk or negedge rstn) begin
    if(~rstn) q <= '0;
    else      q <= d; 
end
endmodule
