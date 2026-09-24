import subprocess,sys,pathlib,json,datetime
H='/Users/njx/apps/deveco-tools/command-line-tools/sdk/default/openharmony/toolchains/hdc'
P=pathlib.Path(__file__).resolve().parent
r=subprocess.run([H]+sys.argv[1:],capture_output=True,text=True)
with (P/'environment-commands.jsonl').open('a') as f:f.write(json.dumps({'at':datetime.datetime.now().astimezone().isoformat(),'args':sys.argv[1:],'returncode':r.returncode,'output':r.stdout+r.stderr},ensure_ascii=False)+'\n')
print(r.stdout+r.stderr)
sys.exit(r.returncode)
