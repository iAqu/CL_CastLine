"""Assemble the verified delivery from Studio and source validation receipts."""
from collections import Counter
import csv
import json
from pathlib import Path
import statistics

ROOT=Path(__file__).resolve().parent

def read(path):
    return json.loads((ROOT/path).read_text())

inventory=read('inventory.json')
audit=read('audit-all.json')
gameplay=read('gameplay-validation.json')
regression=read('regression-validation.json')
installation=read('installation.json')
curves=read('curve-validation.json')
assert installation['complete'] and installation['installed']==112
assert audit['done'] and not audit['errors'] and len(audit['results'])==112
assert gameplay['done'] and len(gameplay['results'])==112 and not gameplay['errors']
assert all(x['passed'] and x['framingPassed'] for x in gameplay['results'])
assert regression['done'] and regression['random']['templates']==112 and regression['drip']['fish']==112
assert curves['passed'] and len(read('blender-readback.json')['fish'])==112
assert read('surface-installation.json')['points']==112*24
game={x['name']:x for x in gameplay['results']}
drip={x['name']:x for x in regression['drip']['results']}
cache=read('asset-cache.json')
lift_capacity=read('lift-range-capacity.json')
rows=[]
clips=['SwimLoop','StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop']
for e in inventory['rows']:
    name,key=e['name'],e['key']
    rig=read(f'payload/{key}/rig.json')
    measured=read(f'bounds/{key}.json')
    row={
        'name':name,'key':key,'family':e['family'],'oldBones':e['bones'],'logicalBones':len(rig['bones']),
        'boneInstances':audit['results'][name]['boneInstances'],'meshParts':len(rig['parts']),
        'variant':rig['variant'],'eyeScale':e['attributes'].get('EyeDiameterScale'),
        'meshIds':[{'part':p['name'],'previous':p['mesh'],'rigV2':cache[p['recipe']]} for p in rig['parts']],
        'animationIds':{c:audit['results'][name]['clips'][c]['id'] for c in clips},
        'sourceAnimationIds':rig['sourceClips'],'poseValidation':audit['results'][name],
        'motionMeasurement':measured,'liftRangeCapacity':lift_capacity[name],'gameplay':game[name],'drip':drip[name],
    }
    rows.append(row)
blends=list((ROOT/'models').glob('*/*.blend'))
fbx=list((ROOT/'models').glob('*/*.fbx'))
assert len(blends)==112 and len(fbx)==672
for p in fbx:
    with p.open('rb') as f:assert f.read(18).startswith(b'Kaydara FBX Binary'),p
assert all(p.stat().st_size>1000 for p in blends)
logical=Counter(x['logicalBones'] for x in rows)
ratios={c:statistics.median(r['motionMeasurement']['tailRatios'][c] for r in rows
                          if r['motionMeasurement']['before'][c]['tailExcursion']>.05) for c in clips}
result={
    'complete':True,'fish':rows,'templates':112,'meshParts':sum(x['meshParts'] for x in rows),
    'logicalBones':sum(x['logicalBones'] for x in rows),'boneInstances':sum(x['boneInstances'] for x in rows),
    'liftTargetBeyondFixedHeadReach':sum(x['targetExceedsFixedHeadBound'] for x in lift_capacity.values()),
    'animationsPlayed':sum(len(x['animationIds']) for x in rows),'animationVariants':len(curves['variants']),
    'blenderFiles':len(blends),'fbxFiles':len(fbx),'medianTailExcursionRatios':ratios,
    'gameplaySamples':sum(x['samples'] for x in gameplay['results']),'installation':installation,
    'maxFramingRatio':max(x['maxFramingRatio'] for x in gameplay['results']),
    'maxDripSurfaceError':max(x['maxSurfaceError'] for x in drip.values()),
    'random':regression['random'],'dripFish':regression['drip']['fish'],
}
(ROOT/'validation-manifest.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
with (ROOT/'fish-index.csv').open('w',encoding='utf-8-sig',newline='') as f:
    out=csv.writer(f)
    out.writerow(['鱼名','类型','原逻辑骨骼','新逻辑骨骼','实际 Bone 实例','网格数','动作组',
                  '游动尾端摆幅倍率','左挣扎','右挣扎','出水','展示','展示取景最大比例'])
    for row in rows:
        out.writerow([row['name'],row['family'],row['oldBones'],row['logicalBones'],row['boneInstances'],
                      row['meshParts'],row['variant'],*[round(row['motionMeasurement']['tailRatios'][c],3) for c in clips],
                      round(row['gameplay']['maxFramingRatio'],4)])
ratio_text='、'.join(f"{label} {ratios[key]:.2f}×" for key,label in
                     zip(clips,['游动','左挣扎','右挣扎','出水','展示']))
lines=[
    '# CastLine 鱼模型 Rig V2',
    '',
    '112 种已升级，保留现有名称、外观、尺寸和随机池。Studio 成品位于 `Workspace.Fish_Processed`，游戏模板位于 `ReplicatedStorage.Models.Fish`。每条鱼的五个动作在自己的 `Animations` 下。',
    '',
    f"{logical[10]} 种使用 10 根骨骼、{logical[14]} 种使用 14 根、{logical[16]} 种使用 16 根。{result['meshParts']} 个网格共 {result['boneInstances']} 个 Bone 实例，所有逻辑骨骼均有有效权重。",
    '',
    '## 动作和幅度',
    '',
    '身体和尾部使用连续传播的弯曲，尾鳍另有滞后与回弹。鲸鱼、海豚以上下摆尾为主。鳐鱼、海龟和触须类使用各自的附肢动作。头眼、嘴部和龟壳保持刚性。各材质层接缝采用相同权重，滴水点按网格混合权重跟随表面。',
    '',
    f'去除鱼身整体移动后，对同一批尾部顶点测量峰间位移。新版相对旧版的中位数为{ratio_text}。出水动作旧版已有较大弯曲，保持头部固定并限制过度折叠后，实测位移增幅低于 2.5–3 倍目标。固定头、保持骨长时，77 种鱼的理论可达范围小于原位移的 2.5 倍。逐鱼数据见 fish-index.csv 和 lift-range-capacity.json。',
    '',
    '五个动作保留原时长，以 120 Hz 烘焙。挣扎视觉周期为 0.45 秒。展示甩尾间隔复用 SwimLoop（0.35 倍速度、0.25 权重）。滴水只在展示阶段产生，甩尾水珠随 ShowcaseFlop 触发。',
    '',
    '## 文件',
    '',
    '- models/：每鱼一份 Blender、绑定 FBX 和五份动作 FBX，贴图保留。共 112 个 Blender 和 672 个 FBX。',
    '- studio/ 保存升级前的成品、模板、动作源和动作引用备份，以及升级后的 112 鱼成品、模板与可编辑动作源。所有文件均通过回读。',
    '- validation-manifest.json：旧/新网格与动作 ID、逻辑骨骼和 Bone 实例数、权重、帧采样、接线、取景与滴水结果。',
    '- source/、payload/、motions/、textures/：当前游戏网格读回、制作权重、120 Hz 动作配方、31 张无损贴图。',
    '- previews/ElderFish-motion-before-after.mp4：Elder Fish 五个原始动作片段同角度对照，左侧旧版、右侧 Rig V2。',
    '',
    f"Studio 制作前备份位于 `{inventory['backup']}`。资源发布所有者为 M101 Crew，仓库代码通过 Rojo 同步。",
    '',
    '## 验证',
    '',
    f"- 实际加载并播放 {result['animationsPlayed']} 个模型动作，检查 30/60 FPS 采样、材质层同步、循环首尾、固定头部和实际顶点位移。",
    f"- 112 种鱼的进食、左右挣扎、出水、展示、接嘴和取景共 {result['gameplaySamples']} 个流程采样，变形顶点最大到达画框边界的 {result['maxFramingRatio']:.1%}。",
    f"- 逐鱼检查 24 个滴水点的发射时机、缩放、骨骼随动和清理。实测随动位置误差最大 {result['maxDripSurfaceError']:.4f} studs。",
    '- 随机池仍为 112 种，逐鱼指定及随机抽取验证单轮鱼种不变。',
    '- selene 静态检查和滴水、动画、进食、生命周期、阶段切换的 5 个本地测试通过。Studio 成品及备份 RBXM 已回读。',
]
(ROOT/'README.md').write_text('\n'.join(lines)+'\n')
print('Complete: 112 Rig V2 fish, 560 playback checks, validated archives')
