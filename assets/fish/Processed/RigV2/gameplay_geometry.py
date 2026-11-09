"""Build per-fish Play validation inputs from the same geometry that was published."""
import argparse
import numpy as np
from build import read, save, ROOT

p=argparse.ArgumentParser()
p.add_argument('--pilots',action='store_true')
p.add_argument('--only',nargs='+')
args=p.parse_args()
for entry in read('inventory.json')['rows']:
    if (args.pilots and not entry.get('pilot')) or (args.only and entry['name'] not in args.only):continue
    key=entry['key']
    if not (ROOT/f'payload/{key}/rig.json').exists():continue
    rig=read(f'payload/{key}/rig.json')
    out={'bones':[b['name'] for b in rig['bones']],'parts':[]}
    for i,spec in enumerate(rig['parts'],1):
        p=read(f'source/{key}/part{i:03}.json')
        if p['transparency']>=1:continue
        w=read(f'payload/{key}/part{i:03}.json')
        pos=(np.array(p['vertices'])*np.array(p['size'])/np.maximum(p['meshSize'],1e-6)).round(5)
        indices=np.array(w['indices']).reshape(-1,4)
        weights=np.array(w['weights']).reshape(-1,4)
        # Identical rest coordinates and skin weights have identical deformed positions.
        combined=np.column_stack((pos,indices,weights))
        unique=np.unique(combined,axis=0)
        out['parts'].append(dict(name=spec['name'],vertices=unique[:,:3].tolist(),
            weights=[[row[3:7].astype(int).tolist(),row[7:].tolist()] for row in unique]))
    save(f'gameplay/{key}.json',out)
