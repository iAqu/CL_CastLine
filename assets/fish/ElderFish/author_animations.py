"""Author fixed keyframe clips, shared by Blender and the Studio asset publisher.

Angles are authored in Roblox bone-local degrees; no runtime angle generation.
"""
import json
from pathlib import Path

OUTPUT = Path(__file__).resolve().parent
BONES = ["FishBody", "SpineFront", "SpineMid", "TailBase", "FishTail"]
CLIPS = {}


def clip(name, times, yaws, pitches=None, loop=False):
    frames = []
    for index, time in enumerate(times):
        rotations = {"FishBody": [0, 0, 0]}
        for bone, yaw in zip(BONES[1:], yaws):
            pitch = pitches[BONES.index(bone) - 1][index] if pitches else 0
            rotations[bone] = [pitch, yaw[index], 0]
        frames.append({"time": time, "rotations": rotations})
    CLIPS[name] = {"duration": times[-1], "loop": loop, "frames": frames}


clip("SwimLoop", [0, .078125, .15625, .234375, .3125, .390625, .46875, .546875, .625], [
    [0, 2, 3, 2, 0, -2, -3, -2, 0],
    [-2, 0, 4, 6, 2, 0, -4, -6, -2],
    [-8, -4, 0, 9, 8, 4, 0, -9, -8],
    [-10, -10, -4, 0, 10, 10, 4, 0, -10],
], loop=True)
struggle_yaw = [
    [24, 25.414214, 26, 25.414214, 24, 22.585786, 22, 22.585786, 24],
    [36, 38.12132, 39, 38.12132, 36, 33.87868, 33, 33.87868, 36],
    [8, 17.899495, 22, 17.899495, 8, -1.899495, -6, -1.899495, 8],
    [-18.384776, 0, 18.384776, 26, 18.384776, 0, -18.384776, -26, -18.384776],
]
struggle_pitch = [
    [0, .707107, 1, .707107, 0, -.707107, -1, -.707107, 0],
    [-1, -.707107, 0, .707107, 1, .707107, 0, -.707107, -1],
    [0, 1.414214, 2, 1.414214, 0, -1.414214, -2, -1.414214, 0],
    [-1.414214, 0, 1.414214, 2, 1.414214, 0, -1.414214, -2, -1.414214],
]
struggle_times = [0, .075, .15, .225, .3, .375, .45, .525, .6]
clip("StruggleLeft", struggle_times, struggle_yaw, struggle_pitch, loop=True)
clip("StruggleRight", struggle_times, [[-v for v in row] for row in struggle_yaw], struggle_pitch, loop=True)
clip("LiftFlop", [0, .15, .3, .5, .7, 1, 1.3, 1.6, 2], [
    [0, 10, 18, -12, -10, 6, -4, 0, 0],
    [0, 5, 22, 4, -18, 12, -6, 0, 0],
    [0, -6, 20, 24, -16, 18, -10, 0, 0],
    [0, -10, 8, 28, -6, 20, -12, 0, 0],
], [
    [0, 2, 3, -2, 0, 1, -1, 0, 0],
    [0, 0, 4, 2, -4, 2, -1, 0, 0],
    [0, -3, 2, 5, -2, 3, -2, 0, 0],
    [0, -4, 0, 6, 2, -3, -2, 0, 0],
])
clip("ShowcaseFlop", [0, .1, .2, .32, .45, .55, .65, .76, .9], [
    [0, 5, 10, -8, 0, 8, -10, -3, 0],
    [0, 0, 14, -2, -8, 10, -4, -6, 0],
    [0, -4, 10, 12, -12, 6, 10, -12, 0],
    [0, -8, 4, 16, -8, 0, 16, -10, 0],
], [
    [0, 1, 2, -1, 0, 1, -2, 0, 0],
    [0, 0, 3, 1, -2, 2, 1, -2, 0],
    [0, -1, 2, 3, -3, 0, 3, -2, 0],
    [0, -2, 0, 4, -2, -1, 4, -3, 0],
])
DATA = {"bones": BONES, "pivotFractions": [None, .28, .48, .70, .88],
        "weightAnchors": [.25, .42, .62, .82, .97], "clips": CLIPS}
if __name__ == "__main__":
    (OUTPUT / "animation_clips.json").write_text(json.dumps(DATA, indent=2) + "\n")
