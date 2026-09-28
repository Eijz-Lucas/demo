#=============================================================================
# Verilator 5.042 Makefile — 纯 SV Testbench
#
# 用法:
#   make TOP=alu_top           # 编译 + 运行仿真 + 生成 wave.fst
#   make TOP=alu_top wave      # 编译 + 运行 + 打开 GTKWave
#   make TOP=alu_top verilate  # 只生成 C++（不编译运行）
#   make TOP=alu_top clean     # 清理
#=============================================================================

#--------- 变量 ---------
TOP        ?= alu_top
TB_TOP     ?= tb_$(TOP)
FILELIST   ?= filelist/$(TOP).f
OBJ_DIR    ?= obj_dir
WAVE       ?= wave.fst
VERILATOR  ?= verilator
IVERILOG   ?= iverilog
VVP        ?= vvp

# Verilator --timing generates C++20 coroutine code.  Prefer an installed
# modern GCC over the system default (this environment's g++ points to 9).
ifeq ($(origin CXX),default)
CXX := $(or $(shell command -v g++-11 2>/dev/null), \
           $(shell command -v g++-10 2>/dev/null), \
           $(shell command -v g++ 2>/dev/null))
endif
CXXFLAGS += -std=c++20
export CXXFLAGS
# Verilator's --binary invokes a recursive make whose generated makefile
# otherwise hard-codes the compiler detected when Verilator was built.
override MAKEFLAGS := $(MAKEFLAGS) CXX=$(CXX) LINK=$(CXX)

#--------- Verilator 选项 ---------
#   --binary        : 生成可执行文件（内置 main）
#   --timing        : 支持 #delay / wait / always 等时序语句
#   --trace-fst     : 开启 FST 波形
#   --trace-structs : 展开 struct
#   --top-module    : 顶层模块（这里是 TB）
VFLAGS = --binary \
         --timing \
         --trace-fst \
         --trace-structs \
         --top-module $(TB_TOP) \
         --Mdir $(OBJ_DIR) \
         -Wno-fatal \
         -j 0

# --binary 生成的可执行文件通常名为 V<top>
SIM_BIN = $(OBJ_DIR)/V$(TB_TOP)

.PHONY: all run wave verilate clean help

all: run

ifeq ($(TOP),flash_controller)
# Flash 模型由 Icarus Verilog 负责编译，保留 verilate 目标名以兼容原用法。
verilate:
	@echo "=== Icarus compiling TOP=$(TOP) ==="
	mkdir -p $(OBJ_DIR)
	$(IVERILOG) -g2012 -s $(TB_TOP) -o $(SIM_BIN) -f $(FILELIST)
else
# 生成 C++ 模型（不编译成可执行文件）
verilate:
	$(VERILATOR) --cc --exe \
	             --timing \
	             --trace-fst --trace-structs \
	             --top-module $(TB_TOP) \
	             --Mdir $(OBJ_DIR) \
	             -Wno-fatal \
	             -f $(FILELIST)
endif

# 编译 + 运行
ifeq ($(TOP),flash_controller)
run:
	@echo "=== Icarus Verilog TOP=$(TOP) ==="
	mkdir -p $(OBJ_DIR)
	$(IVERILOG) -g2012 -s $(TB_TOP) -o $(SIM_BIN) -f $(FILELIST)
	@echo ""
	@echo "=== Running simulation ==="
	$(VVP) $(SIM_BIN)
	@echo ""
	@if [ -f flash_controller.vcd ]; then \
	    echo "=== Waveform generated: flash_controller.vcd ($$(stat -c%s flash_controller.vcd) bytes) ==="; \
	else \
	    echo "=== WARNING: flash_controller.vcd NOT generated ==="; \
	fi
else
run:
	@echo "=== Verilating TOP=$(TOP) ==="
	$(VERILATOR) $(VFLAGS) -f $(FILELIST)
	@echo ""
	@echo "=== Running simulation ==="
	./$(SIM_BIN)
	@echo ""
	@if [ -f $(WAVE) ]; then \
	    echo "=== Waveform generated: $(WAVE) ($$(stat -c%s $(WAVE)) bytes) ==="; \
	else \
	    echo "=== WARNING: $(WAVE) NOT generated ==="; \
	fi
endif

# 运行并打开波形
ifeq ($(TOP),flash_controller)
wave: run
	@echo "=== Opening flash_controller.vcd with GTKWave ==="
	gtkwave flash_controller.vcd &
else
wave: run
	@echo "=== Opening $(WAVE) with GTKWave ==="
	gtkwave $(WAVE) &
endif

clean:
	rm -rf $(OBJ_DIR)
	rm -f $(WAVE) *.vcd

help:
	@echo "Targets:"
	@echo "  make TOP=alu_top          - build & run"
	@echo "  make TOP=alu_top wave     - build, run, open waveform"
	@echo "  make TOP=alu_top verilate - only generate C++"
	@echo "  make clean                - cleanup"
