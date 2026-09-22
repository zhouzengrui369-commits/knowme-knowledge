/**
 * GOAL-KK-04 PCM → WAV 封装（16 kHz / mono / s16le）。
 *
 * AudioCaptureController 产出裸 PCM；工作台 ASR 链路吃标准 WAV。
 * 同时负责把字节流可靠写入沙箱文件（采集箱资产）。
 */
import { fileIo as fs } from '@kit.CoreFileKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';

export class WavWriter {
  /** 构造 44 字节标准 WAV 头。 */
  static header(pcmBytes: number, sampleRate: number = 16000): Uint8Array {
    const byteRate = sampleRate * 2;           // mono * s16le
    const dataSize = pcmBytes;
    const riffSize = 36 + dataSize;
    const h = new Uint8Array(44);
    const dv = new DataView(h.buffer);
    const writeStr = (off: number, s: string): void => {
      for (let i = 0; i < s.length; i++) {
        h[off + i] = s.charCodeAt(i);
      }
    };
    writeStr(0, 'RIFF');
    dv.setUint32(4, riffSize, true);
    writeStr(8, 'WAVE');
    writeStr(12, 'fmt ');
    dv.setUint32(16, 16, true);                // PCM fmt chunk size
    dv.setUint16(20, 1, true);                 // PCM format
    dv.setUint16(22, 1, true);                 // mono
    dv.setUint32(24, sampleRate, true);
    dv.setUint32(28, byteRate, true);
    dv.setUint16(32, 2, true);                 // block align
    dv.setUint16(34, 16, true);                // bits per sample
    writeStr(36, 'data');
    dv.setUint32(40, dataSize, true);
    return h;
  }

  /** PCM → 完整 WAV 字节。 */
  static wrap(pcm: Uint8Array, sampleRate: number = 16000): Uint8Array {
    const header = WavWriter.header(pcm.length, sampleRate);
    const out = new Uint8Array(header.length + pcm.length);
    out.set(header, 0);
    out.set(pcm, header.length);
    return out;
  }

  /** 写入沙箱文件（先写 .part 再 rename + fsync，保证中断不半成品）。 */
  static writeFile(absPath: string, data: Uint8Array): void {
    const dir = absPath.slice(0, absPath.lastIndexOf('/'));
    if (!fs.accessSync(dir)) {
      fs.mkdirSync(dir, true);
    }
    const tmp = `${absPath}.part`;
    const fd = fs.openSync(tmp, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    fs.writeSync(fd.fd, data.buffer as ArrayBuffer);
    fs.fsyncSync(fd.fd);
    fs.closeSync(fd);
    fs.renameSync(tmp, absPath);
  }

  /** 计算字节 SHA-256（hex）。 */
  static sha256Hex(data: Uint8Array): string {
    const md = cryptoFramework.createMd('SHA256');
    md.updateSync({ data: data });
    const digest = md.digestSync();
    return digest.data.reduce((acc: string, b: number) =>
      acc + b.toString(16).padStart(2, '0'), '');
  }

  /** 文本 UTF-8 字节 SHA-256（hex）。 */
  static sha256Text(text: string): string {
    const bytes = new util.TextEncoder().encodeInto(text);
    return WavWriter.sha256Hex(bytes);
  }
}
