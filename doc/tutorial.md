# ALU Demo 使用说明

这是一个基于 **Verilator 5.042** 的最小 SystemVerilog 仿真示例：一个 8 位 ALU + 累加寄存器 + 简单状态机，配套一个纯 SV 测试平台（testbench，简称 TB）。

## 1. 环境要求

| 工具 | 用途 | 备注 |
|------|------|------|
| Verilator 5.x | 编译 + 仿真 | 需支持 `--timing`（5.x 自带） |
| make | 构建 | GNU make |

## 2. 目录结构

```
demo/
├── makefile                 # 构建脚本（编译/运行/看波形/清理）
├── rtl/                     # ★ 可综合设计（RTL）写在这里
│   └── alu_top.sv           #    被测模块 DUT
├── testbench/               # ★ 测试平台（TB）写在这里
│   └── tb_alu_top.sv        #    仿真顶层，实例化 DUT 并给激励
├── filelist/                # ★ 文件列表（告诉仿真器编译哪些文件）
│   └── alu_top.f
├── doc/
│   └── tutorial.md          # 本说明
├── wave.fst                 # 运行后生成的波形（被 git 忽略）
└── obj_dir/                 # Verilator 生成的 C++ 中间文件（被 git 忽略）
```

## 3. 快速开始

```bash
cd demo
make TOP=alu_top          # 编译 + 运行仿真 + 生成 wave.fst
make TOP=alu_top wave     # 编译 + 运行 + 自动打开 GTKWave
make TOP=alu_top verilate # 只生成 C++ 模型，不编译运行
make clean                # 清理 obj_dir 和波形
```

运行成功后，终端会打印每一条测试的 `PASS/FAIL`，最后输出 `ALL TESTS PASSED`。

## 4. RTL 写在哪里

设计代码放在 `rtl/` 目录，扩展名 `.sv`（SystemVerilog）。

- 示例：`rtl/alu_top.sv`，模块名 `alu_top`。
- 约定：**一个文件放一个模块，模块名 = 文件名**（去掉扩展名），这样 filelist 和 top 命名才统一。
- 新增一个模块，例如加法器，就新建 `rtl/adder.sv`，里面写 `module adder ... endmodule`，然后在 filelist 里加一行（见第 6 节）。

## 5. TB 写在哪里

测试平台放在 `testbench/` 目录。

- 示例：`testbench/tb_alu_top.sv`，模块名 `tb_alu_top`。
- 命名约定：TB 模块名 = `tb_` + RTL top 名（例如 `tb_alu_top`）。
- TB 是**仿真的真正顶层**（见第 7 节），负责：产生时钟、给 DUT 发激励、比对结果、打印 PASS/FAIL、写波形。

本 demo 的 TB 里有几个值得注意的写法（供你仿写）：
- `$dumpfile("wave.fst")` / `$dumpvars(0, tb_alu_top)`：生成波形，注意 `$dumpfile` 在前。
- 一个 `function automatic` 独立复算期望值，和 DUT 输出比对，而不是用同一份代码测自己。
- `wait_done` 里带超时保护，避免状态机卡住时仿真死等。

## 6. filelist 怎么写

`filelist/alu_top.f` 是文件列表，**每一行一个源文件路径**，路径相对于 `demo/` 目录（也就是 makefile 所在目录）：

```
rtl/alu_top.sv
testbench/tb_alu_top.sv
```

Makefile 里通过 `-f $(FILELIST)` 把它传给 Verilator（`-f` 会把文件内容当作额外命令行参数逐行读入）。

约定：
- 文件名 = `filelist/<TOP>.f`，和 top 模块同名。例如 top 叫 `alu_top`，filelist 就是 `filelist/alu_top.f`。
- **先 RTL 后 TB**（其实 Verilator 不强制顺序，但保持先设计后测试更清晰）。
- 新增源文件时，在这里**加一行**即可；换 top 时新建一个对应的 `.f` 文件。

## 7. 怎么指定 top

关键在 `makefile` 顶部这几个变量：

```make
TOP       ?= alu_top      # RTL 顶层模块名（决定 filelist 名、TB 名）
TB_TOP    ?= tb_$(TOP)    # TB 顶层模块名，自动拼成 tb_alu_top
FILELIST  ?= filelist/$(TOP).f
```

以及传给 Verilator 的关键选项：

```make
VFLAGS = ... --top-module $(TB_TOP) ...
```

两点要理解清楚：

1. **`--top-module` 指定的不是 DUT，而是 TB。** 因为 TB（`tb_alu_top`）才是仿真顶层，DUT（`alu_top`）只是被 TB `instance` 出来的子模块。所以 `--top-module tb_alu_top`。
2. **命令行用 `make TOP=xxx` 来切换 top。** 换一个设计时，只要：
   - RTL 写在 `rtl/xxx.sv`，TB 写在 `testbench/tb_xxx.sv`；
   - 建 `filelist/xxx.f`；
   - 执行 `make TOP=xxx`。

变量用 `?=` 赋值，所以有默认值（`alu_top`），不带参数直接 `make` 等价于 `make TOP=alu_top`。

## 8. 换一个模块 / 新增模块的完整流程

以新增一个 `my_core` 为例：

1. 设计：`rtl/my_core.sv`，模块名 `my_core`。
2. 测试：`testbench/tb_my_core.sv`，模块名 `tb_my_core`。
3. 文件列表：新建 `filelist/my_core.f`，内容两行：
   ```
   rtl/my_core.sv
   testbench/tb_my_core.sv
   ```
4. 运行：`make TOP=my_core`。

## 9. 常见问题

- **`command not found: verilator`**：Verilator 没装或不在 PATH。WSL/Ubuntu 下 `sudo apt install verilator`（要 5.x 版本以支持 `--timing`）。
- **波形没生成**：检查 TB 里 `$dumpfile` 写在 `$dumpvars` 之前；且 Verilator 开了 `--trace-fst`（本 makefile 已开）。
- **改了 RTL/TB 没生效**：先 `make clean` 再 `make TOP=alu_top`，避免用到旧的 `obj_dir` 缓存。
- **`--timing` 报错**：说明 Verilator 版本过低，需升级到 5.x。
