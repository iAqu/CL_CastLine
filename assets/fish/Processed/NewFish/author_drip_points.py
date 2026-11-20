"""Surface emission points on all visible material layers, using stable dominant bones."""
import json,math
from pathlib import Path
ROOT=Path(__file__).resolve().parent

def normalized(v):
 n=math.sqrt(sum(a*a for a in v));return [a/n for a in v] if n>1e-10 else None

def sample(candidates,count,size,spread_height=False):
 unique={tuple(round(x,5) for x in c['position']):c for c in candidates}
 candidates=list(unique.values());assert len(candidates)>=count,('Insufficient surface candidates',len(candidates),count)
 def dist(a,b):return sum(((a[i]-b[i])/max(size[i],.2))**2 for i in range(3))
 chosen=[min(candidates,key=lambda c:(c['position'][1],c['position'][2]))]
 if spread_height:
  chosen.append(max(candidates,key=lambda c:c['position'][1]))
 while len(chosen)<count:
  c=max(candidates,key=lambda c:min(dist(c['position'],p['position']) for p in chosen))
  assert min(dist(c['position'],p['position']) for p in chosen)>1e-10
  chosen.append(c)
 return chosen

import sys
wanted=set(sys.argv[1:])
rows=json.loads((ROOT/'drip-surface-points.json').read_text())['fish'] if wanted else {}
for path in sorted((ROOT/'payload').glob('*.json')):
 if wanted and path.stem not in wanted:continue
 d=json.loads(path.read_text());all_points=[]
 for p in d['parts']:
  if p['original']['transparency']>=1:continue
  vs=p['vertices'];normals=[[0,0,0] for v in vs]
  for face in p['faces']:
   a,b,c=[vs[i] for i in face[:3]];ab=[b[i]-a[i] for i in range(3)];ac=[c[i]-a[i] for i in range(3)]
   n=[ab[1]*ac[2]-ab[2]*ac[1],ab[2]*ac[0]-ab[0]*ac[2],ab[0]*ac[1]-ab[1]*ac[0]]
   for vi in face[:3]:normals[vi]=[normals[vi][a]+n[a] for a in range(3)]
  for i,(v,weights) in enumerate(zip(vs,p['weights'])):
   normal=normalized(normals[i])
   if not normal:continue
   ids,values=weights;which=max(range(len(values)),key=lambda j:values[j]);weight=values[which]
   if weight<.90:continue
   all_points.append({'position':[v[a]+p['center'][a] for a in range(3)],'normal':normal,'bone':d['bones'][ids[which]]['name'],'boneWeight':weight,'part':p['name']})
  # Native low-poly fish may have fewer than 16 underside vertices; sample actual triangle interiors.
  for face in p['faces']:
   ids=face[:3];a,b,c=[vs[vi] for vi in ids];ab=[b[j]-a[j] for j in range(3)];ac=[c[j]-a[j] for j in range(3)]
   normal=normalized([ab[1]*ac[2]-ab[2]*ac[1],ab[2]*ac[0]-ab[0]*ac[2],ab[0]*ac[1]-ab[1]*ac[0]])
   if not normal:continue
   for bary in ((1/3,1/3,1/3),(.6,.2,.2),(.2,.6,.2),(.2,.2,.6)):
    merged={}
    for vi,factor in zip(ids,bary):
     for bi,w in zip(*p['weights'][vi]):merged[bi]=merged.get(bi,0)+w*factor
    bi=max(merged,key=merged.get);weight=merged[bi]
    if weight<.9:continue
    point=[sum(vs[vi][j]*factor for vi,factor in zip(ids,bary))+p['center'][j] for j in range(3)]
    all_points.append({'position':point,'normal':normal,'bone':d['bones'][bi]['name'],'boneWeight':weight,'part':p['name']})
 lo=min(c['position'][2] for c in all_points);hi=max(c['position'][2] for c in all_points);span=hi-lo
 belly=[c for c in all_points if c['normal'][1]<-.12 and .08<(c['position'][2]-lo)/span<.80]
 if len(belly)<16:belly=[c for c in all_points if c['normal'][1]<.1]
 if d['family']=='dolphin':
  # Caught rolls local Y onto the screen's horizontal axis. Sample lower side surfaces
  # as well as the underside, rather than placing every point on one belly edge.
  floor=min(c['position'][1] for c in all_points)
  ceiling=floor+d['bodySize'][1]*.65
  belly=[c for c in all_points if c['normal'][1]<.5 and c['position'][1]<ceiling and .08<(c['position'][2]-lo)/span<.80]
 tail=[c for c in all_points if ((c['position'][2]-lo)/span<.35 if d['family']=='squid' else (c['position'][2]-lo)/span>.73)]
 if d['family']=='seahorse':
  belly=[c for c in all_points if c['position'][1]>-d['bodySize'][1]*.28 and c['normal'][1]<.5]
  tail=[c for c in all_points if c['position'][1]<-d['bodySize'][1]*.28]
 chosen=[]
 for region,candidates,count in [('Belly',belly,16),('Tail',tail,8)]:
  for i,c in enumerate(sample(candidates,count,d['bodySize'],d['family']=='dolphin' and region=='Belly'),1):
   center=d['parts'][0]['center'];position=[c['position'][a]-center[a] for a in range(3)]
   chosen.append({'name':region+f'{i:02d}','bone':c['bone'],'region':region.lower(),'bodyPosition':[position[a]+c['normal'][a]*.025 for a in range(3)],'surfacePosition':position,'bodyNormal':c['normal'],'boneWeight':c['boneWeight'],'sourcePart':c['part']})
 width=d['bodySize'][0];coverage=(max(p['bodyPosition'][0] for p in chosen)-min(p['bodyPosition'][0] for p in chosen))/width
 assert coverage>.25,(d['name'],'insufficient spread',coverage)
 rows[d['name']]={'name':d['name'],'primarySize':d['parts'][0]['size'],'points':chosen,'validation':{'count':24,'coverage':coverage,'minDominantWeight':min(p['boneWeight'] for p in chosen),'surfaceOffset':.025}}
 print(d['name'],round(coverage,2),flush=True)
temp=ROOT/'drip-surface-points.tmp';temp.write_text(json.dumps({'fish':rows},ensure_ascii=False,separators=(',',':')));temp.replace(ROOT/'drip-surface-points.json')
