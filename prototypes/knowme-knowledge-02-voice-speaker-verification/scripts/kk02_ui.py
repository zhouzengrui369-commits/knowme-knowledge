#!/usr/bin/env python3
"""kk02 emulator helper: dump layout, find button/text bounds, click by label (fresh coords every time)."""
import json, subprocess, sys, time

HDC = '/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc'

def dump(path='/tmp/kk02-cur.json'):
    subprocess.run([HDC, 'shell', 'uitest', 'dumpLayout', '-p', '/data/local/tmp/cur.json'],
                   capture_output=True)
    subprocess.run([HDC, 'file', 'recv', '/data/local/tmp/cur.json', path], capture_output=True)
    return json.load(open(path))

def find(d, label, types=('Button', 'Text', 'TextInput')):
    out = []
    def walk(n):
        a = n.get('attributes', {})
        if a.get('type') in types and label in a.get('text', ''):
            out.append((a.get('type'), a.get('text',''), a.get('bounds')))
        for c in n.get('children', []):
            walk(c)
    walk(d)
    return out

def center(bounds):
    # "[56,1164][421,1304]"
    import re
    x1, y1, x2, y2 = [int(float(v)) for v in re.findall(r'-?[\d.]+', bounds)][:4]
    return (x1 + x2) // 2, (y1 + y2) // 2

def click(x, y):
    r = subprocess.run([HDC, 'shell', 'uitest', 'uiInput', 'click', str(x), str(y)],
                       capture_output=True, text=True)
    return r.stdout.strip()

def click_label(label, index=0):
    d = dump()
    hits = find(d, label, types=('Button',)) or find(d, label)
    if len(hits) <= index:
        print(f'NOTFOUND: {label} (hits={len(hits)})')
        return False
    x, y = center(hits[index][2])
    print(f'click "{hits[index][1][:30]}" at {x},{y}: {click(x, y)}')
    return True

def texts(d=None):
    d = d or dump()
    out = []
    def walk(n, depth=0):
        a = n.get('attributes', {})
        t = a.get('text', '')
        if t:
            out.append(' ' * depth + t)
        for c in n.get('children', []):
            walk(c, depth + 1)
    walk(d)
    return out

if __name__ == '__main__':
    cmd = sys.argv[1]
    if cmd == 'click':
        click_label(sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 0)
    elif cmd == 'texts':
        pat = sys.argv[2] if len(sys.argv) > 2 else ''
        for t in texts():
            if pat in t:
                print(t[:100])
    elif cmd == 'xy':
        print(click(int(sys.argv[2]), int(sys.argv[3])))
