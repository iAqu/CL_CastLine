# 商店付费蛋

商店仅启用 `LimitedEggFrame.Egg_R_1`。三档商品沿用 PurchaseData 的既有 ID、图标及价格：1 个 79、3 个 199、10 个 649 Robux。`PaidEggConfig` 是鱼池和概率展示的共同来源，修改概率时必须同时提高配置版本；已经开始的订单使用冻结的配置。

鱼池为 Fish_001～Fish_005，分别对应 Neon Cyber、Flamingo、Hell Shark、Undead Megalodon、Galaxy Megalodon，概率 55%／30%／10%／4.5%／0.5%。变异必出，Golden／Diamond／Rainbow 权重为 10／5／2，独立于鱼种且不受幸运加成影响。商店显示 Studio 美术原有的概率文字。

重量复用 TrainingProgress.CalculateFishWeight：从 DefaultWeight 开始按 3.375 倍分档，取不超过训练捕获上限的最大档；基础重量高于上限时取上限。赠送使用收礼人的训练上限。发起购买时冻结收件人、重量上限、鱼池及变异权重，不预先抽奖，也不向客户端暴露未付款的随机结果。

## 订单与恢复

- 仅 ProcessReceipt 确认付款；弹窗关闭事件在客户端启动等待动画，并在明确取消时释放订单。每位购买者同时保留一个未结付费蛋订单，状态不明不自动过期或改变收件人。
- `PaidEggReceipts_v1` 以玩家 ID 和回执 PurchaseId 记录冻结的抽取结果、收件人及投递状态。通过 ProfileService GlobalUpdates 投递，不加载或抢占离线玩家的 profile；在线消费和离线上线后的消费使用相同逻辑。
- 玩家 `PaidEgg.Receipts` 记录逐项提交与完成状态，`Results` 保存未展示完的奖励，`Purchases` 防止重复统计消费。抽取结果和收件箱投递持久化后向在线收礼人推送。鱼揭晓后，服务器把整单鱼实例与逐鱼提交标记一起写入存档并更新背包。展示确认只移除待展示记录。
- `PaidOrigin` 随付费鱼保存在背包、赠送及落水掉落中。购买和转送检查双方对应的 PolicyService 限制；查询失败不开放付费入口。
- 单抽、三连和十连分别同屏呈现 1、3、10 个结果。十连横屏 5×2，窄屏 3 列、末条居中。鱼在各自位置持续旋转，每圈约 5 秒。回执等待超过 8 秒会恢复操作，结果就绪后继续展示。未揭晓的订单从持久投递恢复。

## 无品质的鱼

所有鱼不再抽取或保存 ConditionId，不显示品质名称，价格和幸运不再乘品质倍率。公共接口为 `ItemStatUtil.CalculatePrice(item, weight, mutationRate)` 和 `CalculateLuck(item, weight)`。出售、恢复、摆放、幸运、鱼赠送、掉落共用新规则；不做旧品质存档迁移。ConditionsData 原始表及生成模块本次保留为未引用数据，画质 Quality 设置不受影响。

## 验证

`#CL_DEV` 的 Studio Play 默认用独立购买意图存储。对照测试时在 Workspace 把布尔属性 `StudioDedicatedPaidEggCheckout` 设为 `false` 可使用旧路径。清除该属性可恢复默认值。线上成功读取配置后也默认启用独立结算。将 `DedicatedPurchaseCheckout` 设为 `false` 可回退新订单，已保存的独立订单仍按原记录处理。

运行 `python3 tools/run-tests.py PaidEggPurchases PaidEggMailbox`，覆盖概率边界、冻结订单、重复与并发回执、部分失败、明确取消、离线投递、邮箱隔离及持久化确认。品质相关回归还覆盖出售、摆放、幸运、工具恢复和赠送。

Studio 测试须持有工程共享锁。仅在 Edit 下显式设置 Workspace 属性 `StudioUseMockProfiles=true`，临时通过 Rojo 将 `tests/studio/PaidEggVerification.server.lua`、`.client.lua` 放入对应运行目录；断言 `_is_user_mock` 后才生成测试奖励，不弹出购买窗口、不调用真实商品回执。测试结果写入 Workspace／PlayerGui 的 `PaidEggVerificationServer`／`PaidEggVerificationClient` 属性。结束后 Stop，删除临时运行入口并清除上述属性，再确认 Edit。该隔离开关只在 Studio 生效，不发布或保存工程。

当前 Studio 驱动模拟弹窗关闭和快慢回执，检查动画首帧、揭晓时序、十连同屏旋转以及整单入包。

2026-11-17 验证记录：Studio Mock 的真实 GlobalUpdates 入队、锁定和消费也已通过；23 个修改脚本经 SHA-256 回读与仓库一致。selene 为 0 错误、0 解析错误，38 个警告与修改前相同。全量测试 121 组通过 115 组；修改前同样失败的六组为 FarmPlateLifecycle、GamepadInputSupport、IndexGuiMigration、PotionFeatureDisable、PotionToolConversion、StarterPlayerAnimationLoadOrder，本次未改动这些功能。
