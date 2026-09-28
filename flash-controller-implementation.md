# Flash Controller 实现计划

## 目标

实现一个可由现有 Verilator Makefile 驱动的 Flash Controller，覆盖 APB 直接映射读、间接寄存器访问、可配置 SPI 分频和 dummy clock，以及 1-1-1、1-1-2、1-1-4 读取模式。

## 任务

- [ ] 建立 `flash_controller` 的 filelist、testbench 和 Makefile 目标；先运行并确认测试在缺少 RTL 时失败。
- [ ] 实现 APB 接口和地址译码：直接映射区、间接寄存器区、等待响应、错误响应。
- [ ] 实现 SPI 时钟分频、片选、单线命令/地址发送和 DQ1 数据接收。
- [ ] 实现连续 32 bit 直接读，并通过 Flash 模型验证命令、地址、dummy 和字节拼接。
- [ ] 实现间接访问寄存器、可配置分频/dummy，以及完成/错误状态。
- [ ] 扩展 Dual Output 和 Quad Output 读取，验证 DQ0~DQ3 高阻控制。
- [ ] 用 Makefile 运行完整仿真，检查边界地址、非法访问、重复访问和波形输出。

## 完成条件

- `make TOP=flash_controller` 返回 0；
- testbench 覆盖基础读、间接读、配置寄存器、Dual/Quad 读和错误访问；
- 仿真中没有未处理的 `X` 数据或 APB 永久等待；
- RTL、filelist、testbench 和 Makefile 变更均位于实现分支。
