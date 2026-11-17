onerror {resume}
quietly virtual function -install /testbench/u_dut/u_ahb_s/r_wen -env /testbench/u_dut/u_ahb_s/r_wen { ( ~(bool)(rstn ) )} dbgTemp0_2
quietly virtual function -install /testbench/u_dut/u_ahb_s/r_wen -env /testbench/u_dut/u_ahb_s/r_wen { ( ~(bool)(rstn ) )} dbgTemp1_2
quietly virtual function -install /testbench/u_dut/u_ahb_s/r_hrdo -env /testbench/u_dut/u_ahb_s/r_hrdo { ( ~(bool)(rstn ) )} dbgTemp0_2
quietly virtual function -install /testbench/u_dut/u_ahb_s/r_hrdo -env /testbench/u_dut/u_ahb_s/r_hrdo { ( ~(bool)(rstn ) )} dbgTemp1_2
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/clk
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/hsel_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/haddr_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/htrans_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/hburst_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/hwrite_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/hwdata_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/hsize_i
add wave -noupdate -expand -group {DUT interface} /testbench/d_if/hready_i
add wave -noupdate -expand -group {DUT interface} -expand -group Output /testbench/d_if/hresp_o
add wave -noupdate -expand -group {DUT interface} -expand -group Output /testbench/d_if/hrdata_o
add wave -noupdate -expand -group {DUT interface} -expand -group Output /testbench/d_if/hreadyout_o
add wave -noupdate -expand -group {Wait Counter} /testbench/u_dut/u_ahb_s/wait_cnt
add wave -noupdate -expand -group {Wait Counter} /testbench/d_if/hreadyout_o
add wave -noupdate -expand -group {Wait Counter} /testbench/u_dut/u_ahb_s/wait_cnt_en
add wave -noupdate -expand -group {Wait Counter} /testbench/u_dut/u_ahb_s/wait_cnt_d
add wave -noupdate -expand -group {Register Interface} /testbench/u_dut/u_regfile/clk
add wave -noupdate -expand -group {Register Interface} /testbench/u_dut/u_regfile/reg_addr_i
add wave -noupdate -expand -group {Register Interface} -expand -group {Write Data} /testbench/u_dut/u_regfile/reg_wdata_i
add wave -noupdate -expand -group {Register Interface} -expand -group {Write Data} /testbench/u_dut/u_regfile/reg_wen_i
add wave -noupdate -expand -group {Register Interface} -expand -group {Read Data} /testbench/u_dut/u_regfile/reg_ren_i
add wave -noupdate -expand -group {Register Interface} -expand -group {Read Data} /testbench/u_dut/u_regfile/reg_rdta_vld_o
add wave -noupdate -expand -group {Register Interface} -expand -group {Read Data} /testbench/u_dut/u_regfile/reg_rdata_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {248 ns} 0} {Trace {145 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {87 ns} {549 ns}
