/**
 * GOAL-KK-04 采集箱持久化 —— 应用沙箱文件存储。
 *
 * 布局（context.filesDir 下）：
 *   capturebox/index.json            全部 CaptureItem 元数据（JSON 数组）
 *   capturebox/assets/<captureId>/r<rev>/<filename>   原始资产（录音 wav 等）
 *
 * 语义：杀 App / 冷开后完整恢复；可靠 ACK 前原件不删；草稿（DRAFT）也持久化但永不入队。
 */
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CaptureItem, TransferStatus } from './CaptureCore';

const DOMAIN = 0x0204;
const TAG = 'KnowME.CaptureStore';

export interface DeviceSessionInfo {
  baseUrl: string;
  deviceId: string;
  token: string;
}

interface DeviceSessionJson {
  base_url: string;
  device_id: string;
  token: string;
}

export class CaptureStore {
  private ctx: common.UIAbilityContext | null = null;
  private items: Map<string, CaptureItem[]> = new Map();  // captureId → revisions 升序
  private loaded = false;

  init(context: common.UIAbilityContext): void {
    this.ctx = context;
    const dir = this.boxDir();
    if (!fs.accessSync(dir)) {
      fs.mkdirSync(dir, true);
    }
    const adir = this.assetsDir();
    if (!fs.accessSync(adir)) {
      fs.mkdirSync(adir, true);
    }
    this.loadAll();
  }

  boxDir(): string {
    return `${this.ctx!.filesDir}/capturebox`;
  }

  assetsDir(): string {
    return `${this.boxDir()}/assets`;
  }

  private indexPath(): string {
    return `${this.boxDir()}/index.json`;
  }

  assetDirFor(captureId: string, revision: number): string {
    return `${this.assetsDir()}/${captureId}/r${revision}`;
  }

  private loadAll(): void {
    this.items.clear();
    try {
      if (fs.accessSync(this.indexPath())) {
        const fd = fs.openSync(this.indexPath(), fs.OpenMode.READ_ONLY);
        const stat = fs.statSync(this.indexPath());
        const buf = new ArrayBuffer(stat.size);
        fs.readSync(fd.fd, buf);
        fs.closeSync(fd);
        const text = new util.TextDecoder().decodeToString(new Uint8Array(buf));
        const arr = JSON.parse(text) as CaptureItem[];
        for (const it of arr) {
          const list = this.items.get(it.captureId) ?? [];
          list.push(it);
          this.items.set(it.captureId, list);
        }
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, `load failed: ${JSON.stringify(e)}`);
    }
    for (const list of this.items.values()) {
      list.sort((a, b) => a.payloadRevision - b.payloadRevision);
    }
    this.loaded = true;
  }

  private persist(): void {
    if (!this.loaded) {
      return;
    }
    const all: CaptureItem[] = [];
    for (const list of this.items.values()) {
      for (const it of list) {
        all.push(it);
      }
    }
    const tmp = `${this.indexPath()}.tmp`;
    try {
      const fd = fs.openSync(tmp, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      fs.writeSync(fd.fd, JSON.stringify(all));
      fs.fsyncSync(fd.fd);
      fs.closeSync(fd);
      fs.renameSync(tmp, this.indexPath());
    } catch (e) {
      hilog.error(DOMAIN, TAG, `persist failed: ${JSON.stringify(e)}`);
    }
  }

  /** 保存（新增或按 captureId+revision 替换）并立即落盘。 */
  save(item: CaptureItem): void {
    const list = this.items.get(item.captureId) ?? [];
    const idx = list.findIndex((x) => x.payloadRevision === item.payloadRevision);
    if (idx >= 0) {
      list[idx] = item;
    } else {
      list.push(item);
      list.sort((a, b) => a.payloadRevision - b.payloadRevision);
    }
    this.items.set(item.captureId, list);
    this.persist();
  }

  /** 最新 revision 视图。 */
  get(captureId: string): CaptureItem | null {
    const list = this.items.get(captureId);
    return list && list.length > 0 ? list[list.length - 1] : null;
  }

  getRevision(captureId: string, revision: number): CaptureItem | null {
    const list = this.items.get(captureId) ?? [];
    const hit = list.find((x) => x.payloadRevision === revision);
    return hit ?? null;
  }

  /** 全部采集的最新 revision 列表（新的在前）。
   *
   * PX-KK04-02 修复：排序键必须是**稳定**的捕获时间，不能用 updatedAt。
   * updatedAt 在每次状态流转（如「交给灵犀」入队、ACK 回写）都会变，
   * 用它排序会让正在操作中的条目在列表里跳位，导致用户下一次点按落到错的对象上。
   * 这里按 capturedAt 降序（同刻再按 captureId 字典序兜底），顺序与同步/整理回写无关。
   */
  listLatest(): CaptureItem[] {
    const out: CaptureItem[] = [];
    for (const list of this.items.values()) {
      if (list.length > 0) {
        out.push(list[list.length - 1]);
      }
    }
    out.sort((a, b) => {
      const ca = a.capturedAt ?? '';
      const cb = b.capturedAt ?? '';
      if (ca !== cb) {
        return ca < cb ? 1 : -1;
      }
      return a.captureId < b.captureId ? 1 : -1;
    });
    return out;
  }

  /** 待同步队列：已授权但未 RECEIVED 的项。 */
  pendingSync(): CaptureItem[] {
    return this.listLatest().filter((it) =>
      it.transfer === TransferStatus.LOCAL_SAVED ||
      it.transfer === TransferStatus.QUEUED ||
      it.transfer === TransferStatus.FAILED);
  }

  // ── 设备会话（工作台地址 + device_id + token 持久化，token 仅本机沙箱）──
  private sessionPath(): string {
    return `${this.boxDir()}/device.json`;
  }

  saveSession(baseUrl: string, deviceId: string, token: string): void {
    try {
      const payload: DeviceSessionJson = {
        base_url: baseUrl, device_id: deviceId, token: token
      };
      const fd = fs.openSync(this.sessionPath(),
        fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      fs.writeSync(fd.fd, JSON.stringify(payload));
      fs.fsyncSync(fd.fd);
      fs.closeSync(fd);
    } catch (e) {
      hilog.error(DOMAIN, TAG, `session persist failed: ${JSON.stringify(e)}`);
    }
  }

  loadSession(): DeviceSessionInfo | null {
    try {
      if (!fs.accessSync(this.sessionPath())) {
        return null;
      }
      const fd = fs.openSync(this.sessionPath(), fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(this.sessionPath());
      const buf = new ArrayBuffer(stat.size);
      fs.readSync(fd.fd, buf);
      fs.closeSync(fd);
      const obj = JSON.parse(new util.TextDecoder().decodeToString(new Uint8Array(buf))) as DeviceSessionJson;
      const info: DeviceSessionInfo = {
        baseUrl: obj.base_url ?? '',
        deviceId: obj.device_id ?? '',
        token: obj.token ?? ''
      };
      return info;
    } catch (e) {
      return null;
    }
  }

  clearSession(): void {
    try {
      if (fs.accessSync(this.sessionPath())) {
        fs.unlinkSync(this.sessionPath());
      }
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `session clear: ${JSON.stringify(e)}`);
    }
  }
}
