"""Author native-exported fish skins and eyes in canonical primary-part coordinates."""
import copy
import json
import math
from pathlib import Path
from inspect_source import ROOT, load, components, bounds

EYES = {
    'YellowfinTuna': (-.052, -2.767), 'BallinaAngelfish': (.031, -1.427),
    'Azure Sturgeon': (.706, -3.548), 'PrettyRoseGoby': (-.977, -2.944),
    'AngelShark': (-.139, -5.131), 'Jadefin': (.237, -2.638),
    'Purplefin': (-.073, -2.293), 'Silver Tail': (-.1, -2.846),
    'SaddleButterflyfish': (-.203, -1.739), 'QueenAngelfish': (.038, -2.45),
    'Chimera Perch': (.194, -2.974), 'MoorishIdol': (-.259, -1.512),
    'Stone Bass': (.013, -2.442), 'ThresherShark': (-.27, -6.613),
    'Venomfish': (.492, -4.978), 'TomatoClownfish': (.05, -1.984),
    'Inferno Pike': (.285, -4.436), 'GreenbandedGoby': (-.19, -1.801),
    'Clownfish': (-.06, -1.726), 'AzureDamsel': (.024, -1.896),
    'Frosttail': (.066, -2.664), 'Golden Carp': (.097, -2.8),
    'Blue Moonfish': (.144, -4.782), 'Thunderfin': (.608, -3.93),
    'FrenchAngelfish': (-.124, -1.42),
}
BASE_NAMES = ['FishBody', 'SpineFront', 'SpineMid', 'TailBase', 'FishTail']


def smooth(v):
    v = max(0, min(1, v))
    return v*v*(3-2*v)


def eye_regions(name, parts):
    if name in ('Firetail Tilapia', 'Tropical Butterfly'):
        names = ['polySurface34_group1'] if name == 'Firetail Tilapia' else ['SXYu_02', 'SXYu_03']
        regions = [[], []]
        for pi, p in enumerate(parts):
            if p['original']['name'] in names:
                for ids in components(p, True):
                    side = int(bounds(p['vertices'], ids)['center'][0] > 0)
                    regions[side].extend((pi, i) for i in ids)
        return regions
    y, z = EYES[name]
    regions = [[], []]
    main = parts[0]
    for ids in components(main, True, True):
        b = bounds(main['vertices'], ids)
        if 8 <= len(ids) <= 110 and abs(b['center'][1]-y)<.035 and abs(b['center'][2]-z)<.035:
            regions[int(b['center'][0] > 0)].extend((0,i) for i in ids)
    # Several fantasy fish have neon pupils as separate Parts.
    for pi, p in enumerate(parts[1:], 1):
        if p['original']['class'] == 'Part':
            b=bounds(p['vertices'])
            if abs(b['center'][1]-y)<.08 and abs(b['center'][2]-z)<.08:
                regions[int(b['center'][0]>0)].extend((pi,i) for i in range(len(p['vertices'])))
    return regions


def enlarge(name, parts, length):
    regions = eye_regions(name, parts)
    assert all(regions), (name, 'missing eye region')
    baseline = [copy.deepcopy(p['vertices']) for p in parts]
    eye_bounds = [bounds([baseline[pi][i] for pi,i in region]) for region in regions]
    factor = 1.5 if max(max(b['size'][1:]) for b in eye_bounds)/length > .065 else 2
    if name in ('Jadefin','Tropical Butterfly','Firetail Tilapia'):
        factor=1.5
    report=[]
    for side, (region,b) in enumerate(zip(regions,eye_bounds)):
        center=b['center']; sign=1 if side else -1
        selected=set(region)
        coords={tuple(round(a,4) for a in baseline[pi][i]) for pi,i in region}
        # Full-eye transform, including every duplicate at a material/normal seam.
        # The surrounding head has a smooth falloff, so integrated eyes remain watertight.
        radius=max(b['size'][1:])*.55
        outward=length*.003
        for pi,p in enumerate(parts):
            for i,v in enumerate(baseline[pi]):
                exact=(pi,i) in selected or tuple(round(a,4) for a in v) in coords
                if exact:
                    influence=1
                elif pi==0 and v[0]*sign>0:
                    distance=math.hypot(v[1]-center[1],v[2]-center[2])
                    influence=(1-smooth((distance-radius)/(radius*.9)))*(1-smooth((abs(v[0]-center[0])-.15*radius)/(radius*1.5)))
                else:
                    influence=0
                if influence:
                    p['vertices'][i]=[v[a]+influence*((v[a]-center[a])*(factor-1)+(outward*sign if a==0 else 0)) for a in range(3)]
        after=bounds([parts[pi]['vertices'][i] for pi,i in region])
        ratios=[after['size'][a]/b['size'][a] for a in (1,2)]
        assert max(abs(v-factor) for v in ratios)<1e-8
        report.append(dict(side='right' if side else 'left',sourceVertices=len(region),center=center,
                           diameterRatios=ratios,outward=outward))
    return dict(scale=factor,eyes=report)


def build(name, row):
    parts=copy.deepcopy(row['parts'])
    parts.sort(key=lambda p: (p['original']['name'] != row['source']['primary'], p['name']))
    main=parts[0]; length=main['original']['size'][2]
    eye=enlarge(name,parts,length)
    names=BASE_NAMES[:]; anchors=[.25,.42,.62,.82,.97]; pivots=[.5,.28,.48,.70,.88]
    if name=='Jadefin':
        # Its enlarged eyes extend farther behind the snout; keep that entire head rigid.
        anchors[0]=.31
        pivots[1]=.33
    variant='standard'
    if name=='ThresherShark':
        variant='longtail';names+=['TailExtra1','TailExtra2']
        pivots=[.5,.15,.28,.42,.58,.74,.90];anchors=[.12,.23,.36,.50,.66,.82,.97]
    bones=[dict(name=n,parent=i-1,position=[0,0,0 if i==0 else length*(pivots[i]-.5)]) for i,n in enumerate(names)]
    if name in ('AngelShark','Tropical Butterfly'):
        variant='fins'
        for sign,n in [(-1,'FinLeft'),(1,'FinRight')]:
            bones.append(dict(name=n,parent=2,position=[sign*length*.08,-length*.03,-length*.06]))
    # Mouth is the center of the frontmost geometry, separate from eyes and decorations.
    front=min(v[2] for v in main['vertices'])
    mouth_points=[v for v in main['vertices'] if v[2]<front+length*.008]
    mouth=[sum(v[a] for v in mouth_points)/len(mouth_points) for a in range(3)]
    output=[]
    for pi,p in enumerate(parts):
        b=bounds(p['vertices']); center=b['center']
        # Keep original source coordinates for audits; upload coordinates are centered.
        weights=[]
        for v in p['vertices']:
            along=v[2]/length+.5
            segment=0
            while segment<len(anchors)-2 and along>anchors[segment+1]:segment+=1
            alpha=smooth((along-anchors[segment])/(anchors[segment+1]-anchors[segment]))
            ids=[segment,segment+1];values=[1-alpha,alpha]
            if variant=='fins' and along>.25:
                amount=smooth((abs(v[0])-length*.08)/(length*.16))
                ids.append(5 if v[0]<0 else 6);values=[(1-alpha)*(1-amount),alpha*(1-amount),amount]
            assert abs(sum(values)-1)<1e-8
            weights.append([ids,values])
        # Retain existing normals when possible; recompute flat normals after eye edits.
        normals=[];faces=[]
        for face in p['faces']:
            a,bv,c=[p['vertices'][v[0]] for v in face]
            ab=[bv[i]-a[i] for i in range(3)];ac=[c[i]-a[i] for i in range(3)]
            normal=[ab[1]*ac[2]-ab[2]*ac[1],ab[2]*ac[0]-ab[0]*ac[2],ab[0]*ac[1]-ab[1]*ac[0]]
            norm=math.sqrt(sum(v*v for v in normal))
            normal=[v/norm for v in normal] if norm>1e-10 else p['normals'][face[0][2]]
            ni=len(normals);normals.append(normal)
            faces.append([v[0] for v in face]+[v[1] for v in face]+[ni]*3)
        output.append(dict(name='polySurface5' if pi==0 else 'FishMesh%02d'%(pi+1),
                           original=p['original'],exportGroup=p['name'],center=center,size=b['size'],
                           vertices=[[v[a]-center[a] for a in range(3)] for v in p['vertices']],
                           uvs=p['uvs'],normals=normals,faces=faces,weights=weights))
    animation_bounds=ROOT/'animation-bounds.json'
    radius=json.loads(animation_bounds.read_text()).get(name,{}).get('presentationRadius') if animation_bounds.exists() else None
    return dict(name=name,variant=variant,eye=eye,bones=bones,weightAnchors=anchors,mouth=mouth,parts=output,presentationRadius=radius,
                primarySource=row['source']['primary'],sourcePivot=row['source']['pivot'],
                validation=dict(uvUnchanged=True,normalizedWeights=True,logicalBones=len(bones),
                                partCount=len(parts),triangles=sum(len(p['faces']) for p in parts)))


if __name__=='__main__':
    target=ROOT/'payload';target.mkdir(exist_ok=True)
    reports=[]
    for name,row in load().items():
        if name=='Elder Fish':continue
        data=build(name,row)
        (target/(name+'.json')).write_text(json.dumps(data,separators=(',',':')))
        reports.append({k:v for k,v in data.items() if k not in ('parts','sourcePivot')})
    (ROOT/'build-validation.json').write_text(json.dumps(reports,indent=2))
    print(json.dumps([dict(name=r['name'],eyes=r['eye']['scale'],bones=len(r['bones'])) for r in reports]))
