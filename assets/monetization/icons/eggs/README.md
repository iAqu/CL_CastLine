# COSMIC CHAOS EGG 付费商品

原图资源：`rbxassetid://131317608690788`，M101 Crew 所有。通过 Studio AssetService 只读提取像素并恢复为 `CosmicChaosEgg.png`（1024×1024 RGBA）；没有重绘或修改场景。

三个商品使用同一张图片，512×512 上传版位于 `../v1/upload/CosmicChaosEgg.png`。

| PurchaseId | 数量 | Robux | ProductId / GiftProductId | 平台商品图标 ID |
| --- | --- | --- | --- | --- |
| Egg_R_1 | 1 | 79 | 3732759360 | 81605708402080 |
| Egg_R_1x3 | 3 | 199 | 3732759375 | 77557054442279 |
| Egg_R_1x10 | 10 | 649 | 3732759388 | 101745587279977 |

已通过 MCP 在 Pull Up a Fish（Universe ID 10777315397，Place ID 105988300474595）创建并上架三个 Developer Product；区域定价和自动价格优化关闭。三个平台图标均由同一个文件上传；表格的三个 IconId 统一保留用户指定的 `rbxassetid://131317608690788`。

`PurchaseData!H11:J13` 已回填并回读一致，其他内容和格式未改。随后仅导出 `PurchaseData.lua`，selene 为 0 错误、0 警告；`sheet-sync.json` 原有完整页签配置保持不变。

通过共享锁在 Edit 模式同步至 #CL_DEV（Place ID 84106335829275）的 `ReplicatedFirst.Data.PurchaseData`。已执行 preflight、apply、verify，最终模块 Source 与仓库源码逐字一致；Data 的 Rojo 排除配置保持不变。未修改 DataHelpers 或发蛋逻辑，未运行测试、保存或发布工程。

`before-create.json` 保存创建前快照；`created-products.json` 保存平台创建结果；`verification.json` 保存表格回读和 Studio 三阶段同步结果。
