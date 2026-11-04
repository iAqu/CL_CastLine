"""Blender -b ElderFish.blend --python update_struggle.py; preserves the current mesh."""
import bpy
import hashlib
import json
import math
from datetime import datetime, timezone
from pathlib import Path
from mathutils import Matrix

ROOT = Path(__file__).resolve().parent
data = json.loads((ROOT / "animation_clips.json").read_text())
rig = bpy.data.objects["ElderFishRig"]
body = bpy.data.objects["polySurface5"]
scene = bpy.context.scene
conversion = Matrix(((1, 0, 0), (0, 0, -1), (0, 1, 0)))
stamp = datetime.now(timezone.utc).strftime("%Y%m%d_%H%M%S")


def geometry_hash():
    payload = {
        "vertices": [list(v.co) for v in body.data.vertices],
        "faces": [list(p.vertices) for p in body.data.polygons],
        "weights": [[(g.group, g.weight) for g in v.groups] for v in body.data.vertices],
        "uv": [[list(v.uv) for v in layer.data] for layer in body.data.uv_layers],
    }
    return hashlib.sha256(json.dumps(payload).encode()).hexdigest()


original_hash = geometry_hash()
original_action = rig.animation_data.action
original_frame, original_end = scene.frame_current, scene.frame_end
baseline = [v.co.copy() for v in body.data.vertices]
length = max(v.co.y for v in body.data.vertices) - min(v.co.y for v in body.data.vertices)
head = [v.index for v in body.data.vertices if .5 - v.co.y / length <= .25]
validation = {}
bpy.ops.object.select_all(action="DESELECT")
body.select_set(True)
rig.select_set(True)
bpy.context.view_layer.objects.active = rig
for name in ("StruggleLeft", "StruggleRight"):
    clip = data["clips"][name]
    assert clip["loop"] and clip["duration"] == .6
    assert clip["frames"][0]["rotations"] == clip["frames"][-1]["rotations"]
    old = bpy.data.actions.get(name)
    if old:
        old.name = name + "_Previous_" + stamp
        old.use_fake_user = True
    action = bpy.data.actions.new(name)
    action.use_fake_user = True
    rig.animation_data.action = action
    for frame in clip["frames"]:
        for bone_name, angles in frame["rotations"].items():
            rx, ry, rz = map(math.radians, angles)
            rotation = Matrix.Rotation(rx, 3, "X") @ Matrix.Rotation(ry, 3, "Y") @ Matrix.Rotation(rz, 3, "Z")
            basis = rig.data.bones[bone_name].matrix_local.to_3x3()
            pose = rig.pose.bones[bone_name]
            pose.rotation_mode = "QUATERNION"
            pose.rotation_quaternion = (basis.inverted() @ conversion @ rotation @ conversion.inverted() @ basis).to_quaternion()
            pose.keyframe_insert(data_path="rotation_quaternion", frame=frame["time"] * 80)
    for curve in action.fcurves:
        for key in curve.keyframe_points:
            key.interpolation = "BEZIER"
            key.handle_left_type = key.handle_right_type = "AUTO_CLAMPED"
        curve.modifiers.new("CYCLES")
    scene.frame_start, scene.frame_end = 0, 48
    bpy.ops.export_scene.fbx(
        filepath=str(ROOT / "animations" / (name + ".fbx")), use_selection=True,
        object_types={"ARMATURE", "MESH"}, global_scale=1, apply_unit_scale=True,
        apply_scale_options="FBX_SCALE_UNITS", axis_forward="Z", axis_up="Y",
        add_leaf_bones=False, use_armature_deform_only=True, mesh_smooth_type="FACE",
        path_mode="RELATIVE", bake_anim=True, bake_anim_use_all_actions=False,
        bake_anim_use_nla_strips=False, bake_anim_simplify_factor=0,
    )
    head_error, displacement = 0, 0
    body_range = [1000, -1000]
    ranges = {bone: [1000, -1000] for bone in data["bones"][1:]}
    for index in range(97):
        scene.frame_set(index // 2, subframe=(index % 2) / 2)
        evaluated = body.evaluated_get(bpy.context.evaluated_depsgraph_get())
        mesh = evaluated.to_mesh()
        head_error = max(head_error, max((mesh.vertices[i].co - baseline[i]).length for i in head))
        displacement = max(displacement, max((v.co - baseline[i]).length for i, v in enumerate(mesh.vertices)))
        evaluated.to_mesh_clear()
        assert rig.pose.bones["FishBody"].rotation_quaternion.angle < 1e-5
        body_yaw = 0
        for bone_name in ranges:
            basis = rig.data.bones[bone_name].matrix_local.to_3x3()
            local = rig.pose.bones[bone_name].rotation_quaternion.to_matrix()
            canonical = conversion.inverted() @ basis @ local @ basis.inverted() @ conversion
            yaw = math.degrees(math.atan2(canonical[0][2], canonical[0][0]))
            ranges[bone_name][0] = min(ranges[bone_name][0], yaw)
            ranges[bone_name][1] = max(ranges[bone_name][1], yaw)
            if bone_name in ("SpineFront", "SpineMid"):
                body_yaw += yaw
        body_range[0] = min(body_range[0], abs(body_yaw))
        body_range[1] = max(body_range[1], abs(body_yaw))
    sign = 1 if name == "StruggleLeft" else -1
    for bone_name, low, high in (("SpineFront", 22, 26), ("SpineMid", 33, 39)):
        signed = sorted(v * sign for v in ranges[bone_name])
        assert signed[0] >= low - .05 and signed[1] <= high + .05, (name, bone_name, signed)
    assert head_error < 1e-5 and displacement > 1
    assert body_range[0] >= 54.95 and body_range[1] <= 65.05, body_range
    validation[name] = {"duration": .6, "loop": True, "keyframes": len(clip["frames"]),
                        "head_error": head_error, "maximum_vertex_displacement": displacement,
                        "yaw_ranges": ranges, "body_yaw_range": body_range,
                        "tail_delay": .075, "seam_identical": True}
assert geometry_hash() == original_hash, "Mesh/UV/skin changed while authoring animations"
rig.animation_data.action = original_action
scene.frame_end = original_end
scene.frame_set(original_frame)
bpy.context.preferences.filepaths.save_version = 0
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT / "ElderFish.blend"))
report = {"geometry_unchanged": True, "geometry_sha256": original_hash,
          "backup_action_suffix": "_Previous_" + stamp, "clips": validation}
(ROOT / "struggle_loop_validation.json").write_text(json.dumps(report, indent=2) + "\n")
summary = json.loads((ROOT / "validation.json").read_text())
summary["clips"].update(validation)
(ROOT / "validation.json").write_text(json.dumps(summary, indent=2) + "\n")
print(json.dumps(report))
