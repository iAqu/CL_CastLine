"""Identify UV chart patches without welding eyes into the body across material seams."""
import json,math
from pathlib import Path
from PIL import Image
from inspect_source import bounds
ROOT=Path(__file__).resolve().parent
rows=json.loads((ROOT/'source/parsed.json').read_text());materials=json.loads((ROOT/'material-files.json').read_text());report={}
def charts(p):
 nodes={};parent=[];references=[]
 def find(a):
  while parent[a]!=a:parent[a]=parent[parent[a]];a=parent[a]
  return a
 for face in p['faces']:
  ids=[]
  for vi,ui,_ in face:
   key=tuple(round(x,4) for x in p['vertices'][vi])+tuple(round(x,5) for x in p['uvs'][ui])
   if key not in nodes:nodes[key]=len(parent);parent.append(len(parent));references.append(set())
   ni=nodes[key];references[ni].add(vi);ids.append(ni)
  for ni in ids[1:]:parent[find(ni)]=find(ids[0])
 groups={}
 for key,ni in nodes.items():groups.setdefault(find(ni),set()).update(references[ni])
 return list(groups.values())
for name,row in rows.items():
 vs=[v for p in row['parts'] if p['original']['transparency']<1 for v in p['vertices']];b=bounds(vs);c=b['center'];rot=b['size'][0]>b['size'][2] and name not in ('GreenTurtle','Turtle Walker')
 def cv(v):
  v=[v[a]-c[a] for a in range(3)]
  return [v[2],v[1],-v[0]] if rot else v
 length=max(b['size'][0],b['size'][2]);cs=[]
 for pi,p in enumerate(row['parts']):
  if p['original']['transparency']>=1:continue
  p['vertices']=[cv(v) for v in p['vertices']]
  for ids in charts(p):
   bb=bounds(p['vertices'],list(ids));size=bb['size'];cen=bb['center']
   if len(ids)>=3 and max(size)<length*.25 :
    cs.append({'part':pi,'refs':sorted(ids),'center':[round(x/length,4) for x in cen],'size':[round(x/length,4) for x in size],'vertices':len(ids)})
 cs.sort(key=lambda x:(x['center'][2],x['center'][1]));report[name]={'length':length,'center':c,'rotateX':rot,'charts':cs}
(ROOT/'source/eye-candidates.json').write_text(json.dumps(report))
for name,r in report.items():
 print(name,[(i,g['vertices'],g['center'],g['size']) for i,g in enumerate(r['charts']) if g['center'][0]>.015])
