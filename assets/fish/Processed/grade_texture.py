"""Lossless PNG layout/alpha preservation; user-authorized per-pixel color grading."""
import argparse
import colorsys
import hashlib
import json
from pathlib import Path
import struct
import zlib


def read_png(path):
    raw = Path(path).read_bytes()
    assert raw[:8] == b'\x89PNG\r\n\x1a\n'
    offset, compressed, ancillary = 8, bytearray(), []
    while offset < len(raw):
        size = struct.unpack('>I', raw[offset:offset + 4])[0]
        kind, data = raw[offset + 4:offset + 8], raw[offset + 8:offset + 8 + size]
        if kind == b'IHDR':
            header = data
        elif kind == b'IDAT':
            compressed.extend(data)
        elif kind in (b'sRGB', b'gAMA', b'cHRM', b'iCCP', b'pHYs'):
            ancillary.append((kind, data))
        offset += size + 12
    width, height, depth, mode, compression, filter_method, interlace = struct.unpack('>IIBBBBB', header)
    assert depth == 8 and mode in (2, 6) and interlace == 0
    assert compression == filter_method == 0
    channels, pixels = (4 if mode == 6 else 3), bytearray()
    stride = width * channels
    decoded = zlib.decompress(compressed)
    assert len(decoded) == height * (stride + 1)
    previous = bytearray(stride)
    for y in range(height):
        start = y * (stride + 1)
        filter_type = decoded[start]
        row = bytearray(decoded[start + 1:start + 1 + stride])
        assert filter_type <= 4
        for x in range(stride):
            a = row[x - channels] if x >= channels else 0
            b = previous[x]
            c = previous[x - channels] if x >= channels else 0
            if filter_type == 1:
                predictor = a
            elif filter_type == 2:
                predictor = b
            elif filter_type == 3:
                predictor = (a + b) // 2
            elif filter_type == 4:
                p = a + b - c
                da, db, dc = abs(p - a), abs(p - b), abs(p - c)
                predictor = a if da <= db and da <= dc else b if db <= dc else c
            else:
                predictor = 0
            row[x] = (row[x] + predictor) & 255
        pixels.extend(row)
        previous = row
    return header, ancillary, width, height, channels, pixels


def chunk(kind, data):
    return struct.pack('>I', len(data)) + kind + data + struct.pack('>I', zlib.crc32(kind + data))


def grade(source, destination):
    header, ancillary, width, height, channels, original = read_png(source)
    result = bytearray(original)
    cache = {}
    changed = 0
    for i in range(0, len(result), channels):
        rgb = bytes(original[i:i + 3])
        if rgb not in cache:
            hue, saturation, value = colorsys.rgb_to_hsv(*(v / 255 for v in rgb))
            # Taper the 35% saturation boost near the gamut boundary; soft S-curve
            # keeps pure black/white and avoids crushing gradient steps by clipping.
            saturation += 0.35 * saturation * (1 - saturation)
            value += 0.20 * (value - 0.5) * 4 * value * (1 - value)
            cache[rgb] = bytes(round(v * 255) for v in colorsys.hsv_to_rgb(hue, saturation, value))
        result[i:i + 3] = cache[rgb]
        changed += cache[rgb] != rgb
    stride = width * channels
    payload = b''.join(b'\0' + result[y * stride:(y + 1) * stride] for y in range(height))
    output = b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', header)
    output += b''.join(chunk(kind, data) for kind, data in ancillary)
    output += chunk(b'IDAT', zlib.compress(payload, 9)) + chunk(b'IEND', b'')
    destination = Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(output)
    checked = read_png(destination)
    assert checked[2:5] == (width, height, channels) and checked[-1] == result
    assert channels != 4 or original[3::4] == result[3::4]
    report = dict(source=str(source), output=str(destination), width=width, height=height,
                  method='HSV saturation +35% with gamut taper; value soft contrast +20%',
                  layoutUnchanged=True, alphaUnchanged=True, changedPixels=changed,
                  sourceSha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),
                  outputSha256=hashlib.sha256(output).hexdigest())
    destination.with_suffix('.validation.json').write_text(json.dumps(report, indent=2) + '\n')
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('source')
    parser.add_argument('destination')
    args = parser.parse_args()
    print(json.dumps(grade(args.source, args.destination)))
