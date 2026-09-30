import subprocess,sys,pathlib,json,datetime
H='/Users/njx/apps/deveco-tools/command-line-tools/sdk/default/openharmony/toolchains/hdc'
P=pathlib.Path(__file__).resolve().parent

def run(args):
 r=subprocess.run([H]+args,capture_output=True,text=True)
 with (P/'operation-log.jsonl').open('a') as f:f.write(json.dumps({'at':datetime.datetime.now().astimezone().isoformat(),'args':args,'returncode':r.returncode,'output':r.stdout+r.stderr},ensure_ascii=False)+'\n')
 if r.returncode: print(r.stdout+r.stderr)
 return r
name=sys.argv[1]
if len(sys.argv)>2:run(['shell','uitest','uiInput']+sys.argv[2:])
run(['shell','uitest','screenCap','-p','/data/local/tmp/px-screen.png'])
run(['file','recv','/data/local/tmp/px-screen.png',str(P/(name+'.png'))])
run(['shell','uitest','dumpLayout','-p','/data/local/tmp/px-layout.json'])
run(['file','recv','/data/local/tmp/px-layout.json',str(P/(name+'.json'))])
def walk(n):
 a=n.get('attributes',{})
 if a.get('text') or a.get('hint'):print(a.get('text') or ('HINT:'+a.get('hint')),a.get('bounds'),'CLICK' if a.get('clickable')=='true' else '')
 for c in n.get('children',[]):walk(c)
walk(json.loads((P/(name+'.json')).read_text()))

# Capture again after layout retrieval to avoid transition frames.
run(['shell','uitest','screenCap','-p','/data/local/tmp/px-screen.png'])
run(['file','recv','/data/local/tmp/px-screen.png',str(P/(name+'.png'))])
