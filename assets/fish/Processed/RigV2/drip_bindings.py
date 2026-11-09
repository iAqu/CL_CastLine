"""Record the exact upgraded vertex weights adjacent to every existing drip anchor."""
from build import read, save
for row in read('inventory.json')['rows']:
    key=row['key']
    rig=read(f'payload/{key}/rig.json')
    weights=[read(f'payload/{key}/part{i:03}.json') for i in range(1,len(rig['parts'])+1)]
    parts=[read(f'source/{key}/part{i:03}.json') for i in range(1,len(rig['parts'])+1)]
    records={}
    for point in rig['drip']:
        index=point['sourceVertex']
        for part, data, source in zip(rig['parts'],weights,parts):
            if index>=part['vertexCount']:
                index-=part['vertexCount'];continue
            values=data['weights'][index*4:index*4+4]
            indices=data['indices'][index*4:index*4+4]
            joints=[{'name':rig['bones'][j]['name'],'weight':w} for j,w in zip(indices,values) if w>0]
            assert 1<=len(joints)<=4 and abs(sum(x['weight'] for x in joints)-1)<1e-6
            records[point['name']]={'influences':joints,'sourcePart':part['name'],'sourceVertex':index,'position':source['vertices'][index]}
            break
    assert len(records)==24
    save(f'drip-bindings/{key}.json',records)
