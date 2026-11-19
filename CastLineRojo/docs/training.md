# 挂机训练

## 数据先于功能

源表为项目正式 Google Sheet 的 TrainingData 和 TrainingLevelsData。先按根目录 sheet-sync.json 仅导出两表，运行 selene，再向 #CL_DEV 的 ReplicatedFirst.Data 执行 preflight / apply / verify。两端一致后才接入功能脚本。生成数据被 Rojo 排除；脚本继续走 Rojo。

TrainingData 的 LayoutOrder 定义连续购买顺序；首档免费，永久使用最高已解锁档位。XpPerRep 是一次基础训练经验；全局每 0.5 秒结算一次，DoubleTrain 权益乘 2。没有点击或离线经验。

TrainingLevelsData 包含 1,500 级，MaxCatchWeight 是训练允许的鱼重放大上限，单位为 kg。1 级为 10 kg，此后每级增加 10 kg。XpToNextLevel 是本级升下一级所需经验，按 `ROUND(5 + 0.006 × (Level − 1)^2.1)` 计算，剩余经验可跨级保留。满级的升级经验为 0，经验条显示 MAX。

## 运行行为

TrainingService 在服务端检测角色脚部与自家 TrainingAnchor 的关系。训练标记的本地 X 轴竖直，各家园锚点相对 Ground 的旋转与 Plot_1 一致。进入后对齐到点中心，面朝自家锚点 LookVector 的水平投影，清零速度，固定根部并关闭自动转向与行走；保存的移动属性在退出时恢复，跳跃能力不被禁用。

STOP、空格、手机跳跃键和手柄跳跃共用停止请求。主动退出移到训练区域外：沿远离家园中心的方向越过标记边缘 2.5 studs，检查可站立地面与角色空间；缺少地面、坡度过大、平台过高或身体空间被挡时回退到家园出生点。跳跃退出在服务端确认解锁与移出后正常起跳。重复请求不重复传送；离开触发范围后才解除再次进入的阻挡。死亡、断线、家园变更或其他玩法中断只释放固定，不额外执行退出传送。

训练时收起工具，结束后恢复原工具。BackRodService 同步监听 IsTraining，训练时移除背部鱼竿，结束或死亡后按当前 EquippedRodId 重建一份；训练期间切换鱼竿仍保持隐藏。TrainingCharacterLock 仅保存运行时角色引用，不写入存档；恢复时不覆盖其他系统已更新的移动速度。断线清理保留 ResumeActive 和最后训练时间，延续 120 秒重连规则。

TrainingDisplay 在有主人的家园训练点放置当前 TrainingID 的闲置杠铃，杆身与角色的训练朝向垂直，并按包围盒底部贴地，所有部件固定且不可碰撞、触摸或查询。训练时由手持模型替代闲置模型，停止/死亡后恢复；升级刷新，换家园、释放家园或退出时清理。服务器实例对其他玩家可见，不在空家园放置。

训练期间关闭并隐藏 BackpackGui（物品面板与快捷栏），顶部背包图标跟随 IsTraining 隐藏，项目 Purse 适配层屏蔽打开、数字键、点击和手柄换物。停止后恢复原先的可见状态但不重开物品面板；如果钓鱼或教学仍在使用隐藏状态，延迟到其结束后再恢复。第三方 Packages 不修改。

TrainingUpgradeAnchor 上的提示只绑定自家家园；服务端按自家锚点、距离、当前器材 ID 和余额再次验证，一次购买下一档。升级不重置经验。

存档 Training 保存 Level / Xp / TrainingID / ResumeActive / LastActiveAt，与旧 Strength 独立。正常退出前更新活跃训练时间；120 秒内重连在本次分配的家园训练点出生。普通出生和恢复通过 PlotSlotService 的同一次定位处理，超时和主动停止不恢复。

## 鱼重与显示

服务端每次 NextRound 先保留原鱼种、变异及鱼饵，再按当前训练上限计算重量，并返回 weight / maxCatchWeight。本轮内固定；已有未结算鱼下一轮按最新训练上限重算，已入库鱼不迁移。

基础重量达到或超过训练上限时按基础重量捕获。可放大时逐档尝试尺寸 ×1.2、重量 ×1.728，保留最后一个不超限档位。鱼影出现前即采用最终尺寸。普通鱼、活动鱼、教学实际捕获及付费蛋鱼奖励适用。显示模型仍遵守现有尺寸保护上限。

HomeGui 的 Weight 双层标签显示最大捕获重量；leaderstats 的 Weight 仍是累计捕获重量。训练预制件为 StarterGui.TrainingGui，安装配方位于根目录 assets/ui/install_training_ui.studio.lua。配方也按 Plot_1 的 Ground 相对变换补齐其余家园锚点；不覆盖已有锚点。

## ThrowFood 风格预制 v2

TrainingGui 使用参考工程的底部经验条、绿色底槽、蓝色填充、条纹和高光，常驻信息只保留 Level 与当前经验/升级所需经验。经验条高 32～44 像素、宽度最大 720 像素；最大捕获重量继续显示在 HomeGui，经验与重量提升只在收益/升级时飘字。Info 说明区隐藏，独立 STOP 按钮恢复显示并保持至少 144×48 像素。训练不控制镜头、不隐藏其他 HUD，也没有点击奖励。

Templates 保存 XpPopup / LevelPopup / WeightPopup / ConfettiPiece，运行时只克隆和动画，不生成界面结构。TrainingFeedback 从相邻、递增版本的服务端快照计算实际经验差，跨级时累加已消耗经验；首次读取、停止重入、重复快照和满级不虚增反馈。每次收益触发约 0.85 秒飘字和轻微弹跳；升级合并显示实际重量增量，并生成 26 片彩纸。TrainingUIEffects 管理动画和临时实例，停止、死亡、切换家园及界面销毁时清理。

升级牌单独保存在 StarterGui.TitleGui.TrainingUpgradeTemplate，运行时作为 TrainingUpgradeTitle 挂在自家 TrainingUpgradeAnchor 下。该标记是旋转薄片，因此使用同一 Part 下的 UpgradeTitleAnchor 附件提供世界坐标上方 5.2 studs 的稳定位置，BillboardGui 的 Adornee 指向该附件。牌子是透明底、大号价格、经验收益及黄色箭头；可购买时绿色呼吸与箭头浮动，不足时红色无箭头，满档金色 MAX。UpgradePrompt 使用 Custom 样式，复用项目 ProximityPromptController 的键盘、手柄和触控效果，不复制参考项目的原生 Prompt 样式。

安装脚本只替换带有已知 TrainingPrefabVersion 的训练预制及升级牌，不修改其他 TitleGui 模板。重复安装和运行时家园重新绑定不会生成重复实例。

## 验证

在 CastLineRojo 目录运行：

```sh
python3 tools/run-tests.py TrainingCharacterLock TrainingBackpackState TrainingSpot BackpackTopbar BackpackMount BackpackDrag TrainingFeedback TrainingProgress TrainingFishing GamePassEffects CarryCapacity FishingService FishingProgression FishingIntro FishingBiteSequence FishingCastLifecycle PlotRespawn WeightFormat FishingLuckyRewards FishingCastLuck PetEggSystem FishingSequenceInfo FishingTransition FishingShowcaseVFX FishWeightEconomy FishingBaitPurchases FishingIntroLoadingHandoff FishingIntroStartup FishingInputGate
```

Studio 验证脚本位于 tests/studio/TrainingVerification.server.lua 与 TrainingVisualVerification.client.lua。仅在持有共享锁时临时复制到对应 src 启动目录，通过 Rojo 同步后测试。服务端替换为隔离 profile，正式 profile 不记录训练收益；结束前设置 Workspace.TrainingVerificationRestore=true，确认 TrainingVerificationRestored=true，然后 Stop 并移除临时启动脚本。不得发布测试启动器。

回读结果分别在 Workspace.TrainingVerification 和 LocalPlayer.TrainingVisualVerification。覆盖固定位置与朝向、退出范围与请求去重、12 档闲置模型贴地、家园释放清理、区域进入/停止重入、工具收起、升级扣费及去重、越距购买、120 秒恢复判断、双倍经验、满级，以及鱼影到展示七阶段固定尺寸。设备验证使用手机横屏与桌面视口，结束后恢复默认设备。

UI 探针为 tests/studio/TrainingUIVerification.client.lua，按相同规则临时复制、验证后删除；计数记录在 LocalPlayer.TrainingUIFeedbackVerification。服务端隔离验证脚本完成后，可设置 Workspace.TrainingUICommand 为 JSON `{ "kind": "Level", "seq": 1 }` 触发真实流程，支持 Normal / Double / Level / Multi / Max / Poor / Stop；结果记录在 TrainingUICommandResult。所有指令仅改变隔离 profile，禁止将探针发布。

### 2026-11-17 固定训练验收

15 组相关本地测试通过；新增模块、训练服务/控制器与顶部背包适配脚本 selene 无错误和告警。Purse 主文件保留既有静态诊断，本次未新增。Studio 隔离数据通过 37 项服务端检查；真实 STOP、空格、手机触摸跳跃及 Controller Emulator 跳跃均能退出并解除固定。验证了训练中升级换模、死亡恢复闲置展示，以及家园释放时原地解除固定并清理展示。桌面、iPhone 17 Pro 和 Galaxy A06 横屏布局通过，手机 STOP 至少 144×48。结束已恢复隔离 profile、删除临时启动脚本、关闭手柄面板、恢复默认视口并返回 Edit。8 个脚本与 Rojo 源码校验一致；未保存或发布。
