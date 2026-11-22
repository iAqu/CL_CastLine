# 鱼竿、保底与鱼饵

普通鱼严格匹配鱼竿 Rarity；按 Index 分三段（10 条为 3/3/4，9 条为 3/3/3），段内权重为 1、2、3……。同档鱼竿按 LayoutOrder 排序，首/中/末的低中高段基础概率分别为 60/30/10、30/45/25、10/40/50，高段最迟第 12/8/5 次成功收鱼出现。两把取首尾，更多按位置线性插值；保底触发后的实际分布会高于基础概率。

新手前 5 条至少 3 个鱼种，前 10 条至少 1 条高段，前 20 条至少 1 条池内最高 Index。开场教学鱼计入；老账号不追补。活动鱼不推进普通保底，但照常享受鱼饵变异。每把鱼竿独立保存保底。

## 鱼饵与扣费

档位取当前鱼竿 BaitsSelect 的第 1～4 个位置。同一个 BaitID 在不同鱼竿上可能对应不同档位，鱼饵自身 Rarity 和 LuckBoost 不参与抽取。

| 档位 | 费用 | 黄金/钻石/彩虹 |
| --- | --- | --- |
| 1 | 鱼竿 Price × 0.15，四舍五入 | 70/25/5 |
| 2 | 鱼竿 Price × 2，四舍五入 | 0/80/20 |
| 3 | 鱼竿 Price × 25，四舍五入 | 0/20/80 |
| 4 | Developer Product | 0/0/100 |

免费饵按 MutationsData.Chance 抽一次。普通鱼在每轮出现鱼影前，由服务端根据当前训练等级的最大捕获重量确定重量：基础重量超过上限时缩到上限，否则逐次乘 3.375，保留最后一个不超过上限的重量；该轮体型保持固定。鱼竿、鱼饵和抛竿幸运只展示。保留鱼、鱼竿价格及变异收益倍率；鱼蛋沿用原重量规则。

现金饵在成功收鱼时扣费。第四档使用已购买的同竿次数，服务端接受抛竿时消耗 1 次，漏钩后仍可在本场用同一鱼种和变异重试。已完成付款但未抛竿即离开时，剩余次数可在同一根鱼竿上补用。

## 第四档产品

每根鱼竿的第四档从 `PurchaseData.PremiumBait.ProductId` 读取商品 ID。正式版 Pull Up a Fish 使用 Roblox 原生窗口处理真实购买，#CL_DEV 的 Studio Play 使用同一 ID 模拟购买。卡片由 MarketplaceService 查询实际价格，基准价为 9 Robux。购买意向记录原会话和鱼竿，商品通过钓鱼界面售卖。

`PurchaseService.ProcessReceipt` 按 Roblox 的 `PurchaseId` 去重，按保存的意向向对应鱼竿发放 1 次权益，再用 ProfileService.MetaTagsLatest 确认持久化。客户端关闭购买窗口后向服务端查询状态。收据在退出后送达时仍发给原鱼竿；收据尚未确认期间可以选择免费饵和现金饵。

## 存档

`FishingProgress` v2 保存新手进度、每竿 MissHigh，以及 Credits、Receipts、ReceiptRevision。付费饵将待确认意向和新发放权益的写入版本保存在 `PendingBaitPurchase` 和 `BaitCreditRevisions`。存档里的同竿旧权益继续可用。旧存档首次加载时只清除各鱼竿的 Pending。新玩家首次初始化时按历史会话、开场奖励、累计重量、物品和图鉴判断是否为老账号。鱼的库存写入、现金扣费、推进保底和清除本场待结算结果在同一个不让出执行权的提交段完成，美术呈现和通知在提交后执行。

验证可运行 `python3 tools/run-tests.py FishingProgression FishingBaitPurchases FishingService FishingIntro FishingTransition`，并在项目目录运行 selene。

## 初版验证记录

- 三张数据表导出后通过 selene，Studio preflight/apply/verify 全部回读一致；已有一致模块不重写。
- Studio 新运行环境验证全部 27 把鱼竿，同档合法鱼池各有 9～10 条。隔离存档完成真实收鱼、取消恢复、重复 Hook 拦截、现金扣费与保底一起提交、彩虹饵单次消耗、重复凭据拒绝；测试后恢复正式 profile，并停止测试。
- 客户端复用原 UI 验证 Rod_101 的三档价格为 $5/$20/$100，未配置产品的第四档禁用。真实 R 币交易尚未验证，等待实际产品 ID。
- 全量 116 组测试：110 组通过，6 组未通过：FarmPlateLifecycle（农场生命周期标记）、GamepadInputSupport（缺失旧 AnimalPlaceController）、IndexGuiMigration（按钮模拟缺少 GetAttribute）、PotionFeatureDisable（旧商店药水断言）、PotionToolConversion（旧手持药水断言）、StarterPlayerAnimationLoadOrder（缺失旧 EggHatchGuiController）。这些失败所在功能未纳入本次修改。
- 新增概率、收据模块及主要钓鱼改动静态检查无错误/警告；原 PurchaseService、PlayerDataService 仍有既存的未使用变量、单行语句、旧 Instance.new 写法等警告，没有扩大清理范围。

Studio 集成验证脚本保存在 `tests/studio/FishingProgressionVerification.server.lua`；需要复测时，在持有共享锁且 Studio 为 Edit 的情况下临时复制到 `src/ServerScriptService`，通过 Rojo 同步后运行。结果写入 Workspace.FishingProgressionVerification 属性，测试完成必须 Stop 并移除临时启动脚本。它使用克隆存档，不保存测试奖励。


## 进度条抽鱼与四档评级（2026-11-19）

抛竿进度采用同一份客户端/服务端定义：低于 50% 为 BAD（红），50%～不足 80% 为 GOOD（黄），80%～95% 为 PERFECT（绿），严格大于 95% 为 GODLIKE!（彩虹）。GODLIKE 的抽鱼概率与 PERFECT 相同，只增加独立评级标识，供后续动作/特效接入。

下表为低/中/高段的基础概率；同稀有度两把鱼竿取首尾，其余沿用已有排序和线性插值，段内仍按 1、2、3…… 加权。

| 同档鱼竿 | BAD | GOOD | PERFECT / GODLIKE |
| --- | --- | --- | --- |
| 第一把 | 80/18/2% | 70/25/5% | 60/30/10% |
| 中间一把 | 65/30/5% | 45/40/15% | 30/45/25% |
| 最好一把 | 50/40/10% | 25/45/30% | 10/40/50% |

`FishingConfig.GetCastRating` 为共享评级入口，`FishingProgression.GetCurve` 与 `BuildPool` 的末尾参数接收进度，省略时沿用最高档基础概率。服务器接收 `Cast` 时根据点击时机计算进度，锁定本竿评级及鱼池权重，并返回 `castRating`。重复 `Cast` 会被拒绝。错过咬钩后，鱼饵留在水里，下一轮按本竿鱼池和鱼饵重新抽鱼种与变异，结果可以重复。Secret Fish 保留入场时锁定的鱼种，每轮重抽变异。教学保留指定鱼种和变异，宠物蛋沿用首次判定。保底只在成功捕获普通鱼时推进，现金饵在成功捕获鱼时扣费，付费饵每竿扣一次。

客户端点击即弹出评级，不等待 RPC。复用 PowerPopup 的 FredokaOne 与黑描边；不展示概率、进度分数或 POWER 数字。GODLIKE 使用七色 UIGradient，退出时销毁运行时创建的渐变。进度条锁定后保持 0.9 秒，再退场 0.3 秒；弹字总计 1.5 秒，前 0.3 秒弹性放大，1.05 秒起淡出并缓慢上飘。服务器响应不重新计时或重播音效。挥竿、飞行与等待时间不增加；原幸运数字展示保留。

验证命令：`python3 tools/run-tests.py FishingCastQuality FishingProgression FishingService FishingCastLuck FishingCastLifecycle FishingSequenceInfo TrainingFishing FishingIntro FishingInputGate`。Studio 服务端隔离存档脚本为 `tests/studio/FishingCastQualityVerification.server.lua`；客户端预览为 `tests/studio/FishingCastQualityPreview.client.lua`，修改顶部 progress 可预览不同评级。临时启动脚本须经 Rojo 同步，使用后 Stop 并移除。

本次验证：九组概率、四档边界、插值、保底、重试和清理自动化通过；390×844、844×390、1877×1240 的布局边界校验通过；Studio 验证全部八个关键边界、重复请求与逃鱼重试，并回读确认测试 profile 已恢复。客户端检查四种文字与配色、七色渐变及 1.2/1.5 秒退场时间，检查桌面截图，未修改原始 GUI 模板。

全量测试 128 组，119 组通过；另有 EventFishIncome、FarmPlateLifecycle、GamepadInputSupport、IndexGuiMigration、PaidEggPurchases、PotionFeatureDisable、PotionToolConversion、StarterPlayerAnimationLoadOrder、TrainingProgress 共 9 项既有失败，使用本次修改前的五个源文件快照运行同样测试，也得到相同失败。没有为本次功能修改训练、付费蛋、事件、农场、图鉴或旧药水业务逻辑。

## GODLIKE 专属抛竿（2026-11-19）

服务端确认 `castRating == GODLIKE` 才选用 SpecialCastRod；95% 仍为普通 CastRod。两套共享演出配置保存在 FishingConfig.CastProfiles，服务端最早落水时间与客户端共用 LeadTime / ReleaseTime。特殊动画原速完整播放约 2.5167 秒，保留 0.35 秒准备：0.20 秒开启竿尖拖尾，1.03 秒落地烟尘和彩虹环，1.03 秒起手部蓄力，1.70～2.30 秒镜头环绕，2.43 秒主冲击与原 Impact 音效，2.49 秒脱饵，随后进入原追饵镜头。概率、鱼饵、训练、收益和存档结构均未改动。

Land / Wind / Impact 仅调整运行时克隆的数量、尺寸、颜色；复用 EffectPart_Rainbow 的 Stars / Wind，主爆发为同时可见的七种固定颜色、每色 3 个星点。风场随 UpperTorso、手光随 RightHand；脚下特效投射地面后固定，尾迹寿命 0.5 秒。触屏或低画质使用约 60% 粒子预算，保留拖尾和彩虹环。原特效模板、源动画、模型和 UI 布局未修改。

实播校准发现原动画中段会将竿尖插入地面，因此只对演出克隆增加实时腾空补偿，保留动画姿态与速度；GODLIKE 持饵绳长缩短至 0.4 studs，脱手使用实际竿尖。镜头跟随实际身体平移，方向以根节点水平朝向为基准，避免随翻转滚转。投影按头、躯干、手脚包围角点和竿尖适配，观察距离上限仍为 22 studs；窄屏达到距离上限时才适当扩大 FOV，最高 85°，为黑边保留空间。

两套轨道在准备阶段开始加载，只播放选中轨道。特殊动画缺失或加载超时时回退普通动画，速率为 2.05 / 2.49，使脱饵姿态仍落在专属时间轴的 2.49 秒；GODLIKE 评级和彩虹效果保留，警告每客户端仅一次。退出清理两套轨道、预加载任务、特效、附件、拖尾和灯光，相机仍由现有 FishingController 恢复。

验证结果：

- `python3 tools/run-tests.py FishingGodlike FishingCastLifecycle FishingCastQuality FishingService FishingTransition BaitFlightGrowth FishingShowcaseVFX FishingProgression TrainingFishing FishingBaitPurchases FishingBiteSequence FishingInputGate BaitElasticMotion`：13 组通过。本轮六个生产文件 selene 为 0 错误、0 警告。
- 全量 130 组测试中 120 组通过；EventFishIncome、FarmPlateLifecycle、FishingCastLuck、FishingIntro、GamepadInputSupport、IndexGuiMigration、PotionFeatureDisable、PotionToolConversion、StarterPlayerAnimationLoadOrder、StudioOnboardingProfile 共 10 项失败。以修改前五个生产文件快照复跑这 10 项，得到相同失败，没有扩大修复范围。
- `#CL_DEV` 隔离 profile 验证 95% / 95.0001% 评级、重复 Cast 拒绝，以及 GODLIKE 在普通落水时间仍被拦截、专属落水时间后可以开始鱼轮；验证后已恢复原 profile，不发测试奖励。
- 实际动画长度 2.51666665 秒，1 倍速自然结束。完整播放记录主冲击约 2.453 秒、脱饵约 2.505 秒（首次渲染帧跨越节点）；低帧率下也各触发一次。普通动画长度 2.16666675 秒，原脱饵与音效时机保持不变。
- 完整特殊演出桌面和 390×844 投影检查均无裁切。27 把鱼竿在 0.20 / 0.70 / 1.03 / 1.70 / 2.10 / 2.43 / 2.49 秒共 189 个姿态的桌面、窄屏投影检查通过。实播竿尖最低约高于地面 0.74 studs，风场相对躯干偏差与固定落点漂移均为 0。
- 起手、第一翻转、蓄力、第二翻转、主冲击和飞行六处中断后，无残留演出克隆、特效和轨道。实际缺失特殊动画回退速率 0.823293，2.49 秒时普通动画约在 2.058 秒，仍正常播放；低画质每色星点减至 2 个，源模板 EmitCount 仍为 15。
- 三段原音效资源均已加载、实际播放，音量沿用 0.5；本轮只核对触发、资源及播放状态，未做人工听感评审。设备模拟器的 UI 自动化多次超时，窄屏验证采用真实姿态投影，尚未完成手机设备模拟器／真机的目视验证。

复测脚本：`tests/studio/FishingGodlikeVerification.server.lua`（隔离存档），`tests/studio/FishingGodlikePreview.client.lua`（独立演出克隆，可通过 Workspace.GodlikePreviewControl 的 Run / Seek / Stop 属性控制）。仅在持锁且 Studio 为 Edit 时临时复制至 ServerScriptService / StarterPlayerScripts，经 Rojo 同步确认后 Play；结束须 Stop、移除临时入口并确认 Edit。本轮已按此清理，没有保存或发布工程。

## 七色并排拖尾优化（2026-11-19）

GODLIKE 的竿尖及飞行拖尾改用共用 RainbowCastTrail：七条固定颜色 Trail 横向拼接，另加两条深色细边，全部面向镜头。竿尖宽 1.4 studs、寿命 0.85 秒、最长 18 studs、边宽 0.05；飞行宽 1.2 studs、寿命 0.70 秒、最长 20 studs、边宽 0.04。WidthScale 保持 1，前 65% 寿命透明度保持 0.08，最后 35% 渐隐；彩色条 Brightness 为 1.3、LightInfluence 为 0、LightEmission 为 0.4，深色外沿透明度为 0.45。

拖尾使用独立的透明锚定承载件，与鱼饵的旋转、尺寸和弹性附件分离；方向依据移动切线与视线叉乘，并平滑保持同侧颜色顺序。渲染在演出相机更新后执行，七色色带在触屏及低画质下保持完整。竿尖仍从动画 0.20 秒开启至 2.49 秒脱饵，随后自然消散；飞行色带在脱饵时开启，落水时停止生成并自然消散。相机构图加入未消散竿尖尾迹的历史边界，沿用原距离及 FOV 限制。普通抛竿继续使用原白色 Trail，源模板、动画、UI 布局、概率、鱼饵和训练不变。

本轮验证：新增 RainbowCastTrail 自动化覆盖七种固定颜色及两条边、物理宽度、15/30/60 FPS 的朝向连续性、正对镜头和静止情况、重复 Start/Stop/同帧更新、历史边界、停止后的自然消散与销毁。13 组相关测试通过，五个改动生产模块 selene 为 0 错误、0 警告。另跑 FishingService 在第 132 行的教学重量断言失败，用本轮修改前四个生产文件快照复跑同样失败，未更改教学/训练逻辑。

Studio 使用独立演出克隆正常速度实播，截图确认第一段翻转的七色弧线和飞行追镜中的彩虹带清晰可见。390×844 虚拟画幅中，采样的主要可见尾迹每条色带最小宽度约为竿尖 4.34 像素、飞行 6.95 像素；角色桌面/窄屏投影无裁切。该结果为投影检查，未替代手机真机目视验证。实播记录仍为七色主爆发共 21 个星点，三个动作音效各一次。95% 的普通动作实测只有一个白色 Trail，寿命仍为 0.35 秒。起手、第一翻转、蓄力、第二翻转、爆发和飞行六处取消后，RainbowCastTrail 承载件残留均为 0。

复测脚本为 `tests/studio/RainbowCastTrailPreview.client.lua`，经 Rojo 临时复制至 StarterPlayerScripts 后使用 Workspace.RainbowTrailPreviewControl 的 Run / Seek / Stop 属性控制。原有 Rojo 会话仍可同步，Manager 新连接请求报告其他用户已在同步，因此未切换或抢占连接；本轮以 Studio Source 回读核对最终脚本。测试结束已 Stop、确认 Edit 并删除临时入口，没有保存或发布工程。

## 变异鱼出水拖尾（2026-11-19）

仅在钓获鱼首次露出水面、向上升起时替换原出水拖尾：Rainbow 复用七色并排带及两侧细边；Golden / Diamond 复用同一渲染器的单色模式，颜色读取 MutationDataUtil.GetLabelColor，当前分别为 RGB(255,170,0) 与 RGB(37,204,255)。普通鱼及未知变异仍使用原 VFX.Fish.FishTrail，鱼蛋不创建鱼类拖尾；手持和鱼池继续沿用原变异外观，不接入新拖尾。

新 FishingMutationTrail 由 FishingBiteSequence 独占管理。首次出水按 originals 中可见鱼体部件测量主部件局部包围盒：宽为可见宽度的 30%、最低 0.6 studs；边宽为总宽 1/28；最长为包围盒最长边的 2 倍、最低 10 studs。宽度初次确定后固定，位置通过局部中心、当前鱼体缩放及主部件 CFrame 每帧更新，避免展示缩放或旋转导致宽度跳动、偏离鱼体。寿命 0.70 秒，前 65% 保持清晰、最后 35% 淡出。参数保存在 FishingConfig.Bite.MutationTrail。

拖尾创建在 Present 已完成本帧鱼体位置、旋转和缩放之后；读取成功 Hook 已确认的 mutationId，不依赖预览信息猜测。上升顶点停止生成，剩余尾迹自然消散，不在下落、Caught 静止展示或收竿重启。每鱼只创建一次；退出及换鱼通过原 Bite.Destroy 清理，鱼模型外部销毁走现有资源失效退出与清理。无需新增网络接口、存档字段或全局变异监听；概率、收益、鱼体材质、源模板和 UI 均未修改。

本轮验证：

- `python3 tools/run-tests.py FishingMutationTrail RainbowCastTrail FishingBiteSequence FishingShowcaseVFX FishingCastLifecycle FishingGodlike FishingCastQuality FishingLuckyRewards FishingProgression FishingTransition TrainingFishing MutationLifecycle RainbowFishAppearance FishWeightEconomy BaitFlightGrowth`：15 组通过。三个生产文件 selene 为 0 错误、0 警告。
- 新单元测试覆盖配色、三种初始体型、局部中心与旋转/缩放跟随、固定宽度、15/30/60 FPS、未出水不生成、到顶停发、自然消散、一次性创建、重复销毁及鱼蛋/未知变异；原渲染器测试增加黄金/钻石单色模式。
- Studio 正常速度截图确认七色、亮金、冰蓝三种出水尾迹。Golden / Diamond 各为 1 条颜色带加两侧边，Rainbow 为 7 条颜色带加两侧边；均创建一次、未叠加普通拖尾、到顶停发且 0.70 秒后消散。普通和未知变异保留原拖尾。
- GreenSeahorse、Dragonfish、TurtleWalker，以及 Dragonfish / GreenSeahorse 的 1e12 测试重量完成正常演出；新拖尾宽度在单次演出内保持一致。桌面和 390×844 的鱼体投影检查无裁切；手机真机目视仍未验证。
- 4 种真实鱼蛋 Draw001 / Draw006 / Robux1 / Season2，各 8 个阶段的既有表现回归通过，未创建鱼类拖尾。三种变异分别应用到鱼池和手持 Tool 独立副本，新增彩虹拖尾承载件均为 0。
- 出水前、刚出水、上升中、到顶后及静止展示五处取消，均无舞台/拖尾残留。外部销毁鱼模型时，现有资源失效退出触发并完成清理。

复测入口保存在 `tests/studio/FishingMutationTrailPreview.client.lua`，临时经 Rojo 复制到 StarterPlayerScripts 后，可通过 Workspace.FishingMutationTrailControl 的 Mutation / Model / Weight / Egg / Run / FreezeAt / Stop 属性控制。测试只使用独立模型与相机，没有发放奖励或修改玩家存档；结束已 Stop、确认 Edit、删除临时入口，不保存或发布工程。
