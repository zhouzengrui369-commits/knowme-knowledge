import { audio } from '@kit.AudioKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { PcmChunker } from '../core/VoiceCore';

const DOMAIN = 0x0200;
const TAG = 'KnowMEVoice.Capture';
const FRAME_BYTES = 1280; // 16 kHz × 2 B × 40 ms — CoreSpeechKit writeAudio size

/**
 * Single-mic PCM capture (16 kHz / mono / s16le). Explicit start/stop/cancel
 * only — no background or always-on capture, per contract.
 *
 * Every readData buffer is:
 *   1. appended to the session PCM (for speaker embedding), and
 *   2. chunked into 1280-byte frames forwarded to onFrame (STT writeAudio).
 */
export class AudioCaptureController {
  private capturer: audio.AudioCapturer | null = null;
  private recording = false;
  private chunker = new PcmChunker(FRAME_BYTES);
  private sessionPcm: Uint8Array[] = [];
  private sessionBytes = 0;

  onFrame: (frame: Uint8Array) => void = () => {};
  onError: (message: string) => void = () => {};

  isRecording(): boolean {
    return this.recording;
  }

  async start(): Promise<boolean> {
    if (this.recording) {
      return true;
    }
    try {
      const streamInfo: audio.AudioStreamInfo = {
        samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
        channels: audio.AudioChannel.CHANNEL_1,
        sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
        encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
      };
      const capturerInfo: audio.AudioCapturerInfo = {
        source: audio.SourceType.SOURCE_TYPE_MIC,
        capturerFlags: 0
      };
      this.capturer = await audio.createAudioCapturer({
        streamInfo: streamInfo,
        capturerInfo: capturerInfo
      });
      this.chunker = new PcmChunker(FRAME_BYTES);
      this.sessionPcm = [];
      this.sessionBytes = 0;
      this.capturer.on('readData', (buffer: ArrayBuffer) => {
        const bytes = new Uint8Array(buffer);
        this.sessionPcm.push(bytes);
        this.sessionBytes += bytes.length;
        for (const frame of this.chunker.push(bytes)) {
          this.onFrame(frame);
        }
      });
      await this.capturer.start();
      this.recording = true;
      return true;
    } catch (e) {
      hilog.error(DOMAIN, TAG, `capture start failed: ${JSON.stringify(e)}`);
      this.recording = false;
      this.onError(`麦克风启动失败: ${JSON.stringify(e)}`);
      return false;
    }
  }

  /** Stop and return the full session PCM (empty when nothing captured). */
  async stop(): Promise<Uint8Array> {
    this.recording = false;
    try {
      if (this.capturer) {
        await this.capturer.stop();
      }
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `capturer stop warn: ${JSON.stringify(e)}`);
    }
    this.release();
    const out = new Uint8Array(this.sessionBytes);
    let offset = 0;
    for (const part of this.sessionPcm) {
      out.set(part, offset);
      offset += part.length;
    }
    this.sessionPcm = [];
    this.sessionBytes = 0;
    return out;
  }

  /** Cancel discards everything (record-cancel journey). */
  async cancel(): Promise<void> {
    this.recording = false;
    try {
      if (this.capturer) {
        await this.capturer.stop();
      }
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `capturer cancel warn: ${JSON.stringify(e)}`);
    }
    this.release();
    this.sessionPcm = [];
    this.sessionBytes = 0;
    this.chunker = new PcmChunker(FRAME_BYTES);
  }

  private release(): void {
    try {
      this.capturer?.release();
    } catch (e) {
      hilog.warn(DOMAIN, TAG, `capturer release warn: ${JSON.stringify(e)}`);
    }
    this.capturer = null;
  }
}
