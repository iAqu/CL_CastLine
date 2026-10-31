# 持续负载优化设计

日期：2026-05-10
项目：DB_DEV / DigToBuild

## 目标

降低高端手机长时间游玩后的发热，同时不主动控制帧率，也不改变 Roblox 默认渲染策略。

上一轮性能优化主要处理建造过程中的瞬时峰值：建造 VFX 预算、完成特效上限、轮询节流、性能档位和建筑模板统计。本轮关注持续成本：玩家没有直接看见或使用时，仍持续运行数分钟的系统。

本轮选择的目标是优先保持玩法响应稳定。优化应该逐步降低脚本和视觉系统的长期负载，但不能故意降低玩家的帧率目标。

## 当前上下文

最近的性能工作已经新增或加固：

- `PerformanceProfileClient`
- `BuildTemplateStats`
- `BuildVfxBudget`
- 建造轮询节流
- 建造完成特效预算
- 建造 VFX 上限和 debug 状态

通过 Roblox Studio 检查 `#DB_DEV`，当前最大的静态资源块仍然是建筑模板：

- `ReplicatedStorage.Models.Building`：约 12,982 个 BasePart
- `Burjkhalifa`：4,833 个 BasePart
- `StatueofLiberty`：2,491 个 BasePart
- `BigBen`：2,321 个 BasePart
- `PetronasTwinTower`：1,344 个 BasePart
- `Pyramid`：1,082 个 BasePart
- `EiffelTower`：911 个 BasePart

当前 Workspace 规模小于模板仓库，因此本轮不能假设所有发热都来自可见场景几何体。更可能的问题是多类持续工作叠加：`Heartbeat` 循环、`RenderStep` 绑定、距离扫描、UI 动画、宠物更新、粒子、`Trail`、`Highlight` 和建造 VFX 在不必要的时候仍保持活跃。

## 架构

新增客户端持续负载模块：

`src/StarterPlayer/StarterPlayerScripts/Controllers/Performance/SustainedLoadClient.lua`

该模块负责维护运行时压力状态：

- `Normal`：默认体验，未检测到持续压力。
- `Warm`：持续压力开始积累，降低非关键更新频率。
- `Hot`：长时间高负载，保持核心玩法响应，同时暂停或大幅降低屏幕外、远距离视觉工作。

该模块不替代 `PerformanceProfileClient`。

- `PerformanceProfileClient` 判断设备能力和玩家偏好。
- `SustainedLoadClient` 判断当前长时间运行压力。

建议 API：

- `Start()`
- `GetState(): string`
- `GetInterval(systemName: string, baseInterval: number): number`
- `ShouldRun(systemName: string, context: table?): boolean`
- `GetDebugState(): table`
- QA 使用的本地 debug override

模块默认必须安全。启动前或采样失败时，返回 `Normal`。

## 负载状态判定

`SustainedLoadClient` 应使用保守的帧时间窗口，因为目标是降低发热，而不是响应一两帧的瞬时卡顿。

规则：

- 大约每 10 秒评估一次窗口。
- 只有连续多个压力窗口才提升状态。
- 恢复速度慢于提升速度，避免 `Normal/Warm/Hot` 反复抖动。
- `Quality` 模式表示尽量保留更多效果，但仍允许进入 `Warm`。
- `Battery` 模式表示更倾向从接近 `Warm` 的策略开始。
- 支持 QA 测试用的本地 debug override。

输入：

- 平均帧时间
- 帧时间尖峰比例
- 当前是否有重负载玩法，例如建造、战斗、挖矿、大型 UI 或大量宠物
- 可用时读取玩家设置里的性能模式

状态变化应触发 signal，让已缓存预算的系统可以刷新，而不是频繁轮询。

## 状态行为

### Normal

保持当前体验，同时执行无风险优化：

- 关闭或隐藏的 UI 不应继续动画
- 非活跃系统应断开连接或跳过工作
- 安全时合并重复 tween

### Warm

降低持续性的非关键成本：

- 距离扫描改用较低频率，通常为 0.2-0.5 秒
- 远距离 `BillboardGui` 和 `SurfaceGui` 降低更新频率或隐藏
- 非关键 `ParticleEmitter`、`Trail` 和 `Highlight` 按距离开关
- 其他玩家或远距离宠物降低更新频率
- 建造 High 档保留核心 reveal，但减少烟花、飞砖、弹字和相机 shake

### Hot

保持玩法响应，并减少玩家当前没有使用的内容：

- 玩法输入、移动、命中判定、购买、奖励和建造进度保持响应
- 远距离视觉系统暂停或使用很低频率
- 关闭或后台 UI 的动画停止
- 远距离宠物使用低频位置更新
- 大型建筑模板即使在 High 设备上，也使用 Medium 或 Low 的非关键 VFX 预算

`Hot` 不是低画质模式，而是临时运行时状态：停止玩家大概率注意不到的工作。

## 第一期接入范围

### 建造系统

在现有建造预算基础上加入持续负载状态：

- High + `Warm`：非关键 VFX 使用接近 Medium 的上限，同时保留核心 reveal。
- High + `Hot`：巨型模板的非关键 VFX 使用 Medium 或 Low 上限。
- debug 输出包含 sustained state、实际 budget、活跃飞砖、活跃弹字和烟花计数。

不改变服务端进度、存储、奖励或建造正确性。

### 距离扫描 Controller

优先处理有常驻 `Heartbeat` 扫描或反复遍历区域/物品的 controller：

- `VendingMachineController`
- `ChestController`
- `StoreGuiController`
- `UpgradeGuiController`
- `PickaxeGuiController`
- `JetpackGuiController`
- `EggHatchGuiController`
- `FruitShopGuiController`
- `WeaponShopGuiController`
- `FuseGuiController`
- `TitanGuiController`
- `VoidGuiController`
- `DigController`
- `BlueprintDeviceController`

在安全的地方使用 `SustainedLoadClient.GetInterval("ProximityScan", baseInterval)` 替换每帧或过高频率检查。只在 GUI 打开时才需要的逻辑，GUI 关闭时应完全跳过。

玩法关键动作不能被延迟。只节流发现逻辑、prompt 可见性、装饰更新和 UI affordance 扫描。

### 宠物跟随

`PetFollowController` 很可能对持续成本敏感，因为宠物移动和展示会长时间运行。

规则：

- 本地玩家宠物保持顺滑
- 其他玩家宠物按距离降低更新频率
- 屏幕外或远距离宠物减少 tween 和 attachment churn
- `Hot` 下保留基础跟随，但安全时暂停非关键稀有度展示刷新和装饰运动

### UI 动画和数值 Tween

从高 churn 或长时间运行的 UI 开始：

- `HomeGuiController`
- 重复按钮吸引注意力动画
- 在线奖励提示
- 数值 tween 链
- 隐藏或关闭状态的 GUI 面板

规则：

- 隐藏 UI 不应创建新 tween
- 高频数值变化应合并，避免生成重叠的 `NumberValue` 和 tween 链
- 已关闭面板应暂停装饰动画循环

### 视觉成本工具

新增一个小工具：

`src/StarterPlayer/StarterPlayerScripts/Controllers/Performance/VisualCostUtil.lua`

职责：

- 根据持续负载状态和距离判断 `ParticleEmitter`、`Trail`、`Beam` 或 `Highlight` 是否应运行
- 提供小型 helper，安全应用 `Enabled` 状态
- 避免每帧扫描整个游戏

第一版只用于明显路径，例如建造 VFX、喷气背包效果、宠物视觉或选定区域装饰。不要新增昂贵的全局视觉扫描器。

## 不在范围内

本轮不包括：

- 将建筑资产重做为 MeshPart LOD
- 一次性迁移项目里的所有 controller
- 修改服务端网络协议
- 修改存档格式
- 主动锁帧或自定义帧率控制
- 降低战斗、挖矿、购买、奖励或服务端权威正确性

## Debug 和可观测性

为 QA 和后续 profiling 暴露小型 debug 状态：

- 当前 sustained state
- 当前窗口平均 FPS 或平均帧时间
- 尖峰比例
- 压力窗口计数
- 各系统实际生效 interval
- 活跃建造 VFX 计数
- 可用时统计暂停的视觉系统数量
- 可选本地 override 状态

这些信息应能通过简单的客户端 debug API 或现有 dev UI 路径读取。不要保存到玩家数据。

## 错误处理

- 如果 `SustainedLoadClient` 缺失、未启动或返回无效数据，接入系统按 `Normal` 行为处理。
- 如果 Workspace 节点缺失，距离扫描跳过当前轮次，不报错。
- Debug override 必须只在本地生效。
- Budget 变化只影响视觉和非关键扫描频率。
- 核心玩法、服务端状态、奖励、购买和建造进度仍保持权威且不变。

## 测试

### 长时间空闲

在主城或农场站立 10-15 分钟。确认持续负载状态可以在压力下进入 `Warm` 或 `Hot`，非关键扫描降低频率，关闭 UI 保持安静，核心交互不出错。

### 持续建造

连续建造 `Burjkhalifa` 或 `StatueofLiberty`。确认 reveal 正确，`Warm/Hot` 下非关键效果减少，并且飞砖、弹字、烟花或延迟任务不会堆积。

### 多系统 UI 切换

反复打开和关闭商店、蛋、宠物、镐子、喷气背包、传送等相关面板。确认关闭后的 UI 停止装饰循环，距离检查不会继续高频运行。

### 恢复

持续压力下降后，确认状态从 `Hot` 到 `Warm` 再到 `Normal` 逐步恢复。视觉细节应逐步恢复，不出现频繁状态抖动。

## 验收标准

- 本轮不会主动限制高端手机帧率。
- `Warm/Hot` 下，长时间运行的非关键 `Heartbeat` 和 `RenderStep` 工作有可观测下降。
- 所有状态下核心玩法保持响应。
- 建造进度和奖励保持正确。
- Debug 输出能看到 sustained state、实际扫描 interval、VFX 计数和暂停的视觉行为。
- 飞砖、弹字、烟花、宠物展示或 GUI tween 链没有明显内存增长。

