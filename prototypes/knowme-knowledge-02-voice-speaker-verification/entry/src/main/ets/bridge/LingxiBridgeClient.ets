/**
 * GOAL-KK-04 灵犀桥接客户端 —— 协议 v1（/api/mobile-capture/v1）。
 *
 * 只与已授权隔离工作台通信；设备凭证 Bearer；超时与错误分类明确；
 * 内容一律按数据处理，绝不作为指令执行。
 */
import { http } from '@kit.NetworkKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CaptureItem } from '../capture/CaptureCore';

const DOMAIN = 0x0205;
const TAG = 'KnowME.Bridge';

const DEFAULT_TIMEOUT = 20000;

export interface BridgeResult {
  ok: boolean;
  status: number;
  body: string;
  error: string;
}

export interface DeviceSession {
  baseUrl: string;
  deviceId: string;
  token: string;
}

interface ProcessingPolicyJson {
  auto_organize: boolean;
  correction_of: string;
}

interface AssetJson {
  filename: string;
  mime: string;
  sha256: string;
  size: number;
  duration_ms: number;
}

interface CaptureEnvelope {
  capture_id: string;
  schema_version: string;
  payload_revision: number;
  kind: string;
  captured_at: string;
  captured_timezone: string;
  title_hint: string;
  content_hash: string;
  content_size: number;
  context_ref: string;
  intent: string;
  processing_policy: ProcessingPolicyJson;
  client_state: string;
  text?: string;
  asset?: AssetJson;
}

interface RegisterPayload {
  device_label: string;
  app_instance_id: string;
  app_version: string;
  protocol_version: string;
}

export interface DemoAudioDownload {
  ok: boolean;
  size: number;
  error: string;
}

export class LingxiBridgeClient {
  private baseUrl: string = '';
  private token: string = '';
  deviceId: string = '';

  /** PX-KK04-01：工作台「实测可达性」。
   *  true = 最近一次请求拿到了服务端响应（哪怕 4xx/5xx，也证明服务在线、凭证状态可查）；
   *  false = 最近一次请求是网络层失败（status 0：连接拒绝/超时/断网）。仅供 UI 如实展示，不作缓存，
   *  每次真实请求都会刷新。 */
  public lastReachable: boolean = false;

  configure(baseUrl: string, deviceId: string, token: string): void {
    this.baseUrl = baseUrl.replace(/\/+$/, '');
    this.deviceId = deviceId;
    this.token = token;
  }

  get configured(): boolean {
    return this.baseUrl.length > 0 && this.token.length > 0;
  }

  private request(method: http.RequestMethod, path: string,
    body: string | null, extraHeaders?: Record<string, string>,
    timeoutMs: number = DEFAULT_TIMEOUT): Promise<BridgeResult> {
    return new Promise((resolve) => {
      const req = http.createHttp();
      const headers: Record<string, string> = {};
      if (this.token) {
        headers['Authorization'] = `Bearer ${this.token}`;
      }
      if (body !== null) {
        headers['Content-Type'] = 'application/json';
      }
      if (extraHeaders) {
        for (const k of Object.keys(extraHeaders)) {
          headers[k] = extraHeaders[k];
        }
      }
      req.request(`${this.baseUrl}${path}`, {
        method: method,
        header: headers,
        extraData: body ?? undefined,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: timeoutMs,
        readTimeout: timeoutMs
      }, (err, resp) => {
        req.destroy();
        if (err) {
          // PX-KK04-01：网络层失败 = 服务不可达（连接拒绝/超时/断网）
          this.lastReachable = false;
          resolve({ ok: false, status: 0, body: '', error: `网络错误: ${JSON.stringify(err)}` });
          return;
        }
        // PX-KK04-01：拿到任何 HTTP 响应都证明服务在线（凭证是否有效另行区分）
        this.lastReachable = true;
        const status = resp.responseCode;
        const text = typeof resp.result === 'string' ? resp.result : JSON.stringify(resp.result);
        resolve({ ok: status >= 200 && status < 300, status: status, body: text, error: '' });
      });
    });
  }

  /** 设备注册（无需凭证）。返回 token/deviceId 或错误。 */
  async register(baseUrl: string, label: string, instanceId: string,
    appVersion: string): Promise<BridgeResult> {
    this.baseUrl = baseUrl.replace(/\/+$/, '');
    const payload: RegisterPayload = {
      device_label: label,
      app_instance_id: instanceId,
      app_version: appVersion,
      protocol_version: '1.0.0'
    };
    return this.request(http.RequestMethod.POST, '/api/mobile-capture/v1/devices/register',
      JSON.stringify(payload));
  }

  async capabilities(): Promise<BridgeResult> {
    return this.request(http.RequestMethod.GET, '/api/mobile-capture/v1/capabilities', null);
  }

  async revoke(): Promise<BridgeResult> {
    return this.request(http.RequestMethod.POST, '/api/mobile-capture/v1/devices/revoke', '{}');
  }

  /** D-KK04-05：整理失败任务显式重试（服务端幂等，不产生重复效果）。 */
  async retryTask(taskId: string): Promise<BridgeResult> {
    return this.request(http.RequestMethod.POST,
      `/api/mobile-capture/v1/tasks/${taskId}/retry`, '{}');
  }

  /** 提交采集元数据（文本含正文）。 */
  async submitCapture(item: CaptureItem): Promise<BridgeResult> {
    const policy: ProcessingPolicyJson = {
      auto_organize: true,
      correction_of: item.correctionOf
    };
    const envelope: CaptureEnvelope = {
      capture_id: item.captureId,
      schema_version: '1.0.0',
      payload_revision: item.payloadRevision,
      kind: item.kind,
      captured_at: item.capturedAt,
      captured_timezone: item.capturedTimezone,
      title_hint: item.titleHint,
      content_hash: item.contentHash,
      content_size: item.kind === 'text' ? new util.TextEncoder().encodeInto(item.text).length : item.assetSize,
      context_ref: item.contextRef,
      intent: item.intent,
      processing_policy: policy,
      client_state: item.transfer
    };
    if (item.kind === 'text') {
      envelope.text = item.text;
    } else {
      const asset: AssetJson = {
        filename: item.assetFile.split('/').pop() ?? `${item.captureId}.wav`,
        mime: 'audio/wav',
        sha256: item.assetSha256,
        size: item.assetSize,
        duration_ms: item.assetDurationMs
      };
      envelope.asset = asset;
    }
    return this.request(http.RequestMethod.POST, '/api/mobile-capture/v1/captures',
      JSON.stringify(envelope));
  }

  /** 上传音频资产（octet-stream + Content-Sha256）。 */
  async uploadAsset(item: CaptureItem, absPath: string): Promise<BridgeResult> {
    try {
      const fd = fs.openSync(absPath, fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(absPath);
      const buf = new ArrayBuffer(stat.size);
      fs.readSync(fd.fd, buf);
      fs.closeSync(fd);
      return await new Promise((resolve) => {
        const req = http.createHttp();
        req.request(
          `${this.baseUrl}/api/mobile-capture/v1/captures/${item.captureId}/asset?payload_revision=${item.payloadRevision}`,
          {
            method: http.RequestMethod.PUT,
            header: {
              'Authorization': `Bearer ${this.token}`,
              'Content-Type': 'application/octet-stream',
              'Content-Sha256': item.assetSha256
            },
            extraData: buf,
            expectDataType: http.HttpDataType.STRING,
            connectTimeout: 30000,
            readTimeout: 60000
          }, (err, resp) => {
            req.destroy();
            if (err) {
              resolve({ ok: false, status: 0, body: '', error: `网络错误: ${JSON.stringify(err)}` });
              return;
            }
            const status = resp.responseCode;
            const text = typeof resp.result === 'string' ? resp.result : JSON.stringify(resp.result);
            resolve({ ok: status >= 200 && status < 300, status: status, body: text, error: '' });
          });
      });
    } catch (e) {
      hilog.error(DOMAIN, TAG, `read asset failed: ${JSON.stringify(e)}`);
      return { ok: false, status: 0, body: '', error: `读取资产失败: ${JSON.stringify(e)}` };
    }
  }

  async getCapture(captureId: string): Promise<BridgeResult> {
    return this.request(http.RequestMethod.GET,
      `/api/mobile-capture/v1/captures/${captureId}`, null);
  }

  async events(cursor: number): Promise<BridgeResult> {
    return this.request(http.RequestMethod.GET,
      `/api/mobile-capture/v1/events?cursor=${cursor}&limit=200`, null);
  }

  async result(noteId: string): Promise<BridgeResult> {
    return this.request(http.RequestMethod.GET,
      `/api/mobile-capture/v1/results/${encodeURIComponent(noteId)}`, null);
  }

  /** 演示音频清单（J03/J07 受控替代：模拟器无真实麦克风）。 */
  async demoAudioList(): Promise<BridgeResult> {
    return this.request(http.RequestMethod.GET, '/api/mobile-capture/v1/demo-audio', null);
  }

  /** 下载演示音频到本地路径。返回 ok 与字节数。 */
  async downloadDemoAudio(name: string, destPath: string): Promise<DemoAudioDownload> {
    return new Promise((resolve) => {
      const req = http.createHttp();
      req.request(`${this.baseUrl}/api/mobile-capture/v1/demo-audio/${encodeURIComponent(name)}`, {
        method: http.RequestMethod.GET,
        header: { 'Authorization': `Bearer ${this.token}` },
        expectDataType: http.HttpDataType.ARRAY_BUFFER,
        connectTimeout: DEFAULT_TIMEOUT,
        readTimeout: 60000
      }, (err, resp) => {
        req.destroy();
        if (err) {
          resolve({ ok: false, size: 0, error: `网络错误: ${JSON.stringify(err)}` });
          return;
        }
        if (resp.responseCode !== 200 || !(resp.result instanceof ArrayBuffer)) {
          resolve({ ok: false, size: 0, error: `HTTP ${resp.responseCode}` });
          return;
        }
        try {
          const buf = resp.result as ArrayBuffer;
          const fd = fs.openSync(destPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
          fs.writeSync(fd.fd, buf);
          fs.closeSync(fd);
          resolve({ ok: true, size: buf.byteLength, error: '' });
        } catch (e) {
          resolve({ ok: false, size: 0, error: `写文件失败: ${JSON.stringify(e)}` });
        }
      });
    });
  }
}
