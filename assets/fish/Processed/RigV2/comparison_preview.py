"""Render a side-by-side view of the same Elder Fish mesh at its showcase keyframe."""
from pathlib import Path
import sys
import math
import bpy
from mathutils import Vector, Matrix

ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT))
from build import read
from export_blender import TO_BLENDER, FROM_BLENDER

entry=next(x for x in read('inventory.json')['rows'] if x['name']=='Elder Fish')
key=entry['key']
source=read(f'source/{key}/rig.json')
data=read(f'payload/{key}/rig.json')
bpy.ops.wm.open_mainfile(filepath=str(ROOT/'models/Elder Fish/Elder Fish.blend'))
scene=bpy.context.scene
rig=next(o for o in scene.objects if o.type=='ARMATURE')
meshes=[o for o in scene.objects if o.type=='MESH']
old_data=bpy.data.armatures.new('OriginalRig')
old=bpy.data.objects.new('OriginalRig',old_data)
bpy.context.collection.objects.link(old)
bpy.ops.object.select_all(action='DESELECT')
old.select_set(True);bpy.context.view_layer.objects.active=old
bpy.ops.object.mode_set(mode='EDIT')
for b in source['originalBones']:
    n=old_data.edit_bones.new(b['name'])
    n.head=TO_BLENDER@Vector(b['position']);n.tail=n.head+Vector((0,-.35,0))
    if b['parent']:n.parent=old_data.edit_bones[b['parent']]
bpy.ops.object.mode_set(mode='OBJECT')
for i,obj in enumerate(meshes,1):
    orig=read(f'source/{key}/part{i:03}.json')
    clone=obj.copy()
    bpy.context.collection.objects.link(clone)
    clone.parent=old
    clone.vertex_groups.clear()
    for b in source['originalBones']:clone.vertex_groups.new(name=b['name'])
    for vi,(names,ws) in enumerate(orig['weights']):
        totals={}
        for n,w in zip(names,ws):totals[n]=totals.get(n,0)+w
        for n,w in totals.items():
            if w>0:clone.vertex_groups[n].add([vi],w,'REPLACE')
    clone.modifiers[0].object=old
    for mat in obj.data.materials:
        if mat and mat.node_tree:
            texture=next((n for n in mat.node_tree.nodes if n.type=='TEX_IMAGE'),None)
            if texture:mat.node_tree.nodes.active=texture
before=read(f'old-motion/{key}.json')
pose=min(before['clips']['ShowcaseFlop']['frames'],key=lambda f:abs(f['time']-.2))
for b in old.pose.bones:
    m=pose['rotationMatrices'][b.name]
    anim=Matrix([m[i:i+3] for i in (0,3,6)])
    orient=before['bindRotations'][b.name]
    orient=Matrix([orient[i:i+3] for i in (0,3,6)])
    anim=orient@anim@orient.transposed()
    basis=b.bone.matrix_local.to_3x3()
    b.rotation_mode='QUATERNION'
    b.rotation_quaternion=(basis.inverted()@TO_BLENDER@anim@FROM_BLENDER@basis).to_quaternion()
rig.animation_data.action=bpy.data.actions['ShowcaseFlop']
scene.frame_set(24)
scale=6/max(data['bodySize'])
for arm,offset in ((old,-4.4),(rig,4.4)):
    arm.rotation_euler.z=math.radians(105)
    arm.scale=(scale,)*3
    arm.location=(offset,0,0)
camera_data=bpy.data.cameras.new('Comparison')
camera=bpy.data.objects.new('Comparison',camera_data)
scene.collection.objects.link(camera)
camera.location=(0,-23,10)
camera.rotation_euler=(Vector((0,0,-.15))-camera.location).to_track_quat('-Z','Y').to_euler()
camera_data.type='ORTHO';camera_data.ortho_scale=17
scene.camera=camera
scene.render.engine='BLENDER_WORKBENCH'
scene.display.shading.light='STUDIO'
scene.display.shading.color_type='SINGLE'
scene.display.shading.single_color=(.43,.70,.76)
scene.display.shading.background_type='WORLD'
scene.display.shading.show_shadows=False
scene.display.shading.show_cavity=True
if not scene.world:scene.world=bpy.data.worlds.new('Comparison Background')
scene.world.color=(.09,.12,.17)
for label,x in (('BEFORE',-4.4),('RIG V2',4.4)):
    font=bpy.data.curves.new(label,'FONT')
    font.body=label;font.align_x='CENTER';font.size=.36
    tag=bpy.data.objects.new(label,font)
    scene.collection.objects.link(tag)
    tag.location=(x,0,-2.9)
    tag.rotation_euler=camera.rotation_euler
scene.render.resolution_x=1440
scene.render.resolution_y=680
scene.render.resolution_percentage=100
scene.render.image_settings.file_format='PNG'
out=ROOT/'previews';out.mkdir(exist_ok=True)
scene.render.filepath=str(out/'ElderFish-showcase-before-after.png')
bpy.ops.render.render(write_still=True)


if "--movie" in sys.argv:
    # Review the authored clips side by side at normal source speed.
    # These views exclude gameplay translations and show the actual skinned motion.
    frames_dir=ROOT/'previews'/'frames'
    frames_dir.mkdir(exist_ok=True)
    scene.render.resolution_x=1080
    scene.render.resolution_y=510
    title_data=bpy.data.curves.new('Action Name','FONT')
    title_data.size=.35
    title_data.align_x='CENTER'
    title=bpy.data.objects.new('Action Name',title_data)
    scene.collection.objects.link(title)
    title.location=(0,0,3.05)
    title.rotation_euler=camera.rotation_euler
    v2=read(f"motions/{data['variant']}.json")['clips']
    def quaternion(bone, frame):
        m=frame['rotationMatrices'][bone.name]
        a=Matrix([m[i:i+3] for i in (0,3,6)])
        orient=before['bindRotations'][bone.name]
        orient=Matrix([orient[i:i+3] for i in (0,3,6)])
        basis=bone.bone.matrix_local.to_3x3()
        return (basis.inverted()@TO_BLENDER@orient@a@orient.transposed()@FROM_BLENDER@basis).to_quaternion()
    index=0
    for name in ('SwimLoop','StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop'):
        title_data.body=name
        rig.animation_data.action=bpy.data.actions[name]
        authored=before['clips'][name]['frames']
        duration=v2[name]['duration']
        repeats=2 if v2[name]['loop'] else 1
        for step in range(math.ceil(duration*24)*repeats):
            time=(step/24)%duration
            right=next((i for i,f in enumerate(authored) if f['time']>=time),len(authored)-1)
            a,b=authored[max(0,right-1)],authored[right]
            fraction=(time-a['time'])/(b['time']-a['time']) if b['time']>a['time'] else 0
            for joint in old.pose.bones:
                joint.rotation_quaternion=quaternion(joint,a).slerp(quaternion(joint,b),max(0,min(1,fraction)))
            frame=time*120
            scene.frame_set(int(frame),subframe=frame%1)
            scene.render.filepath=str(frames_dir/f'{index:04}.png')
            bpy.ops.render.render(write_still=True)
            index+=1
