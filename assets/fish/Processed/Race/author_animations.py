"""Blender mathutils: adapt the established Elder timing to seven creature families."""
import json,math
from pathlib import Path
from mathutils import Matrix,Quaternion
ROOT=Path(__file__).resolve().parent
BASE=json.loads((ROOT.parents[1]/'ElderFish/animation_clips.baked.json').read_text())['clips']
rows=[json.loads(p.read_text()) for p in sorted((ROOT/'payload').glob('*.json'))]
(ROOT/'motions').mkdir(exist_ok=True)
for family in sorted({r['family'] for r in rows}):
 fish=[r for r in rows if r['family']==family];bones=fish[0]['bones'];out={'family':family,'variant':'race_'+family,'bones':bones,'partCount':max(len(r['parts']) for r in fish),'clips':{}}
 for name,clip in BASE.items():
  frames=[]
  for frame in clip['frames']:
   rotations={}
   for i,bone in enumerate(bones):
    bn=bone['name']
    if i<5:
     raw=frame.get('rotationMatrices',{}).get(bn)
     if raw:rotation=Matrix([raw[j:j+3] for j in (0,3,6)])
     else:
      rx,ry,rz=map(math.radians,frame['rotations'][bn]);rotation=Matrix.Rotation(rx,3,'X')@Matrix.Rotation(ry,3,'Y')@Matrix.Rotation(rz,3,'Z')
     factor={'shark':1,'dolphin':.7,'ray':.2,'turtle':.2,'eel':.7,'squid':.35,'ornate':.7}[family]
     if family=='turtle':factor=[0,.1,.03,.30,.35][i]
     if i==0:factor=0
     rotation=Quaternion().slerp(rotation.to_quaternion(),factor).to_matrix()
     if family=='dolphin' and name=='SwimLoop':
      turn=Matrix.Rotation(-math.pi*.5,3,'Z');rotation=turn@rotation@turn.inverted()
    else:
     phase=frame['time']/clip['duration'];envelope=1 if clip['loop'] else max(0,math.sin(math.pi*phase))
     n=i-5
     if family=='eel':rotation=Matrix.Rotation(math.radians(14)*math.sin(2*math.pi*phase-n*.6)*envelope,3,'Y')
     elif family in ('ray','ornate'):
      amplitude=20 if family=='ray' else 8
      angle=math.radians(amplitude)*math.sin(2*math.pi*phase)*envelope*(-1 if n==0 else 1)
      rotation=Matrix.Rotation(angle,3,'Z')
     elif family=='turtle':
      angle=math.radians(20 if n<2 else 14)*math.sin(2*math.pi*phase-(.8 if n==2 else 0))*envelope
      rotation=Matrix.Rotation(angle*(1 if n==0 else -1),3,'Z') if n<2 else Matrix.Rotation(angle,3,'X')
     elif family=='squid':
      angle=math.radians(18)*math.sin(2*math.pi*phase-n*.9)*envelope
      rotation=Matrix.Rotation(angle,3,'Y')@Matrix.Rotation(angle*.4,3,'Z')
     else:raise AssertionError(family)
    rotations[bn]=[rotation[r][c] for r in range(3) for c in range(3)]
   frames.append({'time':frame['time'],'rotationMatrices':rotations})
  out['clips'][name]={'duration':clip['duration'],'loop':clip['loop'],'interpolation':clip.get('interpolation','Cubic'),'frames':frames}
 (ROOT/'motions'/(out['variant']+'.json')).write_text(json.dumps(out,separators=(',',':')))
 print(family,'bones',len(bones),'roots',out['partCount'],flush=True)
