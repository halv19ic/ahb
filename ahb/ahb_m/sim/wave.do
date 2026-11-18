onerror {resume}
virtual type { \
IDLE\
BUSY\
{0x10 NONSEQ}\
{0x11 SEQ}\
} HTRANS_TYPE
quietly WaveActivateNextPane {} 0
add wave -noupdate -group USER_INTERFACE /testbench/dut/addr_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/burst_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/busy_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/cmd_id_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/cmd_ready_o
add wave -noupdate -group USER_INTERFACE /testbench/dut/cmd_vld_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/len_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/prot_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/size_i
add wave -noupdate -group USER_INTERFACE /testbench/dut/write_i
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/clk
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HADDR_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HBURST_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HPROT_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HRDATA_i
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HREADY_i
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HRESP_i
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HSIZE_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HSMARTLOCK_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HTRANS_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HWDATA_o
add wave -noupdate -expand -group AHB_M_INTERFACE /testbench/dut/u_ahb_m/HWRITE_o
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_m/clk
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HADDR_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HBURST_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HPROT_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HRDATA_o
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HREADY_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HREADYOUT_o
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HRESP_o
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HSEL_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HSIZE_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HSMARTLOCK_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HTRANS_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HWDATA_i
add wave -noupdate -group AHB_S_INTERFACE /testbench/dut/u_ahb_s/u_ahb_s/HWRITE_i
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/clk
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/reg_addr_i
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/reg_rdata_o
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/reg_rdta_vld_o
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/reg_ren_i
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/reg_wdata_i
add wave -noupdate -group REGISTER_INTERFACE /testbench/dut/u_ahb_s/u_regfile/reg_wen_i
add wave -noupdate -group ADDR_m_Gen /testbench/dut/addr_i
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/addr_aligned
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/addr_base
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/addr_bound
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/addr_i
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/addr_store
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/addr_wrap_point
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/haddr_d
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/HADDR_o
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/haddr_r
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/nxt_addr_incr
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/nxt_addr_wrap
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/operand_a
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/operand_b
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/wrap_burst_en
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/wrap_burst_mode
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/wrap_en
add wave -noupdate -group ADDR_m_Gen /testbench/dut/u_ahb_m/wrap_type
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/burst_to_busy
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/burst_to_idle
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/busy_to_idle
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/single_to_idle
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/idle_to_burst
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/busy_to_burst
add wave -noupdate -expand -group FSM_m -expand -group FSM_m -expand -group transition_state_logic /testbench/dut/u_ahb_m/idle_to_single
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/clk
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/nxt_trans_vld
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/busy_i
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/current_state
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/HTRANS_o
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/HADDR_o
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_s/u_ahb_s/HREADY_i
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/nxt_state
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/cur_state
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/err_resp
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/last_beat
add wave -noupdate -expand -group FSM_m /testbench/dut/u_ahb_m/nxt_trans_vld
add wave -noupdate /testbench/dut/u_ahb_m/dp_vld_d
add wave -noupdate /testbench/dut/u_ahb_m/dp_vld_r
add wave -noupdate -group Beat_count_m /testbench/dut/u_ahb_m/bcnt_clr
add wave -noupdate -group Beat_count_m /testbench/dut/u_ahb_m/bcnt_d
add wave -noupdate -group Beat_count_m /testbench/dut/u_ahb_m/bcnt_en
add wave -noupdate -group Beat_count_m /testbench/dut/u_ahb_m/bcnt_r
add wave -noupdate -group HRESP_s /testbench/dut/u_ahb_m/clk
add wave -noupdate -group HRESP_s /testbench/dut/u_ahb_s/u_ahb_s/HRESP_o
add wave -noupdate -group HRESP_s /testbench/dut/u_ahb_s/u_ahb_s/HADDR_i
add wave -noupdate -group HRESP_s -group ADDERSS_ERROR /testbench/dut/u_ahb_s/u_ahb_s/addr_aligned_err
add wave -noupdate -group HRESP_s -group ADDERSS_ERROR /testbench/dut/u_ahb_s/u_ahb_s/addr_range_err
add wave -noupdate -group HRESP_s -group ADDERSS_ERROR /testbench/dut/u_ahb_s/u_ahb_s/addr_size_err
add wave -noupdate -group HRESP_s -group ADDERSS_ERROR /testbench/dut/u_ahb_s/u_ahb_s/addr_err
add wave -noupdate -group HRESP_s -group ADDERSS_ERROR /testbench/dut/u_ahb_s/u_ahb_s/addr_err_d
add wave -noupdate -group HRESP_s -group ADDERSS_ERROR /testbench/dut/u_ahb_s/u_ahb_s/addr_err_r
add wave -noupdate -group HRESP_s /testbench/dut/u_ahb_s/u_ahb_s/hresp
add wave -noupdate -group HRESP_s /testbench/dut/u_ahb_s/u_ahb_s/hresp_err_sec
add wave -noupdate -group HRESP_s /testbench/dut/u_ahb_s/u_ahb_s/hresp_err_sec_r
add wave -noupdate -group HREADYOUT_s /testbench/dut/u_ahb_s/u_ahb_s/hreadyout_d
add wave -noupdate -group HREADYOUT_s /testbench/dut/u_ahb_s/u_ahb_s/HREADYOUT_o
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/bcnt_d
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/bcnt_en
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/bcnt_r
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/busy_trans
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/htrans_d
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/HTRANS_o
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/idle_trans
add wave -noupdate -expand -group TRANSFER_TYPE /testbench/dut/u_ahb_m/nonseq_trans
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1124583 ps} 0} {Trace {72861 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 637
configure wave -valuecolwidth 145
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {20235 ps} {203799 ps}
