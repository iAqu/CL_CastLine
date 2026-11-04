# 基础鱼饵：2 倍眼睛

模板为 `ReplicatedStorage.Models.FishBait["1"]["1"]`。保留毛毛虫身体、触角、腿、原调色板及六个 Texture 实例，只放大双眼的黑色区域与白色高光。

原网格无法通过 EditableMesh 读取。将模板克隆到工作区后，Studio 原生 ExportSelection 成功导出；`source/BasicBait_original.obj` 保留基础网格，导出生成的六份 Texture 覆盖层几何已移除，防止再次叠加。导出时世界位置为 `(0, 50, 0)`，构建工具将其还原到模板局部坐标。

直径沿面部 X/Y 方向放大 2 倍，厚度保留。为避免双眼重叠和超出圆角头部，做了最小分离及贴面平移，数值见 `validation.json`。全部非眼部顶点和模型包围盒不变；原 UV、面顺序和法线保留，眼部法线应用缩放的逆转置。

- `python3 assets/bait/BasicBait/build_eyes.py`：重建规范网格 JSON 并验证直径、身体和包围盒。
- Blender 中运行 `export_blender.py`：重建可编辑 `.blend` 与 `.fbx`，模型头朝 Roblox +Z，导出 Z Forward / Y Up。
- `publish.studio.lua`：编辑模式下从本机临时服务器的 `/bait.json` 创建并发布新网格；不会读取受限的原资产。
- `../../eyes2x/install.studio.lua`：把发布结果应用到原 MeshPart，恢复贴图、Size、CFrame、PivotOffset 和外观属性。

资源 ID、原模板备份位置和来源记录见 `studio-assets.json`。上述 Luau 工具仅用于资源制作，不通过 Rojo 部署到游戏。
