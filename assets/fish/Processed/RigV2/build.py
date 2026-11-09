"""Build per-model v2 weights from the published rest mesh; no changes to appearance."""
from __future__ import annotations
import argparse
import hashlib
import json
import math
from pathlib import Path
import numpy as np

ROOT = Path(__file__).resolve().parent
CORE = ['FishBody', 'SpineFront', 'SpineMid', 'TailBase', 'FishTail']
CLIPS = {
    'SwimLoop': (.625, True), 'StruggleLeft': (.6, True), 'StruggleRight': (.6, True),
    'LiftFlop': (2., False), 'ShowcaseFlop': (.9, False),
}
RATE = 120

def read(path):
    path = ROOT / path
    value = json.loads(path.read_text())
    if isinstance(value, dict) and 'chunkCount' in value:
        raw = ''.join(json.loads(Path(f'{path}.chunk{i:03}.json').read_text())['chunk']
                      for i in range(1, value['chunkCount'] + 1))
        assert len(raw.encode()) == value['bytes'], path
        return json.loads(raw)
    return value

def save(path, data):
    p = ROOT / path
    p.parent.mkdir(parents=True, exist_ok=True)
    temp = p.with_suffix(p.suffix + '.tmp')
    temp.write_text(json.dumps(data, ensure_ascii=False, separators=(',', ':')))
    temp.replace(p)

def mix(a, b, t):
    return a + (b - a) * t

def smooth(x):
    x = np.clip(x, 0, 1)
    return x*x*(3 - 2*x)

def unit(v, fallback=(0, 0, 1)):
    n = np.linalg.norm(v)
    return v/n if n > 1e-8 else np.array(fallback, dtype=float)

def project_weights(points, knots):
    """Two neighboring joints along the closest segment of a piecewise centerline."""
    error = np.full(len(points), np.inf)
    selected = np.zeros(len(points), dtype=np.int16)
    alpha = np.zeros(len(points))
    for i, (a, b) in enumerate(zip(knots, knots[1:])):
        delta = b-a
        t = np.clip((points-a) @ delta / max(delta @ delta, 1e-12), 0, 1)
        difference = points - a - t[:, None] * delta
        distance = np.einsum('ij,ij->i', difference, difference)
        mask = distance < error
        error[mask], selected[mask], alpha[mask] = distance[mask], i, t[mask]
    return selected, alpha

def motion(bones, main, family):
    """Continuous traveling angular field sampled into local, quaternion-compatible rotations."""
    def rotation(x, y, z):
        x, y, z = (math.radians(a) for a in (x,y,z))
        cx,sx,cy,sy,cz,sz = math.cos(x),math.sin(x),math.cos(y),math.sin(y),math.cos(z),math.sin(z)
        return [cy*cz, -cy*sz, sy, cx*sz+sx*sy*cz, cx*cz-sx*sy*sz, -sx*cy,
                sx*sz-cx*sy*cz, sx*cz+cx*sy*sz, cx*cy]
    def envelope(p):
        return math.sin(math.pi*p)**2
    clips = {}
    for name, (duration, loop) in CLIPS.items():
        frames = []
        sign = -1 if name == 'StruggleRight' else 1
        for frame in range(round(RATE*duration)+1):
            p = frame/(duration*RATE)
            phase = 2*math.pi*p
            env = 1.0 if loop else envelope(p)
            if name == 'LiftFlop':
                phase = 2*math.pi*(2.05*p + .12)
                env *= 1.13 - .25*p
            elif name == 'ShowcaseFlop':
                phase = 2*math.pi*(1.72*p + .03)
                env = (math.sin(math.pi*p)**2 + 1.25*math.sin(math.pi*min(1.,p/.43))**2) / 1.35
            burst = not loop
            amp = {'SwimLoop':63, 'StruggleLeft':109, 'StruggleRight':109, 'LiftFlop':141, 'ShowcaseFlop':142}[name]
            if family == 'ray':
                amp = 13 if name == 'SwimLoop' else (25 if loop else (42 if name == 'LiftFlop' else 31))
            elif family == 'turtle':
                amp = 10 if name == 'SwimLoop' else (19 if loop else (23 if name == 'LiftFlop' else 13))
            else:
                amp *= {'squid':.78, 'jellyfish':.66, 'dolphin':.92, 'axolotl':.78,
                        'lobster':.82}.get(family, 1.)
            bias = 22*sign if name.startswith('Struggle') else 0
            delay = 1.13 if burst else 2.25
            exponent = .67 if burst else 1.12
            def field(s):
                return bias*s + sign*amp*s**exponent*math.sin(phase - delay*s)*env
            matrices = {}
            prev = 0.
            for i, b in enumerate(bones):
                n = b['name']
                role = b['role']
                if i == 0:
                    angles = (0,0,0)
                elif i in main:
                    s = main.index(i)/max(1, len(main)-1)
                    theta = field(s)
                    bend = theta-prev
                    prev = theta
                    if role == 'fin':
                        bend += sign*(10 if name=='SwimLoop' else 19)*math.sin(phase-3.1-s)*env
                    if family == 'dolphin':
                        angles = (bend, (0 if name=='SwimLoop' else .28*bend), 0)
                    elif family in ('squid','jellyfish'):
                        angles = (.55*bend,.75*bend,.15*bend)
                    elif family == 'seahorse':
                        angles = (.7*bend,.7*bend,0)
                    else:
                        angles = (0,bend,0)
                else:
                    side, tip = b['side'], role == 'limb_tip'
                    limb_amp = (22 if name=='SwimLoop' else 48) * (.55 if tip else 1)
                    q = limb_amp*math.sin(phase - b['lag'] - (.8 if tip else 0))*env
                    if family in ('ray','turtle','fins','ornate'):
                        angles = (.22*q, .1*q, q*side)
                    elif family == 'lobster':
                        angles = (.30*q, q*side, .22*q)
                    else:
                        angles = (.65*q, .6*q*side, .35*q*side)
                matrices[n] = rotation(*angles)
            frames.append({'time': frame/RATE, 'rotationMatrices': matrices})
        if loop:
            frames[-1]['rotationMatrices'] = frames[0]['rotationMatrices']
        clips[name] = {'duration':duration,'loop':loop,'interpolation':'Linear','sampleRate':RATE,'frames':frames}
    return clips

def build(entry):
    key, name, family = (entry[k] for k in ('key','name','family'))
    data = read(f'source/{key}/rig.json')
    old = {b['name']:b for b in data['originalBones']}
    assert len(old) == entry['bones'], (name, 'legacy logical count')
    points, weights, specs = [], [], []
    old_indices = {n:i for i,n in enumerate(old)}
    for i in range(len(entry['parts'])):
        p = read(f'source/{key}/part{i+1:03}.json')
        frame = np.array(p['frame'])
        v = np.array(p['vertices'])
        scale = np.array(p['size'])/np.maximum(p['meshSize'],1e-6)
        q = (v*scale) @ frame[3:].reshape(3,3).T + frame[:3]
        w = np.zeros((len(v),len(old)))
        for j,(names, values) in enumerate(p['weights']):
            for n,value in zip(names,values):
                w[j,old_indices[n]] += value
        w[w.sum(axis=1)<1e-9,old_indices['FishBody']] = 1
        w /= w.sum(axis=1)[:,None]
        points.append(q); weights.append(w); specs.append(p)
    xyz, oldw = np.vstack(points), np.vstack(weights)
    visible = np.repeat([p['transparency']<1 for p in specs],[len(q) for q in points])
    body_size = np.ptp(xyz[visible],axis=0)
    diameter = max(body_size)
    pos = {n:np.array(b['position']) for n,b in old.items()}
    extra = sorted(n for n in old if n.startswith('TailExtra'))
    main_old = CORE+extra
    branches = [n for n in old if n not in main_old]
    bones = []
    def add(n, p, parent=-1, role='body', **kwargs):
        index = len(bones)
        bones.append(dict(name=n,position=p.tolist(),parent=parent,role=role,**kwargs))
        return index
    root = add('FishBody', pos['FishBody'], role='head')
    a,b,c,d = (pos[n] for n in CORE[1:])
    chain = [('SpineFront',a),('SpineFrontFlex',mix(a,b,.5)),('SpineMid',b),('SpineRear',mix(b,c,.5)),('TailBase',c)]
    if extra:
        chain += [('TailMid',mix(c,d,.5)),('FishTail',d)]
        prev = d
        for n in extra:
            chain += [(n+'Flex',mix(prev,pos[n],.5)),(n,pos[n])]
            prev = pos[n]
        axis = unit(pos[extra[-1]]-chain[-2][1])
        travel = (xyz-prev)@axis
        mask = visible & (oldw[:,old_indices[extra[-1]]]+oldw[:,old_indices['FishTail']]>.10)
        far = np.max(travel[mask]) if np.any(mask) else 0.
        if far < diameter*.04:
            # The old terminal joint can already sit beyond the skin. Subdivide the last physical span.
            n, last = chain[-1]
            pre = chain[-3][1]
            if np.any(mask):
                actual = np.max((xyz[mask]-pre)@axis)
            else:
                actual = np.linalg.norm(last-pre)
            actual = max(actual, diameter*.04)
            chain[-2:] = [(n+'Flex',pre+axis*actual*.26),(n,pre+axis*actual*.51)]
            chain += [('TailFinBase',pre+axis*actual*.73),('TailFinTip',pre+axis*actual*.96)]
        else:
            chain += [('TailFinBase',prev+axis*far*.33),('TailFinTip',prev+axis*far*.95)]
    else:
        axis = unit(d-c)
        travel = (xyz-c)@axis
        mask = visible & (oldw[:,old_indices['FishTail']]+oldw[:,old_indices['TailBase']]>.08)
        if not np.any(mask):
            mask = visible & (travel>0)
        span = np.max(travel[mask]) if np.any(mask) else np.linalg.norm(d-c)
        span = max(span,diameter*.035)
        terminal = [('TailMid',.28),('FishTail',.53),('TailFinBase',.74),('TailFinTip',.97)]
        if family == 'turtle':
            terminal = [('TailMid',.38),('FishTail',.92)]
        chain += [(n,c+axis*span*t) for n,t in terminal]
    main = [root]
    for n,p in chain:
        main.append(add(n,p,main[-1],role='fin' if n.startswith('TailFin') else 'body'))
    body_indices = {b['name']:i for i,b in enumerate(bones)}
    new = np.zeros((len(xyz),entry['bones']*2))
    new[:,0] = oldw[:,old_indices['FishBody']]
    core_weights = oldw[:,[old_indices[n] for n in main_old[1:]]].sum(axis=1)
    limb_budget = 1-new[:,0]-core_weights
    limb_scale = np.ones(len(xyz))
    if family == 'squid':
        # The old squid left only 5% on the central chain. Spread part of the
        # existing tentacle influence onto its shared bend while preserving head binds.
        shared = np.maximum(core_weights,.35*(1-new[:,0]))
        limb_scale = np.divide(1-new[:,0]-shared,limb_budget,out=np.ones(len(xyz)),where=limb_budget>1e-8)
        limb_scale = np.clip(limb_scale,0,1)
        core_weights = shared
    # Preserve the existing protected head exactly. Expand the bend only behind it.
    ids, alpha = project_weights(xyz,np.array([b['position'] for b in bones[1:]]))
    rows = np.arange(len(xyz))
    t = alpha
    kernels = ((1-t)**3/6, (3*t**3-6*t**2+4)/6, (-3*t**3+3*t**2+3*t+1)/6, t**3/6)
    for j, kernel in enumerate(kernels):
        np.add.at(new,(rows,np.clip(ids+j,1,len(main)-1)),core_weights*kernel)
    if family == 'turtle':
        # Authored rigid shell islands from the old rig stay at one rigid bind.
        shell = oldw[:,old_indices['SpineMid']] > .9999
        new[shell,:] = 0
        new[shell,body_indices['SpineMid']] = 1
    for order,n in enumerate(sorted(branches)):
        w = oldw[:,old_indices[n]] * limb_scale
        variants = [(n,pos[n],w)]
        if family == 'turtle' and 'Rear' in n:
            pivot = pos[n]
            t = smooth(.5 + (xyz[:,0]-pivot[0]) / max(body_size[0]*.12,1e-6))
            offset = np.array([body_size[0]*.13,0,0])
            variants = [('RearFlipperLeft',pivot-offset,w*(1-t)),('RearFlipperRight',pivot+offset,w*t)]
        for branch,pivot,w in variants:
            parent = body_indices.get(old[n]['parent'],body_indices['SpineMid'])
            mask = visible & (w > max(.10, w.max()*.35))
            if not np.any(mask):
                mask = w>0
            assert np.any(mask),(name,branch,'no source limb influence')
            vector = xyz[mask]-pivot
            distances = np.linalg.norm(vector,axis=1)
            distal = vector[distances>=np.quantile(distances,.85)].mean(axis=0)
            if np.linalg.norm(distal) < diameter*.005:
                distal = vector[np.argmax(distances)]
            tip = pivot + distal*.72
            side = -1 if ('Left' in branch or ('Right' not in branch and pivot[0]<0)) else 1
            i = add(branch,pivot,parent,role='limb',side=side,lag=1.1+order*.55)
            j = add(branch+'Tip',tip,i,role='limb_tip',side=side,lag=1.1+order*.55)
            mix_weight = smooth(((xyz-pivot) @ distal)/max(distal @ distal,1e-12))
            if branch.startswith('RearFlipper'):
                mix_weight *= .8
            new[:,i] += w*(1-mix_weight)
            new[:,j] += w*mix_weight
    assert len(bones) == entry['bones']*2, (name,len(bones),entry['bones'])
    if name.startswith('HaiGui_'):
        # The shell's overlaid material edges must use identical skin weights.
        # When an overlay shares the actual rigid shell vertex, preserve the rigid bind.
        layer = np.repeat(np.arange(len(points)),[len(v) for v in points])
        groups = {}
        for index, keypos in enumerate(map(tuple,np.round(xyz/max(diameter*1e-5,1e-6)).astype(np.int64))):
            groups.setdefault(keypos,[]).append(index)
        for group in groups.values():
            if len(group)<2 or len(set(layer[group]))==1:continue
            if np.any(new[group,0]>.9999):
                new[group,:]=0
                new[group,0]=1
            elif np.any(new[group,body_indices['SpineMid']]>.9999):
                new[group,:]=0
                new[group,body_indices['SpineMid']]=1
            else:
                new[group,:]=new[group].mean(axis=0)
    totals = new.sum(axis=1)
    new /= totals[:,None]
    assert np.all(new[oldw[:,old_indices['FishBody']]>.999999,0]>.99999), (name, 'rigid head')
    # Roblox skin weights are quantized on publication. Keep four largest influences, normalized.
    ranks = np.argsort(-new,axis=1)[:,:4]
    ranked = np.take_along_axis(new,ranks,axis=1)
    ranked[ranked < 1/255] = 0
    ranked /= ranked.sum(axis=1)[:,None]
    effective = np.zeros(len(bones))
    for k in range(4):
        np.maximum.at(effective,ranks[visible,k],ranked[visible,k])
    weak = [b['name'] for b,w in zip(bones,effective) if w < .10]
    result = {'key':key,'name':name,'family':family,'bones':bones,'main':main,
              'bodySize':body_size.tolist(),'mouth':data['mouth'],'sourceClips':data['animations'],
              'attributes':entry['attributes'],'weak':weak,'effective':effective.tolist(),'parts':[]}
    offset = 0
    for i,p in enumerate(specs):
        count = len(points[i])
        # Flat index arrays avoid significant HTTP/JSON overhead per vertex.
        part_weights = {'indices':ranks[offset:offset+count].flatten().tolist(),
                        'weights':np.round(ranked[offset:offset+count],8).flatten().tolist()}
        spec = {k:p[k] for k in ('name','mesh','frame','size','meshSize')}
        spec['vertexCount'] = count
        spec['recipe'] = hashlib.sha256(json.dumps([bones,spec,part_weights],separators=(',',':')).encode()).hexdigest()
        save(f'payload/{key}/part{i+1:03}.json',part_weights)
        result['parts'].append(spec)
        offset += count
    # Reassign the exact existing surface points using their nearest source vertex's new skin.
    drip=[]
    for point in data['drip']:
        pos = np.array(point['position'])
        index = int(np.argmin(np.sum((xyz-pos)**2,axis=1)+np.where(visible,0,1e9)))
        drip.append(dict(name=point['name'],bone=bones[ranks[index,0]]['name'],
                         influence=float(ranked[index,0]),sourceVertex=index))
    assert len(drip)==24, (name,'missing legacy drips',len(drip))
    result['drip'] = drip
    # Share actions only when the pose hierarchy, axes, roles and mesh roots match.
    signature = [4, family,[(b['name'],b['parent'],b['role'],b.get('side'),b.get('lag')) for b in bones],entry['motionRoots']]
    variant = 'v2_'+family+'_'+hashlib.sha256(json.dumps(signature).encode()).hexdigest()[:10]
    result['variant'] = variant
    motion_path=ROOT/f'motions/{variant}.json'
    if not motion_path.exists():
        save(motion_path.relative_to(ROOT), {'variant':variant,'bones':bones,'partNames':signature[3],'clips':motion(bones,main,family)})
    save(f'payload/{key}/rig.json', result)
    return result

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--pilots',action='store_true')
    parser.add_argument('--force',action='store_true')
    parser.add_argument('--only',nargs='+')
    args=parser.parse_args()
    entries=read('inventory.json')['rows']
    roots = {}
    for entry in entries:
        roots.setdefault((entry['family'], entry['bones']), set()).update(p['name'] for p in entry['parts'])
    for entry in entries:
        entry['motionRoots'] = sorted(roots[entry['family'], entry['bones']])
    report={'built':{},'errors':{},'pending':[]}
    for entry in entries:
        key=entry['key']
        if (args.pilots and not entry.get('pilot')) or (args.only and entry['name'] not in args.only):
            continue
        if not (ROOT/f'source/{key}/rig.json').exists():
            report['pending'].append(entry['name'])
            continue
        try:
            old=ROOT/f'payload/{key}/rig.json'
            data=read(old.relative_to(ROOT)) if old.exists() and not args.force else build(entry)
            report['built'][entry['name']]={'key':key,'bones':len(data['bones']),'weak':data['weak'],'variant':data['variant']}
            print(entry['name'],len(data['bones']),data['weak'],flush=True)
        except Exception as exc:
            report['errors'][entry['name']]=str(exc)
            print(entry['name'],str(exc),flush=True)
        save('build-'+('selected' if args.only else ('pilots' if args.pilots else 'all'))+'.json',report)
if __name__=='__main__':
    main()
