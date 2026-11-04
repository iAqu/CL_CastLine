# 展示鱼滴水

运行贴图仍为 `water-drop.png`：256×256 透明四帧图，资源 `rbxassetid://95576999146381`。原图、生成提示词、原参数快照与各尺寸兼容性记录保持不变。

## 表面发射点

全部 28 种鱼各有 24 个 FishDrip_* Attachment：16 个腹部点、8 个尾鳍点。游戏模板和 Workspace.Fish_Processed 均已安装，各含 672 个点。Elder Fish 保留已验证的原点位，横向覆盖约 2.54 studs，即鱼宽的 72%。

其他鱼使用自己的处理后网格与蒙皮权重：先按实际权重切分三角形表面，再从腹部的四个骨骼主导区域各选四点；尾部从末端骨骼权重至少 95% 的真实表面中分散选八点，尖尾也能获得不同位置。腹部主导权重至少 90%，当前数据最小为 92.1%。长尾鲨使用 TailExtra2；宽鳍鱼的主体采样遵循原宽鳍蒙皮权重。所有点沿表面法线外移 0.025 studs，UpVector 朝向表面外侧。

带高大背鳍的鱼，其完整 Size.Y 大于腹部和尾部的实际湿润区域，因此按各鱼自己的静止分布验证动画中的覆盖；不是按 Elder Fish 的尺寸复制点位。

`sample_surface.py` 只读取 Blender 模型并生成 `surface-points.json`，不保存模型。重建命令（项目根目录）：

```sh
/Applications/Blender.app/Contents/MacOS/Blender --background assets/fish/ElderFish/ElderFish.blend --python assets/vfx/fish-drip/sample_surface.py
```

Studio 中旧五个点保存在 `studio-assets.json` 记录的 ServerStorage.FishDripBackups 路径。未修改鱼网格、蒙皮、参考工程和动画。

### 全鱼种重建与安装

先生成或更新 `assets/fish/Processed/payload`，再从项目根目录执行：

```sh
/Applications/Blender.app/Contents/MacOS/Blender --factory-startup --background --threads 1 --python-exit-code 1 --python assets/vfx/fish-drip/sample_surface.py -- --all
python3 -m http.server 18773 --bind 127.0.0.1 --directory assets/fish/Processed
```

`--all` 读取 27 种鱼的处理后网格 payload，并复用 Elder 的 `surface-points.json`，生成 `assets/fish/Processed/drip-surface-points.json`，不保存 Blender 模型。新 payload 的 weightAnchors 由 build_fish.py 一并写出；现有旧 payload 使用与制作工具一致的权重锚点。

编辑模式执行 `install_all_drip_points.studio.lua` 返回的函数，会先校验目标工程、尺寸和骨骼，再完整备份两个模型目录并安装点位；同名点更新且去重，完整的 Elder 点位直接保留。当前备份为 `ServerStorage.FishDripBackups.BeforeAllFishDrip_20261104_074253`。新鱼的 publish_fish.studio.lua 会直接调用同一安装函数，install_templates.studio.lua 在替换游戏模板前检查全部连接点。

更新 RBXM 时，运行 `python3 assets/fish/Processed/export_receiver.py --replace-current`，再于编辑模式执行 `export_drip_models.studio.lua` 返回的函数。接收器先保留带 BeforeDrip 时间戳的旧文件，再原子更新两份当前模型；每份经 SerializationService 反序列化校验包含 28 条鱼、65 个网格、140 个动画和 672 个点。`assets/fish/Processed/drip-validation.json` 记录完整验证与导出哈希。

## 运行控制

FishDripEffect 由 FishingBiteSequence:Present 在本帧鱼姿态落定后更新，参数集中在 FishingConfig.Bite.Drip。内部构造函数支持可选随机数生成器以便重复测试，正常游戏使用独立 Random，不改变玩法随机数。

- 只在 Caught 创建粒子；24 个点各有常态和甩水两套发射器，共 48 个。全部 Enabled=false、Rate=0，通过 Emit 手动调度。
- 常态总量在前 4 秒从每秒 20 颗平滑降至 5 颗。使用速率的解析积分按绝对时间计算颗数，随机打乱全部点，每轮不重复，跨轮也不连续重复同一点。
- 长帧每帧最多发射 4 颗常态水滴，丢弃过期欠量，避免恢复后集中发射。
- 每次实际 ShowcaseFlop 在 0.10～0.25 秒窗口内，按 token 从 10 个不同表面点各发射一颗；错过窗口不补发。
- 常态保留原阻力 10、加速度 (0,-150,0)、生命周期及外观曲线，速度 0.2～0.6。
- 独立甩水层速度 10～16、阻力 2、加速度 (0,-60,0)、生命周期 0.45～0.65、散射角 70°，沿各点法线向外。共用原 256 图、大小/透明度/颜色/Squash 曲线、光照、旋转与 0.5 时间倍率。
- 离开展示清空两层，销毁时释放两层发射器，鱼模型销毁时释放全部表面点。

## 验证

本次本地 selene 使用缓存 Roblox API 标准库，检查结果为 0 错误、0 警告；8 组相关测试通过，覆盖 15/30/60/144 FPS 的相同总量、随机轮换、长帧限量、动画窗口去重和清理。

Studio 的新版 FishingDripEffect 与 FishingPresentation 测试通过：48 个发射器、24 个点；甩尾期间最小横向覆盖 71.2%；0.65/1/1.45 缩放与骨骼跟随误差均为 0；10 秒常态发射 80 颗，长帧最多 4 颗且无欠量堆积。

已用真实展示镜头和临时 2/4 studs 距离标记检查甩水，观察到水珠到达鱼身轮廓外约 2 studs 以上的位置，保留速度 10～16。已检查 iPhone 7 横屏 667×375、Level01 画质下的原生粒子。测试后恢复相机、景深、画质和默认设备视口，并清理全部预览及距离标记。模拟器检查不代表手机真机性能测试。

```sh
# CastLineRojo 目录
selene src/ReplicatedStorage/Modules/FishDripEffect.lua src/ReplicatedStorage/Modules/FishingConfig.lua tests/studio/FishingDripEffect.lua
python3 tools/run-tests.py FishDripEffect FishAnimationController FishingBiteSequence FishingReelSequence FishingCastLifecycle FishingInputGate FishingProjectileMath FishingTransition
```

Studio Client 执行 tests/studio/FishingDripEffect.lua 会逐一指定全部 28 种鱼，验证真实动画下的横向覆盖、表面法线、调度总量、骨骼/缩放跟随及清理，并恢复原随机选鱼设置。Edit/Server 执行 tests/studio/FishingDripAssets.lua 审计两个资源目录；修复前各 27 条失败，修复后全部通过。另已通过随机钓鱼 840 个状态采样点，以及普通鱼、宽鳍鱼、长尾鲨的实际展示镜头检查。VFX 模板和 Attachment 由 Studio 管理，需随开发工程保存。
