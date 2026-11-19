"""Export the existing artwork with 2% transparent padding, without redrawing it."""
import json
import struct
import subprocess
import tempfile
import zlib
from pathlib import Path

HERE = Path(__file__).resolve().parent
V1 = HERE.parent / "v1"


def inspect_png(path):
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n"
    offset, compressed = 8, bytearray()
    while offset < len(data):
        size = struct.unpack(">I", data[offset:offset + 4])[0]
        kind = data[offset + 4:offset + 8]
        payload = data[offset + 8:offset + 8 + size]
        offset += size + 12
        if kind == b"IHDR":
            width, height, depth, color, _, _, interlace = struct.unpack(">IIBBBBB", payload)
            assert (depth, color, interlace) == (8, 6, 0)
        elif kind == b"IDAT":
            compressed.extend(payload)
    raw = zlib.decompress(compressed)
    stride, offset = width * 4, 0
    previous = bytearray(stride)
    bounds = {0: [width, height, 0, 0], 8: [width, height, 0, 0]}
    alpha_min, alpha_max = 255, 0

    def paeth(a, b, c):
        p = a + b - c
        da, db, dc = abs(p - a), abs(p - b), abs(p - c)
        return a if da <= db and da <= dc else b if db <= dc else c

    for y in range(height):
        filter_type = raw[offset]
        offset += 1
        row = bytearray(raw[offset:offset + stride])
        offset += stride
        if filter_type:
            assert filter_type in (1, 2, 3, 4)
            for i in range(stride):
                a = row[i - 4] if i >= 4 else 0
                b = previous[i]
                c = previous[i - 4] if i >= 4 else 0
                predictor = a if filter_type == 1 else b if filter_type == 2 else (a + b) // 2 if filter_type == 3 else paeth(a, b, c)
                row[i] = (row[i] + predictor) & 255
        for x in range(width):
            alpha = row[x * 4 + 3]
            alpha_min, alpha_max = min(alpha_min, alpha), max(alpha_max, alpha)
            for threshold, box in bounds.items():
                if alpha > threshold:
                    box[0], box[1] = min(box[0], x), min(box[1], y)
                    box[2], box[3] = max(box[2], x + 1), max(box[3], y + 1)
        previous = row
    box = bounds[0]
    visible = bounds[8]
    return {"size": [width, height], "alphaRange": [alpha_min, alpha_max],
            "bounds": box, "visibleBounds": bounds[8],
            "margins": [box[0], box[1], width - box[2], height - box[3]],
            "visibleMargins": [visible[0], visible[1], width - visible[2], height - visible[3]]}


def sips(*args):
    subprocess.run(["sips", *map(str, args)], check=True, capture_output=True)


def main():
    spec = json.loads((V1 / "prompts.json").read_text())
    report = {}
    with tempfile.TemporaryDirectory(prefix="castline-icon-export-") as scratch:
        scratch = Path(scratch)
        for name in spec["sourceFiles"]:
            source = HERE / "sources" / f"{name}.png"
            before = inspect_png(source)
            # Generated originals contain scattered almost-invisible alpha <= 8 pixels.
            # Use visible artwork bounds, retaining two extra pixels of edge antialiasing.
            left, top, right, bottom = before["visibleBounds"]
            left, top = max(0, left - 2), max(0, top - 2)
            right, bottom = min(before["size"][0], right + 2), min(before["size"][1], bottom + 2)
            cropped = scratch / f"{name}-crop.png"
            sips("--cropOffset", top, left, "--cropToHeightWidth", bottom - top, right - left, source, "--out", cropped)
            crop_info = inspect_png(cropped)
            assert crop_info["size"] == [right - left, bottom - top]
            assert max(crop_info["visibleMargins"]) <= 3, crop_info
            width, height = crop_info["size"]
            scale = 984 / max(width, height)
            scaled_width, scaled_height = round(width * scale), round(height * scale)
            scaled = scratch / f"{name}-scaled.png"
            sips("--resampleHeightWidth", scaled_height, scaled_width, cropped, "--out", scaled)
            output = HERE / f"{name}.png"
            sips("--padToHeightWidth", 1024, 1024, scaled, "--out", output)
            after = inspect_png(output)
            assert after["size"] == [1024, 1024] and after["alphaRange"] == [0, 255]
            assert min(after["visibleMargins"]) >= 19 and min(after["visibleMargins"]) <= 24, after
            upload = V1 / "upload" / f"{name}-v2.png"
            sips("--resampleHeightWidth", 512, 512, output, "--out", upload)
            upload_info = inspect_png(upload)
            assert upload_info["size"] == [512, 512] and upload_info["alphaRange"] == [0, 255]
            assert min(upload_info["visibleMargins"]) >= 9, upload_info
            report[name] = {"source": str(source), "before": before, "after": after,
                            "uploadPath": str(upload), "upload": upload_info}
            print(name, json.dumps({"bounds": after["visibleBounds"], "margins": after["visibleMargins"]}), flush=True)
    (HERE / "verification.json").write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
