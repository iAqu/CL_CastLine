# Elder Fish 五骨骼关键帧动画

原始模型来自 `/Users/gx/Downloads/fish`，原文件未修改。当前版本将左右眼眶及瞳孔直径放大至 2 倍；保持原贴图、身体尺寸、鱼嘴位置、头朝 Roblox -Z、PrimaryPart 实例及 CameraPart。

`eye_geometry.py` 只修改原 OBJ 的四个眼部几何岛，眼眶与瞳孔以同一眼睛中心放大，并沿侧面向外约 0.016～0.017 studs 以避免与头部穿插。`build_rig.py` 重建时会自动保留此造型。`eyes2x/validation.json` 记录 69 个源眼部顶点的前后坐标及直径验证；骨骼、权重、UV 和包围盒均未改变。Studio 应用时保留现有 Bone 实例，继续使用原五个已发布动画。

放大前的 Blender 源文件为 `eyes2x/ElderFish_before.blend`，Studio 模板备份见 `studio-assets.json` 中的 `eyeScaleBackup`。`eyes2x/publish.studio.lua` 是一次性编辑模式资源发布工具，不是运行脚本。

骨骼链：`FishBody → SpineFront → SpineMid → TailBase → FishTail`。头部前 25% 完全固定，其余顶点在相邻骨骼之间平滑混合；每个顶点最多受两根骨骼影响，权重和为 1。

## 文件

- `ElderFish.blend`：Blender 4.2 源模型，包含五个可编辑的关键帧 Action，贴图使用相对路径。
- `ElderFish.fbx`：静止绑定姿势的五骨骼模型。
- `animations/*.fbx`：五个动作的独立动画 FBX。
- `Polysurface51_diff.png`：原贴图副本。
- `animation_clips.json`：以 Roblox 骨骼本地坐标表示的原始关键帧数据，挣扎动作保留 9 个可编辑关键帧。
- `animation_clips.baked.json`：从 Blender 周期 Bézier 曲线按 80 FPS 烘焙的 Studio 发布数据；左右挣扎各 49 个旋转矩阵姿势，使用 Linear 插值，其他动作保持原数据与 Cubic 插值。
- `bake_struggle.py`：从现有 Blender Action 烘焙发布数据和两个动画 FBX，不重建模型或稀疏关键帧。
- `author_animations.py`、`build_rig.py`：关键帧编排及 Blender 导出工具；`update_struggle.py` 只更新现有 Blender 文件的两个挣扎 Action 和对应 FBX，保留几何、UV、蒙皮及其他动作。
- `publish_rig.studio.lua`：针对正确朝向的两骨骼版本的一次性 Studio 网格升级工具。
- `validation.json`：Blender 几何、固定头部和各动画形变检查。
- `studio-assets.json`：已发布网格、动画 ID、工程所有者和备份位置。

## 动作

| 名称 | 时长 | 行为 |
|---|---:|---|
| SwimLoop | 0.625 秒，循环 | 小幅连续游动，弯曲向尾端依次传递 |
| StruggleLeft / StruggleRight | 各 0.6 秒，循环 | 主体累计弯曲 55～65°，前身 22～26°、中身 33～39°同相起伏；尾根和尾端相差 0.075 秒甩动，循环处不回直 |
| LiftFlop | 2 秒 | 出水旋转期间弯身，落下时逐渐展开 |
| ShowcaseFlop | 0.9 秒 | 两次短促挣动，首尾归零 |

动画全部发布在开发工程所属 M101 Crew，实例位于 `ReplicatedStorage.Animation.Fishing.Fish`；可编辑的 KeyframeSequence 保存在 `ServerStorage.FishAnimationSources`。运行时由独立 AnimationController/Animator 播放，代码只控制选择、权重、速度和时间同步，不计算骨骼角度、不写 Bone.Transform。挣扎阶段只淡入一次，同一轨道连续循环；保留螺旋缩圈路径、侧倾、展示轻晃和空钩收竿时序，已移除挣扎周期回弹。

旧挣扎 Action 在 Blender 内以 `StruggleLeft/Right_Previous_时间戳` 保留，Studio 旧 KeyframeSequence 同样保留且记录 `PreviousAnimationId`；旧资源 ID 见 `studio-assets.json`。`struggle_loop_validation.json` 记录当前循环的骨骼角度范围、固定头部和几何未变检查。

`struggle_bake_validation.json` 验证当前 49 点发布数据的固定头部、55～65° 弯曲和几何未变；`smoothness-validation.json` 记录镜头对照、旧/新动画速度及实际帧率条件。原关键帧处不再逐段缓入缓出，周期首尾姿势相同且速度连续。运行时仍仅由 Animator 播放骨骼动画。

水下螺旋绕行持续 3 秒，所有鱼统一以 2 圈/秒绕行，不随机基础转速、不叠加速度起伏。前 0.2 秒平滑起步，同时从提竿时半径展开到 1.2 倍，随后 2.8 秒持续收至原半径的 80%，交界处径向速度为零且连续。水花使用独立节奏，不影响路径角度或速度。源动画仍是 0.6 秒，运行时以 2 倍速循环，每 0.3 秒甩尾一轮，尾端延迟约 0.0375 秒；保留侧倾、移除周期回弹，出水旋转不变。

只更新挣扎动画：先运行 `author_animations.py`，再运行 `Blender -b assets/fish/ElderFish/ElderFish.blend --python assets/fish/ElderFish/update_struggle.py`。Studio 发布函数传入第二个参数 `{ "StruggleLeft", "StruggleRight" }`，只发布和替换两个资源。

更新或编辑完 Blender 曲线后，运行 `Blender -b assets/fish/ElderFish/ElderFish.blend --python assets/fish/ElderFish/bake_struggle.py`，发布时传入 **`animation_clips.baked.json`**，避免重新发布稀疏的逐段 Cubic 动作。

整鱼挣扎路径不再叠加鱼饵弹性模块的垂直位移；鱼饵自己的形变、轻啄、收竿和出水回弹仍保留。镜头噪声只临时关闭用于对照，最终保持 `Camera.Struggle.Shake = 0.7`。

重新生成源文件（从项目根目录运行）：

```sh
python3 assets/fish/ElderFish/author_animations.py
/Applications/Blender.app/Contents/MacOS/Blender -b --python assets/fish/ElderFish/build_rig.py -- /Users/gx/Downloads/fish
```

导出使用 **Z Forward / Y Up**，禁用 Leaf Bones。导入时选择 Custom rig，动作与模型必须使用相同骨骼层级；发布到 M101 Crew。Studio 安装版本使用相同的五骨骼绑定位置、相邻权重和关键帧，已保留原 TextureID、尺寸、CFrame 与实例引用。正确朝向的两骨骼版本位于 `studio-assets.json` 的 twoBoneBackup；模型与动画资源由 Studio 管理，不通过 Rojo 写入。

## 验证

- `FishingMeshFacing.lua`（Studio Edit）：14 个源 OBJ 几何标志点、五骨骼父子关系、归一化相邻权重、真实嘴部固定和尾端权重。
- `FishingTailRig.lua`（Studio Client）：实际发布动画加载、四段弯曲、头/嘴/鱼线、缩放、归零、克隆隔离及加载取消清理。
- `FishingStruggleLoop.lua`（Studio Client）：左右挣扎各连续播放 3 秒，检查循环不中断、主体持续弯曲、尾部甩动延迟和嘴部连接。
- `FishingCameraSmoothness.lua`（Studio Client）：同种子/时间的镜头开关对照、鱼身稳定水深，以及镜头参数恢复。
- `FishingInterpolation.lua`（Studio Client）：实际新旧资源的关键帧附近速度、周期接缝速度，以及实际 FPS 和播放时间校正次数。
- `FishingStraightApproach.lua`、`FishingPresentation.lua`（Studio Client）：进食、螺旋缩圈、出水、展示、空钩收竿与镜头回归。
- 本地：`python3 tools/run-tests.py FishAnimationController FishingBiteSequence FishingCastLifecycle FishingInputGate FishingProjectileMath FishingTransition`（在 CastLineRojo 目录）。
