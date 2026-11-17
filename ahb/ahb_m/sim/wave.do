onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TOP /testbench/write_i
add wave -noupdate -group TOP /testbench/size_i
add wave -noupdate -group TOP /testbench/rstn
add wave -noupdate -group TOP /testbench/prot_i
add wave -noupdate -group TOP /testbench/len_i
add wave -noupdate -group TOP /testbench/cmd_vld_i
add wave -noupdate -group TOP /testbench/cmd_ready_o
add wave -noupdate -group TOP /testbench/cmd_id_i
add wave -noupdate -group TOP /testbench/clk
add wave -noupdate -group TOP /testbench/busy_i
add wave -noupdate -group TOP /testbench/burst_i
add wave -noupdate -group TOP /testbench/addr_i
add wave -noupdate -expand -group ahb_master /testbench/dut/u_ahb_m/clk
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/size_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/burst_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/len_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/hresp_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/hready_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/hrdata_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/cmd_id_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/busy_i
add wave -noupdate -expand -group ahb_master -expand -group Input /testbench/dut/u_ahb_m/addr_i
add wave -noupdate -expand -group ahb_master -expand -group Valid /testbench/dut/u_ahb_m/cmd_vld_i
add wave -noupdate -expand -group ahb_master -expand -group Valid /testbench/dut/u_ahb_m/cmd_vld
add wave -noupdate -expand -group ahb_master -expand -group Valid /testbench/dut/u_ahb_m/dp_vld_r
add wave -noupdate -expand -group ahb_master -expand -group Valid /testbench/dut/u_ahb_m/dp_vld_d
add wave -noupdate -expand -group ahb_master /testbench/dut/u_ahb_m/ap_done
add wave -noupdate -expand -group ahb_master -expand -group {Beat Counter} /testbench/dut/u_ahb_m/cmd_ready_o
add wave -noupdate -expand -group ahb_master -expand -group {Beat Counter} /testbench/dut/u_ahb_m/last_beat
add wave -noupdate -expand -group ahb_master -expand -group {Beat Counter} /testbench/dut/u_ahb_m/bcnt_r
add wave -noupdate -expand -group ahb_master -expand -group {Beat Counter} /testbench/dut/u_ahb_m/bcnt_en
add wave -noupdate -expand -group ahb_master -expand -group {Beat Counter} /testbench/dut/u_ahb_m/bcnt_d
add wave -noupdate -expand -group ahb_master -expand -group {Beat Counter} /testbench/dut/u_ahb_m/bcnt_clr
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/hready_i
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/nxt_trans_vld
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/nxt_state
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/current_state
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/cur_state
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/idle_to_single
add wave -noupdate -expand -group ahb_master -expand -group fsm /testbench/dut/u_ahb_m/single_to_idle
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/addr_wrap_point
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/addr_bound
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/addr_base
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/haddr_o
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/haddr_d
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/nxt_addr_incr
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/nxt_addr
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/wrap_type
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/wrap_en
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/wrap_burst_mode
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/wrap_burst_en
add wave -noupdate -expand -group ahb_master -expand -group {Address Generator} /testbench/dut/u_ahb_m/inc_burst_mode
add wave -noupdate -expand -group ahb_master /testbench/dut/u_ahb_m/inc_burst_en
add wave -noupdate -expand -group ahb_master -group {Transaction Generator} /testbench/dut/u_ahb_m/nxt_trans_vld
add wave -noupdate -expand -group ahb_master -group {Transaction Generator} /testbench/dut/u_ahb_m/htrans_d
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/hwrite_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/hwdata_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/htrans_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/hsmartlock_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/hsize_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/hprot_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/hburst_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/haddr_o
add wave -noupdate -expand -group ahb_master -expand -group output /testbench/dut/u_ahb_m/cmd_ready_o
add wave -noupdate -group slave_valid /testbench/dut/u_ahb_s/u_ahb_s/hsel_i
add wave -noupdate -group slave_valid /testbench/dut/u_ahb_s/u_ahb_s/dp_vld_d
add wave -noupdate -group slave_valid /testbench/dut/u_ahb_s/u_ahb_s/dp_vld
add wave -noupdate -group slave_valid /testbench/dut/u_ahb_s/u_ahb_s/ap_done
add wave -noupdate -group slave_valid /testbench/dut/u_ahb_s/u_ahb_s/hready_i
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/hreadyout_d
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/dp_vld_d
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/hresp_err_sec
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/hresp_o
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/addr_err_d
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/wait_cnt_d
add wave -noupdate -group readyout /testbench/dut/u_ahb_s/u_ahb_s/hwrite_d
add wave -noupdate -group Slave_address /testbench/dut/u_ahb_s/u_ahb_s/addr_size_err
add wave -noupdate -group Slave_address /testbench/dut/u_ahb_s/u_ahb_s/addr_range_err
add wave -noupdate -group Slave_address /testbench/dut/u_ahb_s/u_ahb_s/addr_err_r
add wave -noupdate -group Slave_address /testbench/dut/u_ahb_s/u_ahb_s/addr_err_d
add wave -noupdate -group Slave_address /testbench/dut/u_ahb_s/u_ahb_s/addr_err
add wave -noupdate -group Slave_address /testbench/dut/u_ahb_s/u_ahb_s/addr_aligned_err
add wave -noupdate -expand -group slave_internal_valid /testbench/dut/u_ahb_s/u_ahb_s/dp_vld_d
add wave -noupdate -expand -group slave_internal_valid /testbench/dut/u_ahb_s/u_ahb_s/dp_vld
add wave -noupdate -expand -group slave_internal_valid /testbench/dut/u_ahb_s/u_ahb_s/ap_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1124583 ps} 0} {Trace {388896 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 637
configure wave -valuecolwidth 38
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
WaveRestoreZoom {0 ps} {1261678 ps}
