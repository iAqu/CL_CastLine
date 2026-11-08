"""Author current-size canonical fish, full eyes, coherent skins, and measured parameters."""
import json,math,copy,colorsys,hashlib
from pathlib import Path
from inspect_source import ROOT,bounds,components
BASE=['FishBody','SpineFront','SpineMid','TailBase','FishTail']
PROFILES={
 '1_鲨鱼_01_00':('shark','shayu_01_07',['shayu_01_08','shayu_01_09'],'shayu_01_05'),
 '1_鲨鱼_02_00':('shark','shayu_02_09',['shayu_02_04','shayu_02_06'],'shayu_02_11'),
 '1_鲨鱼_03_00':('shark','shayu_03_00',['shayu_03_08'],'shayu_03_01'),
 '1_鲨鱼_04_00':('shark','shayu_04_08',['shayu_04_06','shayu_04_07'],'shayu_04_08'),
 'HaiGui_01_00':('turtle','HaiGui_01_00',['HaiGui_01_06'],'HaiGui_01_11'),
 'HaiGui_02_00':('turtle','HaiGui_02_07',['HaiGui_02_02'],'HaiGui_02_05'),
 'HaiGui_03_00':('turtle','HaiGui_03_00',['HaiGui_03_07'],'HaiGui_03_08'),
 'HaiGui_04_00':('turtle','HaiGui_04_12',['HaiGui_04_08'],'HaiGui_04_09'),
 'HaiMan_01_00':('eel','HaiMan_01_11',['HaiMan_01_03'],'HaiMan_01_05'),
 'SXYu_01_00':('ornate','SXYu_13',['SXYu_02','SXYu_03'],'SXYu_13'),
 'YaoYu_01_00':('ray','YaoYu_01_08',['YaoYu_01_01','YaoYu_01_02'],'YaoYu_01_00'),
 'YaoYu_02_00':('ray','YaoYu_02_08',['YaoYu_02_05'],'YaoYu_02_04'),
 'YaoYu_03_00':('ray','YaoYu_03_05',['YaoYu_03_04'],'YaoYu_03_05'),
 'YaoYu_04_00':('ray','YaoYu_04_08',['YaoYu_04_03'],'YaoYu_04_08'),
 'YouYu_01_00':('squid','YouYu_02',['YouYu_05'],'YouYu_02'),
 'YouYu_02_00':('squid','YouYu_02_01',['YouYu_02_07','YouYu_02_08'],'YouYu_02_23'),
 '付费_01_00':('shark','付费_01_08',['付费_01_07'],'付费_01_01'),
 '付费_02_00':('shark','付费_02_03',['付费_02_10'],'付费_02_11'),
 '付费_03_00':('shark','付费_03_07',['付费_03_08'],'付费_03_01'),
 '付费_04_00':('shark','付费_04_01',['付费_04_12'],'付费_04_05'),
 '初始_00_00':('shark','初始_00_10',['初始_00_04','初始_00_08'],'初始_00_05'),
 '海豚1-0':('dolphin','haitun_01_05',['haitun_01_04'],'haitun_01_02'),
 '海豚2-0':('dolphin','haitun_02_01',['haitun_02_03'],'haitun_02_10'),
 '海豚3-0':('dolphin','haitun_03_00',['haitun_03_03'],'haitun_03_04'),
 '海豚4-0':('dolphin','haitun_04_01',['haitun_04_00'],'haitun_04_05'),
}
def smooth(v):v=max(0,min(1,v));return v*v*(3-2*v)
def normalize(v):
 n=math.sqrt(sum(x*x for x in v));return [x/n for x in v] if n>1e-12 else [0,1,0]
def distance(a,b):return math.sqrt(sum((a[i]-b[i])**2 for i in range(3)))
def grade(c):
 h,s,v=colorsys.rgb_to_hsv(*c);s+=.35*s*(1-s);v+=.2*(v-.5)*4*v*(1-v)
 return list(colorsys.hsv_to_rgb(h,s,v))

def eyes(parts,eye_names,family,length):
 # First combine matching socket/pupil islands; six-eyed creatures retain six separate eyes.
 candidates=[]
 for pi,p in enumerate(parts):
  if p['original']['name'] in eye_names:
   for ids in components(p):
    b=bounds(p['vertices'],ids)
    if len(ids)>=3:candidates.append({'refs':[(pi,i) for i in ids],'bounds':b,'diameter':max(b['size'][1:])})
 candidates.sort(key=lambda e:-e['diameter'])
 groups=[]
 for candidate in candidates:
  target=next((g for g in groups if distance(g['bounds']['center'],candidate['bounds']['center'])<g['diameter']*.7),None)
  if target:target['refs']+=candidate['refs']
  else:groups.append(candidate)
 assert groups,'No eye geometry'
 repair=False
 if len(groups)==1:
  # The saw-ray source contains only one eye; restore the matching opposite eye in the same material.
  assert len(eye_names)==1
  pi=groups[0]['refs'][0][0];p=parts[pi];offset=len(p['vertices']);old=copy.deepcopy(p)
  p['vertices'] += [[-v[0],v[1],v[2]] for v in old['vertices']]
  for face in old['faces']:
   p['faces'].append([[c[0]+offset,c[1],c[2]] for c in reversed(face)])
  groups.append({'refs':[(pi,i+offset) for _,i in groups[0]['refs']],'bounds':bounds(p['vertices'],[i+offset for _,i in groups[0]['refs']]),'diameter':groups[0]['diameter']})
  repair=True
 assert len(groups)%2==0
 for g in groups:
  g['bounds']=bounds([parts[pi]['vertices'][vi] for pi,vi in g['refs']]);g['diameter']=max(g['bounds']['size'][1:])
 factor=1.5 if family in ('turtle','squid','ornate') or max(g['diameter'] for g in groups)/length>.065 else 2
 baseline=[copy.deepcopy(p['vertices']) for p in parts]
 centers=[g['bounds']['center'] for g in groups]
 clusters={side:[c for c in centers if (c[0]>0)==side] for side in (False,True)}
 ref_map={ref:gi for gi,g in enumerate(groups) for ref in g['refs']}
 # Preserve every duplicate at seams in any layer.
 coordinate_map={tuple(round(x,4) for x in baseline[pi][vi]):gi for gi,g in enumerate(groups) for pi,vi in g['refs']}
 displacements=[]
 for gi,g in enumerate(groups):
  c=g['bounds']['center'];cluster=clusters[c[0]>0]
  middle=[sum(v[a] for v in cluster)/len(cluster) for a in range(3)]
  separation=[(c[a]-middle[a])*(factor-1) if len(cluster)>1 and a>0 else 0 for a in range(3)]
  displacements.append(separation)
 for pi,p in enumerate(parts):
  for vi,v in enumerate(baseline[pi]):
   exact=ref_map.get((pi,vi),coordinate_map.get(tuple(round(x,4) for x in v)))
   best,which=0,None
   if exact is not None:best,which=1,exact
   else:
    for gi,g in enumerate(groups):
     c=g['bounds']['center'];r=g['diameter']*.55
     if v[0]*c[0]<0:continue
     yz=math.hypot(v[1]-c[1],v[2]-c[2]);dx=abs(v[0]-c[0])
     influence=(1-smooth((yz-r)/(r*.9)))*(1-smooth((dx-r*.15)/(r*1.5)))
     if influence>best:best,which=influence,gi
   if best:
    c=groups[which]['bounds']['center'];shift=displacements[which];sign=1 if c[0]>0 else -1
    p['vertices'][vi]=[v[a]+best*((v[a]-c[a])*(factor-1)+shift[a]+(length*.0015*sign if a==0 else 0)) for a in range(3)]
 eye_refs=set(ref_map);report=[]
 for g,shift in zip(groups,displacements):
  after=bounds([parts[pi]['vertices'][vi] for pi,vi in g['refs']]);before=g['bounds']
  ratios=[after['size'][a]/before['size'][a] for a in (1,2) if before['size'][a]>1e-8]
  assert all(abs(r-factor)<1e-5 for r in ratios),(ratios,factor)
  report.append({'center':before['center'],'diameterRatios':ratios,'vertices':len(g['refs']),'reposition':shift})
 return {'scale':factor,'eyes':report,'mirroredMissingEye':repair},eye_refs

def build(name,row):
 family,primary,eye_names,mouth_name=PROFILES[name]
 parts=copy.deepcopy(row['parts']);parts.sort(key=lambda p:(p['original']['name']!=primary,p['name']))
 assert parts[0]['original']['name']==primary
 planar_repairs=[]
 for p in parts:
  b=bounds(p['vertices'])
  for axis,extent in enumerate(b['size']):
   if extent<.001:
    # Native OBJ rounding flattens extremely thin glow planes; retain their .001-stud envelope.
    spread=max(range(3),key=lambda a:b['size'][a])
    for v in p['vertices']:
     v[axis]=b['center'][axis]+.001*((v[spread]-b['min'][spread])/b['size'][spread]-.5)
    planar_repairs.append({'part':p['name'],'axis':axis,'maximumOffset':.0005})
 origin=bounds(parts[0]['vertices'])['center'];flip=family=='squid'
 def canonical(v):return [-(v[0]-origin[0]) if flip else v[0]-origin[0],v[1]-origin[1],-(v[2]-origin[2]) if flip else v[2]-origin[2]]
 for p in parts:
  p['vertices']=[canonical(v) for v in p['vertices']]
  p['normals']=[[-n[0],n[1],-n[2]] if flip else n for n in p['normals']]
 visible=[v for p in parts if p['original']['transparency']<1 for v in p['vertices']]
 original_bounds=bounds(visible);length=original_bounds['size'][2];zmin,zmax=original_bounds['min'][2],original_bounds['max'][2]
 eye,eye_refs=eyes(parts,eye_names,family,length)
 eye_vertices=[parts[pi]['vertices'][vi] for pi,vi in eye_refs]
 eye_z=max(v[2] for v in eye_vertices)
 if family=='squid':
  mouth=[sum(v[a] for v in eye_vertices)/len(eye_vertices) for a in range(3)]
  mouth[0]=0;mouth[1]-=length*.025;mouth[2]-=length*.012
 else:
  mouth_part=next(p for p in parts if p['original']['name']==mouth_name)
  front=min(v[2] for v in mouth_part['vertices'])
  points=[v for v in mouth_part['vertices'] if v[2]<front+length*.006]
  mouth=[sum(v[a] for v in points)/len(points) for a in range(3)];mouth[0]=0
  if family=='ray':mouth[1]-=length*.015
 names=BASE[:];parents=[-1,0,1,2,3]
 head_end=max(.24,min(.65,(eye_z-zmin)/length+.035))
 if family=='turtle':head_end=max(.09,min(.22,(eye_z-zmin)/length+.035))
 anchors=[head_end]+[head_end+(1-head_end)*f for f in (.22,.48,.76,.98)]
 positions=[[0,0,0]]+[[0,0,zmin+length*f] for f in (head_end+.025,anchors[1]+.025,anchors[2]+.025,anchors[3]+.025)]
 if family=='eel':
  names+=['TailExtra1','TailExtra2','TailExtra3'];parents+=[4,5,6]
  anchors=[head_end]+[head_end+(1-head_end)*i/7 for i in range(1,8)]
  positions=[[0,0,0]]+[[0,0,zmin+length*(head_end+(1-head_end)*(i-.3)/7)] for i in range(1,8)]
 if family in ('ray','ornate'):
  names+=['FinLeft','FinRight'];parents+=[1,1]
  for sign in (-1,1):positions.append([sign*original_bounds['size'][0]*.14,0,zmin+length*.42])
 if family=='turtle':
  names+=['FlipperLeft','FlipperRight','RearFlippers'];parents+=[2,2,2]
  positions += [[-original_bounds['size'][0]*.16,0,zmin+length*.40],[original_bounds['size'][0]*.16,0,zmin+length*.40],[0,0,zmin+length*.77]]
 if family=='squid':
  names+=['TentacleLeft','TentacleMid','TentacleRight'];parents+=[1,2,1]
  head_plane=min(v[2] for v in eye_vertices)-length*.02
  # Base chain travels from the stable mantle/head towards the tentacle tips.
  span=max(length*.2,head_plane-zmin)
  positions=[[0,0,0]]+[[0,0,head_plane-span*f] for f in (.12,.38,.65,.88)]
  positions += [[-original_bounds['size'][0]*.14,0,head_plane-span*.25],[0,0,head_plane-span*.45],[original_bounds['size'][0]*.14,0,head_plane-span*.25]]
 bones=[{'name':n,'parent':parent,'position':p} for n,parent,p in zip(names,parents,positions)]
 shell_parts=set()
 if family=='turtle':
  # Rigid shell layers and their decorations all follow one bind; legs and neck blend independently.
  shell_parts={p['name'] for p in parts if abs(bounds(p['vertices'])['center'][0])<original_bounds['size'][0]*.15 and original_bounds['size'][0]*.25<bounds(p['vertices'])['size'][0]<original_bounds['size'][0]*.70 and bounds(p['vertices'])['min'][2]>=zmin+length*head_end and bounds(p['vertices'])['center'][2]>zmin+length*.3 and bounds(p['vertices'])['center'][2]<zmin+length*.72}
 output=[];effective=set();max_eye_influence=0
 for pi,p in enumerate(parts):
  b=bounds(p['vertices']);center=b['center'];weights=[]
  for vi,v in enumerate(p['vertices']):
   along=(v[2]-zmin)/length
   if family=='squid':
    fraction=(head_plane-v[2])/span
    knots=[.05,.28,.50,.75,.98]
    segment=0
    while segment<3 and fraction>knots[segment+1]:segment+=1
    alpha=smooth((fraction-knots[segment])/(knots[segment+1]-knots[segment]))
   else:
    segment=0
    while segment<len(anchors)-2 and along>anchors[segment+1]:segment+=1
    alpha=smooth((along-anchors[segment])/(anchors[segment+1]-anchors[segment]))
   ids=[segment,segment+1];values=[1-alpha,alpha]
   if family in ('ray','ornate') and along>head_end:
    spread=original_bounds['size'][0]
    amount=smooth((abs(v[0])-spread*.10)/(spread*.31))
    ids.append(5 if v[0]<0 else 6);values=[values[0]*(1-amount),values[1]*(1-amount),amount]
   if family=='turtle':
    if p['name'] in shell_parts:ids,values=[2],[1]
    else:
     spread=original_bounds['size'][0];outer=smooth((abs(v[0])-spread*.12)/(spread*.20))
     if along>.70 and abs(v[0])>spread*.10:
      bi=7;amount=outer
     else:bi=5 if v[0]<0 else 6;amount=outer
     ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   if family=='squid' and fraction>.06:
    side=v[0]/max(original_bounds['size'][0]*.5,.001)
    bi=5 if side<-.23 else 7 if side>.23 else 6
    amount=.95*smooth(fraction/.5)*smooth(abs(v[0])/(original_bounds['size'][0]*.08))
    ids.append(bi);values=[w*(1-amount) for w in values]+[amount]
   if (pi,vi) in eye_refs or (family!='squid' and along<=head_end and p['name'] not in shell_parts) or (family=='squid' and fraction<=.05):ids,values=[0],[1]
   assert abs(sum(values)-1)<1e-8
   if p['name'] in shell_parts:assert ids==[2] and values==[1],('Shell must remain one rigid bind',name,p['name'])
   effective.update(bi for bi,w in zip(ids,values) if w>1e-5)
   weights.append([ids,values])
  normals=[];faces=[]
  for face in p['faces']:
   a,bv,c=[p['vertices'][v[0]] for v in face]
   ab=[bv[i]-a[i] for i in range(3)];ac=[c[i]-a[i] for i in range(3)]
   n=normalize([ab[1]*ac[2]-ab[2]*ac[1],ab[2]*ac[0]-ab[0]*ac[2],ab[0]*ac[1]-ab[1]*ac[0]])
   ni=len(normals);normals.append(n);faces.append([v[0] for v in face]+[v[1] for v in face]+[ni]*3)
  output.append({'name':'polySurface5' if pi==0 else 'FishMesh%02d'%(pi+1),'original':p['original'],'sourceKey':p['name'],'center':center,'size':[max(.001,x) for x in b['size']],
   'vertices':[[v[a]-center[a] for a in range(3)] for v in p['vertices']],'uvs':p['uvs'],'normals':normals,'faces':faces,'weights':weights,
   'color':grade(p['original']['color']) if not p['original']['texture'] else p['original']['color'],'shellRigid':p['name'] in shell_parts})
 for spec in output:
  raw={k:spec[k] for k in ('vertices','faces','uvs','normals','weights','center')};raw['bones']=bones
  spec['meshRecipeHash']=hashlib.sha256(json.dumps(raw,separators=(',',':')).encode()).hexdigest()
 assert len(effective)==len(bones),(name,'unused logical joints',effective)
 return {'name':name,'key':row['source']['exportKey'],'family':family,'variant':'race_'+family,'eye':eye,'bones':bones,'parts':output,'mouth':mouth,
  'presentationRadius':json.loads((ROOT/'animation-bounds.json').read_text()).get(name,{}).get('presentationRadius') if (ROOT/'animation-bounds.json').exists() else None,'bodySize':original_bounds['size'],'sourceOrigin':origin,'sourceFlipped':flip,'weightAnchors':anchors,'headEnd':head_end,
  'validation':{'uvUnchanged':True,'weightsNormalized':True,'rigidEyes':True,'logicalBones':len(bones),'parts':len(parts),'vertices':sum(len(p['vertices']) for p in parts),'shellParts':sorted(shell_parts),'planarRepairs':planar_repairs}}

if __name__=='__main__':
 data=json.loads((ROOT/'source/parsed.json').read_text());reports=[]
 for name,row in sorted(data.items()):
  result=build(name,row);(ROOT/'payload'/(result['key']+'.json')).write_text(json.dumps(result,separators=(',',':')))
  reports.append({k:v for k,v in result.items() if k not in ('parts',)})
 (ROOT/'build-validation.json').write_text(json.dumps(reports,ensure_ascii=False,indent=2))
 print([(r['name'],r['eye']['scale'],len(r['bones']),r['validation']['parts']) for r in reports])
