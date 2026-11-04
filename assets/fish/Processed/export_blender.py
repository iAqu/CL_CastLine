"""Blender 4.2 background: editable per-fish source, rig FBX and five Action FBXs."""
import bpy
import json
import math
from pathlib import Path
from mathutils import Matrix, Vector, Quaternion

ROOT=Path(__file__).resolve().parent
CLIPS=json.loads((ROOT.parent/'ElderFish/animation_clips.baked.json').read_text())['clips']
CONVERSION=Matrix(((1,0,0),(0,0,-1),(0,1,0)))


def create(path):
    data=json.loads(path.read_text());name=data['name']
    out=ROOT/'models'/name;out.mkdir(parents=True,exist_ok=True)
    bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
    for action in list(bpy.data.actions):bpy.data.actions.remove(action)
    rig_data=bpy.data.armatures.new(name+'Skeleton');rig=bpy.data.objects.new(name+'Rig',rig_data)
    bpy.context.collection.objects.link(rig);bpy.context.view_layer.objects.active=rig;rig.select_set(True)
    bpy.ops.object.mode_set(mode='EDIT')
    length=data['parts'][0]['size'][2]
    for bone in data['bones']:
        b=rig_data.edit_bones.new(bone['name']);b.head=CONVERSION@Vector(bone['position'])
        b.tail=b.head+Vector((0,-length*.08,0))
        if bone['parent']>=0:b.parent=rig_data.edit_bones[data['bones'][bone['parent']]['name']]
    bpy.ops.object.mode_set(mode='OBJECT')
    objects=[]
    for p in data['parts']:
        center=Vector(p['center'])
        mesh=bpy.data.meshes.new(p['name'])
        mesh.from_pydata([CONVERSION@(Vector(v)+center) for v in p['vertices']],[],[f[:3] for f in p['faces']]);mesh.update()
        obj=bpy.data.objects.new(p['name'],mesh);bpy.context.collection.objects.link(obj);objects.append(obj)
        uv=mesh.uv_layers.new(name='UVMap')
        for polygon,face in zip(mesh.polygons,p['faces']):
            for loop,ui in zip(polygon.loop_indices,face[3:6]):uv.data[loop].uv=p['uvs'][ui]
        groups=[obj.vertex_groups.new(name=b['name']) for b in data['bones']]
        for i,(ids,weights) in enumerate(p['weights']):
            for bi,w in zip(ids,weights):
                if w>0:groups[bi].add([i],w,'REPLACE')
        modifier=obj.modifiers.new('FishSkin','ARMATURE');modifier.object=rig;obj.parent=rig
        material=bpy.data.materials.new(name+'_'+p['name']);material.use_nodes=True
        shader=material.node_tree.nodes.get('Principled BSDF');color=p['original']['color']
        texture=p['original'].get('texture','')
        if texture:
            image_path=ROOT/'textures'/('Palette_Vivid.png' if texture=='rbxassetid://100058154460562' else 'Reef_Vivid.png')
            tex=material.node_tree.nodes.new('ShaderNodeTexImage');tex.image=bpy.data.images.load(str(image_path),check_existing=True)
            material.node_tree.links.new(tex.outputs['Color'],shader.inputs['Base Color'])
        else:
            import colorsys
            h,s,v=colorsys.rgb_to_hsv(*color);s+=.35*s*(1-s);v+=.2*(v-.5)*4*v*(1-v)
            color=colorsys.hsv_to_rgb(h,s,v);shader.inputs['Base Color'].default_value=(*color,1)
            if p['original']['material']=='Neon':
                shader.inputs['Emission Color'].default_value=(*color,1);shader.inputs['Emission Strength'].default_value=.5
        shader.inputs['Roughness'].default_value=.6;mesh.materials.append(material)
    rig.animation_data_create();actions={}
    for clip_name,clip in CLIPS.items():
        action=bpy.data.actions.new(clip_name);action.use_fake_user=True;rig.animation_data.action=action
        for frame in clip['frames']:
            for index,bone in enumerate(data['bones']):
                bn=bone['name']
                if index<5:
                    matrix=frame.get('rotationMatrices',{}).get(bn)
                    if matrix:rotation=Matrix([matrix[i:i+3] for i in (0,3,6)])
                    else:
                        rx,ry,rz=map(math.radians,frame['rotations'][bn]);rotation=Matrix.Rotation(rx,3,'X')@Matrix.Rotation(ry,3,'Y')@Matrix.Rotation(rz,3,'Z')
                    if data['variant']!='standard':rotation=Quaternion().slerp(rotation.to_quaternion(),.7).to_matrix()
                else:
                    phase=frame['time']/clip['duration'];envelope=1 if clip['loop'] else math.sin(math.pi*phase)
                    angle=math.radians(8 if data['variant']=='fins' else 14)*math.sin(2*math.pi*phase-(index-5)*.7)*envelope
                    rotation=Matrix.Rotation(angle*(-1 if index==5 else 1),3,'Z') if data['variant']=='fins' else Matrix.Rotation(angle,3,'Y')
                basis=rig_data.bones[bn].matrix_local.to_3x3();pose=rig.pose.bones[bn]
                pose.rotation_mode='QUATERNION';pose.rotation_quaternion=(basis.inverted()@CONVERSION@rotation@CONVERSION.inverted()@basis).to_quaternion()
                pose.keyframe_insert(data_path='rotation_quaternion',frame=frame['time']*80)
        for curve in action.fcurves:
            for point in curve.keyframe_points:
                point.interpolation='LINEAR' if clip.get('interpolation')=='Linear' else 'BEZIER'
                point.handle_left_type=point.handle_right_type='AUTO_CLAMPED'
            if clip['loop']:curve.modifiers.new('CYCLES')
        actions[clip_name]=action
    bpy.ops.object.select_all(action='DESELECT');rig.select_set(True)
    for obj in objects:obj.select_set(True)
    bpy.context.view_layer.objects.active=rig
    settings=dict(use_selection=True,object_types={'ARMATURE','MESH'},global_scale=1,apply_unit_scale=True,
                  apply_scale_options='FBX_SCALE_UNITS',axis_forward='Z',axis_up='Y',add_leaf_bones=False,
                  use_armature_deform_only=True,mesh_smooth_type='FACE',path_mode='RELATIVE')
    rig.animation_data.action=None
    for b in rig.pose.bones:b.rotation_quaternion=(1,0,0,0)
    bpy.context.view_layer.update()
    bpy.ops.export_scene.fbx(filepath=str(out/(name+'.fbx')),bake_anim=False,**settings)
    scene=bpy.context.scene;scene.render.fps=80;scene.frame_start=0
    for clip_name,clip in CLIPS.items():
        rig.animation_data.action=actions[clip_name];scene.frame_end=round(clip['duration']*80)
        bpy.ops.export_scene.fbx(filepath=str(out/(clip_name+'.fbx')),bake_anim=True,bake_anim_use_all_actions=False,
            bake_anim_use_nla_strips=False,bake_anim_simplify_factor=0,**settings)
    rig.animation_data.action=actions['SwimLoop'];scene.frame_end=50;scene.frame_set(0)
    bpy.ops.wm.save_as_mainfile(filepath=str(out/(name+'.blend')))
    print('FISH_SOURCE_COMPLETE '+name,flush=True)


if __name__=='__main__':
    for path in sorted((ROOT/'payload').glob('*.json')):
        create(path)
