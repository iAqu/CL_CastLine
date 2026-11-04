"""Check Studio bake structure, rotations and loop tangents without Blender/Studio."""
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent
source = json.loads((ROOT / "animation_clips.json").read_text())
baked = json.loads((ROOT / "animation_clips.baked.json").read_text())
for name, clip in baked["clips"].items():
    if name not in ("StruggleLeft", "StruggleRight"):
        assert clip == source["clips"][name], (name, "unrelated clip changed")
        continue
    assert len(clip["frames"]) == 49 and clip["sampleRate"] == 80 and clip["interpolation"] == "Linear"
    assert clip["duration"] == .6 and clip["loop"]
    assert clip["frames"][0]["rotationMatrices"] == clip["frames"][-1]["rotationMatrices"]
    for index, frame in enumerate(clip["frames"]):
        assert abs(frame["time"] - index / 80) < 1e-10
        for bone, matrix in frame["rotationMatrices"].items():
            for a in range(3):
                for b in range(3):
                    assert abs(sum(matrix[3*a+k] * matrix[3*b+k] for k in range(3)) - (a == b)) < 1e-5, (name, index, bone, "non-unit rotation")
            if bone == "FishBody":
                assert max(abs(matrix[k] - (k in (0, 4, 8))) for k in range(9)) < 1e-8
        sign = 1 if name == "StruggleLeft" else -1
        angles = {}
        for bone in ("SpineFront", "SpineMid"):
            matrix = frame["rotationMatrices"][bone]
            angles[bone] = math.degrees(math.atan2(matrix[2], matrix[0])) * sign
        assert 21.95 <= angles["SpineFront"] <= 26.05
        assert 32.95 <= angles["SpineMid"] <= 39.05
        assert 54.95 <= sum(angles.values()) <= 65.05

    def yaw(index):
        matrix = clip["frames"][index]["rotationMatrices"]["TailBase"]
        return math.degrees(math.atan2(matrix[2], matrix[0]))

    assert abs((yaw(7) - yaw(5)) / .025) > 50, "Original keyframe still stalls"
    left, right = (yaw(48) - yaw(47)) * 80, (yaw(1) - yaw(0)) * 80
    assert left * right > 0 and abs(left - right) < 10, "Loop velocity discontinuity"
print("Bake validation passed: dense linear curves, unit rotations, fixed head, body range, seam, unchanged other clips")
