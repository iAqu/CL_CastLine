"""Preserve finished Elder geometry/eyes/weights; retarget its palette and export copies."""
import bpy
from pathlib import Path
ROOT=Path(__file__).resolve().parent
bpy.ops.wm.open_mainfile(filepath=str(ROOT.parent/'ElderFish/ElderFish.blend'))
out=ROOT/'models/Elder Fish';out.mkdir(parents=True,exist_ok=True)
for image in bpy.data.images:
 if image.source=='FILE':
  image.filepath=str(ROOT/'textures/Palette_Vivid.png');image.reload()
rig=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE')
bpy.ops.object.select_all(action='DESELECT')
for obj in bpy.context.scene.objects:
 if obj.type in ('ARMATURE','MESH'):obj.select_set(True)
bpy.context.view_layer.objects.active=rig
settings=dict(use_selection=True,object_types={'ARMATURE','MESH'},global_scale=1,apply_unit_scale=True,apply_scale_options='FBX_SCALE_UNITS',axis_forward='Z',axis_up='Y',add_leaf_bones=False,use_armature_deform_only=True,mesh_smooth_type='FACE',path_mode='RELATIVE')
rig.animation_data.action=None
for bone in rig.pose.bones:bone.rotation_quaternion=(1,0,0,0)
bpy.context.view_layer.update()
bpy.ops.export_scene.fbx(filepath=str(out/'Elder Fish.fbx'),bake_anim=False,**settings)
for name in ('SwimLoop','StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop'):
 action=bpy.data.actions[name];rig.animation_data.action=action
 bpy.context.scene.frame_start=int(action.frame_range[0]);bpy.context.scene.frame_end=int(action.frame_range[1])
 bpy.ops.export_scene.fbx(filepath=str(out/(name+'.fbx')),bake_anim=True,bake_anim_use_all_actions=False,bake_anim_use_nla_strips=False,bake_anim_simplify_factor=0,**settings)
rig.animation_data.action=bpy.data.actions['SwimLoop'];bpy.context.scene.frame_set(0)
bpy.ops.wm.save_as_mainfile(filepath=str(out/'Elder Fish.blend'))
