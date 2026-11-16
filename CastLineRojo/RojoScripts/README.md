# Rojo 管理

当前 CL 工程通过 **Rojo Manager MCP** 检查和恢复连接，完整流程见 [CL Rojo 自动恢复](../../tools/ROJO.md)，跨会话操作须先遵循 [Studio 排队规则](../../tools/README.md)。

| 参数 | 当前配置 |
| --- | --- |
| Manager 项目名 | `CastLineRojo` |
| Studio 工程 | `#CL_DEV` |
| Place ID | `84106335829275` |
| Rojo 地址 | `localhost:34872` |

使用 Manager 的项目列表和实时连接状态核实配置；已连接时不重复连接，用户主动暂停或断开时不擅自恢复。

## 历史脚本

本目录保留的 `rojo-manager.sh`、`rojo-projects.conf` 和 `test-launchd.sh` 属于旧方案，未改写为 Manager 入口。旧项目名 `CastLine`、端口 `34874` 及 launchd 启动流程不适用于当前 Manager 配置。

Agent 不再以这些脚本作为当前工程的默认启动、停止或恢复入口，不执行它们启动另一套服务，也不恢复旧 launchd 服务。旧 `.rojo-runtime` 日志只作历史记录；当前服务日志通过 Manager 的 `server_logs` 获取。

`test-launchd.sh` 只验证历史方案，与当前 Manager 连接恢复无关，本次规则迁移不运行它。
