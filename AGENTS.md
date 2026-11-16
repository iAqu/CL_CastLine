# 项目约定

## 项目

- 这是一款 抛竿将鱼饵扔远钓鱼 的游戏。
- Roblox 项目。当前开发代码在 `CastLineRojo`，Studio 工程为 `#CL_DEV`。
- Studio 负责美术、场景、模型、贴图和实例层级；仓库负责脚本与 Rojo 同步代码。

## 文件夹说明

- Package：第三方库，只使用不修改

## 参考项目

- 参考项目由 Studio 与 Rojo 代码两部分组成；禁止修改参考项目文件。
- 简称：Grow a Garden 2 = GAG2, Be a Fish Bait = FishBait, Throw Food For Animals = ThrowFood, Goal Kick Simulator = GoalKick, Kick a Lucky Block = KickLuckyBlock, Fish It = FishIt, Fish From Moon = FishFromMoon, Triathlon Star Simulator = Triathlon, Steal An Egg = StealEgg, Greedy Growers = GreedyGrower,
- 只从 `Ref_Game_Code` 分析源码；忽略 `Ref_Game_Rbxl`。
- 需要美术、资源、实例树或布局时，优先通过 Roblox Studio MCP 查看参考 Studio 工程；找不到就提示用户打开。
- 美术和资源尽量复用或平移参考项目。



## Studio / Rojo

- MCP 默认操作 `#CL_DEV`（Place ID `84106335829275`）；用户另有指定时以用户指定为准。每次通过连接列表获取最新 Studio ID，不复用旧 ID。
- 动手前先判断目标属于 Studio 资源还是仓库代码。
- 依赖实例树、资源引用、布局或 Studio-only 内容时，先用 Roblox Studio MCP 查看，再结合仓库代码。
- 若多开 Studio 且无法确认目标工程，先问用户。
- 需要 Rojo 同步前或任务中发现意外断连时，先取得 Studio 共享锁，再按 [Rojo 自动恢复](tools/ROJO.md) 用 Rojo Manager MCP 主动检查并自动重连 `CastLineRojo` 对应的 `#CL_DEV`（端口 `34872`），无需等待用户提醒或重复确认；验证 `Connected` 和目标地址后继续。已连接不重连，用户主动暂停或断开不擅自恢复；禁止另起 Rojo 或恢复旧 launchd 服务。
- Rojo 会自动同步代码到 Studio，禁止通过 MCP 同步仓库脚本。
- 除非用户明确授权，否则不要修改 Studio 中的 UI 组件；确需修改且本次任务尚未授权时，先询问用户并获得同意。UI 脚本功能按任务已有授权执行，不因这条组件限制重复确认。
- 涉及到 UI 文本格式，通过 Mcp 先分析Studio，参考 Label 已经有的 text 文本格式。

## Studio 跨会话排队

- 通过 MCP 查看、修改或测试具体 Studio 工程前，必须取得该工程的共享锁；操作前阅读 [Studio 排队工具](tools/README.md)，按其中的命令和流程执行。用于确认目标和占用的连接列表、状态查询可先执行。
- 已有会话正在使用 Studio 时按顺序排队，不打断、不抢占；未登记锁的旧会话也须先完成原来的使用。
- 等待期间只做不影响占用者的独立工作，避免通过 Rojo 同步修改其正在测试的工程。
- 本会话启动的测试结束后必须 Stop，确认回到 Edit 后再释放锁；不得停止其他会话或用户启动的测试。
- 不自动抢占过期锁；异常恢复、清理失败及用户要求保持运行的处理均按 `tools/README.md` 执行。共享锁是协作约定，不能拦截绕过工具的 MCP 调用或人工操作。


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
