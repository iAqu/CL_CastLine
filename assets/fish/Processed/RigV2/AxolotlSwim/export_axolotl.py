"""Run in Blender background mode after build_axolotl.py."""
import sys
from pathlib import Path

import bpy
from mathutils import Quaternion, Vector

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT.parent))
from export_blender import create, read

files = {
    "payload/Rig007/rig.json": "rig.json",
    "payload/Rig007/part001.json": "weights.json",
    "motions/v2_axolotl_four_leg_swim.json": "motion.json",
}


def reader(path):
    return read("AxolotlSwim/" + files[path]) if path in files else read(path)


def preview():
    bpy.ops.wm.open_mainfile(filepath=str(OUT / "models" / "Axolotl.blend"))
    scene = bpy.context.scene
    rig = next(obj for obj in scene.objects if obj.type == "ARMATURE")
    scene.render.engine = "BLENDER_WORKBENCH"
    scene.render.resolution_x, scene.render.resolution_y = 640, 350
    scene.render.resolution_percentage = 100
    scene.render.image_settings.file_format = "PNG"
    shading = scene.display.shading
    shading.color_type = "TEXTURE"
    shading.light = "STUDIO"
    shading.show_cavity = True
    shading.background_type = "WORLD"
    scene.world = scene.world or bpy.data.worlds.new("Preview world")
    scene.world.color = (.12, .13, .15)
    for material in bpy.data.materials:
        if material.use_nodes:
            texture = next((n for n in material.node_tree.nodes if n.type == "TEX_IMAGE"), None)
            if texture:
                material.node_tree.nodes.active = texture
    camera_data = bpy.data.cameras.new("Swim review")
    camera = bpy.data.objects.new("Swim review", camera_data)
    scene.collection.objects.link(camera)
    scene.camera = camera
    camera_data.type, camera_data.ortho_scale = "ORTHO", 7.8
    out = OUT / "preview"
    out.mkdir(exist_ok=True)
    action = rig.animation_data.action
    for weight in (.4, 1.):
        for frame in (0, 18, 37, 56):
            rig.animation_data.action = action
            scene.frame_set(frame)
            poses = {b.name: b.rotation_quaternion.copy() for b in rig.pose.bones}
            rig.animation_data.action = None
            for bone in rig.pose.bones:
                bone.rotation_quaternion = Quaternion().slerp(poses[bone.name], weight)
            for label, location, roll in (
                ("side", (11, 0, .35), 0.),
                ("top", (0, 0, 11), 1.57079632679),
            ):
                camera.location = location
                aim = -Vector(location)
                camera.rotation_mode = "QUATERNION"
                camera.rotation_quaternion = aim.to_track_quat("-Z", "Y") @ Quaternion((0, 0, 1), roll)
                scene.render.filepath = str(out / f"{label}_{weight}_{frame:02}.png")
                bpy.context.view_layer.update()
                bpy.ops.render.render(write_still=True)


if "--preview" in sys.argv:
    preview()
else:
    create({"key": "Rig007"}, reader, OUT / "models")
