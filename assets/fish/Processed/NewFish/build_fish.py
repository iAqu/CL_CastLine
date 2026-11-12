"""Reproducible canonical geometry, enlarged eyes and coherent 5–8 joint skins."""
import json,math,copy,colorsys,hashlib
from pathlib import Path
from inspect_source import bounds,components
ROOT=Path(__file__).resolve().parent
BASE=['FishBody','SpineFront','SpineMid','TailBase','FishTail']
def smooth(t):t=max(0,min(1,t));return t*t*(3-2*t)
def norm(v):
 d=math.sqrt(sum(x*x for x in v));return [x/d for x in v] if d>1e-12 else [0,1,0]
def grade(c):
 h,s,v=colorsys.rgb_to_hsv(*c);s+=.35*s*(1-s);v+=.2*(v-.5)*4*v*(1-v);return list(colorsys.hsv_to_rgb(h,s,v))
def nearest_segment(v,a,b):
 ab=[b[i]-a[i] for i in range(3)];t=max(0,min(1,sum((v[i]-a[i])*ab[i] for i in range(3))/max(1e-12,sum(x*x for x in ab))));q=[a[i]+t*ab[i] for i in range(3)];return sum((v[i]-q[i])**2 for i in range(3)),t

def subdivide_patch(p,targets,radius,length):
 # Add local resolution for texture-painted eyes; interpolate UVs exactly on the original triangles.
 for level in range(2):
  result=[];cache={}
  def midpoint(a,b):
   k=tuple(sorted((tuple(a),tuple(b))))
   if k in cache:return cache[k]
   vi=len(p['vertices']);ui=len(p['uvs']);ni=len(p['normals'])
   p['vertices'].append([(p['vertices'][a[0]][j]+p['vertices'][b[0]][j])/2 for j in range(3)])
   p['uvs'].append([(p['uvs'][a[1]][j]+p['uvs'][b[1]][j])/2 for j in range(2)])
   p['normals'].append(norm([(p['normals'][a[2]][j]+p['normals'][b[2]][j])/2 for j in range(3)]));cache[k]=[vi,ui,ni];return cache[k]
  for face in p['faces']:
   vs=[p['vertices'][c[0]] for c in face];center=[sum(v[a] for v in vs)/3 for a in range(3)]
   if any(math.hypot(center[1]-t[1],center[2]-t[2])<radius*3 and abs(center[0]-t[0])<length*.08 for t in targets):
    a,b,c=face;ab=midpoint(a,b);bc=midpoint(b,c);ca=midpoint(c,a);result.extend([[a,ab,ca],[ab,b,bc],[ca,bc,c],[ab,bc,ca]])
   else:result.append(face)
  p['faces']=result

def enlarge(parts,profile,info,length):
 mode=profile['eyeMode'];factor=profile['eyeScale'] or 2;regions=[];centers=[]
 if mode=='none':return {'scale':1,'eyes':[],'reason':profile['eyeReason']},set()
 if mode=='charts':
  charts=info['charts'];selected=charts[profile['chartIndex']];target=selected['center'];pi=selected['part']
  if profile['name']=='Axolotl':selected_charts=[charts[0],charts[1]]
  else:
   other=min((c for c in charts if c['center'][0]*target[0]<0),key=lambda c:(c['center'][1]-target[1])**2+(c['center'][2]-target[2])**2)
   selected_charts=[selected,other]
  for c in selected_charts:
   # Include socket and pupil charts sharing the same eye center.
   refs={(c['part'],i) for i in c['refs']};diam=max(c['size'][1:])
   for ch in charts:
    if ch is c:continue
    if ch['center'][0]*c['center'][0]>0 and math.hypot(ch['center'][1]-c['center'][1],ch['center'][2]-c['center'][2])<diam*.15 and max(ch['size'][1:])<diam*1.4:
     refs.update((ch['part'],i) for i in ch['refs'])
   regions.append(sorted(refs))
 elif mode=='components':
  pi=next(i for i,p in enumerate(parts) if p['original']['name']==profile['eyePart'])
  regions=[[(pi,i) for i in ids] for ids in components(parts[pi]) if profile['eyeComponentMin']<=len(ids)<=profile['eyeComponentMax']]
  assert len(regions)==2,(profile['name'],len(regions))
 else:
  y,z,r=profile['eyePatch'];y*=length;z*=length;r*=length
  if profile['flip']:z=-z
  for sign in (-1,1):
   candidates=[(pi,i,v) for pi,p in enumerate(parts) if p['original']['transparency']<1 for i,v in enumerate(p['vertices']) if v[0]*sign>length*.01]
   pi,vi,v=min(candidates,key=lambda item:((item[2][1]-y)**2+(item[2][2]-z)**2))
   centers.append([v[0],y,z])
  for p in parts:
   if p['original']['transparency']<1:subdivide_patch(p,centers,r,length)
  for center in centers:
   refs=[(pi,i) for pi,p in enumerate(parts) if p['original']['transparency']<1 for i,v in enumerate(p['vertices']) if v[0]*center[0]>0 and math.hypot(v[1]-y,v[2]-z)<r*.7 and abs(v[0]-center[0])<r*1.4]
   assert len(refs)>=3,(profile['name'],'insufficient eye patch',len(refs));regions.append(refs)
 baseline=[copy.deepcopy(p['vertices']) for p in parts];eye_refs=set();report=[]
 for region in regions:
  b=bounds([baseline[pi][i] for pi,i in region]);center=b['center'];radius=max(b['size'][1:])*.58;selected=set(region);coords={tuple(round(x,5) for x in baseline[pi][i]) for pi,i in region};eye_refs.update(selected)
  sign=1 if center[0]>0 else -1
  for pi,p in enumerate(parts):
   for vi,v in enumerate(baseline[pi]):
    if v[0]*sign<=0:continue
    exact=(pi,vi) in selected or tuple(round(x,5) for x in v) in coords
    influence=1 if exact else (1-smooth((math.hypot(v[1]-center[1],v[2]-center[2])-radius)/(radius*.85)))*(1-smooth((abs(v[0]-center[0])-radius*.3)/(radius*1.8)))
    if influence:p['vertices'][vi]=[v[a]+influence*((v[a]-center[a])*(factor-1)+(length*.0015*sign if a==0 else 0)) for a in range(3)]
  after=bounds([parts[pi]['vertices'][i] for pi,i in region]);ratios=[after['size'][a]/b['size'][a] for a in (1,2) if b['size'][a]>1e-9]
  assert ratios and max(abs(x-factor) for x in ratios)<1e-6,(profile['name'],ratios)
  report.append({'center':center,'beforeSize':b['size'],'diameterRatios':ratios,'vertices':len(region)})
 return {'scale':factor,'eyes':report,'mode':mode},eye_refs

def build(name,row,profiles,candidates,textures):
 profile=profiles[name];info=candidates[name];parts=copy.deepcopy(row['parts']);origin=info['center'];rotate=profile['rotateX'];flip=profile['flip'];family=profile['family']
 def canonical(v,point=True):
  q=[v[a]-(origin[a] if point else 0) for a in range(3)];q=[q[2],q[1],-q[0]] if rotate else q
  return [-q[0],q[1],-q[2]] if flip else q
 for p in parts:p['vertices']=[canonical(v) for v in p['vertices']];p['normals']=[canonical(v,False) for v in p['normals']]
 vb=bounds([v for p in parts if p['original']['transparency']<1 for v in p['vertices']]);width,height,length=vb['size'];lo,hi=vb['min'],vb['max']
 shell_refs=set()
 if name=='GreenTurtle':
  for pi,p in enumerate(parts):
   for ids in components(p):
    if len(ids)==290:shell_refs.update((pi,i) for i in ids)
 if name=='Turtle Walker':
  for pi,p in enumerate(parts):
   if p['original']['name']=='turtle guns':shell_refs.update((pi,i) for i in range(len(p['vertices'])))
   if p['original']['name']=='turtlebod':
    for ids in components(p):
     if len(ids)==1486:shell_refs.update((pi,i) for i in ids)
 eye,eye_refs=enlarge(parts,profile,info,length)
 eyez=max((parts[pi]['vertices'][vi][2] for pi,vi in eye_refs),default=lo[2]+length*.22)
 head_end=max(.25,min(.65,(eyez-lo[2])/length+.025)) if family not in ('seahorse','lobster') else .28
 if family=='jellyfish':head_end=.43
 anchors=[head_end,head_end+(1-head_end)*.23,head_end+(1-head_end)*.50,head_end+(1-head_end)*.75,.985]
 pivots=[.5,max(.28,head_end+.015),head_end+(1-head_end)*.28,head_end+(1-head_end)*.55,head_end+(1-head_end)*.80]
 bones=[{'name':n,'parent':i-1,'position':[0,0,0 if i==0 else lo[2]+length*pivots[i]]} for i,n in enumerate(BASE)]
 if family=='longbody':
  names=BASE+['TailExtra1','TailExtra2','TailExtra3'];anchors=[head_end+(1-head_end)*i/7 for i in range(8)];anchors[-1]=.99
  bones=[{'name':n,'parent':i-1,'position':[0,0,0 if i==0 else lo[2]+length*(head_end+(1-head_end)*(i-.5)/7)]} for i,n in enumerate(names)]
 if family=='seahorse':
  names=BASE+['TailExtra1','TailExtra2','TailExtra3'];positions=[[0,height*.28,0],[0,height*.18,length*.04],[0,0,length*.08],[0,-height*.18,length*.10],[0,-height*.32,length*.12],[0,-height*.43,length*.06],[0,-height*.44,-length*.05],[0,-height*.36,-length*.10]]
  legacy={b['name']:canonical(b['world'][:3]) for b in row['source']['legacyBones']}
  chosen=['HEAD','SPINE2','SPINE4','SPINE6','SPINE7','SPINE8','SPINE10','SPINE_end']
  positions=[legacy.get(b,positions[i]) for i,b in enumerate(chosen)]
  bones=[{'name':n,'parent':i-1,'position':positions[i]} for i,n in enumerate(names)]
 extras={'fins':[('FinLeft',[-width*.10,0,0]),('FinRight',[width*.10,0,0])],
 'turtle':[('FinLeft',[-width*.12,-height*.12,-length*.12]),('FinRight',[width*.12,-height*.12,-length*.12]),('RearFins',[0,-height*.12,length*.20])],
 'lobster':[('ClawLeft',[-width*.12,0,-length*.18]),('ClawRight',[width*.12,0,-length*.18]),('TailExtra1',[0,0,length*.40])],
 'axolotl':[('LegsLeft',[-width*.12,0,0]),('LegsRight',[width*.12,0,0]),('GillGroup',[0,height*.10,-length*.22])],
 'jellyfish':[('TentacleLeft',[-width*.10,0,0]),('TentacleMid',[0,0,0]),('TentacleRight',[width*.10,0,0])]}
 for bn,pos in extras.get(family,[]):bones.append({'name':bn,'parent':2,'position':pos})
 # Mouth uses body geometry, excluding long weapons and ornaments.
 visible=[p for p in parts if p['original']['transparency']<1]
 main=max(visible,key=lambda p:math.prod(bounds(p['vertices'])['size']))
 if name=='Turtle Walker':main=next(p for p in parts if p['original']['name']=='turtlebod')
 if name=='Saberfish':main=next(p for p in parts if p['original']['name']=='narw')
 if name=='Swordfish Skeleton':
  target=[0,-height*.05,-length*.17];mouth=min(main['vertices'],key=lambda v:sum((v[a]-target[a])**2 for a in range(3)));mouth=[0,mouth[1],mouth[2]]
 else:
  front=min(v[2] for v in main['vertices']);points=[v for v in main['vertices'] if v[2]<front+length*.009];mouth=[sum(v[a] for v in points)/len(points) for a in range(3)]
 output=[];effective=set();eye_part_keys={parts[pi]['name'] for pi,_ in eye_refs}
 for pi,p in enumerate(parts):
  weights=[];rigid=[]
  for vi,v in enumerate(p['vertices']):
   along=(v[2]-lo[2])/length
   if family=='seahorse':
    choices=[(*nearest_segment(v,bones[i]['position'],bones[i+1]['position']),i) for i in range(7)];_,alpha,segment=min(choices);alpha=smooth(alpha)
   else:
    segment=0
    while segment<len(anchors)-2 and along>anchors[segment+1]:segment+=1
    alpha=smooth((along-anchors[segment])/(anchors[segment+1]-anchors[segment]))
   ids=[segment,segment+1];values=[1-alpha,alpha]
   if family=='fins':
    amount=smooth((abs(v[0])-width*.11)/(width*.31));bi=5 if v[0]<0 else 6
    ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   if family=='turtle':
    amount=smooth((abs(v[0])-width*.13)/(width*.20));bi=7 if along>.65 else 5 if v[0]<0 else 6
    ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   if family=='lobster':
    if along<.42:bi=5 if v[0]<0 else 6;amount=smooth((abs(v[0])-width*.10)/(width*.22))
    else:bi=7;amount=smooth((along-.72)/.22)
    ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   if family=='axolotl':
    bi=7 if along<.38 else 5 if v[0]<0 else 6;amount=smooth((abs(v[0])-width*.15)/(width*.27))*.85
    ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   if family=='jellyfish' and along>head_end:
    bi=5 if v[0]<-width*.10 else 7 if v[0]>width*.10 else 6;amount=.8*smooth((along-head_end)/.22)
    ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   fixed=(family=='seahorse' and v[1]>height*.25) or (family!='seahorse' and along<=head_end)
   if (pi,vi) in eye_refs or fixed:ids,values=[0],[1]
   if (pi,vi) in shell_refs:ids,values=[2],[1];rigid.append(vi)
   merged={}
   for bi,w in zip(ids,values):
    if w>1e-9:merged[bi]=merged.get(bi,0)+w
   ids=list(merged);values=list(merged.values());assert abs(sum(values)-1)<1e-7;weights.append([ids,values]);effective.update(ids)
  b=bounds(p['vertices']);center=b['center'];normals=[];faces=[]
  for face in p['faces']:
   a,bv,c=[p['vertices'][v[0]] for v in face];ab=[bv[i]-a[i] for i in range(3)];ac=[c[i]-a[i] for i in range(3)];n=norm([ab[1]*ac[2]-ab[2]*ac[1],ab[2]*ac[0]-ab[0]*ac[2],ab[0]*ac[1]-ab[1]*ac[0]]);ni=len(normals);normals.append(n);faces.append([v[0] for v in face]+[v[1] for v in face]+[ni]*3)
  texture=textures['parts'].get(p['name']) if p['original']['texture'] else None
  spec={'name':p['name'],'original':p['original'],'sourceKey':p['name'],'center':center,'size':[max(.001,x) for x in b['size']],'vertices':[[v[a]-center[a] for a in range(3)] for v in p['vertices']],'uvs':p['uvs'],'normals':normals,'faces':faces,'weights':weights,'color':p['original']['color'] if texture else grade(p['original']['color']),'textureKey':texture['file'][:-4] if texture else None,'shellRigidVertices':rigid}
  raw={k:spec[k] for k in ('vertices','faces','uvs','normals','weights','center')};raw['bones']=bones;spec['meshRecipeHash']=hashlib.sha256(json.dumps(raw,separators=(',',':')).encode()).hexdigest();output.append(spec)
 assert len(effective)==len(bones),(name,'unused bones',effective)
 output.sort(key=lambda p:p['sourceKey']!=main['name'])
 for i,p in enumerate(output):p['name']='polySurface5' if i==0 else 'FishMesh%02d'%(i+1)
 radius=None
 if (ROOT/'animation-bounds.json').exists():radius=json.loads((ROOT/'animation-bounds.json').read_text()).get(name,{}).get('presentationRadius')
 return {'name':name,'key':row['source']['exportKey'],'family':family,'variant':'new_'+family,'eye':eye,'bones':bones,'parts':output,'mouth':mouth,'bodySize':vb['size'],'presentationRadius':radius,'sourceOrigin':origin,'sourceRotateX':rotate,'sourceFlipped':flip,'weightAnchors':anchors,'headEnd':head_end,'validation':{'uvUnchanged':True,'weightsNormalized':True,'rigidEyes':True,'logicalBones':len(bones),'parts':len(parts),'vertices':sum(len(p['vertices']) for p in parts),'shellRigidVertices':len(shell_refs)}}

if __name__=='__main__':
 rows=json.loads((ROOT/'source/parsed.json').read_text());profiles=json.loads((ROOT/'profiles.json').read_text());candidates=json.loads((ROOT/'source/eye-candidates.json').read_text());textures=json.loads((ROOT/'texture-manifest.json').read_text());(ROOT/'payload').mkdir(exist_ok=True);reports=[]
 for name,row in sorted(rows.items()):
  data=build(name,row,profiles,candidates,textures);(ROOT/'payload'/(data['key']+'.json')).write_text(json.dumps(data,separators=(',',':')));reports.append({k:v for k,v in data.items() if k!='parts'});print(name,data['eye']['scale'],len(data['bones']),flush=True)
 (ROOT/'build-validation.json').write_text(json.dumps(reports,ensure_ascii=False,indent=2))
