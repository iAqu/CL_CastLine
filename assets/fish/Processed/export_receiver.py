"""Temporary localhost-only receiver for Studio SerializationService RBXM exports."""
from http.server import HTTPServer,BaseHTTPRequestHandler
from pathlib import Path
import argparse,hashlib,json,os,shutil,tempfile
from datetime import datetime,timezone
parser=argparse.ArgumentParser()
parser.add_argument('--port',type=int,default=18774)
parser.add_argument('--replace-current',action='store_true',help='Back up and atomically refresh only current processed/template exports')
options=parser.parse_args()
ROOT=Path(__file__).resolve().parent/'studio';ROOT.mkdir(exist_ok=True)
ALLOWED={'Fish_Processed.rbxm','Fish_GameTemplates.rbxm','Fish_Templates_Before_20261104_062102.rbxm','Fish_AnimationSources.rbxm','Fish_SourceOriginals.rbxm'}
class Receiver(BaseHTTPRequestHandler):
 def do_POST(self):
  name=self.path.removeprefix('/')
  size=int(self.headers.get('Content-Length','0'))
  if name not in ALLOWED or not 0<size<50_000_000:
   self.send_error(400);return
  path=ROOT/name
  if path.exists() and not (options.replace_current and name in {'Fish_Processed.rbxm','Fish_GameTemplates.rbxm'}):
   self.send_error(409,'Export already exists');return
  raw=self.rfile.read(size)
  if not raw.startswith(b'<roblox'):
   self.send_error(400,'Not a Roblox model');return
  record={'file':name,'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}
  if path.exists():
   stamp=datetime.now(timezone.utc).strftime('%Y%m%d_%H%M%S_%f')
   backup=path.with_name(path.stem+'.BeforeDrip_'+stamp+path.suffix)
   shutil.copy2(path,backup)
   record['previousFile']=backup.name
  with tempfile.NamedTemporaryFile(dir=ROOT,delete=False) as staged:
   staged.write(raw);staged_name=staged.name
  os.replace(staged_name,path)
  result=json.dumps(record).encode()
  self.send_response(200);self.send_header('Content-Type','application/json');self.send_header('Content-Length',str(len(result)));self.end_headers();self.wfile.write(result)
 def log_message(self,*args):pass
HTTPServer(('127.0.0.1',options.port),Receiver).serve_forever()
