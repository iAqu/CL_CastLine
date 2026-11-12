"""Blender 4.2: export editable v2 rigs and each action at the 120 Hz source cadence."""
import math
import sys
from pathlib import Path
import bpy
from mathutils import Matrix, Vector
import numpy as np

ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT))
from build import read, RATE

TO_BLENDER=Matrix(((1,0,0),(0,0,-1),(0,1,0)))
FROM_BLENDER=TO_BLENDER.inverted()

def material(part, name):
    mat=bpy.data.materials.new(name)
    mat.use_nodes=True
    nodes, links=mat.node_tree.nodes,mat.node_tree.links
    shader=nodes.get('Principled BSDF')
    rgba=(*part['color'],1)
    mat.diffuse_color=(*part['color'],1-part['transparency'])
    shader.inputs['Base Color'].default_value=rgba
    shader.inputs['Alpha'].default_value=1-part['transparency']
    vertex=nodes.new('ShaderNodeVertexColor')
    vertex.layer_name='SourceCornerColor'
    combine=nodes.new('ShaderNodeMixRGB')
    combine.blend_type='MULTIPLY'
    combine.inputs[0].default_value=1
    combine.inputs[2].default_value=rgba
    links.new(vertex.outputs['Color'],combine.inputs[1])
    color=combine.outputs[0]
    texture=part.get('texture','')
    if texture:
        mat['RobloxTextureId']=texture
        path=ROOT/'textures'/(texture.rsplit('/',1)[-1]+'.png')
        if path.exists():
            tex=nodes.new('ShaderNodeTexImage')
            tex.image=bpy.data.images.load(str(path),check_existing=True)
            if not tex.image.packed_file:tex.image.pack()
            tex.image.filepath='//../../textures/'+path.name
            overlay=nodes.new('ShaderNodeMixRGB')
            overlay.blend_type='MULTIPLY'
            overlay.inputs[0].default_value=1
            links.new(color,overlay.inputs[1])
            links.new(tex.outputs['Color'],overlay.inputs[2])
            color=overlay.outputs[0]
            alpha=nodes.new('ShaderNodeMath');alpha.operation='MULTIPLY'
            alpha.inputs[1].default_value=1-part['transparency']
            links.new(tex.outputs['Alpha'],alpha.inputs[0])
            links.new(alpha.outputs[0],shader.inputs['Alpha'])
    links.new(color,shader.inputs['Base Color'])
    if part['material']=='Neon':
        links.new(color,shader.inputs['Emission Color'])
        shader.inputs['Emission Strength'].default_value=.65
    mat['RobloxMaterial']=part['material']
    return mat

def create(entry, reader=read, output=None):
    key=entry['key'];data=reader(f'payload/{key}/rig.json')
    clips=reader(f"motions/{data['variant']}.json")['clips']
    name=data['name']
    out=output or ROOT/'models'/name;out.mkdir(parents=True,exist_ok=True)
    bpy.ops.wm.read_factory_settings(use_empty=True)
    rigdata=bpy.data.armatures.new(name+'Skeleton')
    rig=bpy.data.objects.new(name+'RigV2',rigdata)
    bpy.context.collection.objects.link(rig)
    bpy.context.view_layer.objects.active=rig;rig.select_set(True)
    rig['RigVersion']=2
    rig['LogicalBoneCount']=len(data['bones'])
    rig['OriginalMeshAssets']=';'.join(p['mesh'] for p in data['parts'])
    bpy.ops.object.mode_set(mode='EDIT')
    for b in data['bones']:
        joint=rigdata.edit_bones.new(b['name'])
        joint.head=TO_BLENDER@Vector(b['position'])
        joint.tail=joint.head+Vector((0,-max(data['bodySize'])*.045,0))
        if b['parent']>=0:
            joint.parent=rigdata.edit_bones[data['bones'][b['parent']]['name']]
    bpy.ops.object.mode_set(mode='OBJECT')
    scene=bpy.context.scene
    scene.render.fps=RATE
    scene.frame_start=0
    objects=[]
    for index,p in enumerate(data['parts'],1):
        source=reader(f'source/{key}/part{index:03}.json')
        weights=reader(f'payload/{key}/part{index:03}.json')
        frame=np.array(source['frame'])
        scale=np.array(source['size'])/np.maximum(source['meshSize'],1e-6)
        matrix=frame[3:].reshape(3,3)
        points=(np.array(source['vertices'])*scale)@matrix.T+frame[:3]
        mesh=bpy.data.meshes.new(source['name'])
        faces=source['faces']
        mesh.from_pydata([TO_BLENDER@Vector(v) for v in points],[],[f[:3] for f in faces])
        mesh.update()
        obj=bpy.data.objects.new(source['name'],mesh)
        bpy.context.collection.objects.link(obj)
        obj.hide_render=source['transparency']>=1
        obj['SourceMeshId']=source['mesh']
        objects.append(obj)
        uv=mesh.uv_layers.new(name='UVMap')
        color=mesh.color_attributes.new(name='SourceCornerColor', type='FLOAT_COLOR',domain='CORNER')
        normals=source['normals']
        converted=[(TO_BLENDER@Vector((np.array(n)/scale)@matrix.T)).normalized() for n in normals]
        loop_normals=[]
        for poly,f in zip(mesh.polygons,faces):
            poly.use_smooth=True
            for k,loop in enumerate(poly.loop_indices):
                uv.data[loop].uv=source['uvs'][f[3+k]]
                loop_normals.append(converted[f[6+k]])
                if len(f)>=12:
                    color.data[loop].color_srgb=source['colors'][f[9+k]]
                else:
                    color.data[loop].color=(1,1,1,1)
        if loop_normals:mesh.normals_split_custom_set(loop_normals)
        groups=[obj.vertex_groups.new(name=b['name']) for b in data['bones']]
        for vi in range(len(points)):
            for k in range(vi*4,vi*4+4):
                w=weights['weights'][k]
                if w:groups[weights['indices'][k]].add([vi],w,'REPLACE')
        modifier=obj.modifiers.new('RigV2Skin','ARMATURE')
        modifier.object=rig
        obj.parent=rig
        mesh.materials.append(material(source,name+'_'+source['name']))
    source_rig=reader(f'source/{key}/rig.json')
    drip_by_name={p['name']:p['bone'] for p in data['drip']}
    for name_point,point,joint in [('MouthAttachment',data['mouth'],'FishBody')]+[
        (p['name'],p['position'],drip_by_name[p['name']]) for p in source_rig['drip']
    ]:
        empty=bpy.data.objects.new(name_point,None)
        bpy.context.collection.objects.link(empty)
        empty.empty_display_type='PLAIN_AXES'
        empty.empty_display_size=.06
        empty.parent,empty.parent_type,empty.parent_bone=rig,'BONE',joint
        empty.matrix_world.translation=TO_BLENDER@Vector(point)
    rig.animation_data_create()
    actions={}
    for name_clip,clip in clips.items():
        action=bpy.data.actions.new(name_clip);action.use_fake_user=True
        action['SampleRate']=RATE
        rig.animation_data.action=action
        prior={}
        for frame in clip['frames']:
            for bone in data['bones']:
                n=bone['name'];m=frame['rotationMatrices'][n]
                rotation=Matrix([m[i:i+3] for i in (0,3,6)])
                basis=rigdata.bones[n].matrix_local.to_3x3()
                q=(basis.inverted()@TO_BLENDER@rotation@FROM_BLENDER@basis).to_quaternion()
                if n in prior and q.dot(prior[n])<0:q.negate()
                prior[n]=q.copy()
                pose=rig.pose.bones[n]
                pose.rotation_mode='QUATERNION'
                pose.rotation_quaternion=q
                pose.keyframe_insert(data_path='rotation_quaternion',frame=round(frame['time']*RATE))
        for curve in action.fcurves:
            for keyframe in curve.keyframe_points:keyframe.interpolation='LINEAR'
            if clip['loop']:curve.modifiers.new('CYCLES')
        actions[name_clip]=action
    bpy.ops.object.select_all(action='DESELECT')
    rig.select_set(True)
    for obj in objects:obj.select_set(True)
    bpy.context.view_layer.objects.active=rig
    settings=dict(use_selection=True,object_types={'ARMATURE','MESH'},global_scale=1,
                  apply_unit_scale=True,apply_scale_options='FBX_SCALE_UNITS',axis_forward='Z',axis_up='Y',
                  add_leaf_bones=False,use_armature_deform_only=True,mesh_smooth_type='FACE',path_mode='COPY',
                  embed_textures=True)
    rig.animation_data.action=None
    for pose in rig.pose.bones:pose.rotation_quaternion=(1,0,0,0)
    bpy.context.view_layer.update()
    bpy.ops.export_scene.fbx(filepath=str(out/(name+'.fbx')),bake_anim=False,**settings)
    for name_clip,clip in clips.items():
        rig.animation_data.action=actions[name_clip]
        scene.frame_end=round(clip['duration']*RATE)
        bpy.ops.export_scene.fbx(filepath=str(out/(name_clip+'.fbx')),bake_anim=True,
            bake_anim_use_all_actions=False,bake_anim_use_nla_strips=False,bake_anim_simplify_factor=0,**settings)
    rig.animation_data.action=actions['SwimLoop']
    scene.frame_end=75;scene.frame_set(0)
    bpy.context.preferences.filepaths.save_version=0
    bpy.ops.wm.save_as_mainfile(filepath=str(out/(name+'.blend')))
    print('RIGV2_SOURCE_COMPLETE',name,flush=True)

if __name__=='__main__':
    options=sys.argv[sys.argv.index('--')+1:] if '--' in sys.argv else []
    for entry in read('inventory.json')['rows']:
        if '--pilots' in options and not entry.get('pilot'):continue
        if '--only' in options and entry['name'] not in options[options.index('--only')+1:]:continue
        if not (ROOT/f"payload/{entry['key']}/rig.json").exists():continue
        if '--force' not in options and (ROOT/f"models/{entry['name']}/{entry['name']}.blend").exists():continue
        create(entry)
