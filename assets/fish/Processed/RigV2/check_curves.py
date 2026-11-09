"""Check continuity of the baked rotations used by both Roblox and FBX."""
import math
import numpy as np
from build import read, save, CLIPS, RATE

def logarithm(m):
    cosine=max(-1.,min(1.,(np.trace(m)-1)*.5))
    theta=math.acos(cosine)
    if theta<1e-9:return np.zeros(3)
    return theta/(2*math.sin(theta))*np.array([m[2,1]-m[1,2],m[0,2]-m[2,0],m[1,0]-m[0,1]])

catalog=read('inventory.json')['rows']
variants={}
for entry in catalog:
    rig=read(f"payload/{entry['key']}/rig.json")
    if rig['variant'] in variants:continue
    data=read(f"motions/{rig['variant']}.json")
    reports={}
    for name,(duration,loop) in CLIPS.items():
        clip=data['clips'][name]
        frames=clip['frames']
        assert len(frames)==round(duration*RATE)+1
        assert frames[-1]['time']==duration and clip['loop']==loop
        angles=np.array([[f['rotationMatrices'][b['name']] for b in data['bones']] for f in frames]).reshape(len(frames),-1,3,3)
        assert np.max(np.abs(angles@np.swapaxes(angles,-1,-2)-np.eye(3)))<1e-9
        assert np.max(np.abs(angles[:,0]-np.eye(3)))<1e-9
        assert np.min(np.linalg.det(angles))>.999999
        increments=angles[:-1].swapaxes(-1,-2)@angles[1:]
        spins=np.array([logarithm(v) for v in increments.reshape(-1,3,3)]).reshape(len(frames)-1,-1,3)
        max_step=float(np.linalg.norm(spins,axis=-1).max())
        assert max_step<.2,(rig['variant'],name,max_step)
        if loop:
            assert np.max(np.abs(angles[0]-angles[-1]))<1e-10
            seam=float(np.linalg.norm(spins[0]-spins[-1],axis=-1).max())
            local_slope_change=float(np.linalg.norm(np.diff(spins,axis=0),axis=-1).max())
            assert seam<=local_slope_change*1.2+1e-5,(rig['variant'],name,seam)
        else:
            assert np.max(np.abs(angles[[0,-1]]-np.eye(3)))<1e-9
            seam=float(np.linalg.norm(spins[[0,-1]],axis=-1).max())
            assert seam<.025,(rig['variant'],name,seam)
        reports[name]={'samples':len(frames),'sampleRate':RATE,'maxAngularStepRadians':max_step,
                       'boundarySlopeStepRadians':seam,'passed':True}
    variants[rig['variant']]=reports
save('curve-validation.json',{'passed':True,'variants':variants})
print(f'{len(variants)} shared rigs; all {len(variants)*5} authored curves pass')
