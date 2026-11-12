"""Round-trip each delivered FBX through Blender; preserve files and report real inventories."""
import bpy,json,math
from pathlib import Path
ROOT=Path(__file__).resolve().parent
report=[]
for file in sorted((ROOT/'payload').glob('*.json')):
 d=json.loads(file.read_text());expected={b['name'] for b in d['bones']};row={'name':d['name'],'files':[]}
 for label in [d['name'],'SwimLoop','StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop']:
  bpy.ops.wm.read_factory_settings(use_empty=True);path=ROOT/'models'/d['name']/(label+'.fbx');bpy.ops.import_scene.fbx(filepath=str(path))
  rigs=[o for o in bpy.context.scene.objects if o.type=='ARMATURE'];assert len(rigs)==1,(d['name'],label,'missing rig');rig=rigs[0]
  actual={b.name for b in rig.data.bones};assert expected==actual,(d['name'],label,actual)
  meshes=[o for o in bpy.context.scene.objects if o.type=='MESH'];assert len(meshes)==len(d['parts']),(d['name'],label,len(meshes))
  for mesh in meshes:
   assert len(mesh.data.uv_layers)==1 and len(mesh.data.vertices)>0 and 0<len(mesh.vertex_groups)<=len(expected) and {g.name for g in mesh.vertex_groups}.issubset(expected),(d['name'],label,'lost UV or skin')
  if label!=d['name']:
   assert rig.animation_data and rig.animation_data.action,(d['name'],label,'missing Action')
   action=rig.animation_data.action;assert action.frame_range[1]>action.frame_range[0],(d['name'],label,'empty Action')
  row['files'].append({'file':str(path.relative_to(ROOT)),'passed':True,'bones':len(actual),'meshes':len(meshes)})
 report.append(row);print('FBX_ROUNDTRIP',d['name'],flush=True)
(ROOT/'fbx-validation.json').write_text(json.dumps({'passed':True,'fish':len(report),'files':sum(len(r['files']) for r in report),'results':report},indent=2))
