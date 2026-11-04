"""Asset-authoring only: enlarge the original Elder Fish's two eye regions."""
from mathutils import Vector
from mathutils.bvhtree import BVHTree


def enlarge_eyes(body):
    if body.get("EyeDiameterScale", 1) == 2:
        return None
    assert len(body.data.vertices) == 1606, "Unexpected Elder Fish source topology"
    baseline = [v.co.copy() for v in body.data.vertices]
    # Original OBJ islands: black pupil + yellow ring for each eye.
    regions = {"left": list(range(620, 652)), "right": list(range(652, 689))}
    eye_ids = set(regions["left"] + regions["right"])
    polygons = [tuple(p.vertices) for p in body.data.polygons if not eye_ids.intersection(p.vertices)]
    surface = BVHTree.FromPolygons(baseline, polygons, all_triangles=False)
    report, edits = {}, []
    for name, ids in regions.items():
        low = Vector(tuple(min(baseline[i][a] for i in ids) for a in range(3)))
        high = Vector(tuple(max(baseline[i][a] for i in ids) for a in range(3)))
        center = (low + high) / 2
        assert 2.9 < center.y < 3.3 and abs(center.x) < .4, "Source eye landmarks changed"
        sign = -1 if center.x < 0 else 1
        scaled = {i: center + (baseline[i] - center) * 2 for i in ids}
        samples = list(scaled.values())
        for p in body.data.polygons:
            if p.vertices[0] in scaled:
                points = [scaled[i] for i in p.vertices]
                samples.append(sum(points, Vector()) / len(points))
                samples.extend((a + b) / 2 for a, b in zip(points, points[1:] + points[:1]))
        outward = 0.0
        for point in samples:
            hit, _, _, _ = surface.ray_cast(Vector((sign * 2, point.y, point.z)), Vector((-sign, 0, 0)), 4)
            if hit is not None:
                outward = max(outward, sign * (hit.x - point.x) + .002)
        shift = Vector((sign * outward, 0, 0))
        for i in ids:
            body.data.vertices[i].co = scaled[i] + shift
            old, new = baseline[i], body.data.vertices[i].co
            # Blender XYZ -> canonical Roblox XYZ, matching the installed rig.
            edits.append({"old": [old.x, old.z, -old.y], "new": [new.x, new.z, -new.y]})
        after_low = Vector(tuple(min(body.data.vertices[i].co[a] for i in ids) for a in range(3)))
        after_high = Vector(tuple(max(body.data.vertices[i].co[a] for i in ids) for a in range(3)))
        ratios = [(after_high[a] - after_low[a]) / (high[a] - low[a]) for a in range(3)]
        assert max(abs(r - 2) for r in ratios) < .0001
        report[name] = {"vertices": len(ids), "diameterRatios": ratios[1:], "outwardAdjustment": outward}
    assert all((v.co - baseline[v.index]).length == 0 for v in body.data.vertices if v.index not in eye_ids)
    body["EyeDiameterScale"] = 2
    body.data.update()
    return {"scale": 2, "eyes": report, "sourceVerticesChanged": len(eye_ids), "edits": edits}
