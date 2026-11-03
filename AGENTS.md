# 项目约定

## 项目

- 这是一款 抛竿将鱼饵扔远钓鱼 的游戏。
- Roblox 项目。当前开发代码在 `CastLineRojo`，Studio 工程为 `#CL_DEV`。
- Studio 负责美术、场景、模型、贴图和实例层级；仓库负责脚本与 Rojo 同步代码。

## 文件夹说明

- Package：第三方库，只使用不修改

## 参考项目

- 参考项目由 Studio 与 Rojo 代码两部分组成；禁止修改参考项目文件。
- 简称：Grow a Garden 2 = GAG2, Be a Fish Bait = FishBait, Throw Food For Animals = ThrowFood, Goal Kick Simulator = GoalKick, Kick a Lucky Block = KickLuckyBlock, Fish It = FishIt,
- 只从 `Ref_Game_Code` 分析源码；忽略 `Ref_Game_Rbxl`。
- 需要美术、资源、实例树或布局时，优先通过 Roblox Studio MCP 查看参考 Studio 工程；找不到就提示用户打开。
- 美术和资源尽量复用或平移参考项目。



## Studio / Rojo

- 动手前先判断目标属于 Studio 资源还是仓库代码。
- 依赖实例树、资源引用、布局或 Studio-only 内容时，先用 Roblox Studio MCP 查看，再结合仓库代码。
- 若多开 Studio 且无法确认目标工程，先问用户。
- Rojo 已连接时不要操作 Rojo；断开时提示用户重新连接。
- Rojo 会自动同步代码到 Studio，禁止通过 MCP 同步仓库脚本。



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
