"""Bake existing cyclic Blender curves for Studio, without rebuilding the rig or actions."""
import bpy
import copy
import hashlib
import json
import math
from pathlib import Path
from mathutils import Matrix

ROOT = Path(__file__).resolve().parent
data = json.loads((ROOT / "animation_clips.json").read_text())
rig, body = bpy.data.objects["ElderFishRig"], bpy.data.objects["polySurface5"]
scene = bpy.context.scene
conversion = Matrix(((1, 0, 0), (0, 0, -1), (0, 1, 0)))
saved = (rig.animation_data.action, scene.frame_current, scene.frame_start, scene.frame_end, scene.render.fps)


def geometry_hash():
    payload = {
        "vertices": [list(v.co) for v in body.data.vertices],
        "faces": [list(p.vertices) for p in body.data.polygons],
        "weights": [[(g.group, g.weight) for g in v.groups] for v in body.data.vertices],
        "uv": [[list(v.uv) for v in layer.data] for layer in body.data.uv_layers],
    }
    return hashlib.sha256(json.dumps(payload).encode()).hexdigest()


def canonical_matrix(name):
    basis = rig.data.bones[name].matrix_local.to_3x3()
    pose = rig.pose.bones[name].rotation_quaternion.normalized().to_matrix()
    return conversion.inverted() @ basis @ pose @ basis.inverted() @ conversion


original_hash = geometry_hash()
baseline = [v.co.copy() for v in body.data.vertices]
length = max(v.co.y for v in body.data.vertices) - min(v.co.y for v in body.data.vertices)
head = [v.index for v in body.data.vertices if .5 - v.co.y / length <= .25]
scene.render.fps = 80
bpy.ops.object.select_all(action="DESELECT")
body.select_set(True)
rig.select_set(True)
bpy.context.view_layer.objects.active = rig
report = {"geometry_unchanged": True, "geometry_sha256": original_hash, "clips": {}}
for name in ("StruggleLeft", "StruggleRight"):
    clip = data["clips"][name]
    action = bpy.data.actions[name]
    rig.animation_data.action = action
    scene.frame_start, scene.frame_end = 0, 48
    frames, body_range, head_error = [], [1000, -1000], 0
    for index in range(49):
        scene.frame_set(index)
        rotations, body_yaw = {}, 0
        for bone_name in data["bones"]:
            matrix = canonical_matrix(bone_name)
            rotations[bone_name] = [float(matrix[row][col]) for row in range(3) for col in range(3)]
            if bone_name in ("SpineFront", "SpineMid"):
                body_yaw += math.degrees(math.atan2(matrix[0][2], matrix[0][0]))
        assert rig.pose.bones["FishBody"].rotation_quaternion.angle < 1e-5
        body_range[0] = min(body_range[0], abs(body_yaw))
        body_range[1] = max(body_range[1], abs(body_yaw))
        evaluated = body.evaluated_get(bpy.context.evaluated_depsgraph_get())
        mesh = evaluated.to_mesh()
        head_error = max(head_error, max((mesh.vertices[i].co - baseline[i]).length for i in head))
        evaluated.to_mesh_clear()
        frames.append({"time": index / 80, "rotationMatrices": rotations})
    assert body_range[0] >= 54.95 and body_range[1] <= 65.05 and head_error < 1e-5
    for bone_name in data["bones"]:
        assert max(abs(a - b) for a, b in zip(frames[0]["rotationMatrices"][bone_name], frames[-1]["rotationMatrices"][bone_name])) < 1e-5
    frames[-1]["rotationMatrices"] = copy.deepcopy(frames[0]["rotationMatrices"])
    clip["authoredKeyframes"] = len(clip["frames"])
    clip["frames"], clip["interpolation"], clip["sampleRate"] = frames, "Linear", 80
    bpy.ops.export_scene.fbx(
        filepath=str(ROOT / "animations" / (name + ".fbx")), use_selection=True,
        object_types={"ARMATURE", "MESH"}, global_scale=1, apply_unit_scale=True,
        apply_scale_options="FBX_SCALE_UNITS", axis_forward="Z", axis_up="Y",
        add_leaf_bones=False, use_armature_deform_only=True, mesh_smooth_type="FACE",
        path_mode="RELATIVE", bake_anim=True, bake_anim_step=1,
        bake_anim_use_all_actions=False, bake_anim_use_nla_strips=False, bake_anim_simplify_factor=0,
    )
    action["StudioInterpolation"], action["StudioSampleRate"] = "Linear", 80
    report["clips"][name] = {"duration": .6, "samples": 49, "authored_keyframes": clip["authoredKeyframes"],
                             "sample_rate": 80, "interpolation": "Linear",
                             "body_yaw_range": body_range, "head_error": head_error,
                             "seam_identical": True}
assert geometry_hash() == original_hash
rig.animation_data.action, frame, scene.frame_start, scene.frame_end, scene.render.fps = saved
scene.frame_set(frame)
bpy.context.preferences.filepaths.save_version = 0
bpy.ops.wm.save_as_mainfile(filepath=str(ROOT / "ElderFish.blend"))
(ROOT / "animation_clips.baked.json").write_text(json.dumps(data, indent=2) + "\n")
(ROOT / "struggle_bake_validation.json").write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps(report))
