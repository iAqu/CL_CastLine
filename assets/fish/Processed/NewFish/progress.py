from pathlib import Path
import json
p=Path(__file__).resolve().parent
for n in ['texture-publication','mesh-publication','animation-publication','asset-validation','gameplay-validation','regression-validation']:
 f=p/(n+'.json')
 if f.exists():
  d=json.loads(f.read_text());print(n,{k:len(v) if isinstance(v,(list,dict)) else v for k,v in d.items() if k in ('done','current','count','results','errors','error','waiting')})
