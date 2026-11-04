"""Rebuild the native-exported base mesh with 2x eyes; Texture overlays stay in Studio."""
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def build():
    positions, uvs, normals, faces = [], [], [], []
    for line in (ROOT / "source/BasicBait_original.obj").read_text().splitlines():
        fields = line.split()
        if not fields:
            continue
        if fields[0] == "v":
            x, y, z = map(float, fields[1:4])
            positions.append([x, y - 50, z])
        elif fields[0] == "vt":
            uvs.append(list(map(float, fields[1:3])))
        elif fields[0] == "vn":
            normals.append(list(map(float, fields[1:4])))
        elif fields[0] == "f":
            corners = [tuple(int(n) - 1 for n in f.split("/")) for f in fields[1:]]
            assert len(corners) == 3, "Native export must be triangulated"
            faces.append(corners)
    baseline = [v[:] for v in positions]
    parent = list(range(len(positions)))

    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    coincident = {}
    for i, v in enumerate(positions):
        key = tuple(round(a, 5) for a in v)
        if key in coincident:
            parent[find(i)] = find(coincident[key])
        else:
            coincident[key] = i
    for face in faces:
        for corner in face[1:]:
            parent[find(corner[0])] = find(face[0][0])
    groups = {}
    for i in range(len(positions)):
        groups.setdefault(find(i), []).append(i)

    def bounds(ids):
        return ([min(positions[i][a] for i in ids) for a in range(3)],
                [max(positions[i][a] for i in ids) for a in range(3)])

    eye_groups = [ids for ids in groups.values() if bounds(ids)[0][2] > .99249]
    assert len(eye_groups) == 4, "Expected two black eyes and two white highlights"
    regions = {"left": [], "right": []}
    centers = {}
    for ids in eye_groups:
        low, high = bounds(ids)
        name = "left" if (low[0] + high[0]) / 2 < 0 else "right"
        regions[name].extend(ids)
        if high[1] - low[1] > .2:
            centers[name] = [(low[a] + high[a]) / 2 for a in range(3)]
    assert len(centers) == 2
    for name, ids in regions.items():
        center = centers[name]
        for i in ids:
            # Diameter doubles on the face; depth remains unchanged to retain the mesh bounds.
            for a in (0, 1):
                positions[i][a] = center[a] + (positions[i][a] - center[a]) * 2
    left, right = bounds(regions["left"]), bounds(regions["right"])
    separate = max(0, left[1][0] + .01 - right[0][0]) / 2
    for name, ids in regions.items():
        for i in ids:
            positions[i][0] += -separate if name == "left" else separate
    all_eyes = regions["left"] + regions["right"]
    low, high = bounds(all_eyes)
    # Minimal translation to keep the enlarged eyes within the rounded head silhouette.
    shift_x = min(max(0, -.311151 + .02 - low[0]), .31095 - .02 - high[0])
    shift_y = min(max(0, -.2 + .015 - low[1]), .335 - .015 - high[1])
    for i in all_eyes:
        positions[i][0] += shift_x
        positions[i][1] += shift_y
    eye_set = set(all_eyes)
    report = {}
    for name, ids in regions.items():
        before = [[min(baseline[i][a] for i in ids) for a in range(3)],
                  [max(baseline[i][a] for i in ids) for a in range(3)]]
        after = bounds(ids)
        ratios = [(after[1][a] - after[0][a]) / (before[1][a] - before[0][a]) for a in (0, 1)]
        assert max(abs(r - 2) for r in ratios) < 1e-8
        report[name] = {"diameterRatios": ratios, "centerAdjustment": [shift_x + (-separate if name == "left" else separate), shift_y, 0]}
    assert all(v == baseline[i] for i, v in enumerate(positions) if i not in eye_set)
    assert bounds(range(len(positions))) == ([min(v[a] for v in baseline) for a in range(3)], [max(v[a] for v in baseline) for a in range(3)])
    unique, remap, vertex_map = [], [], {}
    for v in positions:
        key = tuple(v)
        if key not in vertex_map:
            vertex_map[key] = len(unique)
            unique.append(v)
        remap.append(vertex_map[key])
    packed_uvs, uv_map, uv_remap = [], {}, []
    for uv in uvs:
        key = tuple(uv)
        if key not in uv_map:
            uv_map[key] = len(packed_uvs)
            packed_uvs.append(uv)
        uv_remap.append(uv_map[key])
    packed_faces, packed_normals, normal_map, normal_values = [], [], {}, {}
    for face in faces:
        eye = face[0][0] in eye_set
        normal_ids = []
        for _, _, ni in face:
            key = (ni, eye)
            if key not in normal_map:
                n = normals[ni][:]
                if eye:
                    n[0] /= 2
                    n[1] /= 2
                    length = math.sqrt(sum(a * a for a in n))
                    n = [a / length for a in n]
                value = tuple(n)
                if value not in normal_values:
                    normal_values[value] = len(packed_normals)
                    packed_normals.append(n)
                normal_map[key] = normal_values[value]
            normal_ids.append(normal_map[key])
        packed_faces.append([remap[c[0]] for c in face] + [uv_remap[c[1]] for c in face] + normal_ids)
    payload = {"vertices": unique, "uvs": packed_uvs, "normals": packed_normals, "faces": packed_faces}
    (ROOT / "BasicBait_Eyes2x.mesh.json").write_text(json.dumps(payload, separators=(",", ":")) + "\n")
    validation = {"scale": 2, "eyes": report, "vertices": len(unique), "triangles": len(faces),
                  "boundsUnchanged": True, "nonEyeVerticesUnchanged": True,
                  "sourceMeshId": "rbxassetid://114464965301610"}
    (ROOT / "validation.json").write_text(json.dumps(validation, indent=2) + "\n")
    return payload, validation


if __name__ == "__main__":
    print(json.dumps(build()[1], indent=2))
