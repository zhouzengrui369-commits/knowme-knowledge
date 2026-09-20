import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { util } from '@kit.ArkTS';
import { AgentContext, AgentSnapshot } from './AgentContext';

const DOMAIN = 0x0200;
const TAG = 'KnowMEVoice.AgentStore';

/**
 * R3 (PX-KK02-01): bounded local persistence for the Agent context.
 *
 * Stores ONLY the AgentSnapshot contract (explicitly confirmed knowledge +
 * bounded conversation tail) as JSON in the app-private sandbox — same
 * privacy class as the speaker profile (deleted on uninstall, never leaves
 * the device, never enters git). Draft / rejected / discarded voice
 * candidates are never written.
 *
 * This is bounded 0.1-prototype persistence so the visible save/confirm
 * promise is truthful across Home return, permission round-trip (permission
 * revoke kills the process), force-stop and cold reopen. It is NOT a
 * production backup/sync claim.
 */
export class AgentContextStore {
  private storePath = '';

  init(context: common.UIAbilityContext): void {
    this.storePath = `${context.filesDir}/kk02_agent_context.json`;
  }

  /** Load the snapshot; null when absent or unreadable (honest fresh start). */
  load(): AgentSnapshot | null {
    if (this.storePath.length === 0) {
      return null;
    }
    try {
      if (!fileIo.accessSync(this.storePath)) {
        return null;
      }
      const file = fileIo.openSync(this.storePath, fileIo.OpenMode.READ_ONLY);
      const buffer = new ArrayBuffer(1024 * 1024);
      const len = fileIo.readSync(file.fd, buffer);
      fileIo.closeSync(file);
      const decoder = util.TextDecoder.create('utf-8');
      const text = decoder.decodeToString(new Uint8Array(buffer.slice(0, len)));
      const parsed = JSON.parse(text) as AgentSnapshot;
      if (!parsed || typeof parsed !== 'object' || !Array.isArray(parsed.knowledge)) {
        return null;
      }
      return parsed;
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `agent context load warn: ${JSON.stringify(e)}`);
      return null;
    }
  }

  /** Persist the current snapshot (small bounded JSON; sync write is fine). */
  save(agent: AgentContext): void {
    if (this.storePath.length === 0) {
      return;
    }
    try {
      const file = fileIo.openSync(this.storePath,
        fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
      fileIo.writeSync(file.fd, JSON.stringify(agent.snapshot()));
      fileIo.closeSync(file);
    } catch (e) {
      hilog.error(DOMAIN, TAG, `agent context persist failed: ${JSON.stringify(e)}`);
    }
  }
}
