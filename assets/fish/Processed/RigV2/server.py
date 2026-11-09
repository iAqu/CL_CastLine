"""Local-only transport for editor authoring inputs and exact Studio exports."""
from http.server import ThreadingHTTPServer,SimpleHTTPRequestHandler
from pathlib import Path
import json,hashlib,os,tempfile
ROOT=Path(__file__).resolve().parent
class Handler(SimpleHTTPRequestHandler):
 def __init__(self,*args,**kwargs):super().__init__(*args,directory=str(ROOT),**kwargs)
 def do_POST(self):
  relative=self.path.lstrip('/')
  path=(ROOT/relative).resolve()
  length=int(self.headers.get('Content-Length','0'))
  if not path.is_relative_to(ROOT) or path.suffix not in ('.json','.rbxm') or not 0<length<100_000_000:
   self.send_error(400);return
  raw=self.rfile.read(length)
  try:
   if path.suffix=='.json':json.loads(raw)
   else:assert raw.startswith(b'<roblox')
  except Exception:self.send_error(400,'Invalid artifact');return
  path.parent.mkdir(parents=True,exist_ok=True)
  with tempfile.NamedTemporaryFile(dir=path.parent,delete=False) as staged:staged.write(raw);temp=staged.name
  os.replace(temp,path)
  result=json.dumps({'file':relative,'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}).encode()
  self.send_response(200);self.send_header('Content-Type','application/json');self.send_header('Content-Length',str(len(result)));self.end_headers();self.wfile.write(result)
 def log_message(self,*args):pass
ThreadingHTTPServer(('127.0.0.1',18776),Handler).serve_forever()
