"""Parse native OBJ using stable exported IDs; preserve every vertex/UV/normal."""
from pathlib import Path
import json,re,math
ROOT=Path(__file__).resolve().parent

def bounds(vertices,ids=None):
 points=vertices if ids is None else [vertices[i] for i in ids]
 lo=[min(v[a] for v in points) for a in range(3)];hi=[max(v[a] for v in points) for a in range(3)]
 return {'min':lo,'max':hi,'center':[(lo[a]+hi[a])*.5 for a in range(3)],'size':[hi[a]-lo[a] for a in range(3)]}

def components(part,weld=True):
 vertices=part['vertices'];parent=list(range(len(vertices)))
 def find(x):
  while parent[x]!=x:parent[x]=parent[parent[x]];x=parent[x]
  return x
 def union(a,b):parent[find(a)]=find(b)
 if weld:
  coords={}
  for i,v in enumerate(vertices):
   key=tuple(round(c,4) for c in v)
   if key in coords:union(i,coords[key])
   else:coords[key]=i
 for face in part['faces']:
  for v in face[1:]:union(face[0][0],v[0])
 groups={}
 for i in range(len(vertices)):groups.setdefault(find(i),[]).append(i)
 return list(groups.values())

def load():
 manifest=json.loads((ROOT/'source-manifest.json').read_text())
 mapping={re.sub('[^a-z0-9]','',p['exportKey'].lower())+'1':(f,p) for f in manifest['fish'] for p in f['parts']}
 vs=[];uvs=[];ns=[];groups=[];g=None
 for filename in ('AllRaceFish.obj','HiddenRaceParts.obj'):
  offsets=[len(vs),len(uvs),len(ns)]
  for line in (ROOT/'source'/filename).read_text().splitlines():
   s=line.split()
   if not s:continue
   if s[0]=='v':vs.append(list(map(float,s[1:4])))
   elif s[0]=='vt':uvs.append(list(map(float,s[1:3])))
   elif s[0]=='vn':ns.append(list(map(float,s[1:4])))
   elif s[0]=='g':g={'name':s[1],'faces':[]};groups.append(g)
   elif s[0]=='f':
    assert len(s)==4
    g['faces'].append([[int(i)-1+offsets[a] for a,i in enumerate(v.split('/'))] for v in s[1:]])
 result={}
 for g in groups:
  f,p=mapping[g['name'].lower()];maps=[{},{},{}];vals=[[],[],[]];faces=[]
  for face in g['faces']:
   corners=[]
   for corner in face:
    out=[]
    for axis,idx in enumerate(corner):
     if idx not in maps[axis]:maps[axis][idx]=len(vals[axis]);vals[axis].append((vs,uvs,ns)[axis][idx])
     out.append(maps[axis][idx])
    corners.append(out)
   faces.append(corners)
  result.setdefault(f['name'],{'source':f,'parts':[]})['parts'].append({'name':p['exportKey'],'original':p,'vertices':vals[0],'uvs':vals[1],'normals':vals[2],'faces':faces})
 for row in result.values():row['parts'].sort(key=lambda p:p['name'])
 assert len(result)==25 and sum(len(r['parts']) for r in result.values())==273
 return result

if __name__=='__main__':
 data=load();(ROOT/'source/parsed.json').write_text(json.dumps(data,separators=(',',':')))
 report={}
 for name,row in data.items():
  report[name]=[{'part':p['original']['name'],'id':p['name'],'bounds':bounds(p['vertices']), 'islands':[{'vertices':len(ids),'bounds':bounds(p['vertices'],ids)} for ids in components(p)]} for p in row['parts']]
 (ROOT/'source/components.json').write_text(json.dumps(report,indent=2))
 print('Parsed',len(data),'fish',sum(len(r['parts']) for r in data.values()),'parts',sum(len(p['vertices']) for r in data.values() for p in r['parts']),'vertices')
