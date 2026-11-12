"""Blender mathutils: Elder timing adapted to nine fish and appendage profiles."""
import json,math
from pathlib import Path
from mathutils import Matrix,Quaternion
ROOT=Path(__file__).resolve().parent
BASE=json.loads((ROOT.parents[1]/'ElderFish/animation_clips.baked.json').read_text())['clips']
rows=[json.loads(p.read_text()) for p in sorted((ROOT/'payload').glob('*.json'))];(ROOT/'motions').mkdir(exist_ok=True)
for family in sorted({r['family'] for r in rows}):
 fish=[r for r in rows if r['family']==family];bones=fish[0]['bones'];out={'family':family,'variant':'new_'+family,'bones':bones,'partCount':max(len(r['parts']) for r in fish),'clips':{}}
 for name,clip in BASE.items():
  frames=[]
  for frame in clip['frames']:
   rotations={};phase=frame['time']/clip['duration'];envelope=1 if clip['loop'] else max(0,math.sin(math.pi*phase))
   for i,bone in enumerate(bones):
    bn=bone['name']
    if i<5:
     raw=frame.get('rotationMatrices',{}).get(bn)
     if raw:rotation=Matrix([raw[j:j+3] for j in (0,3,6)])
     else:
      rx,ry,rz=map(math.radians,frame['rotations'][bn]);rotation=Matrix.Rotation(rx,3,'X')@Matrix.Rotation(ry,3,'Y')@Matrix.Rotation(rz,3,'Z')
     factor={'standard':1,'dolphin':.7,'longbody':.65,'fins':.22,'turtle':.2,'lobster':.35,'seahorse':.25,'axolotl':.5,'jellyfish':.25}[family]
     if family=='turtle':factor=[0,.08,.025,.25,.3][i]
     if i==0:factor=0
     rotation=Quaternion().slerp(rotation.to_quaternion(),factor).to_matrix()
     if (family=='dolphin' and name=='SwimLoop') or family=='seahorse':
      turn=Matrix.Rotation(-math.pi*.5,3,'Z');rotation=turn@rotation@turn.inverted()
    else:
     n=i-5;angle=math.radians(14)*math.sin(2*math.pi*phase-n*.6)*envelope
     if family in ('longbody','seahorse'):rotation=Matrix.Rotation(angle,3,'X' if family=='seahorse' else 'Y')
     elif family=='fins':rotation=Matrix.Rotation(math.radians(20)*math.sin(2*math.pi*phase)*envelope*(-1 if n==0 else 1),3,'Z')
     elif family=='turtle':rotation=Matrix.Rotation(angle*(-1 if n==1 else 1),3,'Z' if n<2 else 'X')
     elif family=='lobster':rotation=Matrix.Rotation(angle*(-1 if n==1 else 1),3,'Y' if n<2 else 'X')
     elif family=='axolotl':rotation=Matrix.Rotation(angle*(.65 if n==2 else 1)*(-1 if n==1 else 1),3,'Z')
     elif family=='jellyfish':rotation=Matrix.Rotation(angle,3,'Z')@Matrix.Rotation(angle*.5,3,'Y')
     else:raise AssertionError(family)
    rotations[bn]=[rotation[r][c] for r in range(3) for c in range(3)]
   frames.append({'time':frame['time'],'rotationMatrices':rotations})
  out['clips'][name]={'duration':clip['duration'],'loop':clip['loop'],'interpolation':clip.get('interpolation','Cubic'),'frames':frames}
 (ROOT/'motions'/(out['variant']+'.json')).write_text(json.dumps(out,separators=(',',':')));print(family,len(bones),out['partCount'],flush=True)
