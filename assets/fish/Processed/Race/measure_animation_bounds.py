"""Measure evaluated skinned vertices across every authored animation in Blender."""
import bpy,json,math
from pathlib import Path
ROOT=Path(__file__).resolve().parent
results={}
for path in sorted((ROOT/'models').glob('*/*.blend')):
 if path.parent.name=='Elder Fish':continue
 bpy.ops.wm.open_mainfile(filepath=str(path))
 rig=next(o for o in bpy.context.scene.objects if o.type=='ARMATURE')
 meshes=[o for o in bpy.context.scene.objects if o.type=='MESH' and not o.hide_render]
 maximum=0;sample_count=0
 for name in ('SwimLoop','StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop'):
  action=bpy.data.actions[name];rig.animation_data.action=action
  start,end=action.frame_range
  for i in range(25):
   frame=start+(end-start)*i/24;bpy.context.scene.frame_set(math.floor(frame),subframe=frame%1)
   depsgraph=bpy.context.evaluated_depsgraph_get()
   for obj in meshes:
    evaluated=obj.evaluated_get(depsgraph);mesh=evaluated.to_mesh()
    maximum=max(maximum,max((evaluated.matrix_world@v.co).length for v in mesh.vertices));evaluated.to_mesh_clear()
   sample_count+=1
 results[path.parent.name]={'measuredRadius':maximum,'presentationRadius':maximum*1.10,'poseSamples':sample_count,'interpolationMargin':1.10}
 print(path.parent.name,maximum,flush=True)
(ROOT/'animation-bounds.json').write_text(json.dumps(results,indent=2))
