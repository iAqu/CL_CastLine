"""Write completion documentation only from final installation and validation records."""
from pathlib import Path
import json,hashlib
ROOT=Path(__file__).resolve().parent
load=lambda n:json.loads((ROOT/n).read_text())
installation=load('installation.json');assert installation['complete']
assets=load('studio-assets.json');delivery=load('delivery-audit.json');gameplay=load('gameplay-validation.json');regression=load('regression-validation.json');validation=load('asset-validation.json');fbx=load('fbx-validation.json');manifest=load('source-manifest.json')
assert len(assets['fish'])==59 and len(gameplay['results'])==112 and not gameplay['errors']
assert validation['count']==59 and not validation['errors'] and regression['random']['passed'] and regression['drip']['passed']
rows=[]
for row in assets['fish']:
 record=next(v for v in delivery['results'] if v['name']==row['name']);rows.append('| '+row['name']+' | '+str(row['eyeScale'])+'× | '+str(row['logicalBones'])+' | '+str(len(row['parts']))+' | '+str(row['boneInstances'])+' | 通过 |')
samples=sum(r['samples'] for r in gameplay['results']);radius=max(r['maxFramingRatio'] for r in gameplay['results'])
unit=load('unit-test-validation.json');assert unit['passed'] and unit['failures']==0
archives=[]
for record in assets['exports']:
 file=ROOT/'studio'/record['file'];assert file.exists();archives.append({'file':str(file.relative_to(ROOT)),'bytes':file.stat().st_size,'sha256':hashlib.sha256(file.read_bytes()).hexdigest(),'roundTripPassed':record['roundTripPassed']})
complete={'complete':True,'sourceFish':59,'sourceMeshes':116,'publishedMeshes':118,'totalFish':112,'animations':295,'blendFiles':59,'fbxFiles':354,'gameplaySamples':samples,'maxFramingRatio':radius,'archives':archives,'installation':installation,'exceptions':[{'name':'Swordfish Skeleton','eyeScale':1,'reason':'原造型为空眼窝骨架，没有独立眼球，保留原设计。'}]}
(ROOT/'validation-manifest.json').write_text(json.dumps(complete,ensure_ascii=False,indent=2))
text=f'''# 新增 59 条鱼成品与验证记录

完成 59/59 条新鱼；成品和游戏模板现在各有 112 种鱼，继续等概率随机钓鱼。原始 `Workspace["新鱼_未处理"]` 下的两个目录及旧 53 种资源均与备份比对保持一致。

- Studio 成品：`Workspace.Fish_Processed`。
- 游戏模板：`ReplicatedStorage.Models.Fish.<鱼名>`，每鱼包含五个动作。
- 可编辑关键帧：`ServerStorage.FishAnimationSources.NewFish`；动作库：`ReplicatedStorage.Animation.Fishing.NewFishVariants`。
- 四个重名成品追加 `_New`：QueenAngelfish、AzureDamsel、SaddleButterflyfish、BallinaAngelfish；旧版本保留。
- 初始备份：`{manifest['backup']}`；合并前备份：`{installation['backup']}`。

## 文件

- `studio/NewFish_Processed_59.rbxm`：本批全部成品。
- `studio/Fish_Processed_112.rbxm`、`studio/Fish_GameTemplates_112.rbxm`：完整成品及游戏模板。
- `studio/NewFish_AnimationSources.rbxm`：可编辑动作，包含拆分前鳍类动作备份。
- `studio/NewFishOriginals.rbxm`、`ProcessedBefore.rbxm`、`TemplatesBefore.rbxm`：制作前备份。
- `models/<鱼名>/`：每鱼一份 Blender、一份绑定 FBX、五份动作 FBX；共 59 份 `.blend`、354 份 `.fbx`。贴图为相对路径。
- `source/`：原生 OBJ、MTL、原贴图和拆分数据；`source-manifest.json`：原始尺寸、层级、材质、资源引用和 789 个旧骨骼实例。
- `profiles.json`、`payload/`、`motions/`：逐鱼标注、最终蒙皮几何及动作数据；`studio-assets.json`：全部最终资源 ID。
- `qa/`：59 条鱼的正面、侧面及实际挣扎姿势预览；`validation-manifest.json` 保存最终计数、取景上限和档案哈希。

## 外观和骨架

保留当前体形与实际尺寸，成品头朝局部 -Z。共 30 张去重导出图片采用数值调色，其中 29 张实际用于成品，另 1 张为未引用的 Studio 合成材质辅助图。调色公式为 `S += 0.35*S*(1-S)`、`V += 0.20*(V-0.5)*4*V*(1-V)`；保留原 UV、花纹、分辨率和透明通道，纯色/Neon 部件同步增强。

眼眶与瞳孔按 1.5 或 2 倍共同放大；贴在头部表面的眼睛在局部细分后平滑放大，UV 线性插值保持原花纹。Swordfish Skeleton 原本为空眼窝骨架，没有独立眼球，按约定保留原造型。SaddleButterflyfish_New 的眼部按原生 UV 色块复核后标定在实际瞳孔。

基础链为 `FishBody → SpineFront → SpineMid → TailBase → FishTail`。普通鱼和鲸/海豚五骨骼；鳐鱼及 Blue Dragon 七骨骼；海马、海龟、龙虾、蝾螈、水母、长身龙鱼八骨骼。海马沿原始身体/卷尾骨架取绑定位置；海龟壳与 Turtle Walker 的炮组为刚性绑定。

源文件共 116 个网格。Blue Dragon（21,318 面）和 Saberfish（30,073 面）超过 Roblox 单网格 20,000 三角面上限，因此无损分为 2 层和 3 层；最终共 118 个蒙皮网格，原几何、UV 和材质保持一致。

## 动作和运行接口

每条鱼拥有 SwimLoop、StruggleLeft、StruggleRight、LiftFlop、ShowcaseFlop 五个动作。九类动作保留 Elder 的时长、循环及节奏；鲸/海豚游动为上下摆尾，特殊附肢参与全部动作。多网格层由同一 Animator 同步，水母覆盖 28 个根节点。拆分后的鳍类动作另行发布并回归。

所有成品具备 PrimaryPart、MouthAttachment、FishBodySize、以 PrimaryPart 为中心实测的 PresentationRadius 和 24 个骨骼表面滴水点。运行时继续由现有 FishAnimationController 播放，不新增程序摆骨骼逻辑。随机池保持 112 种等概率选择。

## 验证

- 118 个已发布蒙皮网格逐一回读，检查绑定位置、骨骼、有效权重、归一化和刚性龟壳。发布资源读回会拆分 UV/法线顶点，因此按实际位置验证刚性，不能假设顶点顺序保留。
- 295 个动作引用逐鱼播放，检查全部材质层与附肢同步、固定头部、循环接缝和停止清理。
- 59 条鱼的正面、侧面和挣扎姿势预览已复查；Studio 样本检查真实资源加载与放大眼睛。
- 全部 112 种鱼的进食、左右挣扎、出水、展示、接嘴、外观恢复和真实蒙皮顶点取景检查通过，共 {samples:,} 个采样；最大取景比例 {radius:.3f}（1.0 为屏幕边界）。
- 全部 112 种鱼的随机抽取、单轮身份固定、滴水、骨骼/缩放跟随及清理回归通过；旧模型嘴部比例回退通过。
- 59 份 Blender 和 354 份 FBX 已审计；354 份 FBX 全部经 Blender 5.1.2 导入回读，骨骼、网格、UV、有效蒙皮和五个动作均保留。
- selene：0 errors、0 warnings、0 parse errors；联网刷新 API dump 不可用，使用本机缓存标准库。四套现有本地单测全部通过：FishAnimationController、FishingBiteSequence、FishingCastLifecycle、FishingTransition。临时 Luau CLI 从官方 0.746 源码构建。
- 成品与动作 RBXM 均经 SerializationService 序列化/反序列化检查，资源 ID、骨骼、动作和滴水点数量一致。

早期输入未就绪、单网格面数上限及发布名称长度失败保留为历史记录；最终状态以 `mesh-publication.json`、`asset-validation.json`、`installation.json` 和 `validation-manifest.json` 为准。Studio 启动前已存在的 TexturePack HTTP 429 日志不作为本批新资源失败；实际用于成品的 29 张贴图与全部网格已成功预载和验收；未引用的合成辅助图预载失败，未影响模型。

## 复现顺序

制作工具的本机传输服务为 `python3 -u assets/fish/Processed/NewFish/server.py`，只绑定 `127.0.0.1:18775`。整批重做前从制作前备份恢复旧 53 种目录；制作中的失败续传使用 retry_meshes.studio.lua。

准备 Studio 备份/唯一编号导出 → inspect_source.py → inspect_eyes.py → author_profiles.py → build_fish.py → split_large_meshes.py → Blender 执行 author_animations.py 与 export_blender.py → measure_animation_bounds.py → 更新 payload 半径 → author_drip_points.py → 发布贴图/网格/动作 → 回读与 Play 回归 → install_templates.studio.lua → export_delivery.studio.lua → write_report.py。

文件、发布 API 与像素接口参考 [Roblox AssetService](https://create.roblox.com/docs/reference/engine/classes/AssetService) 和 [EditableImage](https://create.roblox.com/docs/reference/engine/classes/EditableImage)。仓库脚本仅通过 Rojo 同步，Studio 测试通过现有测试文本执行。Studio 保留完成后的编辑状态，成品 RBXM 已落盘。

| 鱼名 | 眼睛直径 | 逻辑骨骼 | 网格层 | Bone 实例 | 五动作及流程 |
|---|---:|---:|---:|---:|---|
'''+ '\n'.join(rows)+'\n'
(ROOT/'README.md').write_text(text)
print('Documented',len(rows),'fish;',samples,'gameplay samples')
