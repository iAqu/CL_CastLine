"""Per-species authoring annotations, chosen from source previews and UV chart readback."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
candidates=json.loads((ROOT/'source/eye-candidates.json').read_text());manifest=json.loads((ROOT/'source-manifest.json').read_text())
# Chart indices identify pupils/sockets; both sides are recovered by source geometry, never by naming.
indices={2:0,5:2,6:1,7:87,8:22,12:39,14:1,15:195,17:16,19:27,20:0,22:0,25:180,
26:1,27:3,28:2,29:2,30:2,31:1,32:2,33:3,34:4,35:2,36:2,37:1,38:3,39:2,40:2,41:2,42:3,43:2,44:2,45:1,46:3,47:3,48:2,49:6,50:1,51:6,52:0,53:2,54:2,55:3,56:9,57:7,58:2,59:2}
patches={1:(.05,-.30,.022),3:(.03,-.30,.020),4:(.02,-.435,.014),10:(-.04,.354,.025),11:(.05,-.29,.022),13:(-.093,-.155,.018),16:(.0035,-.3195,.020),18:(-.087,-.175,.014),24:(.014,-.35,.032)}
profiles={}
for i,row in enumerate(manifest['fish'],1):
 n=row['name'];r=candidates[n];family='standard'
 if 'Whale' in n or n=='PinkDolphin':family='dolphin'
 if n in ('Dragonfish','Summertime Elk'):family='longbody'
 if n in ('SpottedEagleRay','Blue Dragon'):family='fins'
 if n in ('GreenTurtle','Turtle Walker'):family='turtle'
 if n=='Lobster':family='lobster'
 if 'Seahorse' in n:family='seahorse'
 if n=='Axolotl':family='axolotl'
 if n=='Candy Jellyfish':family='jellyfish'
 spec={'name':n,'key':row['exportKey'],'family':family,'rotateX':r['rotateX'],'flip':n=='Hell Shark','eyeMode':'charts','eyeScale':None}
 if i==21:spec.update(eyeMode='none',eyeReason='Source is a hollow skeleton with empty eye sockets; preserve original design.')
 elif i==23:spec.update(eyeMode='patch',eyePatch=[.0125,-.354,.012],eyeScale=2)
 elif i==9:spec.update(eyeMode='components',eyePart='teethEyes',eyeComponentMin=60,eyeComponentMax=100)
 elif i in patches:spec.update(eyeMode='patch',eyePatch=list(patches[i]),eyeScale=2)
 else:
  chart=r['charts'][indices[i]];spec['chartIndex']=indices[i];spec['eyeTarget']=chart['center'];spec['eyePart']=chart['part']
  spec['eyeScale']=1.5 if max(chart['size'][1:])>.065 or family in ('seahorse','turtle','jellyfish','axolotl') else 2
 if i==2:spec['eyeScale']=1.5
 profiles[n]=spec
(ROOT/'profiles.json').write_text(json.dumps(profiles,ensure_ascii=False,indent=2))
print('Profiles',len(profiles))
