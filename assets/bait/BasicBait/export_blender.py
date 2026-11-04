"""Blender 4.2: blender -b --python export_blender.py."""
import bpy
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from build_eyes import build

payload, _ = build()
bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
mesh = bpy.data.meshes.new("BasicBait_Eyes2x")
mesh.from_pydata([(x, -z, y) for x, y, z in payload["vertices"]], [], [f[:3] for f in payload["faces"]])
mesh.update()
bait = bpy.data.objects.new("BasicBait_Eyes2x", mesh)
bpy.context.collection.objects.link(bait)
bait.select_set(True)
bpy.context.view_layer.objects.active = bait
uv = mesh.uv_layers.new(name="UVMap")
loop_normals = []
for polygon, face in zip(mesh.polygons, payload["faces"]):
    polygon.use_smooth = True
    for li, ui, ni in zip(polygon.loop_indices, face[3:6], face[6:9]):
        uv.data[li].uv = payload["uvs"][ui]
        x, y, z = payload["normals"][ni]
        loop_normals.append((x, -z, y))
mesh.normals_split_custom_set(loop_normals)
material = bpy.data.materials.new("OriginalPalette")
material.use_nodes = True
texture = material.node_tree.nodes.new("ShaderNodeTexImage")
texture.image = bpy.data.images.load(str(ROOT.parent.parent / "fish/ElderFish/Polysurface51_diff.png"))
material.node_tree.links.new(texture.outputs["Color"], material.node_tree.nodes["Principled BSDF"].inputs["Base Color"])
bait.data.materials.append(material)
bpy.ops.export_scene.fbx(
    filepath=str(ROOT / "BasicBait_Eyes2x.fbx"), use_selection=True,
    axis_forward="Z", axis_up="Y", bake_anim=False, mesh_smooth_type="FACE", path_mode="RELATIVE",
)
texture.image.filepath = "//../../fish/ElderFish/Polysurface51_diff.png"
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT / "BasicBait_Eyes2x.blend"))
