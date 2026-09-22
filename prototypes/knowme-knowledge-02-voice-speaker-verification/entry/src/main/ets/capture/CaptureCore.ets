/**
 * GOAL-KK-04 采集箱纯逻辑 —— 无 @kit 依赖，确定性、可单测。
 *
 * 冻结语义：
 *  - 采集先本地可靠落盘（LOCAL_SAVED）；用户显式「交给灵犀」才进入 QUEUED。
 *  - 未提交草稿永不入队、不入库。
 *  - 同一 capture_id+payload_revision+content_hash 重传幂等；
 *    不同 capture_id 同名同分钟互不覆盖（身份=ID，不是文件名）。
 *  - 可靠 ACK（RECEIVED）前本地原件不可删除。
 *  - 传输状态与处理状态分离；RECEIVED ≠ 整理完成。
 */

export enum CaptureKind {
  TEXT = 'text',
  AUDIO = 'audio'
}

export enum TransferStatus {
  DRAFT = 'DRAFT',               // 未授权草稿：不入队、不上传
  LOCAL_SAVED = 'LOCAL_SAVED',   // 已授权，待入队
  QUEUED = 'QUEUED',             // 排队待传
  UPLOADING = 'UPLOADING',
  FAILED = 'FAILED',             // 本次同步失败（可重试，原件保留）
  RECEIVED = 'RECEIVED'          // 工作台可靠 ACK（hash 校验+落盘）
}

export enum ProcessingStatus {
  NONE = 'NONE',
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  NEEDS_INPUT = 'NEEDS_INPUT'
}

export type CaptureIntent = 'note' | 'correction' | 'supplement';

export interface CaptureItem {
  captureId: string;
  payloadRevision: number;
  kind: CaptureKind;
  capturedAt: string;            // RFC 3339 带偏移量
  capturedTimezone: string;      // IANA，如 Asia/Shanghai
  titleHint: string;
  text: string;                  // kind=text 正文
  assetFile: string;             // kind=audio 沙箱内文件名（采集箱目录相对）
  assetSha256: string;
  assetSize: number;
  assetDurationMs: number;
  contentHash: string;           // sha256:<hex>（text=正文字节；audio=资产字节）
  transfer: TransferStatus;
  processing: ProcessingStatus;
  taskId: string;
  noteId: string;
  noteRevision: number;
  intent: CaptureIntent;
  correctionOf: string;          // 修正对象 captureId
  contextRef: string;
  error: string;
  recoveryAction: string;
  attempts: number;
  updatedAt: number;
}

/** RFC 4122 v4 UUID（Math.random 足够：仅作身份标识，不作安全用途）。 */
export function newCaptureId(): string {
  const hex = '0123456789abcdef';
  let s = '';
  for (let i = 0; i < 32; i++) {
    s += hex.charAt(Math.floor(Math.random() * 16));
  }
  return `cap_${s.slice(0, 8)}${s.slice(8, 12)}${s.slice(12, 16)}${s.slice(16, 20)}${s.slice(20)}`;
}

/** 本地时间 → RFC 3339 带偏移量（如 2026-09-22T17:30:00+08:00）。 */
export function localIsoWithOffset(d: Date): string {
  const pad = (n: number, w: number = 2): string => String(n).padStart(w, '0');
  const offMin = -d.getTimezoneOffset();
  const sign = offMin >= 0 ? '+' : '-';
  const oh = pad(Math.floor(Math.abs(offMin) / 60));
  const om = pad(Math.abs(offMin) % 60);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}` +
    `T${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}${sign}${oh}:${om}`;
}

/** 设备时区 IANA 名（模拟器/真机均可得；失败时回退偏移描述）。 */
export function deviceTimezone(): string {
  try {
    return Intl.DateTimeFormat().resolvedOptions().timeZone || 'Asia/Shanghai';
  } catch (e) {
    return 'Asia/Shanghai';
  }
}

/** 草稿显式授权（交给灵犀）：DRAFT → LOCAL_SAVED；其他状态拒绝。 */
export function authorizeDraft(item: CaptureItem): boolean {
  if (item.transfer !== TransferStatus.DRAFT) {
    return false;
  }
  if (item.kind === CaptureKind.TEXT && item.text.trim().length === 0) {
    return false;
  }
  if (item.kind === CaptureKind.AUDIO && (!item.assetFile || item.assetSize === 0)) {
    return false;
  }
  item.transfer = TransferStatus.LOCAL_SAVED;
  item.updatedAt = Date.now();
  return true;
}

/** 入队：LOCAL_SAVED/FAILED（可重试）→ QUEUED；幂等：QUEUED/UPLOADING/RECEIVED 不变。 */
export function enqueue(item: CaptureItem): boolean {
  if (item.transfer === TransferStatus.LOCAL_SAVED || item.transfer === TransferStatus.FAILED) {
    item.transfer = TransferStatus.QUEUED;
    item.error = '';
    item.updatedAt = Date.now();
    return true;
  }
  return false;
}

/** 可上传判定：只有 QUEUED 且未在传的项。 */
export function canUpload(item: CaptureItem): boolean {
  return item.transfer === TransferStatus.QUEUED;
}

/** ACK 到达：仅 UPLOADING → RECEIVED；此后本地原件可标记可清理（默认仍保留）。 */
export function markReceived(item: CaptureItem, taskId: string): boolean {
  if (item.transfer !== TransferStatus.UPLOADING && item.transfer !== TransferStatus.QUEUED) {
    return false;
  }
  item.transfer = TransferStatus.RECEIVED;
  item.taskId = taskId;
  item.processing = ProcessingStatus.PENDING;
  item.updatedAt = Date.now();
  return true;
}

/** 上传失败回 QUEUED（等待重试）；原件保留。 */
export function markUploadFailed(item: CaptureItem, error: string, recovery: string): void {
  item.transfer = TransferStatus.FAILED;
  item.error = error;
  item.recoveryAction = recovery;
  item.attempts += 1;
  item.updatedAt = Date.now();
}

/** 工作台处理状态同步（事件/轮询补回）。 */
export function applyProcessing(item: CaptureItem, status: ProcessingStatus,
  noteId: string = '', noteRevision: number = 0,
  error: string = '', recovery: string = ''): void {
  item.processing = status;
  if (noteId) {
    item.noteId = noteId;
  }
  if (noteRevision > 0) {
    item.noteRevision = noteRevision;
  }
  item.error = error;
  item.recoveryAction = recovery;
  item.updatedAt = Date.now();
}

/** 现场修正：基于既有采集生成 revision+1 的新内容项（原件不变）。 */
export function makeCorrection(src: CaptureItem, newText: string, now: Date): CaptureItem {
  return {
    captureId: src.captureId,
    payloadRevision: src.payloadRevision + 1,
    kind: CaptureKind.TEXT,
    capturedAt: localIsoWithOffset(now),
    capturedTimezone: deviceTimezone(),
    titleHint: src.titleHint,
    text: newText,
    assetFile: '', assetSha256: '', assetSize: 0, assetDurationMs: 0,
    contentHash: '',
    transfer: TransferStatus.DRAFT,
    processing: ProcessingStatus.NONE,
    taskId: '', noteId: src.noteId, noteRevision: src.noteRevision,
    intent: 'correction',
    correctionOf: src.captureId,
    contextRef: src.noteId,
    error: '', recoveryAction: '', attempts: 0,
    updatedAt: now.getTime()
  };
}

/** 状态中文标签（采集箱分清「未同步」与「未整理」）。 */
export function statusLabel(item: CaptureItem): string {
  if (item.transfer === TransferStatus.DRAFT) {
    return '草稿（未提交）';
  }
  if (item.transfer !== TransferStatus.RECEIVED) {
    switch (item.transfer) {
      case TransferStatus.LOCAL_SAVED: return '已保存（未同步）';
      case TransferStatus.QUEUED: return '排队待传';
      case TransferStatus.UPLOADING: return '上传中';
      case TransferStatus.FAILED: return '同步失败（可重试）';
      default: return '未同步';
    }
  }
  switch (item.processing) {
    case ProcessingStatus.PENDING: return '已接收（待整理）';
    case ProcessingStatus.PROCESSING: return '灵犀整理中';
    case ProcessingStatus.COMPLETED: return '已整理（可查看）';
    case ProcessingStatus.FAILED: return '整理失败';
    case ProcessingStatus.NEEDS_INPUT: return '需要补充';
    default: return '已接收';
  }
}
