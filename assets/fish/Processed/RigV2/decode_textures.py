"""Store unmodified RGBA readback as PNG, using only the standard library."""
import base64
import json
from pathlib import Path
import struct
import zlib

ROOT=Path(__file__).resolve().parent
out=ROOT/'textures'
out.mkdir(exist_ok=True)
def chunk(name, data):
    return struct.pack('>I',len(data))+name+data+struct.pack('>I',zlib.crc32(name+data))
for path in (ROOT/'texture-data').glob('*.json'):
    if not path.stem.isdecimal():
        continue
    m=json.loads(path.read_text())
    rgba=b''.join(base64.b64decode(json.loads(path.with_name(f'{path.stem}-{i:03}.json').read_text())['rgba'])
                  for i in range(1,m['chunks']+1))
    w,h=m['width'],m['height']
    assert len(rgba)==w*h*4
    raw=b''.join(b'\0'+rgba[i:i+w*4] for i in range(0,len(rgba),w*4))
    png=b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',w,h,8,6,0,0,0))
    png+=chunk(b'IDAT',zlib.compress(raw,9))+chunk(b'IEND',b'')
    (out/f'{path.stem}.png').write_bytes(png)
