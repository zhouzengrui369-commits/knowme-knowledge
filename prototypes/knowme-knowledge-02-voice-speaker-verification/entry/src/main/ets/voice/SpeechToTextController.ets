import { speechRecognizer } from '@kit.CoreSpeechKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0200;
const TAG = 'KnowMEVoice.STT';
const SYSCAP = 'SystemCapability.AI.SpeechRecognizer';
const LANGUAGE_ZH_CN = 'zh-CN';
const MODE_OFFLINE = 1;

export interface SttSessionResult {
  transcript: string;
  partials: string[];
  completed: boolean;
  errorMessage: string;
}

/**
 * Local-first Mandarin STT over CoreSpeechKit, fed by our own PCM via
 * writeAudio (external capture is shared with speaker verification).
 *
 * Honesty rules:
 *  - syscap / engine unavailable ⇒ NOT_AVAILABLE (caller maps it), never a
 *    fake transcript;
 *  - offline request mode only; there is NO cloud fallback path in this app.
 */
export class SpeechToTextController {
  private engine: speechRecognizer.SpeechRecognitionEngine | null = null;
  private sessionId = '';
  private finals: string[] = [];
  private lastPartial = '';
  private completed = false;
  private errorMessage = '';
  private active = false;

  /** Runtime capability probe — result is surfaced honestly in the UI. */
  static capabilityAvailable(): boolean {
    try {
      return canIUse(SYSCAP);
    } catch (e) {
      return false;
    }
  }

  /** Create the offline engine; false ⇒ treat as NOT_AVAILABLE. */
  async init(): Promise<boolean> {
    if (!SpeechToTextController.capabilityAvailable()) {
      return false;
    }
    try {
      const params: speechRecognizer.CreateEngineParams = {
        language: LANGUAGE_ZH_CN,
        online: MODE_OFFLINE
      };
      this.engine = await speechRecognizer.createEngine(params);
      return this.engine !== null;
    } catch (e) {
      hilog.error(DOMAIN, TAG, `createEngine failed: ${JSON.stringify(e)}`);
      this.engine = null;
      return false;
    }
  }

  isActive(): boolean {
    return this.active;
  }

  /** Begin a session; frames then flow through pushFrame(). */
  beginSession(): boolean {
    if (!this.engine) {
      return false;
    }
    this.sessionId = `kk02-${Date.now()}`;
    this.finals = [];
    this.lastPartial = '';
    this.completed = false;
    this.errorMessage = '';
    try {
      const listener: speechRecognizer.RecognitionListener = {
        onStart: (sessionId: string, eventMessage: string) => {
          hilog.info(DOMAIN, TAG, `stt onStart ${sessionId}: ${eventMessage}`);
        },
        onEvent: (sessionId: string, eventCode: number, eventMessage: string) => {
          hilog.info(DOMAIN, TAG, `stt onEvent ${eventCode}: ${eventMessage}`);
        },
        onResult: (sessionId: string, result: speechRecognizer.SpeechRecognitionResult) => {
          if (result.isFinal) {
            if (result.result.length > 0) {
              this.finals.push(result.result);
            }
          } else {
            this.lastPartial = result.result;
          }
        },
        onComplete: (sessionId: string, eventMessage: string) => {
          this.completed = true;
          hilog.info(DOMAIN, TAG, `stt onComplete: ${eventMessage}`);
        },
        onError: (sessionId: string, errorCode: number, errorMessage: string) => {
          this.errorMessage = `STT 错误 ${errorCode}: ${errorMessage}`;
          hilog.error(DOMAIN, TAG, `stt onError ${errorCode}: ${errorMessage}`);
        }
      };
      this.engine.setListener(listener);
      this.engine.startListening({
        sessionId: this.sessionId,
        audioInfo: {
          audioType: 'pcm',
          sampleRate: 16000,
          soundChannel: 1,
          sampleBit: 16
        }
      });
      this.active = true;
      return true;
    } catch (e) {
      hilog.error(DOMAIN, TAG, `startListening failed: ${JSON.stringify(e)}`);
      this.active = false;
      return false;
    }
  }

  /** Feed one 640/1280-byte PCM frame. */
  pushFrame(frame: Uint8Array): void {
    if (!this.active || !this.engine) {
      return;
    }
    try {
      this.engine.writeAudio(this.sessionId, frame);
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `writeAudio warn: ${JSON.stringify(e)}`);
    }
  }

  /** Finish and collect the final transcript (may arrive via onComplete later). */
  async finishSession(): Promise<SttSessionResult> {
    if (this.active && this.engine) {
      try {
        this.engine.finish(this.sessionId);
      } catch (e) {
        hilog.warn(DOMAIN, TAG, `finish warn: ${JSON.stringify(e)}`);
      }
    }
    this.active = false;
    // Give the engine a bounded moment to deliver final results.
    const deadline = Date.now() + 1500;
    while (!this.completed && this.errorMessage.length === 0 && Date.now() < deadline) {
      await new Promise<void>((resolve) => setTimeout(resolve, 50));
    }
    const transcript = this.finals.join('').trim();
    return {
      transcript: transcript.length > 0 ? transcript : this.lastPartial.trim(),
      partials: this.finals.slice(),
      completed: this.completed,
      errorMessage: this.errorMessage
    };
  }

  async cancelSession(): Promise<void> {
    if (this.engine) {
      try {
        this.engine.cancel(this.sessionId);
      } catch (e) {
        hilog.warn(DOMAIN, TAG, `cancel warn: ${JSON.stringify(e)}`);
      }
    }
    this.active = false;
    this.finals = [];
    this.lastPartial = '';
  }

  destroy(): void {
    this.engine = null;
    this.active = false;
  }
}
