# Enlarge 合成 Cash 费用设计

## 背景

Animal Enlarger 允许玩家将 5 只同种动物合成为 1 只更大体型的动物。合成需要额外消耗 Cash（`profile.Data.Wins`），费用与材料价值和最终预览 Size 相关。

## 公式

```text
Value(i)      = GetFinalBuyCost(i)   -- BuyCost × Size × MutationPriceRate
materialSum   = Σ Value(input)       -- 基础值 = 全部材料价值总和
previewSize   = ComputePreviewSize(sizes)   -- 与 UI 预览一致，无随机
sizeMult      = (previewSize / DEFAULT_SIZE) ^ SIZE_EXP
cost          = RoundToFrontDigits(materialSum × sizeMult, 2)
```

## 配置

位于 `AnimalEnlargeConfig`（继承 `AnimalsSizeConfig`）：

| 常量 | 值 | 说明 |
|---|---|---|
| `DEFAULT_SIZE` | 1.0 | 抽卡 Size 下限 |
| `SIZE_EXP` | 2 | 相对默认尺寸的指数倍率 |
| `MERGE_AMOUNT` | 5 | 合成所需动物数量 |

## 计入 / 不计入

| 因素 | 是否进费用 |
|---|---|
| AnimalID / BuyCost | 是 |
| Size | 是（材料价值 + 预览 Size 指数） |
| Mutation | 是（经 `GetFinalBuyCost`） |
| Level | 否 |
| 实际合成随机浮动 | 否（按 preview 定价） |

未满 5 只：`cost = 0`，`PriceLabel` 隐藏。

## 扣费流程

1. 客户端 `UpdateMergeSlots` 调用 `ComputeMergeCost` 更新 `PriceLabel`
2. 玩家点击 Merge → 服务端 `EnlargeAnimals` 校验材料
3. 服务端重算 `cost`（不信任客户端）
4. `Wins < cost` → 拒绝，文案 `Constants.NOTIFICATION_NO_ENOUGH_WIN`
5. 够钱 → `AdjustWins(-cost)` → 删除材料 → 给予新动物

## 数值样例（Fox BuyCost=1000）

| 组合 | 材料总和 | Cash 费用 |
|---|---|---|
| 5× Size1 | 5000 | 7500 |
| 5× Size2 | 10000 | 60000 |
| 5× Size3 | 15000 | 200000 |
| 5× Size5 | 25000 | 940000 |
| Size3 + 4× Size1 | 7000 | 68000 |
| 5× Size1 全 Rainbow | 12500 | 18000 |

连续同 Size 合（Fox）：约 `7500 → 14000 → 26000 → 48000 → 90000 → 160000`。

## 实现位置

- `AnimalEnlargeConfig.lua` — 常量
- `AnimalEnlargeHelper.ComputeMergeCost` — 共享算价
- `AnimalService:EnlargeAnimals` — 服务端扣费
- `AnimalEnlargerGuiController:UpdateMergeSlots` — UI 展示

## 验证

- `selene` 静态检查
- Studio：满 5 只显示价格；Cash 不足拒绝且动物不丢；成功扣费并合成
