"""Render final authored skins at rest and in an actual Blender animation pose."""
import bpy,json,math
from pathlib import Path
from mathutils import Vector
ROOT=Path(__file__).resolve().parent
(ROOT/'qa').mkdir(exist_ok=True)
import sys
wanted=set(sys.argv[sys.argv.index('--')+1:]) if '--' in sys.argv else set()
for path in sorted((ROOT/'models').glob('*/*.blend')):
 if wanted and path.parent.name not in wanted:continue
 bpy.ops.wm.open_mainfile(filepath=str(path));scene=bpy.context.scene;scene.render.engine='BLENDER_EEVEE';scene.render.resolution_x=480;scene.render.resolution_y=320;scene.render.resolution_percentage=100;scene.render.image_settings.file_format='PNG';scene.render.film_transparent=False;scene.world.color=(.18,.18,.18);scene.view_settings.view_transform='Standard'
 rig=next(o for o in scene.objects if o.type=='ARMATURE');d=json.loads(next(p for p in (ROOT/'payload').glob('*.json') if json.loads(p.read_text())['name']==path.parent.name).read_text());length=max(d['bodySize']);scale=6/length
 for obj in scene.objects:
  if obj.type=='MESH':obj.hide_render=obj.name not in {p['name'] for p in d['parts'] if p['original']['transparency']<1}
 cameraData=bpy.data.cameras.new('QA');camera=bpy.data.objects.new('QA',cameraData);scene.collection.objects.link(camera);scene.camera=camera;cameraData.type='ORTHO';cameraData.ortho_scale=7.8/scale
 for pos,power in [((5,8,6),1500),((-4,-5,4),1000)]:
  ld=bpy.data.lights.new('QA_light','AREA');ld.energy=power/(scale*scale);ld.size=8/scale;o=bpy.data.objects.new('QA_light',ld);scene.collection.objects.link(o);o.location=Vector(pos)/scale;o.rotation_euler=(-o.location).to_track_quat('-Z','Y').to_euler()
 for view,pos,clip,t in [('side',(10,0,0),None,0),('front',(0,10,1),None,0),('struggle',(8,8,5),'StruggleLeft',.15)]:
  rig.animation_data.action=bpy.data.actions[clip] if clip else None
  if not clip:
   for bone in rig.pose.bones:bone.rotation_quaternion=(1,0,0,0)
  scene.frame_set(round(t*80));bpy.context.view_layer.update();camera.location=Vector(pos)/scale;camera.rotation_euler=(-camera.location).to_track_quat('-Z','Y').to_euler();scene.render.filepath=str(ROOT/'qa'/(d['key']+'_'+view+'.png'));bpy.ops.render.render(write_still=True)
 print('QA_RENDER',d['name'],flush=True)
