
#################################################################################################
# AHB Slave Verification
# Makefile
#################################################################################################

# Define variables
TESTNAME ?= ahb_burst_test
TB_NAME  ?= testbench
RADIX    ?= hexadecimal
SEED     ?= 1

#==============================
.PHONY: all build run wave clean help

all: build run

build:
	vlib work
	vmap work work
	vlog -sv -f compile.f 2>&1 | tee compile.log

run:
	vsim -sv_seed $(SEED) -debugDB -l $(TESTNAME).log -voptargs=+acc -assertdebug -c $(TB_NAME) +TESTNAME=$(TESTNAME) -do "log -r /*; run -all; quit -f"

wave:
	vsim -i -view vsim.wlf -do "add wave -r sim:/$(TB_NAME)/*; radix -$(RADIX)" &

clean:
	rm -rf work
	rm -rf vsim.dbg
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript

help:
	@echo ""
	@echo "****************************************"
	@echo "** make build : compile design and testbench"
	@echo "** make run TESTNAME=ahb_burst_test"
	@echo "** make run TESTNAME=ahb_error_test"
	@echo "** make all : compile and run"
	@echo "** make wave : open waveform"
	@echo "** make clean : clean compiled data"
	@echo "****************************************"
	@echo ""

