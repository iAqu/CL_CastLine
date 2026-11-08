"""Full skinned geometry for old + new species; hidden helper layers are excluded from framing."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
result=json.loads((ROOT.parent/'geometry-qa.json').read_text())
for path in sorted((ROOT/'payload').glob('*.json')):
 d=json.loads(path.read_text())
 result[d['name']]={'bones':[b['name'] for b in d['bones']],'parts':[{'name':p['name'],'vertices':p['vertices'],'weights':p['weights']} for p in d['parts'] if p['original']['transparency']<1]}
raw=json.dumps(result,separators=(',',':'))
(ROOT/'geometry-qa.json').write_text(raw)
print('Geometry species',len(result),'bytes',len(raw),'vertices',sum(len(p['vertices']) for d in result.values() for p in d['parts']))
