"""Upper bound on tail excursion when head/pivots stay fixed and bones do not stretch."""
import numpy as np
from build import read,save
from measure import geometry

out={}
for entry in read('inventory.json')['rows']:
    key=entry['key']
    rig=read(f'payload/{key}/rig.json')
    result=read(f'bounds/{key}.json')
    points, ids, weights, bones=geometry(rig,2)
    binds=np.array([b['position'] for b in bones])
    length=np.zeros(len(bones))
    for i,b in enumerate(bones):
        parent=b['parent']
        if parent>0:length[i]=length[parent]+np.linalg.norm(binds[i]-binds[parent])
    direction=binds[rig['main'][-1]]-binds[rig['main'][1]]
    direction/=np.linalg.norm(direction)
    along=points@direction
    chosen=along>=np.quantile(along,.98)
    p,ix,w=points[chosen],ids[chosen],weights[chosen]
    radius=length[ix]+np.linalg.norm(p[:,None,:]-binds[ix],axis=2)
    radius[ix==0]=0
    max_chord=2*float(np.sum(radius*w,axis=1).mean())
    original=result['before']['LiftFlop']['tailExcursion']
    out[entry['name']]={'headFixedUpperBound':max_chord,'oldLiftExcursion':original,
                       'target2_5':2.5*original,'targetExceedsFixedHeadBound':2.5*original>max_chord}
save('lift-range-capacity.json',out)
print('Target exceeds fixed-head reach bound:',
      sum(x['targetExceedsFixedHeadBound'] for x in out.values()),'/',len(out))
