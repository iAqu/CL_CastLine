"""Offline geometry and texture previews of native exports; never alters source assets."""
import bpy,json,math,sys
from pathlib import Path
from mathutils import Vector
ROOT=Path(__file__).resolve().parent
rows=json.loads((ROOT/'source/parsed.json').read_text())
bpy.ops.object.select_all(action='SELECT');bpy.ops.object.delete(use_global=False)
scene=bpy.context.scene;scene.render.engine='BLENDER_EEVEE';scene.render.resolution_x=320;scene.render.resolution_y=240;scene.render.resolution_percentage=100
scene.render.image_settings.file_format='PNG';scene.render.film_transparent=False
scene.world.color=(.18,.18,.18);scene.view_settings.view_transform='Standard'
scene.render.image_settings.color_mode='RGB'
camdata=bpy.data.cameras.new('QA');cam=bpy.data.objects.new('QA',camdata);scene.collection.objects.link(cam);scene.camera=cam;camdata.type='ORTHO'
for pos,power in [((5,8,-4),1500),((-4,5,3),1000)]:
 d=bpy.data.lights.new('QA_Light','AREA');d.energy=power;d.shape='DISK';d.size=8;o=bpy.data.objects.new('QA_Light',d);scene.collection.objects.link(o);o.location=pos;o.rotation_euler=(-o.location).to_track_quat('-Z','Y').to_euler()
(ROOT/'source/previews').mkdir(exist_ok=True)
for name,row in rows.items():
 allv=[v for p in row['parts'] if p['original']['transparency']<1 for v in p['vertices']];lo=[min(v[a] for v in allv) for a in range(3)];hi=[max(v[a] for v in allv) for a in range(3)];center=Vector([(a+b)/2 for a,b in zip(lo,hi)]);scale=6/max(hi[a]-lo[a] for a in range(3));flip=hi[0]-lo[0]>hi[2]-lo[2]
 objects=[]
 for p in row['parts']:
  if p['original']['transparency']>=1:continue
  vertices=[]
  for v in p['vertices']:
   q=(Vector(v)-center)*scale
   if flip:q=Vector((q.z,q.y,-q.x))
   vertices.append(Vector((q.x,-q.z,q.y)))
  mesh=bpy.data.meshes.new('QA');mesh.from_pydata(vertices,[],[[c[0] for c in f] for f in p['faces']]);mesh.update();obj=bpy.data.objects.new('QA',mesh);scene.collection.objects.link(obj);objects.append(obj)
  uv=mesh.uv_layers.new(name='UVMap')
  for poly,face in zip(mesh.polygons,p['faces']):
   for loop,corner in zip(poly.loop_indices,face):uv.data[loop].uv=p['uvs'][corner[1]]
  mat=bpy.data.materials.new('QA');mat.use_nodes=True;shader=mat.node_tree.nodes.get('Principled BSDF');shader.inputs['Base Color'].default_value=(*p['original']['color'],1);shader.inputs['Roughness'].default_value=.55
  material_files=json.loads((ROOT/'material-files.json').read_text());filename=material_files.get(p.get('material'),{}).get('map_Kd');matches=[ROOT/'source'/filename] if filename else []
  if matches:
   tex=mat.node_tree.nodes.new('ShaderNodeTexImage');tex.image=bpy.data.images.load(str(matches[0]),check_existing=True);mat.node_tree.links.new(tex.outputs['Color'],shader.inputs['Base Color'])
  obj.data.materials.append(mat)
 for view,position in [('side',(10,1,0)),('oblique',(8,5,-8))]:
  cam.location=position;cam.rotation_euler=(-cam.location).to_track_quat('-Z','Y').to_euler();camdata.ortho_scale=7.8;scene.render.filepath=str(ROOT/'source/previews'/(row['source']['exportKey']+'_'+view+'.png'));bpy.ops.render.render(write_still=True)
 for obj in objects:bpy.data.objects.remove(obj,do_unlink=True)
 print('PREVIEW',name,flush=True)
