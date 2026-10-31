# 性能优化设计

日期：2026-05-10
项目：DB_DEV / DigToBuild

## 目标

优化以建筑搭建为核心的运行时性能，重点解决低内存安卓设备卡顿，以及移动端长时间游玩发热的问题。

本次优化采用平衡目标：

- 低端安卓设备在搭建大型建筑时不能明显卡死。
- 中端设备在降低部分表现后仍保持建造交互流畅。
- 高端设备尽量保留当前表现，但不能长期维持高负载导致持续发热。

选定方案是“运行时设备分级 + 分档建造表现”。服务端仍保持精确进度和存储模型，客户端根据设备承载能力选择合适的建造展示成本。

## 当前热点

通过 Studio 检查，`ReplicatedStorage.Models.Building` 下的建筑模板规模较大：

- `Burjkhalifa`：4,833 个 BasePart
- `StatueofLiberty`：2,491 个 BasePart
- `BigBen`：2,321 个 BasePart
- `PetronasTwinTower`：1,344 个 BasePart
- `Pyramid`：1,082 个 BasePart
- `EiffelTower`：911 个 BasePart

当前客户端进入建造区时会把完整建筑模型 clone 到 Workspace，隐藏每个 build part，然后随着进度逐个 reveal。对于本地可见建造部件，当前 VFX 路径可能创建飞砖 Part、Attachments、Trail、NumberValue、Tween 链、相机 shake、奖励弹字和 reveal 动画。大型建筑上这些成本很高，并且在展示其他玩家建造时会继续叠加。

`BuildController` 也在每个 Heartbeat 中运行多类检查：建造区距离、空农场邀请、进度 UI 可见性、脱困检测、本地 pending reveal、其他玩家 reveal、完成反馈和建造请求。这些单项逻辑不大，但叠在一起会形成稳定的移动端 CPU 消耗。

服务端存储方向已经是正确的：建造进度使用层状态和 bitset 式压缩进度，而不是保存很长的 completed part key 列表。当前主要剩余压力在客户端渲染、VFX 临时 Instance 创建销毁，以及广播 payload 的客户端处理。

## 性能分级

新增客户端模块 `PerformanceProfileClient`，用于判断当前渲染档位：

- `Low`
- `Medium`
- `High`

模块不应依赖硬编码机型列表，而应保守结合平台和运行时表现。初始档位可以在启动后采样 5-10 秒确定；如果后续帧时间持续不稳定，再缓慢降级。

建议输入：

- 平台：移动端或桌面端。
- Roblox 客户端可用的画质或相关信号。
- 5-10 秒帧时间采样。
- 建造重负载期间持续帧时间尖峰。
- 玩家手动设置。

新增玩家设置：

- `Auto`：使用自动分级。
- `Battery`：强制 Low 或 Medium 行为。
- `Quality`：允许 High 行为，但仍保留安全上限。

最终生效档位需要能通过日志或小型 debug API 查看，方便 QA 确认当前走的是哪条路径。

## 分档行为

### Low

Low 面向 2GB 安卓设备、帧率不稳定的移动端，以及手动开启省电模式的玩家。

行为：

- 建造展示使用层级或分组 reveal，不做逐 Part 表现。
- 服务端进度仍保持精确，但客户端视觉更新合并成较粗的组。
- 除非非常接近且确实需要，否则不 clone 其他玩家的完整细节建筑模型。
- 飞砖禁用 Trail。
- 只显示少量代表性飞砖，重负载时可以不显示飞砖。
- 关闭或大幅降低烟花、相机 shake、奖励弹字、多段 Part Tween。
- 拉大距离检测和 UI 检测间隔。
- 大量 Part 优先直接恢复最终状态。

### Medium

Medium 面向普通移动端，以及帧率可接受但不稳定的设备。

行为：

- 本地建筑可以 clone 完整模型，但 reveal 使用更大的批次处理。
- 飞砖效果采样显示，例如每几个完成 Part 只显示 1 个飞砖。
- 使用简化 reveal 动画。
- 其他玩家详细建筑模型按距离和数量限制。
- 烟花和弹字设置并发上限。
- 非关键距离检测降低更新频率。

### High

High 面向桌面端和稳定的高端移动设备。

行为：

- 本地玩家保留接近当前的完整视觉体验。
- 对同时飞砖、烟花、弹字、相机 shake、单帧 reveal 工作量设置硬上限。
- 只展示最近的 1-2 个其他玩家详细建筑。
- 对超大建筑模板即使在 High 也自动降低 VFX 压力。

High 不能等于无限特效。iPhone 16 发热说明高端设备也需要持续负载上限。

## 建筑模型加载

新增建筑模板统计缓存，供建造表现代码共享：

- 总 build part 数
- 层数
- 每层 part 数
- model name
- 大型模板标记，例如 `totalParts > 2000`

用这些信息为大型建筑应用更严格的预算。例如 `Burjkhalifa` 有 4,833 个 BasePart，不能允许无限逐 Part VFX。

本地玩家模型策略：

- Low：如果碰撞和最终外观需要，可以保留完整本地模型，但 reveal 必须分组，VFX 保持最低成本。
- Medium：允许完整本地模型，配合批量 reveal。
- High：完整本地模型，配合有上限的细节 reveal。

其他玩家模型策略：

- Low：默认不 clone 其他玩家的完整细节建筑；显示进度 UI 或粗粒度完成状态。
- Medium：仅在附近 clone 其他玩家详细建筑。
- High：只保留最近的相关槽位，例如 1-2 个农场的详细建筑。

离开当前 Area 或远离农场时，应及时销毁其他玩家 build state。

## 建造同步与存储

服务端建造进度继续保持权威和精确。当前存储方向应保留：

- 已完成层数
- 当前层索引
- 当前层 bitset
- 总 part 数
- 用于迁移安全的签名
- 紧凑的保存 payload

客户端档位只影响渲染，不影响服务端正确性。服务端可以继续发送精确 delta payload，Low 和 Medium 客户端自行决定视觉上合并到什么粒度。

如果后续实测发现网络或客户端反序列化成为瓶颈，再增加旁观者专用节流：

- 建造者立即收到精确 delta。
- 附近旁观者收到批量 delta。
- 远处旁观者只收到低频进度快照。

这是第二阶段内容，第一期不强制实现，除非 profiling 证明网络压力已经明显。

## Heartbeat 调度

将 `BuildController` 的 Heartbeat 工作拆成分频调度：

- 建造区进入/退出：每 0.15-0.25 秒检测一次。
- 建造进度 UI 可见性：每 0.25-0.5 秒检测一次。
- 空农场邀请 prompt：每 0.25-0.5 秒检测一次。
- 脱困检测：保持当前 0.2 秒，Low 可降到 0.4 秒。
- 建造请求：只在建造 active 时运行，并按档位限制请求频率和 batch。
- 其他玩家 reveal 清理：分频并按距离处理。

这样可以保持玩法响应，同时移除非关键系统的每帧轮询。

同类模式也应考虑用于其他有 proximity Heartbeat 的客户端 controller，例如商店、蛋、宝箱、贩卖机等 UI prompt。该部分可在建造系统之后实施，但设计上应避免继续增加一次性调度逻辑。

## VFX 预算

新增建造 VFX 预算层，例如 `BuildVfxBudget`，根据生效性能档位和建筑规模返回限制。

预算应覆盖：

- 最大同时飞砖数
- 每秒最多新建飞砖数
- Trail 开关
- 每帧 reveal Tween 数量
- 弹字并发数
- 相机 shake 最小间隔
- 每层和整栋烟花数量
- 最大延迟特效排队数量

Low 下大部分效果应变成代表性表现，而不是每个完成 Part 都创建效果。Medium 使用采样。High 保留当前手感，但必须有 cap。

VFX 实现应在合理范围内复用 Instance。飞砖很适合做对象池，因为当前每个视觉飞砖都会创建并销毁多个 Instance。

## 全局优化后续项

建造路径受控后，再扫描相邻系统的移动端稳定成本：

- 商店、蛋、宝箱、贩卖机、镐子、喷气背包、商店等 controller 中的多个 Heartbeat proximity 扫描。
- SurfaceGui 和 BillboardGui 在远距离时的可见性。
- ParticleEmitter、Beam、Trail、Highlight 在非活跃或远距离时是否仍运行。
- UI 或玩法模式关闭后是否仍有 RenderStep / Heartbeat 连接未断开。
- 大型 ReplicatedStorage 资源文件夹是否导致客户端过早接收不需要的资源。

这些作为后续工作处理，除非 profiling 证明它们与建造瓶颈同等或更严重。

## 测试与验收

增加 debug 输出或 dev panel 计数：

- 当前生效性能档位
- 当前 building id 和总 part 数
- 活跃飞砖数
- pending reveal 数
- 其他玩家 build model 数
- 当前 VFX budget
- build model clone / destroy 事件

验收目标：

- 低端安卓设置下，搭建 `Burjkhalifa` 时正常流程不能明显卡死。
- 重复进入、离开、建造、重置后，内存不能持续增长。
- `BuildFlyBrick` 和 `RunningVFX` 对象在特效结束后不能堆积。
- Medium 档在 active building 和附近其他玩家进度更新时保持流畅。
- High 档保留当前视觉手感，同时降低持续发热压力。
- iPhone 16 在 Auto 模式下不能长时间保持满特效强度。

## 实施范围

第一期实现应包括：

- `PerformanceProfileClient`
- 建筑模板统计缓存
- 按档位处理的 build reveal 策略
- 按档位处理的其他玩家建筑策略
- `BuildController` 分频调度
- 建造 VFX budgets 和 caps
- QA 用 debug 计数/日志

第一期不包含：

- 将建筑资产重做为 MeshPart LOD。
- 把项目里所有 proximity controller 全部替换成共享服务。
- 服务端旁观者专用网络节流，除非 profiling 证明必须做。
- 任何建造系统视觉重设计。
