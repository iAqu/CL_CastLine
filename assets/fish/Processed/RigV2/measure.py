"""Measure weighted vertex envelopes and body/tail excursion from authored poses."""
import argparse
import json
import numpy as np
from build import ROOT, read, save

def geometry(rig, version):
    points, all_ids, all_w = [], [], []
    old = read(f"source/{rig['key']}/rig.json")['originalBones']
    bone_indices = {b['name']:i for i,b in enumerate(old)}
    for i,spec in enumerate(rig['parts'],1):
        part = read(f"source/{rig['key']}/part{i:03}.json")
        if part['transparency'] >= 1:
            continue
        v = np.array(part['vertices'])
        f = np.array(part['frame'])
        v = (v*np.array(part['size'])/np.maximum(part['meshSize'],1e-6)) @ f[3:].reshape(3,3).T + f[:3]
        points.append(v)
        if version == 2:
            w = read(f"payload/{rig['key']}/part{i:03}.json")
            all_ids.append(np.array(w['indices']).reshape(-1,4))
            all_w.append(np.array(w['weights']).reshape(-1,4))
        else:
            indices=np.zeros((len(v),4),dtype=int)
            weights=np.zeros((len(v),4))
            for k,(names,ws) in enumerate(part['weights']):
                if not ws:
                    weights[k,0]=1
                else:
                    indices[k,:len(ws)]=[bone_indices[n] for n in names]
                    weights[k,:len(ws)]=ws
            all_ids.append(indices)
            all_w.append(weights)
    if version == 1:
        old=[{**b,'parent':bone_indices[b['parent']] if b['parent'] else -1} for b in old]
    return np.vstack(points),np.vstack(all_ids),np.vstack(all_w),rig['bones'] if version==2 else old

def evaluate(rig, clips, version, bind_rotations=None):
    vertices, ids, weights, bones = geometry(rig, version)
    bind = np.array([b['position'] for b in bones])
    local = vertices[:,None,:]-bind[ids]
    tail = rig['main'][-1]
    tail_direction = np.array(rig['bones'][tail]['position']) - np.array(rig['bones'][rig['main'][1]]['position'])
    tail_direction /= np.linalg.norm(tail_direction)
    along=vertices@tail_direction
    tail_indices=np.flatnonzero(along>=np.quantile(along,.98))
    middle_indices=np.flatnonzero((along>=np.quantile(along,.4)) & (along<=np.quantile(along,.6)))
    head = np.logical_or(ids != 0, weights < .9999).all(axis=1) == False
    report={}
    max_radius=0.
    for name,clip in clips.items():
        radius, head_error, tail_motion, mid_motion = 0., 0., [], []
        frames=clip['frames']
        stride=3 if version==2 else 1
        for frame in frames[::stride] + ([frames[-1]] if (len(frames)-1)%stride else []):
            rotations, joints = [], []
            for i,bone in enumerate(bones):
                local_rotation=np.array(frame['rotationMatrices'].get(bone['name'],[1,0,0,0,1,0,0,0,1])).reshape(3,3)
                if bind_rotations and bone['name'] in bind_rotations:
                    rest=np.array(bind_rotations[bone['name']]).reshape(3,3)
                    local_rotation=rest@local_rotation@rest.T
                parent=bone['parent']
                if parent>=0:
                    joints.append(joints[parent]+rotations[parent]@(bind[i]-bind[parent]))
                    rotations.append(rotations[parent]@local_rotation)
                else:
                    joints.append(bind[i])
                    rotations.append(local_rotation)
            transform = np.array(rotations)[ids]
            pos=np.sum((np.einsum('nkij,nkj->nki', transform, local)+np.array(joints)[ids])*weights[:,:,None],axis=1)
            radius=max(radius,float(np.sqrt(np.max(np.sum(pos**2,axis=1)))))
            if np.any(head):head_error=max(head_error,float(np.max(np.linalg.norm(pos[head]-vertices[head],axis=1))))
            tail_motion.append(pos[tail_indices].mean(axis=0))
            mid_motion.append(pos[middle_indices].mean(axis=0))
        def excursion(points):
            p=np.array(points)
            return float(np.max(np.linalg.norm(p[:,None,:]-p[None,:,:],axis=-1)))
        report[name]={'radius':radius,'headError':head_error,'tailExcursion':excursion(tail_motion),
                      'midExcursion':excursion(mid_motion),'poses':len(tail_motion)}
        max_radius=max(max_radius,radius)
    return report,max_radius

if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('--pilots',action='store_true')
    p.add_argument('--force',action='store_true')
    p.add_argument('--only',nargs='+')
    args=p.parse_args()
    for entry in read('inventory.json')['rows']:
        key=entry['key']
        if (args.pilots and not entry.get('pilot')) or (args.only and entry['name'] not in args.only):continue
        rig_path=ROOT/f'payload/{key}/rig.json'
        if not rig_path.exists() or (not args.force and (ROOT/f'bounds/{key}.json').exists() and (not (ROOT/f'old-motion/{key}.json').exists() or 'before' in read(f'bounds/{key}.json'))):continue
        rig=read(rig_path.relative_to(ROOT))
        if rig['weak']:continue
        clips=read(f"motions/{rig['variant']}.json")['clips']
        measurements,radius=evaluate(rig,clips,2)
        assert max(c['headError'] for c in measurements.values()) < 1e-6, entry['name']
        result={'name':entry['name'],'radius':radius*1.1,'new':measurements}
        if (ROOT/f'old-motion/{key}.json').exists():
            prior=read(f'old-motion/{key}.json')
            old,_=evaluate(rig,prior.get('clips',prior),1,prior.get('bindRotations'))
            result['before']=old
            result['tailRatios']={k:measurements[k]['tailExcursion']/max(v['tailExcursion'],1e-6) for k,v in old.items()}
        save(f'bounds/{key}.json',result)
        print(entry['name'],round(result['radius'],3),result.get('tailRatios',''),flush=True)
