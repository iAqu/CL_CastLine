"""Offline surface authoring. Legacy Elder sampling, or --all from processed skin payloads."""
import json
import math
import sys
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree


def sample_elder():
    import bpy
    output = Path(__file__).resolve().parent
    body = bpy.data.objects["polySurface5"]
    vertices = body.data.vertices
    tree = BVHTree.FromPolygons([v.co for v in vertices], [list(p.vertices) for p in body.data.polygons])
    length = max(v.co.y for v in vertices) - min(v.co.y for v in vertices)
    offset = 0.025
    points = []


    def canonical(v):
        return [v.x, v.z, -v.y]


    def point(name, bone, region, surface, normal):
        normal = normal.normalized()
        points.append({
            "name": name, "bone": bone, "region": region,
            "bodyPosition": canonical(surface + normal * offset),
            "surfacePosition": canonical(surface), "bodyNormal": canonical(normal),
        })


    for fraction, bone in [(0.25, "FishBody"), (0.42, "SpineFront"), (0.62, "SpineMid"), (0.82, "TailBase")]:
        for angle in [-160, -120, -80, -40]:
            direction = Vector((math.cos(math.radians(angle)), 0, math.sin(math.radians(angle))))
            origin = Vector((0, -length * (fraction - 0.5), 0)) + direction * 10
            hit, normal, _, _ = tree.ray_cast(origin, -direction)
            assert hit is not None, (fraction, angle)
            point(f"Belly{len(points) + 1:02d}", bone, "belly", hit, normal)

    # Beyond the final weight anchor, all tail vertices are controlled by FishTail.
    tail = [v for v in vertices if 0.5 - v.co.y / length >= 0.97]
    tail_ids = {v.index for v in tail}
    candidates = {}


    def tail_candidate(position, normal):
        key = tuple(round(c, 6) for c in position)
        if key not in candidates:
            candidates[key] = (position.copy(), normal.copy())


    for vertex in tail:
        tail_candidate(vertex.co, vertex.normal)
    # Edge interpolation retains full FishTail weight at both ends and in between.
    for edge in body.data.edges:
        if all(index in tail_ids for index in edge.vertices):
            a, b = [vertices[index] for index in edge.vertices]
            for fraction in [0.25, 0.5, 0.75]:
                tail_candidate(a.co.lerp(b.co, fraction), a.normal.lerp(b.normal, fraction))
    tail_samples = list(candidates.values())
    chosen = [min(tail_samples, key=lambda sample: (sample[0].z, tuple(sample[0])))]
    while len(chosen) < 8:
        candidate = max(tail_samples, key=lambda sample: min((sample[0] - q[0]).length_squared for q in chosen))
        assert min((candidate[0] - q[0]).length_squared for q in chosen) > 1e-8, "Not enough distinct tail samples"
        chosen.append(candidate)
    for index, (position, normal) in enumerate(chosen, 1):
        point(f"Tail{index:02d}", "FishTail", "tail", position, normal)

    width = max(v.co.z for v in vertices) - min(v.co.z for v in vertices)
    span = max(p["bodyPosition"][1] for p in points) - min(p["bodyPosition"][1] for p in points)
    assert len(points) == 24 and span / width >= 0.3
    result = {
        "meshId": "rbxassetid://123142360733957", "surfaceOffset": offset, "points": points,
        "validation": {"count": len(points), "horizontalSpan": span, "fishWidth": width, "coverage": span / width},
    }
    (output / "surface-points.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result["validation"]))


def sample_processed(data):
    """Sample real surface regions with >=90% influence from their parent bone."""
    part = data["parts"][0]
    vertices = [Vector(v) for v in part["vertices"]]
    faces = [face[:3] for face in part["faces"]]
    tree = BVHTree.FromPolygons(vertices, faces, all_triangles=True)
    center = Vector(part["center"])
    length = part["original"]["size"][2]
    # Legacy payloads predate weightAnchors; these match build_fish.py.
    anchors = data.get("weightAnchors") or ([.12, .23, .36, .50, .66, .82, .97]
              if data["variant"] == "longtail" else [.31 if data["name"] == "Jadefin" else .25, .42, .62, .82, .97])
    normals = [Vector((0, 0, 0)) for _ in vertices]
    for face in faces:
        a, b, c = [vertices[i] for i in face]
        normal = (b-a).cross(c-a)
        for i in face:
            normals[i] += normal
    points = []

    def add(name, bone, region, sample):
        position, normal, weight = sample
        normal = normal.normalized()
        assert normal.length > .99, (data["name"], name, "zero normal")
        points.append(dict(name=name, bone=bone, region=region,
                           bodyPosition=list(position + normal * .025),
                           surfacePosition=list(position), bodyNormal=list(normal), boneWeight=weight))

    def surface_region(bone_index, threshold):
        weights = [sum(w for bone, w in zip(ids, values) if bone == bone_index)
                   for ids, values in part["weights"]]
        assert max(weights) >= threshold, (data["name"], bone_index, "insufficient skin influence")
        candidates = {}

        def candidate(position, normal, weight):
            if normal.length > 1e-8:
                candidates[tuple(round(c, 6) for c in position)] = (position, normal.normalized(), weight)

        # Clip each real triangle by its linearly interpolated skin influence.
        # Sampling the clipped polygons also handles tails with only one rigid tip.
        for face in faces:
            polygon = [(vertices[i], normals[i], weights[i]) for i in face]
            clipped = []
            for a, b in zip(polygon, polygon[1:]+polygon[:1]):
                if a[2] >= threshold:
                    clipped.append(a)
                if (a[2] >= threshold) != (b[2] >= threshold):
                    fraction = (threshold-a[2])/(b[2]-a[2])
                    clipped.append((a[0].lerp(b[0], fraction), a[1].lerp(b[1], fraction), threshold))
            for a, b in zip(clipped, clipped[1:]+clipped[:1]):
                candidate(*a)
                for fraction in (.25, .5, .75):
                    candidate(a[0].lerp(b[0], fraction), a[1].lerp(b[1], fraction),
                              a[2]*(1-fraction)+b[2]*fraction)
            if len(clipped) >= 3:
                candidate(sum((v[0] for v in clipped), Vector())/len(clipped),
                          sum((v[1] for v in clipped), Vector())/len(clipped),
                          sum(v[2] for v in clipped)/len(clipped))
        return list(candidates.values())

    radius = max(part["size"])*2+1
    for bone_index, fraction in enumerate(anchors[:4]):
        maximum = max(sum(w for b, w in zip(ids, values) if b == bone_index)
                      for ids, values in part["weights"])
        samples = surface_region(bone_index, min(.98, maximum-.005))
        assert maximum-.005 >= .9, (data["name"], "belly skin influence")
        for angle in (-160, -120, -80, -40):
            direction = Vector((math.cos(math.radians(angle)), math.sin(math.radians(angle)), 0))
            axis = Vector((-center.x, -center.y, length*(fraction-.5)-center.z))
            hit, _, _, _ = tree.ray_cast(axis+direction*radius, -direction)
            target = hit if hit is not None else axis+direction*max(part["size"][:2])
            choices = [p for p in samples if all((p[0]-Vector(q["surfacePosition"])).length >= .001 for q in points)]
            assert choices, (data["name"], "insufficient distinct belly surface")
            pick = min(choices, key=lambda p: (p[0]-target).length_squared)
            add("Belly%02d" % (len(points)+1), data["bones"][bone_index]["name"], "belly", pick)

    tail_name = "TailExtra2" if data["variant"] == "longtail" else "FishTail"
    tail_index = next(i for i, bone in enumerate(data["bones"]) if bone["name"] == tail_name)
    samples = surface_region(tail_index, .95)
    assert len(samples) >= 8, (data["name"], "insufficient tail surface")
    chosen = [min(samples, key=lambda s: (s[0].y, tuple(s[0])))]
    while len(chosen) < 8:
        pick = max(samples, key=lambda s: min((s[0]-p[0]).length_squared for p in chosen))
        assert min((pick[0]-p[0]).length_squared for p in chosen) > 1e-8
        chosen.append(pick)
    for i, sample in enumerate(chosen, 1):
        add("Tail%02d" % i, tail_name, "tail", sample)

    span = max(p["bodyPosition"][1] for p in points)-min(p["bodyPosition"][1] for p in points)
    coverage = span/part["size"][1]
    # Tall decorative dorsal fins enlarge Size.Y beyond the wet belly/tail area.
    assert len(points) == 24 and coverage >= .2, (data["name"], "coverage", coverage)
    assert len({tuple(round(c, 5) for c in p["surfacePosition"]) for p in points}) == 24
    return dict(surfaceOffset=.025, points=points, primarySize=part["size"],
                validation=dict(count=24, coverage=coverage,
                                minimumBoneWeight=min(p["boneWeight"] for p in points)))


def sample_all():
    root = Path(__file__).resolve().parents[2]/"fish"/"Processed"
    fish = {"Elder Fish": json.loads((Path(__file__).parent/"surface-points.json").read_text())}
    for path in sorted((root/"payload").glob("*.json")):
        data = json.loads(path.read_text())
        fish[data["name"]] = sample_processed(data)
    assert len(fish) == 28
    result = dict(version=1, fish=fish)
    (root/"drip-surface-points.json").write_text(json.dumps(result, indent=2)+"\n")
    print(json.dumps({"fish": len(fish), "points": sum(len(f["points"]) for f in fish.values()),
                      "minimumCoverage": min(f["validation"]["coverage"] for f in fish.values())}))


if __name__ == "__main__":
    if "--all" in sys.argv:
        sample_all()
    else:
        sample_elder()
