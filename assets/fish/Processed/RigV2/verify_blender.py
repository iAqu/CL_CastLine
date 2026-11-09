"""Read back all source projects and check the editable rig, actions and packed textures."""
from pathlib import Path
import sys
import bpy

ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT))
from build import read,save,CLIPS,RATE

results={}
for entry in read('inventory.json')['rows']:
    name,key=entry['name'],entry['key']
    rig=read(f'payload/{key}/rig.json')
    bpy.ops.wm.open_mainfile(filepath=str(ROOT/f'models/{name}/{name}.blend'), load_ui=False)
    objects=list(bpy.context.scene.objects)
    armatures=[o for o in objects if o.type=='ARMATURE']
    meshes=[o for o in objects if o.type=='MESH']
    assert len(armatures)==1 and len(meshes)==len(rig['parts']),name
    assert {b.name for b in armatures[0].data.bones}=={b['name'] for b in rig['bones']},name
    assert bpy.context.scene.render.fps==RATE,name
    assert {a.name for a in bpy.data.actions}==set(CLIPS),name
    for action in bpy.data.actions:
        assert abs(action.frame_range[1]-CLIPS[action.name][0]*RATE)<1e-4,(name,action.name)
        assert action['SampleRate']==RATE,(name,action.name)
    for obj in meshes:
        assert len(obj.vertex_groups)==len(rig['bones']) and obj.modifiers[0].object==armatures[0],name
        assert obj.data.uv_layers and all(abs(sum(g.weight for g in v.groups)-1)<1e-5 for v in obj.data.vertices),name
    textures=[img for img in bpy.data.images if img.source=='FILE' and img.users>0]
    assert all(img.packed_file is not None for img in textures),name
    results[name]={'passed':True,'bones':len(armatures[0].data.bones),'meshes':len(meshes),
                   'actions':len(bpy.data.actions),'packedTextures':len(textures)}
save('blender-readback.json',{'passed':True,'fish':results})
