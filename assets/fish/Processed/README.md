# 28 条鱼成品与验证记录

已完成 28/28 条鱼，已安装到开发工程 `heixiaogu's Place: 10302026_1`（Place 84106335829275）。成品位于 `Workspace.Fish_Processed`，同名游戏模板已更新到 `ReplicatedStorage.Models.Fish`。原始 `Workspace.Fish` 保留，默认从 28 种鱼中等概率随机。

替换前完整备份：`ServerStorage.FishUpgradeBackups.BeforeTemplateInstall_20261104_065839`。最初备份：`ServerStorage.FishUpgradeBackups.BeforeProcessed_20261104_062102`。

## 本地交付

- `studio/Fish_Processed.rbxm`：完整成品文件夹，可通过 Studio 的 Insert from File 导入 Workspace。
- `studio/Fish_GameTemplates.rbxm`：完整游戏模板文件夹，目标位置为 ReplicatedStorage.Models.Fish。
- `studio/Fish_Templates_Before_20261104_062102.rbxm`：升级前的 28 条游戏模板。
- `studio/Fish_SourceOriginals.rbxm`：原 Workspace.Fish；`studio/Fish_AnimationSources.rbxm`：可编辑 KeyframeSequence。
- `models/<鱼名>/`：每条鱼一份 Blender 源文件、一份静态绑定 FBX、五份动作 FBX，共 28 个 .blend 和 168 个 .fbx。贴图使用相对路径。
- `source/AllFish.obj`、MTL 和原 PNG：用户从 Studio 原生导出的源文件。`source-manifest.json` 是处理前快照，不代表当前完成状态。
- `textures/`：逐像素调色结果及透明通道、分辨率、哈希验证。
- `studio-assets.json`：逐鱼网格、贴图、五个动画 ID、嘴部位置、眼睛倍率、骨骼数及备份地址。
- `validation.json`：最终验收汇总；其他 `*-validation.json` 保留详细测量。

RBXM 使用 Roblox [SerializationService](https://create.roblox.com/docs/reference/engine/classes/SerializationService) 导出并反序列化校验；成品 65 个网格资源、140 个动画引用和 359 个 Bone 实例均已回读。导出不会发布整个游戏的新版本。

## 制作约定

贴图使用 HSV 数值处理：`S += 0.35*S*(1-S)`，`V += 0.20*(V-0.5)*4*V*(1-V)`。色相、UV 色块布局、尺寸和 alpha 不变；高饱和区降低增幅，避免截断高光和暗部。纯色及 Neon 同样调色，原材质保留。大色板资源为 `127837620888950`，礁鱼/鲨鱼色板为 `107659492385621`。资源发布到 M101 Crew（598797612）。

普通鱼有五个有效关节：FishBody → SpineFront → SpineMid → TailBase → FishTail。ThresherShark 增加 TailExtra1/2；AngelShark、Tropical Butterfly 增加 FinLeft/Right。多部件鱼为保留不同材质，仍使用独立蒙皮 MeshPart；每个 MeshPart 具有同名骨骼副本，通过同一 Animator、同一时序动作驱动。下表“骨骼”指逻辑关节数，实例总数单独列出。

Elder Fish 复用已完成的两倍眼睛和五骨骼网格，未再次放大。其他鱼按 1.5 或 2 倍放大眼眶与瞳孔，双眼倍率一致。Jadefin 的刚性头部区域延长至体长前 31%，保证放大眼睛不参与颈部弯曲。27 条重建鱼的主体尺寸误差均小于 0.001 studs（原生 OBJ 导出精度）；UV 完全一致，眼部全部权重绑定 FishBody。

## 动作与运行接入

所有模型拥有 Animations 文件夹和 SwimLoop、StruggleLeft、StruggleRight、LiftFlop、ShowcaseFlop 五个动作。标准鱼共用 standard 动作，长尾与宽鳍采用适配动作，额外骨骼参与全部五个动作。Elder 保留原动作。

FishAnimationController 优先读取模型动作，缺少单个动作时回退公共库；仍由 Animator 播放。FishingBiteSequence 优先读取 PrimaryPart.MouthAttachment，旧模型继续使用比例配置。大型鱼的五动作网格范围写入 PresentationRadius；出水/展示镜头按视锥平面留出完整变形空间。

| 动作组 | SwimLoop | StruggleLeft | StruggleRight | LiftFlop | ShowcaseFlop |
|---|---|---|---|---|---|
| elder | 70913216656088 | 89750144915761 | 97164203030284 | 125603144317245 | 80610507328189 |
| standard | 80864845357658 | 97026641022678 | 132200893707806 | 95963478104076 | 118119646715033 |
| longtail | 118690432610237 | 89927017851760 | 103460252054379 | 94501805907925 | 104247802254247 |
| fins | 87262770878415 | 121166993085346 | 126567681691786 | 103559424196151 | 130514023815551 |

## 逐鱼验收

全部通过正面、侧面、斜视与实际挣扎网格形变检查；140 个动作检查加载、所有网格层同步、固定头部和循环接缝。Studio Client 共采样 4,480 次，覆盖进食、左右挣扎、出水、展示、材质恢复、鱼线和嘴部缩放。最大嘴部接触误差小于 0.000001 studs；修正后最大取景比例 0.911（1.0 为屏幕边界）。

| 鱼 | 眼睛直径 | 逻辑骨骼 | 网格数 | Bone 实例 | 动作组 | 验证 |
|---|---:|---:|---:|---:|---|---|
| AngelShark | 2× | 7 | 1 | 7 | fins | 通过 |
| Azure Sturgeon | 1.5× | 5 | 2 | 10 | standard | 通过 |
| AzureDamsel | 1.5× | 5 | 1 | 5 | standard | 通过 |
| BallinaAngelfish | 1.5× | 5 | 1 | 5 | standard | 通过 |
| Blue Moonfish | 2× | 5 | 4 | 20 | standard | 通过 |
| Chimera Perch | 2× | 5 | 1 | 5 | standard | 通过 |
| Clownfish | 1.5× | 5 | 1 | 5 | standard | 通过 |
| Elder Fish | 2× | 5 | 1 | 5 | elder | 通过 |
| Firetail Tilapia | 1.5× | 5 | 6 | 30 | standard | 通过 |
| FrenchAngelfish | 1.5× | 5 | 1 | 5 | standard | 通过 |
| Frosttail | 2× | 5 | 3 | 15 | standard | 通过 |
| Golden Carp | 2× | 5 | 1 | 5 | standard | 通过 |
| GreenbandedGoby | 2× | 5 | 1 | 5 | standard | 通过 |
| Inferno Pike | 2× | 5 | 2 | 10 | standard | 通过 |
| Jadefin | 1.5× | 5 | 4 | 20 | standard | 通过 |
| MoorishIdol | 1.5× | 5 | 1 | 5 | standard | 通过 |
| PrettyRoseGoby | 2× | 5 | 1 | 5 | standard | 通过 |
| Purplefin | 1.5× | 5 | 3 | 15 | standard | 通过 |
| QueenAngelfish | 2× | 5 | 1 | 5 | standard | 通过 |
| SaddleButterflyfish | 1.5× | 5 | 1 | 5 | standard | 通过 |
| Silver Tail | 2× | 5 | 1 | 5 | standard | 通过 |
| Stone Bass | 2× | 5 | 1 | 5 | standard | 通过 |
| ThresherShark | 2× | 7 | 1 | 7 | longtail | 通过 |
| Thunderfin | 2× | 5 | 4 | 20 | standard | 通过 |
| TomatoClownfish | 2× | 5 | 1 | 5 | standard | 通过 |
| Tropical Butterfly | 1.5× | 7 | 15 | 105 | fins | 通过 |
| Venomfish | 2× | 5 | 4 | 20 | standard | 通过 |
| YellowfinTuna | 2× | 5 | 1 | 5 | standard | 通过 |

## 验证与复现

- `geometry-validation.json`：UV、眼睛倍率、固定眼部权重、主体尺寸。
- `published-skin-validation.json`：65 个已发布网格回读，骨骼层级、绑定姿势、权重归一化和每个逻辑骨骼的有效权重。
- `studio-publication-audit.json`：发布记录与 140 个 Edit 模式 Animator 检查；其中保留 Jadefin 修正前资源 ID，最终使用 ID 以 studio-assets.json 为准。
- `gameplay-validation.json`：28 条鱼最终游戏流程检查。`gameplay-validation-before-camera-fix.json` 记录修正前五条大型鱼的裁切/边距问题，均已修复。
- `animation-bounds.json`：每条重建鱼 125 个实际蒙皮姿势的取景范围，额外保留 10% 插值余量。
- selene：三个涉及的运行模块和新增 Studio 测试均 0 error、0 warning；联网刷新 API dump 失败，使用本机缓存标准库。
- 本地四套测试 FishAnimationController、FishingBiteSequence、FishingCastLifecycle、FishingTransition 全部通过；git diff --check 通过。

制作顺序：inspect_source.py → build_fish.py → export_blender.py / export_elder.py（Blender 后台）→ measure_animation_bounds.py → build_fish.py（写入取景半径）→ make_sources_portable.py → Blender 后台运行 assets/vfx/fish-drip/sample_surface.py -- --all。发布工具会调用 install_drip_points.studio.lua，模板安装前会检查全部滴水点；仓库脚本只通过 Rojo 同步。

运行批量 Studio 测试前，将 geometry-qa.json 通过本机 HTTP 提供给 Server，分割成不超过 100,000 字节的 StringValue 放入 ReplicatedStorage._FishGeometryQA，并设置 ByteLength；在 Client 执行 CastLineRojo/tests/studio/FishingProcessedFish.lua。测试临时切换 Client 模板和 FishName，结束恢复；游戏默认从 28 种鱼中等概率随机。

本次没有覆盖既有未提交修改，也未提交 Git 或发布整个游戏。Studio 当前保留升级后的编辑状态，独立 RBXM 文件已经落盘，可用于恢复。

## 全鱼种展示滴水

已修复其余 27 种鱼缺少 FishDrip_* 连接点的问题。两个资源目录各有 28 条鱼、672 个点；Elder Fish 保留原点位。每条鱼均有 16 个腹部点和 8 个尾部点，沿真实表面法线外移 0.025 studs，并绑定主导蒙皮骨骼；长尾鲨尾部使用 TailExtra2。

- `drip-surface-points.json`：全部鱼的离线点位；`drip-validation.json`：修复前后审计、全鱼种发射、随机钓鱼回归及导出记录。
- `install_all_drip_points.studio.lua`：编辑模式备份两个资源目录并幂等安装；`export_drip_models.studio.lua`：导出并检查 28 条鱼、65 个网格、140 个动画和 672 个点。
- Studio Client 执行 `CastLineRojo/tests/studio/FishingDripEffect.lua` 遍历全部鱼，验证 48 个发射器、10 秒常态 80 颗、甩尾 10 颗、骨骼/缩放跟随和清理。Edit/Server 执行 `FishingDripAssets.lua` 审计两个资源目录。
- 滴水粒子模板与调度参数保持现状；已目视检查 Clownfish、AngelShark 和 ThresherShark。错误日志和缺失滴水点警告均为 0。
- 本次 Studio 备份：`ServerStorage.FishDripBackups.BeforeAllFishDrip_20261104_074253`。RBXM 导出前的文件副本见 `drip-validation.json` 的 previousFile。
