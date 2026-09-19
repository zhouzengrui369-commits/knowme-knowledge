import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { SpeakerEmbeddingExtractor, SpeakerEmbeddingExtractorConfig } from 'sherpa_onnx';
import { ISpeakerEmbeddingEngine } from '../voice/SpeakerVerificationController';

const DOMAIN = 0x0200;
const TAG = 'KnowMEVoice.SherpaEngine';
const MODEL_RAWFILE = 'models/3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx';
const MODEL_LOCAL = 'eres2net_zh_cn_16k.onnx';
const ENGINE_ID =
  'sherpa-onnx 1.12.1 (ohpm sherpa_onnx.har) + 3dspeaker_speech_eres2net_base_200k_sv_zh-cn_16k-common.onnx, cpu, 16kHz';

/**
 * Real on-device speaker embedding engine (sherpa-onnx SpeakerEmbeddingExtractor).
 *
 * Provisioning: the exact model bytes are bundled as a rawfile at build time
 * by scripts/provision-models.sh (pinned URL + sha256; never committed to
 * git). On first run they are copied into the app sandbox because the native
 * ONNX runtime needs a real file path. Everything stays on-device.
 */
export class SherpaSpeakerEngine implements ISpeakerEmbeddingEngine {
  private extractor: SpeakerEmbeddingExtractor | null = null;
  private modelPath = '';
  private ready = false;
  private failureNote = '';

  isReady(): boolean {
    return this.ready;
  }

  engineIdentity(): string {
    return this.ready ? ENGINE_ID : `NOT_READY (${this.failureNote})`;
  }

  /** Copy rawfile model → sandbox and create the extractor. */
  async init(context: common.UIAbilityContext): Promise<boolean> {
    try {
      this.modelPath = `${context.filesDir}/${MODEL_LOCAL}`;
      if (!fileIo.accessSync(this.modelPath)) {
        const raw = context.resourceManager.getRawFileContentSync(MODEL_RAWFILE);
        const file = fileIo.openSync(this.modelPath,
          fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
        fileIo.writeSync(file.fd, raw.buffer.slice(raw.byteOffset, raw.byteOffset + raw.byteLength));
        fileIo.closeSync(file);
      }
      const config = new SpeakerEmbeddingExtractorConfig();
      config.model = this.modelPath;
      config.numThreads = 2;
      config.provider = 'cpu';
      config.debug = false;
      this.extractor = new SpeakerEmbeddingExtractor(config);
      this.ready = this.extractor.dim > 0;
      if (!this.ready) {
        this.failureNote = 'extractor dim=0';
      }
      return this.ready;
    } catch (e) {
      this.failureNote = `init failed: ${JSON.stringify(e)}`;
      hilog.error(DOMAIN, TAG, this.failureNote);
      this.ready = false;
      return false;
    }
  }

  /** 16 kHz mono s16le PCM → embedding (empty array on failure). */
  extract(pcm: Uint8Array): number[] {
    if (!this.ready || !this.extractor) {
      return [];
    }
    try {
      const frames = pcm.length >> 1;
      const samples = new Float32Array(frames);
      for (let i = 0; i < frames; i++) {
        const lo = pcm[2 * i];
        const hi = pcm[2 * i + 1];
        let v = (hi << 8) | lo;
        if (v >= 32768) {
          v -= 65536;
        }
        samples[i] = v / 32768.0;
      }
      const stream = this.extractor.createStream();
      stream.acceptWaveform({ samples: samples, sampleRate: 16000 });
      if (!this.extractor.isReady(stream)) {
        return [];
      }
      const emb = this.extractor.compute(stream);
      const out: number[] = [];
      for (let i = 0; i < emb.length; i++) {
        out.push(emb[i]);
      }
      return out;
    } catch (e) {
      hilog.error(DOMAIN, TAG, `extract failed: ${JSON.stringify(e)}`);
      return [];
    }
  }
}
