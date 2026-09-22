/**
 * GOAL-KK-04 同步控制器 —— 队列调度、自动补传、状态补拉。
 *
 * 语义（合同 §4/§5）：
 *  - 只推进「已授权」队列（DRAFT 永不上传）。
 *  - 幂等：同 capture_id+revision+hash 重传由服务端去重，本地重复触发安全。
 *  - ACK（RECEIVED）前不删本地原件；上传失败回 FAILED/QUEUED 可重试。
 *  - 网络恢复且服务可达 → 10 秒内启动同步（tick 节流 3s + 事件驱动）。
 *  - 处理状态通过事件游标 + 状态查询补回；事件不是唯一完成记录。
 */
import { connection } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  CaptureItem, TransferStatus, ProcessingStatus,
  enqueue, canUpload, markReceived, markUploadFailed, applyProcessing
} from '../capture/CaptureCore';
import { CaptureStore } from '../capture/CaptureStore';
import { LingxiBridgeClient } from './LingxiBridgeClient';

const DOMAIN = 0x0206;
const TAG = 'KnowME.Sync';

export interface SyncListener {
  onChange: () => void;
}

interface BridgeEventRefs {
  note_id?: string;
  note_revision?: number;
  error?: string;
}

interface BridgeEvent {
  capture_id?: string;
  type?: string;
  refs?: BridgeEventRefs;
}

interface EventsResponse {
  events?: BridgeEvent[];
  next_cursor?: number;
}

interface CaptureView {
  processing_status?: string;
  result_refs?: BridgeEventRefs;
  error?: string;
  recovery_action?: string;
}

export class SyncController {
  private store: CaptureStore;
  private client: LingxiBridgeClient;
  private listener: SyncListener | null = null;
  private syncing = false;
  private lastTick = 0;
  private eventCursor = 0;
  private netCallbackRegistered = false;

  constructor(store: CaptureStore, client: LingxiBridgeClient) {
    this.store = store;
    this.client = client;
  }

  setListener(l: SyncListener): void {
    this.listener = l;
  }

  private notify(): void {
    if (this.listener) {
      this.listener.onChange();
    }
  }

  /** 监听网络恢复（需要 ohos.permission.GET_NETWORK_INFO）。 */
  watchNetwork(): void {
    if (this.netCallbackRegistered) {
      return;
    }
    try {
      const net = connection.createNetConnection();
      net.on('netAvailable', () => {
        hilog.info(DOMAIN, TAG, 'network available → sync tick');
        this.tick();
      });
      this.netCallbackRegistered = true;
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `net watch unavailable: ${JSON.stringify(e)}`);
    }
  }

  /** 周期/事件驱动 tick：3 秒节流，先补拉状态，再推进上传队列。 */
  async tick(): Promise<void> {
    if (this.syncing || !this.client.configured) {
      return;
    }
    const now = Date.now();
    if (now - this.lastTick < 3000) {
      return;
    }
    this.lastTick = now;
    this.syncing = true;
    try {
      await this.pullEvents();
      await this.refreshPending();
      await this.pushQueue();
    } finally {
      this.syncing = false;
    }
  }

  /** 手动「交给灵犀」后立即调用。 */
  async kick(): Promise<void> {
    this.lastTick = 0;
    await this.tick();
  }

  private async pullEvents(): Promise<void> {
    const r = await this.client.events(this.eventCursor);
    if (!r.ok) {
      return;
    }
    let changed = false;
    try {
      const body = JSON.parse(r.body) as EventsResponse;
      for (const ev of body.events ?? []) {
        const cid = ev.capture_id ?? '';
        if (!cid) {
          continue;
        }
        const item = this.store.get(cid);
        if (!item) {
          continue;
        }
        const type = ev.type ?? '';
        if (type === 'ORGANIZE_COMPLETED') {
          const refs = ev.refs;
          applyProcessing(item, ProcessingStatus.COMPLETED,
            refs?.note_id ?? '', refs?.note_revision ?? 1);
          this.store.save(item);
          changed = true;
        } else if (type === 'ORGANIZE_FAILED') {
          applyProcessing(item, ProcessingStatus.FAILED, '', 0,
            ev.refs?.error ?? '', '可在采集箱重试');
          this.store.save(item);
          changed = true;
        } else if (type === 'PROCESSING_STARTED') {
          applyProcessing(item, ProcessingStatus.PROCESSING);
          this.store.save(item);
          changed = true;
        }
      }
      this.eventCursor = body.next_cursor ?? this.eventCursor;
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `events parse: ${JSON.stringify(e)}`);
    }
    if (changed) {
      this.notify();
    }
  }

  /** 对已 RECEIVED 但未完成的采集做状态查询补回（事件不是唯一完成记录）。 */
  private async refreshPending(): Promise<void> {
    const pending = this.store.listLatest().filter((it) =>
      it.transfer === TransferStatus.RECEIVED &&
      (it.processing === ProcessingStatus.PENDING ||
        it.processing === ProcessingStatus.PROCESSING));
    let changed = false;
    for (const item of pending.slice(0, 5)) {
      const r = await this.client.getCapture(item.captureId);
      if (!r.ok) {
        continue;
      }
      try {
        const v = JSON.parse(r.body) as Record<string, Object>;
        const ps = String(v['processing_status'] ?? '');
        if (ps === 'COMPLETED' || ps === 'FAILED' || ps === 'NEEDS_INPUT') {
          const refs = (v['result_refs'] ?? {}) as Record<string, Object>;
          applyProcessing(item, ps as ProcessingStatus,
            String(refs['note_id'] ?? ''), Number(refs['note_revision'] ?? 0),
            String(v['error'] ?? ''), String(v['recovery_action'] ?? ''));
          this.store.save(item);
          changed = true;
        }
      } catch (e) {
        hilog.warn(DOMAIN, TAG, `capture parse: ${JSON.stringify(e)}`);
      }
    }
    if (changed) {
      this.notify();
    }
  }

  private async pushQueue(): Promise<void> {
    const queue = this.store.pendingSync();
    for (const item of queue) {
      if (!enqueue(item) && !canUpload(item)) {
        continue;
      }
      this.store.save(item);
      this.notify();
      await this.uploadOne(item);
    }
  }

  private async uploadOne(item: CaptureItem): Promise<void> {
    item.transfer = TransferStatus.UPLOADING;
    this.store.save(item);
    this.notify();

    const sub = await this.client.submitCapture(item);
    if (!sub.ok) {
      if (sub.status === 409) {
        markUploadFailed(item, '内容与已提交版本冲突', '如需修正请使用「现场修正」生成新版本');
      } else if (sub.status === 401) {
        markUploadFailed(item, '设备凭证失效', '请到「连接」重新注册设备');
      } else if (sub.status === 503) {
        markUploadFailed(item, '工作台插件停用中', '保持排队，插件启用后自动补传');
        item.transfer = TransferStatus.QUEUED;   // 可自动恢复，不算用户错误
      } else {
        markUploadFailed(item, `提交失败(${sub.status || '网络'})`, '检查网络后自动重试');
        item.transfer = TransferStatus.QUEUED;
      }
      this.store.save(item);
      this.notify();
      return;
    }

    if (item.kind === 'text') {
      const body = JSON.parse(sub.body) as Record<string, Object>;
      if (String(body['transfer_status'] ?? '') === 'RECEIVED') {
        markReceived(item, String(body['task_id'] ?? ''));
        this.store.save(item);
        this.notify();
        return;
      }
      markUploadFailed(item, '未获得可靠接收确认', '将自动重试');
      item.transfer = TransferStatus.QUEUED;
      this.store.save(item);
      this.notify();
      return;
    }

    // audio：元数据受理后上传资产，ACK 才算 RECEIVED
    const assetAbs = `${this.store.assetDirFor(item.captureId, item.payloadRevision)}/${item.assetFile.split('/').pop()}`;
    const up = await this.client.uploadAsset(item, assetAbs);
    if (up.ok) {
      try {
        const body = JSON.parse(up.body) as Record<string, Object>;
        markReceived(item, String(body['task_id'] ?? item.taskId));
      } catch (e) {
        markReceived(item, item.taskId);
      }
    } else {
      markUploadFailed(item, `资产上传失败(${up.status || '网络'})`, '原件已保留，将自动重试');
      item.transfer = TransferStatus.QUEUED;
    }
    this.store.save(item);
    this.notify();
  }
}
