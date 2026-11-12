"""Blender 4.2 background: editable per-fish source, rig FBX and five Action FBXs."""
import bpy
import json
import math
from pathlib import Path
from mathutils import Matrix, Vector, Quaternion

ROOT=Path(__file__).resolve().parent
CONVERSION=Matrix(((1,0,0),(0,0,-1),(0,1,0)))


def create(path):
    data=json.loads(path.read_text());name=data['name']
    CLIPS=json.loads((ROOT/'motions'/(data['variant']+'.json')).read_text())['clips']
    out=ROOT/'models'/name;out.mkdir(parents=True,exist_ok=True)
    bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
    for action in list(bpy.data.actions):bpy.data.actions.remove(action)
    rig_data=bpy.data.armatures.new(name+'Skeleton');rig=bpy.data.objects.new(name+'Rig',rig_data)
    bpy.context.collection.objects.link(rig);bpy.context.view_layer.objects.active=rig;rig.select_set(True)
    bpy.ops.object.mode_set(mode='EDIT')
    length=data['bodySize'][2]
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
        shader=material.node_tree.nodes.get('Principled BSDF');color=p['color']
        obj.hide_render=p['original']['transparency']>=1
        shader.inputs['Alpha'].default_value=1-p['original']['transparency']
        texture=p['original'].get('texture','')
        if p.get('textureKey'):
            image_path=ROOT/'textures'/(p['textureKey']+'.png')
            tex=material.node_tree.nodes.new('ShaderNodeTexImage');tex.image=bpy.data.images.load(str(image_path),check_existing=True)
            multiply=material.node_tree.nodes.new('ShaderNodeMixRGB');multiply.blend_type='MULTIPLY';multiply.inputs[0].default_value=1;multiply.inputs[2].default_value=(*color,1)
            material.node_tree.links.new(tex.outputs['Color'],multiply.inputs[1]);material.node_tree.links.new(multiply.outputs[0],shader.inputs['Base Color'])
        else:
            shader.inputs['Base Color'].default_value=(*color,1)
            if p['original']['material']=='Neon':
                shader.inputs['Emission Color'].default_value=(*color,1);shader.inputs['Emission Strength'].default_value=.5
        shader.inputs['Roughness'].default_value=.6;mesh.materials.append(material)
    rig.animation_data_create();actions={}
    for clip_name,clip in CLIPS.items():
        action=bpy.data.actions.new(clip_name);action.use_fake_user=True;rig.animation_data.action=action
        for frame in clip['frames']:
            for index,bone in enumerate(data['bones']):
                bn=bone['name']
                matrix=frame['rotationMatrices'][bn]
                rotation=Matrix([matrix[i:i+3] for i in (0,3,6)])
                basis=rig_data.bones[bn].matrix_local.to_3x3();pose=rig.pose.bones[bn]
                pose.rotation_mode='QUATERNION';pose.rotation_quaternion=(basis.inverted()@CONVERSION@rotation@CONVERSION.inverted()@basis).to_quaternion()
                pose.keyframe_insert(data_path='rotation_quaternion',frame=frame['time']*80)
        for curve in (action.fcurves if hasattr(action,'fcurves') else [fc for layer in action.layers for strip in layer.strips for bag in strip.channelbags for fc in bag.fcurves]):
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
    for image in bpy.data.images:
        if image.source=='FILE':image.filepath='//../../textures/'+Path(image.filepath).name
    bpy.context.preferences.filepaths.save_version=0
    bpy.ops.wm.save_as_mainfile(filepath=str(out/(name+'.blend')))
    print('FISH_SOURCE_COMPLETE '+name,flush=True)


if __name__=='__main__':
    import sys
    wanted=set(sys.argv[sys.argv.index('--')+1:]) if '--' in sys.argv else set()
    for path in sorted((ROOT/'payload').glob('*.json')):
        if not wanted or path.stem in wanted:create(path)
