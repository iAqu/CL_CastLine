# 付费商品图标 v1

使用内置 imagegen 制作，统一导出为 1024×1024 透明 PNG。深蓝描边、简洁卡通造型和柔和高光；主体留有约 15% 透明安全边距。

| PurchaseId | 本地图标 | 内容 |
| --- | --- | --- |
| DoubleWins | `DoubleWins.png` | 绿色纸钞 Cash 束与 ×2 |
| DoubleTrain | `DoubleTrain.png` | 蓝橙色哑铃与 ×2 |
| MegaLuck | `MegaLuck.png` | 绿色四叶草与紫色星光 |
| PremiumBait | `PremiumBait.png` | 橙色彩虹鱼饵与鱼钩 |
| WinsTier1 | `WinsTier1.png` | 少量绿色纸钞 |
| WinsTier2 | `WinsTier2.png` | 装满绿色纸钞的钱袋 |
| WinsTier3 | `WinsTier3.png` | 装满绿色纸钞的宝箱 |

三个 Game Pass 的赠送商品复用对应基础图标，不单独制作赠送版本。

2026-11-17 用户改为重新生成三档 Cash 包图标；七项商品均已上传新图标。以下是 Google Sheet 当前回填的自购、赠送和图标 ID：

| PurchaseId | ProductId | GiftProductId | IconId |
| --- | --- | --- | --- |
| DoubleWins | 2093792687 | 3732742706 | `rbxassetid://126148300454717` |
| DoubleTrain | 2092694679 | 3732742733 | `rbxassetid://88235559897835` |
| MegaLuck | 2092652693 | 3732742767 | `rbxassetid://126653733934648` |
| WinsTier1 | 3732742786 | 3732742786 | `rbxassetid://122785842415419` |
| WinsTier2 | 3732742806 | 3732742806 | `rbxassetid://82231269286791` |
| WinsTier3 | 3732742828 | 3732742828 | `rbxassetid://131806921692920` |
| PremiumBait | 3732742846 | 3732742846 | `rbxassetid://97716120013119` |

已通过 Studio MCP 在 Pull Up a Fish（Universe ID 10777315397，Place ID 105988300474595）创建并上架 3 个 Game Pass、7 个 Developer Product；价格按表格配置，关闭区域定价和自动价格优化。赠送商品使用相同本地图片单独上传，其平台图标 ID 记录在 `roblox-assets.json`。

`PurchaseData!H4:J10` 已完成回填并回读核对；其他值、格式和数据验证规则保持不变。未导入仓库 Data 或 Studio Data，未修改购买功能代码，未保存或发布 Studio 工程。

`prompts.json` 记录最终生成提示词、风格参考及生成源文件。图片内容由 imagegen 生成；交付导出仅使用 macOS sips 调整尺寸和透明留白。`upload/` 为 512×512 平台上传版本；同名顶层文件为 1024×1024 原始交付版本。`roblox-assets.json` 记录所有平台商品、图标及回读结果。
