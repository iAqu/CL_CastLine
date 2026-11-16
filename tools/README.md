# Studio 排队工具

`studio_lock.py` 使用 Python 3 标准库与 SQLite 事务，提供本机跨会话、跨 worktree 的 FIFO 排队。共享数据库固定为 `~/.codex/studio-locks/queue.sqlite3`，不放入 Git，也不随 Rojo 同步。正式使用不要传 `--db`；该参数只供隔离测试。

工具只管理占用记录，不连接 Studio、不启动或停止测试、不修改 Rojo。所有会话必须遵守项目 `AGENTS.md`；不能拦截绕过工具的 MCP 调用或人工操作。已在运行的旧会话不会因文件更新自动采用新规则，接入时必须先等待它结束 Studio 操作。

## 工程标识

同一个 Place 的所有 Studio 窗口共用一个队列，不使用会变化的 MCP Studio ID 作为锁名。

| 工程 | resource |
| --- | --- |
| 开发版 #CL_DEV | `place:84106335829275` |
| 其他云端工程 | `place:<连接列表中的 Place ID>` |
| 本地参考工程 | `file:<该 rbxl/rbxlx 的绝对真实路径>` |

本地文件路径必须从连接信息或用户提供的路径确认，不能只凭文件名猜测。没有可确认标识时先澄清。同一 Place 重开窗口或跨 worktree 仍然共用锁。不同 Place 可以并行；需要同时占用多个工程时按 resource 字符串升序获取，避免相互等待。

## 操作示例

通过 MCP 查看、修改或测试具体工程前都要获锁；用于确认目标与占用的连接列表、状态查询可先执行。用 Codex `list_threads` 按项目路径（含对应 worktree）或项目归属筛选其他活跃会话，必要时用 `read_thread` 核对近期 Studio 操作。会话 active 不代表一直占用 Studio；已知正在使用或归属不明时先等待，不接管。

在仓库根目录运行。`acquire` 默认从 `CODEX_THREAD_ID` 读取当前会话 ID；变量缺失时传 `--thread <真实会话ID>`。

```sh
python3 tools/studio_lock.py status
python3 tools/studio_lock.py acquire --resource place:84106335829275 --purpose '检查背包并测试购买流程'
```

只有 JSON 中 `phase` 为 `held` 才取得使用权。`queued` 的退出码为 **2**，表示已排队，不是工具故障。返回的 `token` 用于后续操作；同一会话对同一工程重复 acquire 会返回原票据和 token，不会插队。

先检查同项目活跃会话的近期 Studio 操作；对于已有、未登记锁的 Studio 使用者，必须等它结束，不能仅凭数据库为空就接管。必要时用 `wait_threads` 等待；不主动给其他会话发消息。

```sh
python3 tools/studio_lock.py wait --token <token> --timeout 45
python3 tools/studio_lock.py heartbeat --token <token>
```

`wait` 单次最多 50 秒，超时退出码为 2，保留队列位置；后续继续 wait。持有或排队期间每 60 秒以内至少执行一次 heartbeat 或 wait。较长的 MCP 操作必须保持可续心跳；如果操作本身阻塞，过期记录仍保留，不会被自动抢占。`status` 是只读快照，不续心跳。

每次实际操作前确认自己的票据仍为 `held`，并通过连接列表获取最新 Studio ID；不得通过更换数据库或工程标识绕过占用。不要停止其他会话或用户启动的测试；归属不明时先等待或澄清。

等待时可以继续独立工作，但不要修改会通过 Rojo 同步到占用者正在测试的工程的脚本。最后不再需要 Studio 时，取消自己的排队票据：

```sh
python3 tools/studio_lock.py cancel --token <token>
```

## 测试与清理

1. 获锁后重新列出连接并检查目标状态；如果已处于 Play／Run 且归属不明，不操作、不 Stop，释放未启动测试的锁，等待或澄清。
2. 确认目标为 Edit 后，在调用 MCP 启动测试**之前**登记清理义务：

   ```sh
   python3 tools/studio_lock.py test-started --token <token>
   ```

3. 使用 MCP 启动并执行测试。将“停止与确认”作为 `finally` 清理步骤：测试成功、失败、抛错、取消时，都要 Stop 本会话启动的测试，并重新检查目标确实回到 Edit。
4. 确认 Edit 后才执行：

   ```sh
   python3 tools/studio_lock.py test-stopped --token <token> --confirmed-studio-edit
   python3 tools/studio_lock.py release --token <token>
   ```

纯只读查看、没有启动测试时可直接 release。不留后台测试占用 Studio。用户明确要求保持运行时，保留锁与 `needs_stop`，交代占用情况，不得释放后留着 Play。

`needs_stop=true` 时 release 会失败；Stop 失败、连接丢失或状态无法确认时保留锁并说明原因。确认参数是调用者对外部检查结果的声明，工具自身不会验证 Studio。不要为了释放锁而跳过实际 Stop 或伪造确认。

## 异常恢复

超过 180 秒没有心跳会显示 `stale=true`，**不会自动失效、跳过队首或夺锁**。排队者可用自己的 token 取消排队；其他会话只有在重新检查原会话确已空闲或结束、目标 Studio 为 Edit 后才能清除过期票据：

```sh
python3 tools/studio_lock.py recover --resource place:84106335829275 --ticket <票据号> --thread <原会话ID> --confirmed-thread-inactive --confirmed-studio-edit
```

恢复会在同一事务中核对工程、票据、会话和最新心跳，拒绝删除已续期的记录。原会话仍 active、状态未知、Studio 仍在运行或连接丢失时，都不得恢复；继续等待或向用户说明。排队者异常退出也按同样规则处理，保守保留队首。

## 验证

```sh
python3 -m unittest discover -s tools/tests -v
```

测试仅使用临时数据库，覆盖独占、FIFO、多进程竞争、测试清理限制与过期恢复，不连接真实 Studio。
