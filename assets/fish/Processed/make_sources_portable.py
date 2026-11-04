import bpy
from pathlib import Path
ROOT=Path(__file__).resolve().parent
for path in sorted((ROOT/'models').glob('*/*.blend')):
 bpy.ops.wm.open_mainfile(filepath=str(path))
 for image in bpy.data.images:
  if image.source=='FILE':
   image.filepath='//../../textures/'+Path(image.filepath).name
 bpy.ops.wm.save_as_mainfile(filepath=str(path))
