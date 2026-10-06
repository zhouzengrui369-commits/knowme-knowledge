/* Public, read-only release status. Never sends credentials or renders fetched HTML. */
(() => {
  'use strict';
  const ORIGIN='https://knowme-owner-preview-1945e70a.zhouzengrui2015.chatgpt.site';
  const ENDPOINT=ORIGIN+'/api/public/release-status';
  const CANONICAL=ORIGIN+'/index.html#/portal/start';
  const WINDOWS='https://github.com/zhouzengrui369-commits/knowme-knowledge/releases/download/lingxi-windows-1.1.0.0929-r5-formfix-test/Lingxi-1.1.0.0929-r5-formfix-20261002-windows-x64-setup.exe';
  const isObject=x=>x!==null&&typeof x==='object'&&!Array.isArray(x);
  const version=x=>typeof x==='string'&&/^[0-9][0-9A-Za-z.+-]{0,63}$/.test(x);
  const sha=x=>typeof x==='string'&&/^[a-f0-9]{64}$/.test(x);
  const iso=x=>typeof x==='string'&&/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{3})?Z$/.test(x)&&Number.isFinite(Date.parse(x));
  const exactList=(x,list)=>Array.isArray(x)&&x.length===list.length&&new Set(x).size===x.length&&x.every(v=>list.includes(v));
  const allDisconnected=['email','phone','desktop_login','devices','workspaces','entitlements','wizard','sync'];
  function validate(x){
    if(!isObject(x)||x.schema_version!==1||!iso(x.updated_at)||Date.parse(x.updated_at)>Date.now()+300000||x.canonical_url!==CANONICAL)throw Error('Invalid public status envelope');
    const s=x.stable,c=x.candidate,a=x.account;
    if(!isObject(s)||!version(s.version)||typeof s.release_date!=='string'||!/^\d{4}-\d{2}-\d{2}$/.test(s.release_date)||!Number.isFinite(Date.parse(s.release_date))||s.availability!=='existing_workbench_release_no_public_binary'||s.download_url!==null)throw Error('Unsupported stable release status');
    if(!isObject(c)||!version(c.version)||c.platform!=='macos-arm64'||c.build_status!=='built_locked_start_verified'||c.download_url!==null)throw Error('Unsupported candidate status');
    if(!exactList(c.verified_features,['dmg_packaging','limited_locked_startup'])||!exactList(c.unavailable_features,['public_download','signing','notarization','installation_verified','real_login','product_acceptance']))throw Error('Unsupported verification boundary');
    if(!Number.isSafeInteger(c.size_bytes)||c.size_bytes<=0||c.size_bytes>1000000000000||!sha(c.sha256))throw Error('Invalid candidate metadata');
    if(c.signing_status!=='not_verified'||c.notarization_status!=='not_verified'||c.authentication_status!=='not_tested'||c.product_acceptance!=='not_granted'||c.publication_status!=='not_published')throw Error('Unsupported candidate verification status');
    if(c.ui_inheritance!=='not_completed'||c.functional_parity!=='not_completed'||c.status_label!=='封装工程验证包，尚非完整灵犀客户端')throw Error('Unsupported client completion boundary');
    if(!isObject(a)||a.chatgpt!=='web_login_available'||a.profile!=='available'||!allDisconnected.every(k=>a[k]==='not_connected'))throw Error('Unsupported account status');
    if(!Array.isArray(x.available_downloads)||x.available_downloads.length!==1)throw Error('Unsupported public downloads');
    const w=x.available_downloads[0];
    if(!isObject(w)||!version(w.version)||w.platform!=='windows-x64'||w.channel!=='installation_test_candidate'||w.download_url!==WINDOWS||!sha(w.sha256))throw Error('Unapproved download URL or channel');
    const source=x.source_authority;
    if(!isObject(source)||typeof source.revision!=='string'||!/^[A-Za-z0-9._-]{1,100}$/.test(source.revision)||source.mode!=='checked_in_snapshot'||source.canonical_feed!==ENDPOINT)throw Error('Invalid source authority');
    return x;
  }
  let data;
  try{data=validate(JSON.parse(document.getElementById('lp-release-snapshot').textContent))}catch{
    document.querySelectorAll('[data-lp-status="freshness"]').forEach(el=>{el.textContent='状态快照不可用，请查看公开进展。'});
    return;
  }
  let state='snapshot',busy=false,lastError='';
  const utc=x=>x.replace('T',' ').replace(/(?:\.\d{3})?Z$/,' UTC');
  function render(root=document){
    const stale=Date.now()-Date.parse(data.updated_at)>86400000;
    const values={
      'stable.version':data.stable.version,
      'stable.release_date':data.stable.release_date,
      'candidate.version':data.candidate.version,
      'candidate.status_label':data.candidate.status_label,
      'candidate.size_bytes':data.candidate.size_bytes.toLocaleString('en-US'),
      'candidate.sha256':data.candidate.sha256,
      'account.chatgpt':'网页可用',
      'account.profile':'已接入',
      'account.email_phone':'均未接入',
      'account.desktop':'均未接入',
      'account.services':'均未接入',
      'updated_at':utc(data.updated_at),
      'freshness':busy?'正在读取公开状态；当前显示已标注时间的快照':state==='fetched'?'已获取公开状态快照；请核对更新时间':'暂未获取最新状态；显示已标注时间的快照',
      'staleness':stale?' · 快照已超过 24 小时，可能有后续变化':' · 快照信息，不保证即时更新'
    };
    root.querySelectorAll('[data-lp-status]').forEach(el=>{
      const key=el.getAttribute('data-lp-status');
      if(Object.hasOwn(values,key))el.textContent=values[key];
      if(key==='updated_at')el.setAttribute('datetime',data.updated_at);
    });
    root.querySelectorAll('[data-lp-refresh]').forEach(el=>{el.disabled=busy;el.setAttribute('aria-busy',String(busy))});
  }
  async function readBoundedJson(response){
    const limit=20000;
    const length=response.headers.get('content-length');
    if(length!==null&&/^\d+$/.test(length)&&Number(length)>limit)throw Error('Public status response too large');
    if(!response.body||typeof response.body.getReader!=='function')throw Error('Streaming response unavailable');
    const reader=response.body.getReader();
    const decoder=new TextDecoder('utf-8',{fatal:true});
    let bytes=0,raw='';
    try{
      while(true){
        const {done,value}=await reader.read();
        if(done)break;
        bytes+=value.byteLength;
        if(bytes>limit)throw Error('Public status response too large');
        raw+=decoder.decode(value,{stream:true});
      }
      return JSON.parse(raw+decoder.decode());
    }catch(error){await reader.cancel().catch(()=>{});throw error}
    finally{reader.releaseLock()}
  }
  async function refresh(){
    if(busy)return;
    busy=true;render();
    const controller=new AbortController();
    const timeout=setTimeout(()=>controller.abort(),6000);
    try{
      const response=await fetch(ENDPOINT,{method:'GET',credentials:'omit',mode:'cors',cache:'no-store',redirect:'error',referrerPolicy:'no-referrer',headers:{Accept:'application/json'},signal:controller.signal});
      if(!response.ok||!/^application\/json(?:;|$)/i.test(response.headers.get('content-type')||''))throw Error('Public status response unavailable');
      const next=validate(await readBoundedJson(response));
      if(Date.parse(next.updated_at)<Date.parse(data.updated_at))throw Error('Public status is older than the current snapshot');
      data=next;state='fetched';lastError='';
    }catch(error){state='snapshot';lastError=error.name==='AbortError'?'timeout':'unavailable_or_invalid';controller.abort()}
    finally{clearTimeout(timeout);busy=false;render()}
  }
  window.LingxiReleaseStatus=Object.freeze({render,refresh,status:()=>({state,busy,updated_at:data.updated_at,last_error:lastError})});
  render();refresh();
})();
