"""Write delivery records only after every admission check has passed."""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def read(name):
    return json.loads((ROOT / name).read_text())


build = read('build-validation.json')
assets = read('studio-assets.json')
gameplay = read('gameplay-validation.json')
regression = read('regression-validation.json')
published = read('asset-validation.json')
installation = read('installation.json')
preservation = read('preservation-validation.json')
visual = read('visual-validation.json')
assert installation['complete'] and preservation['passed'] and visual['passed']
assert published['done'] and published['count'] == len(build) and not published['errors']
assert gameplay['done'] and len(gameplay['results']) == installation['templates'] and not gameplay['errors']
assert all(x['passed'] and x['framingPassed'] for x in gameplay['results'])
assert regression['done'] and regression['random']['passed'] and regression['drip']['passed']
assert regression['legacyMouthFallback']['passed']
assert len(list((ROOT / 'models').glob('*/*.blend'))) == len(build)
assert len(list((ROOT / 'models').glob('*/*.fbx'))) == len(build) * 6
assert all(x['roundTripPassed'] for x in assets['exports'])
by_name = {x['name']: x for x in assets['fish']}
game_by_name = {x['name']: x for x in gameplay['results']}
rows = []
for spec in build:
    row = by_name[spec['name']]
    row.update(eye=spec['eye'], sourceValidation=spec['validation'],
               gameplay=game_by_name[spec['name']],
               publishedValidation=published['results'][spec['name']],
               complete=True)
    rows.append(row)
archives = []
for path in sorted((ROOT / 'studio').glob('*.rbxm')):
    archives.append(dict(file=str(path.relative_to(ROOT)), bytes=path.stat().st_size,
                         sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
report = dict(complete=True, newFish=len(rows), totalFish=installation['templates'],
              groupId=598797612, placeId=84106335829275,
              newMeshParts=sum(len(x['parts']) for x in rows),
              newBoneInstances=sum(x['boneInstances'] for x in rows),
              newLogicalBones=sum(x['logicalBones'] for x in rows),
              newAnimationInstances=len(rows)*5, uniqueNewAnimationAssets=35,
              gameplaySamples=sum(x['samples'] for x in gameplay['results']),
              random=regression['random'], dripFish=regression['drip']['fish'],
              incomplete=[], archives=archives, fish=rows,
              installation=installation, staticChecks=read('static-validation.json'))
(ROOT / 'validation-manifest.json').write_text(json.dumps(report, ensure_ascii=False, indent=2))
lines = [
    '# Race 新增鱼成品与验证记录', '',
    f"完成 {len(rows)}/{len(rows)} 条新鱼；两个成品目录均为 {report['totalFish']} 种鱼，继续等概率随机钓鱼。原始 `Workspace[\"race的鱼\"]` 及原有 28 条资源已与制作前备份比对，保持不变。", '',
    '- Studio 成品：`Workspace.Fish_Processed`。',
    '- 游戏模板及每鱼动作：`ReplicatedStorage.Models.Fish.<鱼名>.Animations`。',
    '- 五个动作：`SwimLoop`、`StruggleLeft`、`StruggleRight`、`LiftFlop`、`ShowcaseFlop`。',
    '- 共用适配资源：`ReplicatedStorage.Animation.Fishing.RaceVariants.race_<类型>`；7 组、35 个资源 ID，为 25 条鱼提供 125 个 Animation 实例。',
    '- 可编辑关键帧：`ServerStorage.FishAnimationSources.Race`。',
    '- 调用：`FishingBiteSequence` 创建 `FishAnimationController`，优先读取每鱼 `Animations`，通过 `Animator:LoadAnimation()`、`AnimationTrack:Play()` 播放。', '',
    '## 交付文件', '',
    '- `studio/Race_Processed_25.rbxm`：仅本批 25 条成品，可直接恢复到 Studio。',
    '- `studio/Fish_Processed_53.rbxm`、`studio/Fish_GameTemplates_53.rbxm`：完整 53 条成品及游戏模板。',
    '- `studio/Race_AnimationSources.rbxm`：7 组可编辑动作。',
    '- `studio/RaceOriginals.rbxm`、`ProcessedBefore.rbxm`、`TemplatesBefore.rbxm`：制作前完整备份。',
    '- `models/<鱼名>/`：每鱼一个 Blender、一份绑定 FBX、五份动作 FBX，共 25 个 `.blend`、150 个 `.fbx`。',
    '- `source/`：原生 OBJ、MTL、贴图、拆分数据；`source-manifest.json` 保存原尺寸、实例层级、材质、颜色和旧骨架。',
    '- `payload/`、`motions/`：可重现网格、蒙皮及动作参数；`studio-assets.json`、`validation-manifest.json`：全部最终资源 ID 与逐鱼验收记录。', '',
    '## 外观与骨架', '',
    '保留当前实际尺寸，统一头朝局部 -Z。贴图复用已逐像素调色的同一 UV 色板（资源 127837620888950）；保持 UV、色相和透明通道。纯色、Neon 使用 HSV 数值增强，保留材质、透明度和花纹。饱和度以 `S + 0.35*S*(1-S)`、亮度对比度以 `V + 0.20*(V-0.5)*4*V*(1-V)` 校正，避免截断高光和暗部。', '',
    '普通五骨骼链为 `FishBody → SpineFront → SpineMid → TailBase → FishTail`。每个材质层都有同名骨骼副本，同一 Animator 同步；头眼固定。鳐鱼和特殊鱼另有左右鳍，海龟增加前后鳍、壳层全权重绑定刚性 SpineMid，海鳗增加三段尾，鱿鱼增加三组触须。', '',
    '海豚游动采用上下摆尾。五个动作保留 Elder 的时长、循环和节奏，按七类体形调整弯曲与附肢延迟；最大覆盖 23 个网格根节点。每鱼均有 MouthAttachment、实测动画范围 PresentationRadius、完整 FishBodySize 和 24 个骨骼表面滴水点。', '',
    '修复两处源网格问题：YaoYu_04_00 原本只有一侧眼睛，成品在同一网格补齐镜像眼；YouYu_02_00 两个零厚度发光平面补回 0.001 stud 包络，最大位置改动 0.0005 stud，以避免发布后的零 MeshSize。源模型均未修改。', '',
    '| 鱼名 | 眼睛直径倍率 | 逻辑骨骼 | 网格层 | Bone 实例 | 五动作及流程 |',
    '|---|---:|---:|---:|---:|---|',
]
for x in rows:
    lines.append(f"| {x['name']} | {x['eyeScale']:g}× | {x['logicalBones']} | {len(x['parts'])} | {x['boneInstances']} | 通过 |")
lines += ['', '## 验证', '',
    f"- 新增 {report['newMeshParts']} 个已发布蒙皮网格逐一回读；检查骨骼层级、实际绑定位置、有效权重、归一化及龟壳刚性。共 {report['newBoneInstances']} 个 Bone 实例。",
    '- 25 条逐鱼正面、侧面、斜视及实际形变检查；Studio 蓝色骨骼显示标记不是模型几何。',
    '- 125 个新增动作逐鱼播放，检查所有材质层、额外骨骼、固定头眼、循环接缝和停止清理。',
    f"- 全部 53 种鱼经过进食、左右挣扎、出水、展示、嘴部接线、外观恢复和真实蒙皮顶点镜头检查，共 {report['gameplaySamples']} 个流程采样。",
    '- 全部 53 种鱼滴水回归通过：每鱼 24 点，检查骨骼随动、缩放、覆盖、发射时序与清理。随机回归逐一指定 53 种并额外抽取 12 轮，确认单轮身份固定及随机流兼容。',
    '- 海豚展示会把局部 Y 轴转到屏幕横向；首次回归发现仅采样腹部底边会过窄，已把四条海豚的腹部点扩展到下半身两侧表面，保留真实表面法线与骨骼绑定。旧失败记录另存 regression-validation-before-drip-spread.json，最终完整回归通过。',
    '- 旧模型嘴部比例回退检查通过。RBXM 序列化回读保留网格、贴图、动画 ID、骨骼数及滴水点。',
    '- selene：0 错误、0 警告；网络未取得新 API dump，使用本机缓存。动画、进食、钓鱼生命周期、阶段切换 4 项本地测试全部通过。',
    '- 发布期间的 HTTP 429 已通过限速、退避和逐部件缓存续传解决。早期 mesh-publication/turtle-correction 等记录保留为历史；最终状态以 studio-assets、asset-validation、validation-manifest 为准。', '',
    '## 复查与恢复', '',
    f"Studio 初始备份为 `ServerStorage.FishUpgradeBackups.BeforeRace_20261104_095404`；合并前再次备份到 `{installation['backup']}`。RBXM 的 SHA256 见 validation-manifest。", '',
    '运行测试时先通过 prepare_gameplay_qa.studio.lua 准备分块几何数据，再在 Play Client 执行 CastLineRojo/tests/studio/FishingProcessedFish.lua。测试临时切换模板和 FishName，结束恢复。仓库脚本只由 Rojo 同步。', '',
    '制作工具按清单或目录实际数量验收。旧批滴水安装器可通过 additionalDataUrls 传入本批 drip-surface-points.json，合并两批点位。',
]
(ROOT / 'README.md').write_text('\n'.join(lines) + '\n')
print(f"Delivered {len(rows)} new fish / {report['totalFish']} total; complete manifest and README written")
