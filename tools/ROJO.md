# Rojo Manager 与 AI 自动恢复

CL 的 Agent 默认通过 Rojo Manager MCP 管理连接。以下是已核实的工程参数；操作前仍须核对当前项目列表，不能把历史配置视为实时状态。

| 项目 | 配置 |
| --- | --- |
| Manager 项目名 | `CastLineRojo` |
| 仓库目录 | `CastLineRojo`，使用 `default.project.json` |
| Studio 工程 | `#CL_DEV` |
| Place ID | `84106335829275` |
| 共享锁 resource | `place:84106335829275` |
| Rojo 地址 | `localhost:34872` 或 `127.0.0.1:34872` |

## 操作边界

- 本流程用于 AI 任务中需要同步或发现意外断连时的恢复，不启动后台轮询。
- 已连接到正确地址时不重复连接、不重启。用户主动暂停、停止或断开期间不擅自恢复；`NotConnected` 本身不能证明是意外断连，需结合当前任务和近期操作判断，原因不明时先澄清。
- Studio 实例树和测试继续使用 Roblox Studio MCP；不同 MCP 的实例 ID 不通用，按 Place ID 对应，每次从最新连接列表取 ID。
- 不修改 Manager 的全局配置、自动启动设置、插件版本或项目关联来绕过不匹配；不读取、打印或提交本机桥接控制凭据。
- 旧 `CastLineRojo/RojoScripts` 脚本中的 `CastLine`、端口 `34874` 和 launchd 流程是历史工具配置，不代表当前 Manager 状态。不要通过旧脚本、screen、nohup 或另起 `rojo serve` 恢复当前工程。

## 检查与恢复

所有命令在仓库根目录执行。先按 [Studio 排队工具](README.md) 检查同项目及 worktree 中其他聊天的使用情况，再获取共享锁；只有 `phase=held` 才能操作。正式使用不传 `--db`。

```sh
python3 tools/studio_lock.py acquire --resource place:84106335829275 --purpose '检查并恢复 CL Rojo 连接'
```

保存本次返回的 token；等待或持锁期间每 60 秒以内续心跳。用于定位工程和占用的连接列表、状态查询可先执行，但不能据此绕过共享锁发起连接或修改。

1. 通过最新 Studio 连接列表核实 `#CL_DEV` 的 Place ID、模式和测试归属。已有其他会话或用户的 Play/Run 时不重连、不 Stop；归属不明时释放未启动测试的锁，等待或澄清。只在确认目标为 Edit，或本会话持锁启动且可安全结束的测试回到 Edit 后继续恢复。
2. 用 Rojo Manager 的 `list_projects` 核对项目名 `CastLineRojo`、路径 `/Users/gx/Documents/RobloxProjects/CL_CastLine/CastLineRojo`、端口 `34872`、Place ID `84106335829275`；worktree 的队列共用该 Place 锁，但不能擅自将 Manager 切换到 worktree 路径。读取 `rojo_session` 的 `status` 获取实时连接状态。
3. 如果状态为 `Connected`，且地址为 `localhost:34872` 或 `127.0.0.1:34872`，继续工作，不重复连接。连接到其他地址或工程、项目路径不匹配时先诊断，不自动覆盖。
4. 确认属于需要恢复的意外断连后，服务为 `off` 时用 `rojo_server` 的 `start` 启动 `CastLineRojo`。端口 `blocked`、未知外部进程、接口异常或工程参数不符时，不抢端口、不盲目重启健康服务。
5. 插件断开或报错时，对已核实的 `CastLineRojo` 执行 `rojo_session` 的 `connect`。若返回 `Confirming`，仅对本次操作发起且目标明确的同步执行 `accept`，不确认来历不明的同步请求。
6. 再读 `status`，确认实际为 `Connected` 且目标地址正确后继续。进程存在、HTTP 正常或 `connect` 返回都不能单独证明连接成功。
7. 桥接插件未上报、工程未打开或恢复失败时，报告原因并等待必要处理，不自动关闭工程、不丢弃未保存内容，也不无限重试。
8. 不再使用 Studio 时释放本会话的锁；若本会话启动过测试，必须先按排队文档执行 Stop、确认 Edit、`test-stopped`。失败时保留锁及清理义务并说明原因。

MCP 调用参数示例（工具所属 namespace 以当前可用工具为准）：

```json
{"tool":"list_projects","arguments":{}}
{"tool":"rojo_session","arguments":{"project":"CastLineRojo","action":"status"}}
{"tool":"rojo_server","arguments":{"project":"CastLineRojo","action":"start"}}
{"tool":"rojo_session","arguments":{"project":"CastLineRojo","action":"connect"}}
{"tool":"rojo_session","arguments":{"project":"CastLineRojo","action":"accept"}}
```

上面的调用不是无条件依次执行的批处理；只按检查结果执行必要步骤。使用本会话 acquire 返回的 token 续期和释放：

```sh
python3 tools/studio_lock.py heartbeat --token <本会话的token>
python3 tools/studio_lock.py release --token <本会话的token>
```

已排队但不再需要 Studio 时使用 `cancel`；已持有且无清理义务时使用 `release`。

## 日志与验证

- Manager 的 `studio_output` 使用 `level=warning` 或 `error`；需要 Information 时使用可按类型过滤的 Roblox Studio MCP，忽略其他输出类型。
- Manager 服务异常通过 `server_logs` 读取诊断信息，不依赖旧 `.rojo-runtime` 日志判定当前状态。
- 锁工具测试使用临时数据库，不启动、连接、断开或停止真实 Studio：

```sh
python3 -m unittest discover -s tools/tests -v
```

规则和文档迁移本身不需要真实断连恢复演练。实际验证连接恢复时，先检查其他聊天、持锁、确认 Edit，再在已有授权范围内验证；不得为了验证打断正在运行的测试。
