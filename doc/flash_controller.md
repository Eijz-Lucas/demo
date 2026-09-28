# 2026虚拟项目：Flash Controller

# 功能说明

Flash Controller 负责接收APB总线的信号，并根据总线信号实现对NOR\_FLASH芯片的访问。

# 结构图与数据流

![Image](https://internal-api-drive-stream.feishu.cn/space/api/box/stream/download/authcode/?code=YmI3YjNkZGY2YWY3ODQ2MjFkNzEyNDIyMjI4ZjM5YTVfNWFlM2ZjNmI2NzJlNmRkNTE1Y2M0MTYxNzgzNTc1MDZfSUQ6NzUyMTY1MjcxMDIxODEzNzYwMl8xNzkwNTg5MzM5OjE3OTA2NzU3MzlfVjM)

# Flash Memory访问

## 3\.1 Flash Memory寻址空间

0x0000\_0000 \~ 0x00ff\_ffff \(128M寻址空间\)

## 3\.2 Flash Memory快速读时序

![Image](https://internal-api-drive-stream.feishu.cn/space/api/box/stream/download/authcode/?code=ZGI3YWE3YTE3ZWRmYzAyZTY5OTMxYmY1NzRjMGNkYzJfNjBjZGZjMWVmZGU3YmQ2NTZlMTQ4YTdiMDdkN2VlZmNfSUQ6NzUyMTY1MjkxMzIxMzg4MjM2OV8xNzkwNTg5MzM5OjE3OTA2NzU3MzlfVjM)

![Image](https://internal-api-drive-stream.feishu.cn/space/api/box/stream/download/authcode/?code=NDgyNTBmZmUzZTBjY2M2NjM5N2FkYmEzYTk0NzU2ZmFfNGRiYjlhYmU4ZGVmNzMyNGI4YWZiNDkyYzYzNzIyNWFfSUQ6NzUyMTY1Mjk3MTE0NTg3MTM4OF8xNzkwNTg5MzM5OjE3OTA2NzU3MzlfVjM)

## 3\.3 Flash Memory相关寄存器

![Image](https://internal-api-drive-stream.feishu.cn/space/api/box/stream/download/authcode/?code=NzE3MzE0ZDk1MDFkZmVmMDJiNzNiYmNjZDEzM2MxYTVfNjI3ZmZkZTg2NDgzMzY3ZWExMTkwOTNiNzY0ZjY3ZDVfSUQ6NzUyMTY1MzA5OTI2MDM0NjM3MV8xNzkwNTg5MzM5OjE3OTA2NzU3MzlfVjM)

![Image](https://internal-api-drive-stream.feishu.cn/space/api/box/stream/download/authcode/?code=NGZjMmM5OTNlNzNkOWQzYzNiYjI2YTFhZjA5ODA3ZmFfZDRjOTJhNmU1NmIyZTVlZmE2MTA4NDJmOTc5MTZjMzdfSUQ6NzUyMTY1MzExODYzMTI4MDY0NF8xNzkwNTg5MzM5OjE3OTA2NzU3MzlfVjM)

# 功能点与接口

## 4\.1 基础功能点说明

完成一个APB从机，使其可以通过单线SPI读取NOR FLASH

支持Micron MT系列Nor flash芯片

支持接收APB总线信号并解析，支持读数据模式

NOR FLASH的地址空间映射在APB地址空间的一段，如果APB从机收到的总线地址不在映射段内，不需响应

系统时钟频率为100M，SPI频率1M

只需要支持NOR FLASH快速读模式\(dummy clock默认值为8\)

基于镁光MT25QU128ABB8E0\_VG17模型完成vcs仿真验证

## 4\.2 进阶功能点说明


支持NOR FLASH时钟速率可调，dummy clock可配


支持间接访问模式（总线基于MMIO配置从机的首地址，写入、读取数据长度、读写模式、时钟频率等寄存器后，controller访问FLASH芯片并将信息放在相应寄存器上供总线访问）

# FLASH模型接入设计源文件方法

## 5\.1 解压模型文件并添加进工程框架

\[MT25QU128ABB8E0\_VG17 \(1\)\.zip\]

## 5\.2 修改路径

在MT25QU128ABB8E0\_VG17/include/UserData\.h中将FILENAME\_mem和FILENAME\_sfdp修改为你自己的路径

## 5\.3 实例化

其中，spi\_csn为spi片选信号，spi\_clk为spi时钟信号，spi0和spi1为数据通路

```Verilog
N25Qxxx u_flashdevice(
    .S(spi_csn),
    .C_(spi_clk),
    .HOLD_DQ3(),
    .DQ0(spi0),
    .DQ1(spi1),
    .Vcc(3300),
    .Vpp_W_DQ2()
);
```

## 5\.4 修改simfile\_rtl\.f

添加如下代码并修改路径

```Shell
+incdir+testbench/MT25QU128ABB8E0_VG17
    testbench/MT25QU128ABB8E0_VG17/code/N25Qxxx.v
```

# 参考资料

## 6\.1 AXI协议

\[AXI4\_specification\.pdf\]

## 6\.2 QSPI/SPI 协议说明文档

\[SPIQSPI specification\.pdf\]

## 6\.3 APB 协议说明文档

https://www\.yuejianzun\.xyz/2017/09/30/APB%E6%80%BB%E7%BA%BF%E5%8D%8F%E8%AE%AE/

## 6\.4 Norflash\_device 器件说明文档

\[mt25q\_qlhs\_l\_128\_aba\_0\.pdf\]

