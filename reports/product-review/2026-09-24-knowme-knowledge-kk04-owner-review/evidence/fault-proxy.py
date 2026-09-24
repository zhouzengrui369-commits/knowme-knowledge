"""Review-only loopback fault adapter. No product code; no credentials logged."""
from http.server import ThreadingHTTPServer,BaseHTTPRequestHandler
import http.client,json,pathlib,datetime,socket,threading
out=pathlib.Path(__file__).with_name('fault-proxy-actions.jsonl');lock=threading.Lock();faults={'ack':True,'asset':False}
class Proxy(BaseHTTPRequestHandler):
 def log_message(self,*a):pass
 def run(self):
  data=self.rfile.read(int(self.headers.get('Content-Length','0')))
  with lock:
   fault=''
   if self.command=='POST' and self.path=='/api/mobile-capture/v1/captures' and not faults['ack']:fault='lost_ack_after_durable_accept';faults['ack']=True
   if self.command=='PUT' and self.path.split('?')[0].endswith('/asset') and not faults['asset']:fault='upload_interrupted_before_delivery';faults['asset']=True
  status=None;body=b''
  if fault!='upload_interrupted_before_delivery':
   conn=http.client.HTTPConnection('127.0.0.1',18251,timeout=120);headers={k:v for k,v in self.headers.items() if k.lower() not in ['host','connection','content-length']};headers['Content-Length']=str(len(data));conn.request(self.command,self.path,data,headers);r=conn.getresponse();status=r.status;body=r.read();content_type=r.getheader('Content-Type','application/json');conn.close()
  if fault:
   with lock:out.open('a').write(json.dumps({'at':datetime.datetime.now().astimezone().isoformat(),'method':self.command,'path':self.path,'fault':fault,'upstream_http':status,'input_bytes':len(data)})+'\n')
   self.connection.shutdown(socket.SHUT_RDWR);self.connection.close();return
  self.send_response(status);self.send_header('Content-Type',content_type);self.send_header('Content-Length',str(len(body)));self.end_headers();self.wfile.write(body)
 do_GET=run;do_POST=run;do_PUT=run
ThreadingHTTPServer(('127.0.0.1',18252),Proxy).serve_forever()
