# 首次进入钓鱼教学

## 入口与加载交接

正式游戏只为存档 `MetaData.SessionLoadCount == 1` 的首次进入自动启动。服务器 `ClaimAutoPlay()` 一次占有资格；中断、死亡或重进不补播，不按历史捕获重量或开场版本推断新玩家。`FishingIntroVersion` 继续用于首鱼奖励去重，不新增存档字段。

家园在加载期间分配。首次进入跳过家园入场运镜，直接进入玩家的抛竿准备机位和进度条；老玩家保留原入场流程。没有剧情时间轴、NPC、NPC 鱼或剧情事件。

加载仍使用 `Pending → Preparing → Prepared` 及 `Skipped` 状态。确认资格、角色外观与钓鱼平台就绪后，加载脚本在黑幕下释放相机、锚定、GUI 和提示快照，建立正常家园相机。教学取得独立快照并构建玩家及现有 FishingCastSequence，在黑幕下按固定准备时刻渲染真实抛竿首帧；等待加载完成期间不推进进度条或播放钓鱼音效。

首帧完成后标记 `Prepared`。加载撤下，通过现有 `StartPlayback(token)` 确认服务器就绪；服务器从 Prepared 进入 ReadyToCast，客户端直接进入 Teaching，重新起算进度条，不再等待 19 秒。确认前不允许抛竿，旧回执或重复确认不能重新接管控制。

## 玩家、鱼与操作

场景容器 `FishingIntroScene` 只包含保留玩家外观的 R15 钓鱼演出骨架。沿用实际家园平台及正常抛竿、飞行、落水、水面镜头与首获展示特写；成功时切到角色双手举鱼的特写。背景里的真实玩家、家园展示鱼、道具及悬浮提示只在本客户端暂时隐藏，退出恢复。

- 教学鱼与真实首获奖励均使用 `Fish_102 / WheelersShrimpGoby`。
- 每轮读取鱼配置的 `DefaultWeight`，不按训练能力计算重量。当前默认重量 0.6、ModelDefaultScale 1.03；代码不硬编码这些数值。水下、出水及展示保持默认倍率，没有额外放大或缩放冲击，入包重量与展示一致。普通钓鱼尺寸规则保持现状。
- 抛竿条接受任意有效点击。教学固定两次假咬，复用正常鱼影、轻涟漪、水花与音效。
- 提前提竿只重试咬饵段，不重播抛竿，不额外消耗鱼饵；新一轮由服务器安排真咬时刻，旧轮次不能领奖。
- 真咬持续等待输入，鱼和鱼饵保持轻微抖动及低强度骨骼活动，鱼嘴与鱼饵接触点不分离。屏幕右侧手指以 0.36 秒循环提示，首次有效输入后隐藏；只需点击一次。
- 提竿后沿用挣扎和出水。成功时隐藏演出鱼竿和鱼线，双手托住鱼腹并用约 0.25 秒将鱼举过头顶。鱼信息立即显示，展示满 1.4 秒后开放继续；确认后的下一渲染帧直接恢复正常玩法镜头和操作。
- 正式奖励通过 ItemGrantUtil 按默认重量入包并记一次捕获重量，同时把该鱼的实例设为放养引导目标。确认继续后恢复操作，由服务端装备该实例。Studio 预览不发奖、不写完成进度，不修改真实存档。

## 操作提示

删除所有对白和人名，只创建一条 Instruction 文本和点击手指，不创建 Dialogue、Speaker。沿用 FishingSequenceGui.ContinuePrompt 的 FredokaOne 字体，克隆的提示文字使用 4 像素黑色描边；文本区域为视口宽 96%、高 12%，TextScaled、字号上限 94。常规提示位于下方中央，继续提示上移到 74% 高度避开鱼信息。教学期间隐藏钓鱼 Luck 倍率条与对应数值提示音，以及进度条旧提示和玩法旧等待提示，结束恢复。

| 阶段 | 指令 | 颜色 |
| --- | --- | --- |
| 准备抛竿 | TAP TO CAST! | 亮青 RGB(0,200,255) |
| 落稳后等待、假咬 | WAIT FOR A STRONG BITE | 亮黄 RGB(255,200,0) |
| 提前点击重试 | WAIT UNTIL IT HOLDS，持续 1.3 秒 | 橙色 RGB(255,128,0) |
| 真咬 | TAP TO HOOK! | 亮绿 RGB(30,255,60) |
| 展示完成 | TAP TO CONTINUE | 白色 |

手柄输入提示对应改为 PRESS A TO CAST!、PRESS A TO HOOK! 和 PRESS A TO CONTINUE。抛竿飞行、挣扎和出水期间不额外显示等待指令。成功只保留鱼信息和继续提示，不显示 Nice catch。引导中将首获徽章向右移，给继续提示留出空间，退出后恢复徽章位置。

## Studio 预览与清理

F6 从头预览，播放中再次 F6 可重播；F7 停止当前教学或待启动流程，本次会话不再自动启动。离线收益窗口在预览时暂时收起，结束恢复，不领取收益。

保留 Studio 专用桥 `game.Players.LocalPlayer.PlayerGui.FishingIntroPreview:Invoke("Play")`、`Invoke("Cancel")`、`Invoke("Status")`；移除剧情 Sample/Resume 接口。重生可能清除 PlayerGui 内的调试桥，F6/F7 仍为实际预览入口。

正常结束、取消、角色替换、死亡和构建失败均解除输入绑定，清理玩家克隆、鱼、鱼线、手指、效果及音频，恢复独立快照中的相机、锚定、GUI、背包、提示与音乐。准备超时和迟到回执不能重启旧会话。

## 验证记录

```sh
python3 tools/run-tests.py FishingIntro FishingIntroStartup FishingIntroLoadingHandoff FishingBiteSequence FishingInputGate FishingService FishingCastLifecycle FishingReelSequence FishingTransition AmbientAudioLifecycle LoadingScreenExitTransition LoadingScreenClientReadiness StartupUiStateLatency
```

2026-11-18：13 组定向回归通过，修改的 5 个生产 Luau 文件 Selene 零错误、零警告。覆盖确认前拒绝抛竿、确认后立即允许抛竿、重复请求、首播资格和加载冻结、迟到回执、提前点击重试、两次假咬、真咬保护、默认重量奖励去重及固定尺寸。服务测试中的训练重量查询直接抛错，确保教学不再依赖训练上限。

桌面 Studio 已跑通完整教学，首个观测帧直接为 Preparing；场景仅含 1 个玩家骨架，无旧 Dialogue/Speaker 和重复提示。水下至成功的 88 次采样倍率均为 1.029999971（配置值 1.03 的浮点表示），两次假咬完整发生，继续后相机为 Custom、根未锚定、演出容器无残留。

2026-11-18 登录恢复后补验完成：Rojo 连接确认 Connected / localhost:34872，Edit Source 确认最终继续提示位置为 74% 高度。iPhone 17 Pro 横屏模拟实拍检查等待、收竿及继续提示，继续文字已避开鱼名，未创建对白、人名或重复旧提示。提前点击只重试当前咬饵段，第二轮两次假咬完整，之后捕获及继续返回正常；手机重试至成功的 150 次尺寸采样仍保持 1.03。

独立真咬长等待实测 15.216 秒、84 次采样，始终保持 Bite 与手指提示，鱼倍率保持 1.03，没有自动捕获；F7 退出后相机 Custom、根解除锚定、场景无残留。F6 快速重播、F7 停止、死亡／重生及重生后再次 F6/F7 均通过；相机主体为新 Humanoid，移动与确认绑定均解除。相关 Warning/Error/Information 日志无新增问题。

自身测试已停止并确认 Edit，设备模拟器已恢复 default，共享锁释放；未保存或发布 Studio 工程。手机检查为 Studio 模拟，未使用物理设备。
