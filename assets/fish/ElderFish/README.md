# Elder Fish 游动骨骼

源文件来自 `/Users/gx/Downloads/fish`，原文件未修改。

- `ElderFish.blend`：Blender 4.2 工作源文件，贴图使用相对路径。
- `ElderFish.fbx`：供 Studio 自定义骨骼导入，保持同目录 PNG。
- `Polysurface51_diff.png`：原贴图副本。
- `build_rig.py`：可重复执行的建模脚本。
- `validation.json`：Blender 几何及蒙皮检查结果。
- `studio-assets.json`：已安装的 Studio 资源和备份位置。

鱼头朝 Roblox 本地 -Z，保持原始尺寸。`FishBody` 固定，`FishTail` 负责摆尾；前 35% 鱼身不受尾骨影响，至 85% 处平滑增加至完全受尾骨影响。骨骼本地轴由导入器决定，代码将鱼身竖直轴换算到尾骨本地坐标后旋转。

重新生成（从项目根目录运行）：

```sh
/Applications/Blender.app/Contents/MacOS/Blender -b --python assets/fish/ElderFish/build_rig.py -- /Users/gx/Downloads/fish
```

导入 Studio 时选择 Custom rig，上传到开发工程所属的 M101 Crew。已安装版本使用导入网格，保留原 TextureID、尺寸、CFrame、PrimaryPart 实例和 CameraPart。原模板与完整导入模型位于 `ServerStorage.FishRigBackups`。模型资源不通过 Rojo 同步。

验证：`CastLineRojo/tests/studio/FishingTailRig.lua` 在 Studio Client 运行真实模板回归；普通钓鱼测试通过 `python3 tools/run-tests.py FishingBiteSequence FishingCastLifecycle FishingInputGate FishingProjectileMath FishingTransition` 运行。
