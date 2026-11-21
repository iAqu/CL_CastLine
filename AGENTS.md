# 项目约定

## 项目

- 这是一款 抛竿将鱼饵扔远钓鱼 的游戏。
- Roblox 项目。当前开发代码在 `CastLineRojo`，Studio 工程为 `#CL_DEV`。
- Studio 负责美术、场景、模型、贴图和实例层级；仓库负责脚本与 Rojo 同步代码。

## 文件夹说明

- Package：第三方库，只使用不修改

## 数据源与导入

- [Google 表格](https://docs.google.com/spreadsheets/d/1UlSnNuUBmQ1BQB43Jj3y8J9RYDzOF5g0Z5Js0PzHB8Y/edit?gid=977245643#gid=977245643) 保存便于编辑的原始数据；游戏使用前必须导入仓库和 Studio，导入配置以根目录 `sheet-sync.json` 为准。
- “导数据／同步表格”默认同时更新仓库 `CastLineRojo/src/ReplicatedFirst/Data` 和 Studio `#CL_DEV`（Place ID `84106335829275`）的 `ReplicatedFirst.Data`；目标明确时无需重复确认。
- 使用 `google-sheet-sync` 技能，从本项目根目录按 `sheet-sync.json` 导出。仅导入本次请求的表；按本次成功导出的完整文件清单同步 Studio，不从 Git 差异推断范围，本地无变化的文件也必须回读核对。临时选择部分表时保留完整页签配置。
- 先完成导出并对生成文件运行 `selene`；导出或静态检查失败时，不向 Studio 写入失败数据，不猜测修正表格内容。检查通过后，按 [Studio 排队工具](tools/README.md) 取得目标工程共享锁，重新获取 Studio 连接列表，核实 Place ID 和 Edit 模式，再执行预检、写入、回读比较。
- Studio 导入按 `google-sheet-sync` 技能执行 `preflight`、`apply`、`verify`，仅处理本次导出的数据 ModuleScript；不删除未导出的模块，不改动 DataHelpers、其他脚本或美术资源，不自动保存或发布工程。
- `CastLineRojo/default.project.json` 已将 `ReplicatedFirst/Data` 排除在 Rojo 同步之外，因此生成的数据模块允许通过 MCP 导入。其他仓库脚本继续通过 Rojo 同步，不通过 MCP 同步。
- 仓库和 Studio 的所有请求模块回读一致后，才报告双端导入完成。Studio 未打开、不可用或处于 Play／Run 时，保留仓库导出结果并报告 Studio 待处理；不停止其他会话或用户的测试。失败或部分完成时分别说明仓库、Studio 已完成及待处理的模块与原因。

## 参考项目

- 参考项目由 Studio 与 Rojo 代码两部分组成；禁止修改参考项目文件。
- 简称：Grow a Garden 2 = GAG2, Be a Fish Bait = FishBait, Throw Food For Animals = ThrowFood, Goal Kick Simulator = GoalKick, Kick a Lucky Block = KickLuckyBlock, Fish It = FishIt, Fish From Moon = FishFromMoon, Triathlon Star Simulator = Triathlon, Steal An Egg = StealEgg, Greedy Growers = GreedyGrower,
- 只从 `Ref_Game_Code` 分析源码；`Ref_Game_Rbxl` 仅用于在 Studio 中打开参考工程，不作为源码分析来源。
- 需要参考工程的美术、资源、实例树或布局等 Studio 内容时，优先通过 Roblox Studio MCP 查看已打开的对应参考工程。
- 对应参考工程尚未打开时，定位参考项目路径下的 `.rbxl` 或 `.rbxlx` 文件（本项目通常在 `Ref_Game_Rbxl`），通过命令行按完整路径打开，不在 Studio 内部搜索工程。每次执行打开操作前，必须向用户说明工程名和完整文件路径并获得确认；未获确认不得打开，之前的打开授权不自动沿用。打开后重新获取 Studio 连接列表，核实目标工程后再按共享锁流程查看；始终保持参考工程只读。
- 美术和资源尽量复用或平移参考项目。



## Studio / Rojo

- MCP 默认操作 `#CL_DEV`（Place ID `84106335829275`）；用户另有指定时以用户指定为准。每次通过连接列表获取最新 Studio ID，不复用旧 ID。
- 动手前先判断目标属于 Studio 资源还是仓库代码。
- 依赖实例树、资源引用、布局或 Studio-only 内容时，先用 Roblox Studio MCP 查看，再结合仓库代码。
- 若多开 Studio 且无法确认目标工程，先问用户。
- 同时打开多个同名 Studio 工程时，只操作当前 MCP 连接列表中唯一可确认的工程。MCP 已关闭或未连接的同名工程一律不得操作。若有多个同名工程都已连接，且无法确认目标，先询问用户。
- 需要 Rojo 同步前或任务中发现意外断连时，先取得 Studio 共享锁，再按 [Rojo 自动恢复](tools/ROJO.md) 用 Rojo Manager MCP 主动检查并自动重连 `CastLineRojo` 对应的 `#CL_DEV`（端口 `34872`），无需等待用户提醒或重复确认；验证 `Connected` 和目标地址后继续。已连接不重连，用户主动暂停或断开不擅自恢复；禁止另起 Rojo 或恢复旧 launchd 服务。
- Rojo 会自动同步代码到 Studio，禁止通过 MCP 同步仓库脚本；被 Rojo 排除的生成数据模块按“数据源与导入”约定通过 MCP 导入。
- 除非用户明确授权，否则不要修改 Studio 中的 UI 组件；确需修改且本次任务尚未授权时，先询问用户并获得同意。UI 脚本功能按任务已有授权执行，不因这条组件限制重复确认。
- 涉及到 UI 文本格式，通过 Mcp 先分析Studio，参考 Label 已经有的 text 文本格式。

## Studio 跨会话排队

- 通过 MCP 查看、修改或测试具体 Studio 工程前，必须取得该工程的共享锁；操作前阅读 [Studio 排队工具](tools/README.md)，按其中的命令和流程执行。用于确认目标和占用的连接列表、状态查询可先执行。
- 已有会话正在使用 Studio 时按顺序排队，不打断、不抢占；未登记锁的旧会话也须先完成原来的使用。
- 等待期间只做不影响占用者的独立工作，避免通过 Rojo 同步修改其正在测试的工程。
- 本会话启动的测试结束后必须 Stop，确认回到 Edit 后再释放锁；不得停止其他会话或用户启动的测试。
- 排队遇到过期队首时，按 [异常恢复流程](tools/README.md#异常恢复) 主动确认原会话已停止、目标 Studio 处于 Edit。确认后直接 `recover`，继续按原票据排队，无需用户提醒或再次确认。无法核实时保留票据。清理失败及用户要求保持运行的处理也按 `tools/README.md` 执行。共享锁是协作约定，不能拦截绕过工具的 MCP 调用或人工操作。


## 验证

- 涉及 Luau 代码时，优先运行 `selene` 静态检查。
- 依赖 Roblox 运行效果时，使用 Roblox Studio MCP 运行测试或手动验证。
- 无法本地验证时，说明已检查内容，以及仍需在 Studio 验证的文件或功能。



## 日志

- 写运行日志时只使用 warning 和 error 级别；不要新增普通 print、debug 或 info 噪音日志。
- 获取 Roblox Studio Output 日志时，只读取或汇报 Error、Warning、Information 三类，忽略其他类型日志。



## 沟通

- 用简洁中文说明关键修改。
- 主动指出假设、风险点和需要 Studio 验证的内容。
