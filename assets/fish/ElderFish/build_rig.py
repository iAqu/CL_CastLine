"""Run with Blender 4.2: blender -b --python build_rig.py -- /path/to/export."""
import bpy
import json
import math
from pathlib import Path
import shutil
import sys
from mathutils import Vector

OUTPUT = Path(__file__).resolve().parent
SOURCE = Path(sys.argv[sys.argv.index("--") + 1])
bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
bpy.ops.wm.obj_import(filepath=str(SOURCE / "1.obj"), forward_axis="NEGATIVE_Z", up_axis="Y")
body = next(obj for obj in bpy.context.selected_objects if obj.type == "MESH")
body.name = "polySurface5"
bpy.context.view_layer.objects.active = body
bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
points = [body.matrix_world @ vertex.co for vertex in body.data.vertices]
low = Vector(tuple(min(point[i] for point in points) for i in range(3)))
high = Vector(tuple(max(point[i] for point in points) for i in range(3)))
center = (low + high) / 2
for vertex, point in zip(body.data.vertices, points):
    vertex.co = point - center
body.location = (0, 0, 0)
length = high.y - low.y
# OBJ's +Z (tail) is Blender's -Y after the Y-up import conversion.
tail_origin_y = length * 0.1
rig_data = bpy.data.armatures.new("ElderFishSkeleton")
rig = bpy.data.objects.new("ElderFishRig", rig_data)
bpy.context.collection.objects.link(rig)
bpy.context.view_layer.objects.active = rig
body.select_set(False)
rig.select_set(True)
bpy.ops.object.mode_set(mode="EDIT")
root = rig_data.edit_bones.new("FishBody")
root.head, root.tail = (0, 0, 0), (0, -length * 0.15, 0)
tail = rig_data.edit_bones.new("FishTail")
tail.head, tail.tail = (0, tail_origin_y, 0), (0, -length * 0.48, 0)
tail.parent = root
tail.use_connect = False
bpy.ops.object.mode_set(mode="OBJECT")
body_group = body.vertex_groups.new(name="FishBody")
tail_group = body.vertex_groups.new(name="FishTail")
weights = []
for vertex in body.data.vertices:
    along = 0.5 - vertex.co.y / length
    alpha = max(0, min(1, (along - 0.35) / 0.5))
    weight = alpha * alpha * (3 - 2 * alpha)
    body_group.add([vertex.index], 1 - weight, "REPLACE")
    tail_group.add([vertex.index], weight, "REPLACE")
    weights.append(weight)
modifier = body.modifiers.new("FishSkin", "ARMATURE")
modifier.object = rig
body.parent = rig
texture_name = "Polysurface51_diff.png"
shutil.copy2(SOURCE / texture_name, OUTPUT / texture_name)
material = bpy.data.materials.new("ElderFishMaterial")
material.use_nodes = True
texture = material.node_tree.nodes.new("ShaderNodeTexImage")
texture.image = bpy.data.images.load(str(OUTPUT / texture_name))
material.node_tree.links.new(texture.outputs["Color"], material.node_tree.nodes["Principled BSDF"].inputs["Base Color"])
material.node_tree.nodes["Principled BSDF"].inputs["Roughness"].default_value = 0.6
body.data.materials.clear()
body.data.materials.append(material)

# Check skin deformation numerically before export: front remains fixed, tail moves.
baseline = [vertex.co.copy() for vertex in body.data.vertices]
tail_pose = rig.pose.bones["FishTail"]
tail_pose.rotation_mode = "XYZ"
tail_pose.rotation_euler.z = math.radians(18)
bpy.context.view_layer.update()
evaluated = body.evaluated_get(bpy.context.evaluated_depsgraph_get())
deformed = evaluated.to_mesh()
head_error = max((deformed.vertices[i].co - point).length for i, point in enumerate(baseline) if weights[i] == 0)
tail_motion = max((deformed.vertices[i].co - point).length for i, point in enumerate(baseline) if weights[i] > 0.99)
evaluated.to_mesh_clear()
assert head_error < 1e-5, head_error
assert tail_motion > length * 0.05, tail_motion
tail_pose.rotation_euler = (0, 0, 0)
bpy.context.view_layer.update()
body.select_set(True)
rig.select_set(True)
bpy.context.view_layer.objects.active = rig
bpy.ops.export_scene.fbx(filepath=str(OUTPUT / "ElderFish.fbx"), use_selection=True,
    object_types={"ARMATURE", "MESH"}, global_scale=1, apply_unit_scale=True,
    apply_scale_options="FBX_SCALE_UNITS", axis_forward="-Z", axis_up="Y",
    add_leaf_bones=False, use_armature_deform_only=True, bake_anim=False,
    mesh_smooth_type="FACE", path_mode="RELATIVE")

# Keep the working source portable with a relative texture path.
texture.image.filepath = "//" + texture_name
rig.show_in_front = True
bpy.ops.wm.save_as_mainfile(filepath=str(OUTPUT / "ElderFish.blend"))
(OUTPUT / "validation.json").write_text(json.dumps({
    "vertices": len(body.data.vertices), "faces": len(body.data.polygons),
    "roblox_size": [high.x-low.x, high.z-low.z, length],
    "bones": ["FishBody", "FishTail"], "fixed_head_vertices": weights.count(0),
    "full_tail_vertices": weights.count(1), "head_error_at_18_degrees": head_error,
    "tail_displacement_at_18_degrees": tail_motion,
}, indent=2) + "\n")
