"""Blender 4.2: blender -b --python build_rig.py -- /path/to/original-obj-folder."""
import bpy
import json
import math
from pathlib import Path
import shutil
import sys
from mathutils import Matrix, Vector

OUTPUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUTPUT))
from eye_geometry import enlarge_eyes

SOURCE = Path(sys.argv[sys.argv.index("--") + 1])
data = json.loads((OUTPUT / "animation_clips.json").read_text())
names, anchors = data["bones"], data["weightAnchors"]
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
for vertex, point in zip(body.data.vertices, points): vertex.co = point - center
body.location = (0, 0, 0)
eye_validation = enlarge_eyes(body)
length = high.y - low.y
rig_data = bpy.data.armatures.new("ElderFishSkeleton")
rig = bpy.data.objects.new("ElderFishRig", rig_data)
bpy.context.collection.objects.link(rig)
bpy.context.view_layer.objects.active = rig
body.select_set(False)
rig.select_set(True)
bpy.ops.object.mode_set(mode="EDIT")
previous = None
for index, name in enumerate(names):
    bone = rig_data.edit_bones.new(name)
    fraction = data["pivotFractions"][index]
    bone.head = (0, 0 if fraction is None else -length * (fraction - .5), 0)
    next_fraction = data["pivotFractions"][index + 1] if 0 < index < len(names)-1 else 1
    bone.tail = (0, -length * (.15 if index == 0 else next_fraction-.5), 0)
    bone.parent = previous
    bone.use_connect = False
    previous = bone
bpy.ops.object.mode_set(mode="OBJECT")
groups = [body.vertex_groups.new(name=name) for name in names]
head_vertices = []
for vertex in body.data.vertices:
    along = .5 - vertex.co.y / length
    segment = 0
    while segment < len(anchors)-2 and along > anchors[segment+1]: segment += 1
    alpha = max(0, min(1, (along-anchors[segment])/(anchors[segment+1]-anchors[segment])))
    alpha = alpha*alpha*(3-2*alpha)
    groups[segment].add([vertex.index], 1-alpha, "REPLACE")
    groups[segment+1].add([vertex.index], alpha, "REPLACE")
    if along <= anchors[0]: head_vertices.append(vertex.index)
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
material.node_tree.nodes["Principled BSDF"].inputs["Roughness"].default_value = .6
body.data.materials.clear()
body.data.materials.append(material)
scene = bpy.context.scene
scene.render.fps = 80
scene.frame_start = 0
# Convert canonical Roblox XYZ rotations into each Blender bone's local axes.
conversion = Matrix(((1, 0, 0), (0, 0, -1), (0, 1, 0)))
rig.animation_data_create()
actions = {}
for name, clip in data["clips"].items():
    action = bpy.data.actions.new(name)
    action.use_fake_user = True
    rig.animation_data.action = action
    for frame in clip["frames"]:
        for bone_name, angles in frame["rotations"].items():
            rx, ry, rz = [math.radians(value) for value in angles]
            rotation = (Matrix.Rotation(rx, 3, "X") @ Matrix.Rotation(ry, 3, "Y") @ Matrix.Rotation(rz, 3, "Z"))
            basis = rig_data.bones[bone_name].matrix_local.to_3x3()
            pose = rig.pose.bones[bone_name]
            pose.rotation_mode = "QUATERNION"
            pose.rotation_quaternion = (basis.inverted() @ conversion @ rotation @ conversion.inverted() @ basis).to_quaternion()
            pose.keyframe_insert(data_path="rotation_quaternion", frame=frame["time"]*80)
    for curve in action.fcurves:
        for key in curve.keyframe_points: key.interpolation = "BEZIER"; key.handle_left_type = key.handle_right_type = "AUTO_CLAMPED"
        if name in ("StruggleLeft", "StruggleRight"):
            curve.modifiers.new("CYCLES")
    actions[name] = action
body.select_set(True)
rig.select_set(True)
bpy.context.view_layer.objects.active = rig
export_settings = dict(use_selection=True, object_types={"ARMATURE", "MESH"}, global_scale=1,
    apply_unit_scale=True, apply_scale_options="FBX_SCALE_UNITS", axis_forward="Z", axis_up="Y",
    add_leaf_bones=False, use_armature_deform_only=True, mesh_smooth_type="FACE", path_mode="RELATIVE")
rig.animation_data.action = None
for bone in rig.pose.bones: bone.rotation_quaternion = (1, 0, 0, 0)
bpy.context.view_layer.update()
bpy.ops.export_scene.fbx(filepath=str(OUTPUT / "ElderFish.fbx"), bake_anim=False, **export_settings)
(OUTPUT / "animations").mkdir(exist_ok=True)
baseline = [vertex.co.copy() for vertex in body.data.vertices]
validation = {}
for name, clip in data["clips"].items():
    rig.animation_data.action = actions[name]
    scene.frame_end = round(clip["duration"]*80)
    bpy.ops.export_scene.fbx(filepath=str(OUTPUT / "animations" / (name+".fbx")), bake_anim=True,
        bake_anim_use_all_actions=False, bake_anim_use_nla_strips=False,
        bake_anim_simplify_factor=0, **export_settings)
    head_error, tail_motion = 0, 0
    for frame in clip["frames"]:
        point = frame["time"]*80
        scene.frame_set(int(point), subframe=point-int(point))
        evaluated = body.evaluated_get(bpy.context.evaluated_depsgraph_get())
        mesh = evaluated.to_mesh()
        head_error = max(head_error, max((mesh.vertices[i].co-baseline[i]).length for i in head_vertices))
        tail_motion = max(tail_motion, max((v.co-baseline[i]).length for i,v in enumerate(mesh.vertices)))
        evaluated.to_mesh_clear()
    assert head_error < 1e-5, (name, head_error)
    assert tail_motion > .1, (name, tail_motion)
    validation[name] = {"duration":clip["duration"], "keyframes":len(clip["frames"]), "head_error":head_error, "maximum_vertex_displacement":tail_motion}
rig.animation_data.action = actions["SwimLoop"]
scene.frame_start, scene.frame_end = 0, 50
scene.frame_set(0)
texture.image.filepath = "//" + texture_name
rig.show_in_front = True
bpy.ops.wm.save_as_mainfile(filepath=str(OUTPUT / "ElderFish.blend"))
(OUTPUT / "validation.json").write_text(json.dumps({"vertices":len(body.data.vertices), "faces":len(body.data.polygons),
    "roblox_size":[high.x-low.x, high.z-low.z, length], "bones":names, "fbx_forward":"Z", "fbx_up":"Y",
    "fixed_head_vertices":len(head_vertices), "clips":validation}, indent=2) + "\n")
if eye_validation:
    (OUTPUT / "eyes2x").mkdir(exist_ok=True)
    (OUTPUT / "eyes2x/validation.json").write_text(json.dumps(eye_validation, indent=2) + "\n")
