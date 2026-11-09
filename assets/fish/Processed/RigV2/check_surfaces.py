"""Measure skin deformation at seams and authored drip points without touching the scene."""
import argparse
import numpy as np
from build import read, save, ROOT
from measure import geometry

parser=argparse.ArgumentParser()
parser.add_argument('--pilots',action='store_true')
args=parser.parse_args()
results={}
for e in read('inventory.json')['rows']:
    if args.pilots and not e.get('pilot'):continue
    rig=read(f"payload/{e['key']}/rig.json")
    original=read(f"source/{e['key']}/rig.json")
    clips=read(f"motions/{rig['variant']}.json")['clips']
    v, ids, ws, bones=geometry(rig,2)
    by_name={b['name']:i for i,b in enumerate(bones)}
    binds=np.array([b['position'] for b in bones])
    scale=max(rig['bodySize'])
    # Find material layer seams using the original rest position of each vertex.
    layers=[]
    for i in range(len(rig['parts'])):
        p=read(f"source/{rig['key']}/part{i+1:03}.json")
        if p['transparency']<1:layers.extend([i]*len(p['vertices']))
    keys=np.round(v/max(scale*1e-5,1e-6)).astype(np.int64)
    seen={}
    seam_a,seam_b=[],[]
    for index,key in enumerate(map(tuple,keys)):
        previous=seen.setdefault(key,index)
        if previous!=index and layers[previous]!=layers[index]:
            seam_a.append(previous);seam_b.append(index)
    qa=[(int(np.argmin(np.sum((v-np.array(p['position']))**2,axis=1))),np.array(p['position']),
            by_name[next(x['bone'] for x in rig['drip'] if x['name']==p['name'])])
        for p in original['drip']]
    sa=np.array(seam_a,dtype=int);sb=np.array(seam_b,dtype=int)
    distinct=np.unique(np.concatenate((sa,sb))) if len(sa) else np.array([],dtype=int)
    row={'sharedSeamVertices':len(sa),'maxMaterialSeamGap':0.,'maxDripDeviation':0.,'size':scale}
    for name in ('StruggleLeft','StruggleRight','LiftFlop','ShowcaseFlop'):
        for frame in clips[name]['frames'][::6]:
            basis,joint=[],[]
            for i,b in enumerate(bones):
                parent=b['parent'];m=np.array(frame['rotationMatrices'][b['name']]).reshape(3,3)
                if parent<0:
                    basis.append(m);joint.append(binds[i])
                else:
                    basis.append(basis[parent]@m)
                    joint.append(joint[parent]+basis[parent]@(binds[i]-binds[parent]))
            basis,joint=np.array(basis),np.array(joint)
            if len(sa):
                influence=ids[distinct]
                local=v[distinct,None,:]-binds[influence]
                actual=np.sum((np.einsum('nkij,nkj->nki',basis[influence],local)+joint[influence])*ws[distinct,:,None],axis=1)
                delta=actual[np.searchsorted(distinct,sa)]-actual[np.searchsorted(distinct,sb)]
                row['maxMaterialSeamGap']=max(row['maxMaterialSeamGap'],float(np.linalg.norm(delta,axis=1).max()))
            if name=='ShowcaseFlop':
                for vi,p,bone in qa:
                    ix=ids[vi];ideal=((basis[ix]@(p-binds[ix])[...,None])[:,:,0]+joint[ix]).T@ws[vi]
                    actual=basis[bone]@(p-binds[bone])+joint[bone]
                    row['maxDripDeviation']=max(row['maxDripDeviation'],float(np.linalg.norm(actual-ideal)))
    row['seamGapFraction']=row['maxMaterialSeamGap']/scale
    row['dripDeviationFraction']=row['maxDripDeviation']/scale
    results[e['name']]=row
    save('surface-validation-'+('pilots' if args.pilots else 'all')+'.json',results)
    print(e['name'],round(row['seamGapFraction'],4),round(row['dripDeviationFraction'],4),flush=True)
