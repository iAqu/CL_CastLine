"""Author Axolotl's four limb chains from the Rig V2 rest geometry."""
import heapq
import json
import math
import sys
from pathlib import Path

import numpy as np

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT.parent))
from build import RATE, read, save, smooth

KEY = "Rig007"
VARIANT = "v2_axolotl_four_leg_swim"
LEGS = {
    "FrontLeft": ("SpineFrontFlex", (-.55, -.10, -.81), (-.69, -.58, -.82), (-.8, -.88, -.80)),
    "FrontRight": ("SpineFrontFlex", (.58, -.11, -1.11), (.73, -.58, -1.13), (.85, -.88, -1.17)),
    "HindLeft": ("SpineRear", (-.55, -.10, .19), (-.63, -.57, .17), (-.70, -.88, .17)),
    "HindRight": ("SpineRear", (.69, -.10, .22), (.89, -.57, .25), (1.08, -.88, .28)),
}


def rotation(x, y, z):
    x, y, z = np.radians((x, y, z))
    cx, cy, cz = np.cos((x, y, z))
    sx, sy, sz = np.sin((x, y, z))
    return np.array(((cy*cz, -cy*sz, sy), (cx*sz+sx*sy*cz, cx*cz-sx*sy*sz, -sx*cy),
                     (sx*sz-cx*sy*cz, sx*cz+cx*sy*sz, cx*cy)))


def distance_to_foot(points, edges, foot, side):
    seed = int(np.argmin(np.linalg.norm(points-foot, axis=1)))
    distal = {seed}
    frontier = [seed]
    for vertex in frontier:
        for other in edges[vertex]:
            if other not in distal and points[other, 1] < -.32:
                distal.add(other)
                frontier.append(other)
    assert 190 <= len(distal) <= 265, ("Limb surface region changed", len(distal))
    # Grow through welded surface edges, avoiding the adjacent gills on the right front leg.
    radius = .50
    allowed = (points[:, 0]*side > .27) & (abs(points[:, 2]-foot[2]) < .46)
    distances = np.full(len(points), np.inf)
    queue = [(0., index) for index in sorted(distal)]
    distances[list(distal)] = 0.
    while queue:
        distance, vertex = heapq.heappop(queue)
        if distance != distances[vertex]:
            continue
        for other in edges[vertex]:
            if not allowed[other]:
                continue
            new_distance = distance + np.linalg.norm(points[other]-points[vertex])
            if new_distance < min(radius, distances[other]):
                distances[other] = new_distance
                heapq.heappush(queue, (new_distance, other))
    return distances, np.array(sorted(distal))


def author():
    source = read(f"source/{KEY}/part001.json")
    source_rig = read(f"source/{KEY}/rig.json")
    rig = read(f"payload/{KEY}/rig.json")
    old_motion = read(f"motions/{rig['variant']}.json")
    raw = np.array(source["vertices"])
    assert source["frame"] == [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1]
    vertices = raw * np.array(source["size"]) / np.array(source["meshSize"])
    unique, first, weld = np.unique(np.round(vertices, 5), axis=0, return_index=True, return_inverse=True)
    edges = [set() for _ in unique]
    for triangle in source["faces"]:
        a, b, c = weld[triangle[:3]]
        edges[a].update((b, c))
        edges[b].update((c, a))
        edges[c].update((a, b))

    bones = rig["bones"][:12]
    indices = {bone["name"]: i for i, bone in enumerate(bones)}
    weights = np.zeros((len(vertices), 20))
    previous = read(f"payload/{KEY}/part001.json")
    old_ids = np.array(previous["indices"]).reshape(-1, 4)
    old_weights = np.array(previous["weights"]).reshape(-1, 4)
    # Any old side-chain influence outside the new leg masks belongs with its torso parent.
    np.add.at(weights, (np.arange(len(vertices))[:, None], np.where(old_ids < 12, old_ids, indices["SpineMid"])), old_weights)
    samples = {}
    regions = {}
    for name, (parent, root, knee, foot) in LEGS.items():
        root, knee, foot = map(np.array, (root, knee, foot))
        side = int(np.sign(foot[0]))
        distances, distal = distance_to_foot(unique, edges, foot, side)
        assert not any(np.intersect1d(distal, prior).size for prior in regions.values())
        regions[name] = distal
        mask = smooth(1-distances[weld]/.50)
        # Keep the shoulder/hip blended into the body and give the feet full independent control.
        bend = smooth((-vertices[:, 1] - .41)/.40)
        i = len(bones)
        bones.extend((
            {"name": name+"Leg", "position": root.tolist(), "parent": indices[parent], "role": "limb"},
            {"name": name+"Joint", "position": knee.tolist(), "parent": i, "role": "limb_tip"},
        ))
        weights *= 1-mask[:, None]
        weights[:, i] = mask*(1-bend)
        weights[:, i+1] = mask*bend
        foot_vertices = distal[unique[distal, 1] < -.82]
        samples[name] = first[foot_vertices].tolist()
    assert len(bones) == 20
    ranks = np.argsort(-weights, axis=1)[:, :4]
    ranked = np.take_along_axis(weights, ranks, axis=1)
    ranked[ranked < 1/255] = 0
    ranked /= ranked.sum(axis=1)[:, None]
    assert np.max(np.abs(ranked.sum(axis=1)-1)) < 1e-8
    effective = np.zeros(20)
    np.maximum.at(effective, ranks.flatten(), ranked.flatten())
    assert min(effective) >= .1
    # Every split vertex shares the same limb envelope. Preserve the authored face and eye weights.
    head = vertices[:, 2] < -1.72
    assert np.all(weights[head, 12:] == 0)

    clips = old_motion["clips"]
    for clip_name, clip in clips.items():
        for frame in clip["frames"]:
            matrices = frame["rotationMatrices"]
            for name in LEGS:
                side = -1 if name.endswith("Left") else 1
                if clip_name == "SwimLoop":
                    hind = name.startswith("Hind")
                    phase = math.tau * frame["time"]/clip["duration"] - (1.1 if hind else 0) - (.38 if side == 1 else 0)
                    root = rotation((-62 if hind else -53)+3.5*math.sin(phase),
                                    -side*(8+2*math.cos(phase)), side*2.5*math.sin(phase))
                    knee = rotation((-16 if hind else -12)+3*math.sin(phase-.65), 0, 0)
                else:
                    old = "LegsLeft" if side == -1 else "LegsRight"
                    root = np.array(matrices[old]).reshape(3, 3)
                    knee = np.array(matrices[old+"Tip"]).reshape(3, 3)
                matrices[name+"Leg"] = root.flatten().tolist()
                matrices[name+"Joint"] = knee.flatten().tolist()
            for name in ("LegsLeft", "LegsLeftTip", "LegsRight", "LegsRightTip"):
                del matrices[name]
        if clip["loop"]:
            clip["frames"][-1]["rotationMatrices"] = clip["frames"][0]["rotationMatrices"]

    for point in rig["drip"]:
        index = point["sourceVertex"]
        point["bone"] = bones[ranks[index, 0]]["name"]
        point["influence"] = float(ranked[index, 0])
        point["position"] = raw[index].tolist()
        point["influences"] = {bones[j]["name"]: float(w) for j, w in zip(ranks[index], ranked[index]) if w > 0}
    rig.update(bones=bones, variant=VARIANT, effective=effective.tolist())
    rig["parts"][0].update(recipe=VARIANT, baseMesh="rbxassetid://78418285631743")
    rig["parts"][0]["vertexChecks"] = {str(i+1): raw[i].tolist() for i in range(0, len(raw), 521)}
    poses = {"variant": VARIANT, "bones": bones, "partNames": old_motion["partNames"], "clips": clips}

    radius, measured = measure(vertices, ranks, ranked, bones, clips, samples, head)
    save("AxolotlSwim/rig.json", rig)
    save("AxolotlSwim/weights.json", {"indices": ranks.flatten().tolist(),
                                       "weights": np.round(ranked, 8).flatten().tolist()})
    save("AxolotlSwim/motion.json", poses)
    save("AxolotlSwim/bounds.json", {"radius": radius*1.1, "clips": measured})
    save("AxolotlSwim/landmarks.json", {
        "feet": {n: vertices[ids].mean(axis=0).tolist() for n, ids in samples.items()},
        "tail": vertices[np.argmax(vertices[:, 2])].tolist(),
    })
    print(json.dumps(measured, indent=2))


def measure(vertices, indices, weights, bones, clips, feet, head):
    bind = np.array([b["position"] for b in bones])
    offsets = vertices[:, None, :]-bind[indices]
    result = {}
    radius = 0.
    tail = np.flatnonzero(vertices[:, 2] > 2.85)
    body_anchor = {bone["name"]: i for i, bone in enumerate(bones)}
    for name, clip in clips.items():
        entries = {}
        for influence in ((.4, 1.) if name == "SwimLoop" else (1.,)):
            minima = {leg: math.inf for leg in feet}
            tail_x = []
            max_head = 0.
            for frame in clip["frames"]:
                rotations, joints = [], []
                for i, bone in enumerate(bones):
                    rotation = np.array(frame["rotationMatrices"][bone["name"]]).reshape(3, 3)
                    if influence < 1:
                        # Interpolate from the bind pose with the same axis and scaled angle.
                        angle = math.acos(float(np.clip((np.trace(rotation)-1)/2, -1, 1)))
                        if angle > 1e-7:
                            skew = (rotation-rotation.T)/(2*math.sin(angle))
                            rotation = np.eye(3)+math.sin(angle*influence)*skew+(1-math.cos(angle*influence))*(skew@skew)
                    p = bone["parent"]
                    joints.append(bind[i] if p < 0 else joints[p]+rotations[p]@(bind[i]-bind[p]))
                    rotations.append(rotation if p < 0 else rotations[p]@rotation)
                deformed = ((np.einsum("nkij,nkj->nki", np.array(rotations)[indices], offsets)
                             +np.array(joints)[indices])*weights[:, :, None]).sum(axis=1)
                max_head = max(max_head, float(np.max(np.linalg.norm(deformed[head]-vertices[head], axis=1))))
                radius = max(radius, float(np.max(np.linalg.norm(deformed, axis=1))))
                tail_x.append(float(deformed[tail, 0].mean()))
                for leg, sample in feet.items():
                    i = body_anchor[leg+"Leg"]
                    local = rotations[bones[i]["parent"]].T@(deformed[sample].mean(axis=0)-joints[i])
                    minima[leg] = min(minima[leg], float(local[2]))
            assert max_head < .002, (name, "Head shifted", max_head)
            if name == "SwimLoop":
                assert min(minima.values()) > .10, ("Leg did not reach rearward", influence, minima)
            entries[str(influence)] = {"minFootBehindRoot": minima, "tailLateralRange": max(tail_x)-min(tail_x),
                                       "headDisplacement": max_head, "samples": len(tail_x), "sampleRate": RATE}
        result[name] = entries
    return radius, result


if __name__ == "__main__":
    author()
