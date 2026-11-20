"""Audit final authoring inputs and delivery files independently of publication jobs."""
import json,hashlib,math
from pathlib import Path
ROOT=Path(__file__).resolve().parent
manifest=json.loads((ROOT/'source-manifest.json').read_text());report=[]
for source in manifest['fish']:
 d=json.loads((ROOT/'payload'/(source['exportKey']+'.json')).read_text());n=d['name'];expected=len(d['bones']);assert 5<=expected<=8
 assert [b['name'] for b in d['bones'][:5]]==['FishBody','SpineFront','SpineMid','TailBase','FishTail']
 effective=set()
 for p in d['parts']:
  assert len(p['faces'])<=20000
  assert len(p['weights'])==len(p['vertices'])
  for ids,weights in p['weights']:
   assert abs(sum(weights)-1)<1e-7 and all(0<=w<=1 for w in weights);effective.update(i for i,w in zip(ids,weights) if w>1e-7)
  for face in p['faces']:
   assert all(0<=i<len(p['vertices']) for i in face[:3]) and all(0<=i<len(p['uvs']) for i in face[3:6])
 assert len(effective)==expected
 if d['eye']['eyes']:
  assert d['eye']['scale'] in (1.5,2) and len(d['eye']['eyes'])==2
  for eye in d['eye']['eyes']:assert max(abs(r-d['eye']['scale']) for r in eye['diameterRatios'])<1e-5
 else:assert n=='Swordfish Skeleton' and d['eye']['reason']
 files=[]
 for suffix in [n+'.blend',n+'.fbx','SwimLoop.fbx','StruggleLeft.fbx','StruggleRight.fbx','LiftFlop.fbx','ShowcaseFlop.fbx']:
  file=ROOT/'models'/n/suffix;assert file.stat().st_size>100
  files.append({'file':str(file.relative_to(ROOT)),'bytes':file.stat().st_size,'sha256':hashlib.sha256(file.read_bytes()).hexdigest()})
 report.append({'name':n,'eyeScale':d['eye']['scale'],'bones':expected,'layers':len(d['parts']),'files':files})
result={'passed':True,'fish':len(report),'sourceMeshes':manifest['partCount'],'publishedMeshes':sum(r['layers'] for r in report),'blendFiles':len(report),'fbxFiles':len(report)*6,'results':report}
(ROOT/'delivery-audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2));print({k:v for k,v in result.items() if k!='results'})
