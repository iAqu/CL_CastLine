# 付费商品图标 v2

七张原图按可见主体边界裁去透明空白，再等比放大、居中。主体长边约占画布 96%，保留原有画风、文字、透明背景和完整主体；没有重新绘制。短边方向的透明边距随主体比例保留。

- 本目录 PNG：1024×1024，长边两端约 20px 边距。
- 平台上传版：`../v1/upload/<PurchaseId>-v2.png`，512×512，长边两端约 10px 边距。
- v1 图片和原上传版本保持不变。

通过 Studio MCP 的 PATCH 接口更新 Pull Up a Fish（Universe ID 10777315397，Place ID 105988300474595）的 3 个 Game Pass 和 7 个开发者商品。只提交 imageFile；已逐项回读确认商品 ID、名称、说明、价格、上架状态和定价配置均未改变。

| PurchaseId | 新 IconId |
| --- | --- |
| DoubleWins | `rbxassetid://138623259278633` |
| DoubleTrain | `rbxassetid://79384382232892` |
| MegaLuck | `rbxassetid://112313109810427` |
| WinsTier1 | `rbxassetid://131898173375499` |
| WinsTier2 | `rbxassetid://114996568546760` |
| WinsTier3 | `rbxassetid://97713154008181` |
| PremiumBait | `rbxassetid://132669232893917` |

三个赠送商品使用对应基础图标的相同图片，其独立平台图标 ID 记录在 `roblox-assets.json`。

Google Sheet `PurchaseData!J4:J10` 已回填并回读一致；其他值、格式和数据验证规则保持不变。未导入仓库或 Studio 游戏数据，未修改购买功能代码，未保存或发布工程。

`export.py` 使用标准库读取 PNG 透明边界，并调用 macOS sips 做确定性裁切、缩放和透明画布导出。原始生成图片含散落的极低透明度像素，裁切依据为 alpha > 8 的可见主体边界，并额外保留 2px 抗锯齿边沿。`verification.json` 记录原图、新图及上传版的尺寸、透明通道和主体边界。

`sources/` 保存用于裁边导出的原始生成图片，导出流程不依赖 Codex 缓存目录。`before-update.json` 保存更新前平台和表格快照；`update-journal.json` 保存十次 PATCH 结果；`roblox-assets.json` 保存最新商品及图标映射。

十个新图标的平台预览均已完成生成，结果记录在 `thumbnail-verification.json`。
