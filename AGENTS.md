# 项目约定

## 项目

- Roblox 抛竿远投钓鱼游戏。开发代码在 `CastLineRojo`，Studio 工程为 `#CL_DEV`（Place ID `84106335829275`）。
- Studio 管理美术、场景、模型、贴图和实例层级。脚本在仓库维护，由 Rojo 自动同步。`Package` 是只读第三方库。

## 数据源与导入

[Google 表格](https://docs.google.com/spreadsheets/d/1UlSnNuUBmQ1BQB43Jj3y8J9RYDzOF5g0Z5Js0PzHB8Y/edit?gid=977245643#gid=977245643) 保存可编辑的原始数据，游戏使用前须导入双端。“导数据／同步表格”默认更新仓库 `CastLineRojo/src/ReplicatedFirst/Data` 和 Studio `#CL_DEV` 的 `ReplicatedFirst.Data`，目标明确时无需重复确认。

1. **导出并检查。** 用 `google-sheet-sync` 技能在仓库根目录按 `sheet-sync.json` 仅导出本次请求的表，对生成文件运行 `selene`。临时筛选时保留完整页签配置。导出或检查失败的数据不得写入 Studio，表格内容有误时不得猜测修正。
2. **导入 Studio。** 检查通过后取得共享锁，刷新连接列表并核实 Place ID 和 Edit 模式，再按该技能执行 `preflight`、`apply`、`verify`。以本次成功导出的完整 ModuleScript 清单为准，包含 Git 无差异的文件。不删除未导出的模块，不改动 DataHelpers、其他脚本或美术资源，不自动保存或发布工程。
3. **回读并汇报。** 所有请求模块双端回读一致后才报告完成。Studio 未打开、不可用或处于 Play／Run 时，保留仓库导出结果并报告 Studio 待处理。失败或部分完成时，分别列出双端已完成、待处理的模块及原因。

`CastLineRojo/default.project.json` 将 `ReplicatedFirst/Data` 排除在 Rojo 同步之外。每次仅将本次导出的数据模块通过 MCP 导入 Studio。仓库其他脚本一律通过 Rojo 同步。

## 参考项目

- 参考项目的 Rojo 代码和 Studio 工程始终只读。源码只看 `Ref_Game_Code`，`Ref_Game_Rbxl` 仅用于在 Studio 打开参考工程。美术、资源、实例树和布局优先通过 Roblox Studio MCP 查看已打开的工程。美术与资源尽量复用或平移。
- 工程未打开时，在参考项目目录定位 `.rbxl` 或 `.rbxlx`（通常在 `Ref_Game_Rbxl`），禁止在 Studio 内搜索工程。每次告知用户工程名和完整路径并获确认后，用命令行按完整路径打开。打开后刷新连接列表，核实目标，再按共享锁流程查看。
- 简称为 Grow a Garden 2（GAG2）、Be a Fish Bait（FishBait）、Throw Food For Animals（ThrowFood）、Goal Kick Simulator（GoalKick）、Kick a Lucky Block（KickLuckyBlock）、Fish It（FishIt）、Fish From Moon（FishFromMoon）、Triathlon Star Simulator（Triathlon）、Steal An Egg（StealEgg）、Greedy Growers（GreedyGrower）、Cast For Fish（CastForFish）、Harpoon a Fish（HarpoonFish）、Fish For Sea Animals（FishForSeaAnimals）。

## Studio / Rojo

- MCP 默认操作 `#CL_DEV`，用户指定时以指定工程为准。每次从最新连接列表取 Studio ID，只操作唯一可确认的已连接工程。多开时目标不明就先问用户。
- 先区分 Studio 资源和仓库代码。涉及实例树、资源引用、布局或其他 Studio 专有内容时，先用 Roblox Studio MCP 查看，再结合代码。涉及 UI 文本格式时，先用 MCP 查看现有 Label 并参考其格式。
- 新增 UI 前先查看项目中同类界面，沿用现有的字体、配色、间距和组件样式。
- 修改 Studio UI 组件须获用户明确授权。UI 脚本按任务已有授权执行。
- 需要 Rojo 同步或发现意外断连时，先获共享锁，再用 Rojo Manager MCP 主动检查 `CastLineRojo` 对应的 `#CL_DEV`（端口 `34872`）。确认意外断连后自动重连，无需重复确认。核实 `Connected` 和目标地址后继续。已连接时不重连，用户主动暂停或断开时保持现状，禁止另起 Rojo 或恢复旧 launchd 服务。详见 [Rojo 自动恢复](tools/ROJO.md)。

## Studio 跨会话排队

- 通过 MCP 查看、修改或测试具体工程前，必须取得共享锁。用于确认目标与占用的连接列表和状态查询可先执行。按顺序等待现有使用者（含未登记锁的旧会话）。等待期间只做独立工作，勿修改会通过 Rojo 同步到对方测试工程的脚本。操作前须阅读 [Studio 排队工具](tools/README.md)。
- 本会话启动的测试结束后必须 Stop 并确认回到 Edit，再释放锁。其他会话或用户启动的测试不得 Stop。清理失败或用户要求保持运行时，按排队文档处理。
- 遇到过期队首，核实原会话已停止且目标 Studio 处于 Edit 后，直接 `recover` 并用原票据继续排队。无法核实时保留票据。详见 [异常恢复流程](tools/README.md#异常恢复)。

## 验证与日志

- Luau 优先运行 `selene`。依赖运行效果时，用 Roblox Studio MCP 测试或手动验证。需要确认 UI 或效果时，提供视频或截图供用户确认。无法本地验证时，说明已检查内容及待在 Studio 验证的文件或功能。
- 任务明确指定参考效果时，完成后在验收阶段将实际运行效果与原参考对照，调整与任务相关的差异后复验。
- 移动端仅测试横屏，验收以横屏表现为准。
- 运行日志仅使用 warning 和 error 级别。Studio Output 仅读取或汇报 Error、Warning、Information。

## 沟通

- 用简洁中文说明关键修改、假设、风险及待在 Studio 验证的内容。
- 先检查。需求明确、范围可控且可回滚时，直接执行并验证，自定实现细节，无需先提交长计划。仅在产品规则歧义影响方案、涉及支付或存档等高风险改动、或范围明显扩大时，才询问关键决策并附建议。遵守权限审批。
- 凡涉及创建或使用 Git 分支，或使用隔离路径（如 Git worktree、独立检出目录）的操作，均须事先获得用户明确同意。未经同意，不得执行相关操作。
