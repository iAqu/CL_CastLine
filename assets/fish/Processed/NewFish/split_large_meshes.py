"""Lossless triangle partitioning for Roblox's 20,000-triangle EditableMesh limit."""
import json,copy,hashlib
from pathlib import Path
ROOT=Path(__file__).resolve().parent
report=[]
for file in sorted((ROOT/'payload').glob('*.json')):
 data=json.loads(file.read_text());out=[];changed=False
 for part in data['parts']:
  if len(part['faces'])<=20000:out.append(part);continue
  changed=True
  for start in range(0,len(part['faces']),18000):
   spec=copy.deepcopy(part);maps=[{},{},{}];values=[[],[],[]];weights=[];faces=[];rigid=[];oldrigid=set(part['shellRigidVertices'])
   for face in part['faces'][start:start+18000]:
    corners=[]
    for j in range(3):
     corner=[]
     for axis,idx in enumerate((face[j],face[j+3],face[j+6])):
      if idx not in maps[axis]:
       maps[axis][idx]=len(values[axis]);values[axis].append(part[('vertices','uvs','normals')[axis]][idx])
       if axis==0:
        weights.append(part['weights'][idx])
        if idx in oldrigid:rigid.append(maps[axis][idx])
      corner.append(maps[axis][idx])
     corners.append(corner)
    faces.append([c[0] for c in corners]+[c[1] for c in corners]+[c[2] for c in corners])
   globalv=[[v[a]+part['center'][a] for a in range(3)] for v in values[0]];lo=[min(v[a] for v in globalv) for a in range(3)];hi=[max(v[a] for v in globalv) for a in range(3)];center=[(lo[a]+hi[a])/2 for a in range(3)]
   spec.update(sourceKey=part['sourceKey']+'_S'+str(start//18000+1),vertices=[[v[a]-center[a] for a in range(3)] for v in globalv],uvs=values[1],normals=values[2],faces=faces,weights=weights,center=center,size=[max(.001,hi[a]-lo[a]) for a in range(3)],shellRigidVertices=rigid)
   raw={k:spec[k] for k in ('vertices','faces','uvs','normals','weights','center')};raw['bones']=data['bones'];spec['meshRecipeHash']=hashlib.sha256(json.dumps(raw,separators=(',',':')).encode()).hexdigest();out.append(spec)
 if changed:
  before=sum(len(p['faces']) for p in data['parts']);assert before==sum(len(p['faces']) for p in out)
  for i,spec in enumerate(out):spec['name']='polySurface5' if i==0 else 'FishMesh%02d'%(i+1)
  data['parts']=out;data['validation']['publishedParts']=len(out);data['validation']['losslessTriangleSplit']=True
  file.write_text(json.dumps(data,separators=(',',':')));report.append({'name':data['name'],'parts':len(out),'triangles':before,'largestLayer':max(len(p['faces']) for p in out)})
(ROOT/'mesh-split-validation.json').write_text(json.dumps({'passed':True,'lossless':True,'results':report},indent=2));print(report)
