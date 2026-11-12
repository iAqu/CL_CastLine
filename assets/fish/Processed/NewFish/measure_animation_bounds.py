"""Measure evaluated skinned vertices across every authored animation in Blender."""
import bpy,json,math
from mathutils import Vector
from pathlib import Path
ROOT=Path(__file__).resolve().parent
previous=json.loads((ROOT/"animation-bounds.json").read_text()) if (ROOT/"animation-bounds.json").exists() else {}
rows={json.loads(f.read_text())["name"]:json.loads(f.read_text()) for f in (ROOT/"payload").glob("*.json")}
results={}
for path in sorted((ROOT/'models').glob('*/*.blend')):
 if path.parent.name=='Elder Fish':continue
 bpy.ops.wm.open_mainfile(filepath=str(path))
 rig=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE')
 meshes=[o for o in bpy.context.scene.objects if o.type=='MESH' and not o.hide_render]
 primary=rows[path.parent.name]["parts"][0]["center"]
 center=Vector((primary[0],-primary[2],primary[1]))
 maximum=0;sample_count=0
 for name in ('SwimLoop','StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop'):
  action=bpy.data.actions[name];rig.animation_data.action=action
  start,end=action.frame_range
  for i in range(25):
   frame=start+(end-start)*i/24;bpy.context.scene.frame_set(math.floor(frame),subframe=frame%1)
   depsgraph=bpy.context.evaluated_depsgraph_get()
   for obj in meshes:
    evaluated=obj.evaluated_get(depsgraph);mesh=evaluated.to_mesh()
    maximum=max(maximum,max((evaluated.matrix_world@v.co-center).length for v in mesh.vertices));evaluated.to_mesh_clear()
   sample_count+=1
 results[path.parent.name]={'measuredRadius':maximum,'presentationRadius':max(maximum*1.10,previous.get(path.parent.name,{}).get('presentationRadius',0)),'center':'PrimaryPart','poseSamples':sample_count,'interpolationMargin':1.10}
 print(path.parent.name,maximum,flush=True)
(ROOT/'animation-bounds.json').write_text(json.dumps(results,indent=2))
