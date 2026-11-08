"""Parse Studio's native OBJ into per-fish, primary-local geometry without changing UVs."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def key(name):
    return re.sub('[^a-z0-9]', '', name.lower())


def load():
    manifest = json.loads((ROOT / 'source-manifest.json').read_text())
    fish = {key(row['name']): row for row in manifest['fish']}
    vertices, uvs, normals, groups, group = [], [], [], [], None
    for line in (ROOT / 'source/AllFish.obj').read_text().splitlines():
        s = line.split()
        if not s:
            continue
        if s[0] == 'v':
            vertices.append(list(map(float, s[1:4])))
        elif s[0] == 'vt':
            uvs.append(list(map(float, s[1:3])))
        elif s[0] == 'vn':
            normals.append(list(map(float, s[1:4])))
        elif s[0] == 'g':
            group = dict(name=s[1], faces=[])
            groups.append(group)
        elif s[0] == 'usemtl':
            group['material'] = s[1]
        elif s[0] == 'f':
            assert len(s) == 4
            group['faces'].append([[int(x) - 1 for x in corner.split('/')] for corner in s[1:]])
    result = {}
    for g in groups:
        candidates = [f for k, f in fish.items() if key(g['name']).startswith(k)]
        assert len(candidates) == 1, g['name']
        f = candidates[0]
        main = next(p for p in f['parts'] if p['name'] == f['primary'])
        matrix = main['cframe']
        def rotate(v):
            return [sum(matrix[3 + row * 3 + col] * v[row] for row in range(3)) for col in range(3)]
        def point(v):
            return rotate([v[i] - matrix[i] for i in range(3)])
        part_candidates = [p for p in f['parts'] if p['name'] != 'CameraPart' and key(g['name']).endswith(key(p['name']) + '1')]
        longest = max(len(key(p['name'])) for p in part_candidates)
        part_candidates = [p for p in part_candidates if len(key(p['name'])) == longest]
        # Parts with the same name are eyes; their geometry location resolves them.
        center = [sum(vertices[c[0]][i] for face in g['faces'] for c in face) / (len(g['faces']) * 3) for i in range(3)]
        part = min(part_candidates, key=lambda p: sum((p['cframe'][i] - center[i]) ** 2 for i in range(3)))
        maps, values = [{}, {}, {}], [[], [], []]
        faces = []
        for face in g['faces']:
            corners = []
            for corner in face:
                mapped = []
                for axis, idx in enumerate(corner):
                    if idx not in maps[axis]:
                        maps[axis][idx] = len(values[axis])
                        v = (vertices, uvs, normals)[axis][idx]
                        values[axis].append(point(v) if axis == 0 else rotate(v) if axis == 2 else v)
                    mapped.append(maps[axis][idx])
                corners.append(mapped)
            faces.append(corners)
        result.setdefault(f['name'], dict(source=f, parts=[]))['parts'].append(dict(
            original=part, name=g['name'], material=g['material'], vertices=values[0], uvs=values[1], normals=values[2], faces=faces))
    assert len(result) == len(manifest['fish'])
    return result


def components(part, weld=False, uv_seams=False):
    vertices = part['vertices']
    parents = list(range(len(vertices)))
    def find(i):
        while parents[i] != i:
            parents[i] = parents[parents[i]]
            i = parents[i]
        return i
    coincident = {}
    vertex_uv = {}
    for face in part['faces']:
        for corner in face:
            vertex_uv[corner[0]] = part['uvs'][corner[1]]
    for i, v in enumerate(vertices):
        k = tuple(round(a, 3) for a in v)
        if uv_seams:
            k += tuple(round(a, 5) for a in vertex_uv[i])
        if weld and k in coincident:
            parents[find(i)] = find(coincident[k])
        else:
            coincident[k] = i
    for face in part['faces']:
        for corner in face[1:]:
            parents[find(corner[0])] = find(face[0][0])
    groups = {}
    for i in range(len(vertices)):
        groups.setdefault(find(i), []).append(i)
    return list(groups.values())


def bounds(vertices, ids=None):
    points = vertices if ids is None else [vertices[i] for i in ids]
    lo = [min(v[a] for v in points) for a in range(3)]
    hi = [max(v[a] for v in points) for a in range(3)]
    return dict(low=lo, high=hi, center=[(a+b)/2 for a,b in zip(lo,hi)], size=[b-a for a,b in zip(lo,hi)])


if __name__ == '__main__':
    data = load()
    (ROOT / 'source/parsed.json').write_text(json.dumps(data, separators=(',', ':')))
    summaries = {}
    for name, row in data.items():
        part = next(p for p in row['parts'] if p['original']['name'] == row['source']['primary'])
        length = row['source']['parts'][next(i for i,p in enumerate(row['source']['parts']) if p['name']==row['source']['primary'])]['size'][2]
        groups = sorted(components(part), key=len, reverse=True)
        summaries[name] = [dict(vertices=len(ids), **bounds(part['vertices'], ids)) for ids in groups if bounds(part['vertices'], ids)['center'][2] < -length * .15]
        print(name, 'parts',len(row['parts']), 'components',len(groups), 'front islands',json.dumps(summaries[name])[:1800])
    (ROOT / 'source/components.json').write_text(json.dumps(summaries, indent=2))
