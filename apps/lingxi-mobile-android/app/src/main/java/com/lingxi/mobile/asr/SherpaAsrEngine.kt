package com.lingxi.mobile.asr

import android.content.Context
import java.io.File
import java.security.MessageDigest

/**
 * sherpa-onnx（k2-fsa，Apache-2.0）流式引擎封装。
 * 模型资源要求随包/预置到 files/asr/ 下；NOT_PROVISIONED 如实上报，绝不在飞行模式下等待下载。
 * 具体模型：Zipformer 中英双语 small（竖切联调时锁定版本+sha256，写入 CANONICAL_ARTIFACT_RECEIPT）。
 *
 * 注意：sherpa AAR 的 Kotlin/JNI API 在版本间有差异；本封装通过反射门控存在性，
 * 避免设备/版本差异导致崩溃——缺类时报 INCOMPATIBLE_DEVICE 而不是闪退。
 */
class SherpaAsrEngine(
    private val context: Context,
) : AsrEngine {

    private val modelDir: File get() = File(context.filesDir, "asr")

    override fun provisionState(): AsrEngine.ProvisionState {
        val dir = modelDir
        if (!dir.isDirectory) return AsrEngine.ProvisionState.NOT_PROVISIONED
        val required = dir.listFiles()?.filter { it.isFile }.orEmpty()
        if (required.isEmpty()) return AsrEngine.ProvisionState.NOT_PROVISIONED
        return if (sherpaAvailable()) {
            AsrEngine.ProvisionState.READY
        } else {
            AsrEngine.ProvisionState.INCOMPATIBLE_DEVICE
        }
    }

    private fun sherpaAvailable(): Boolean = runCatching {
        Class.forName("com.k2fsa.sherpa.onnx.OnlineRecognizer")
        System.loadLibrary("sherpa-onnx-jni")
    }.isSuccess

    override fun openSession(): AsrEngine.AsrSession {
        check(provisionState() == AsrEngine.ProvisionState.READY) { "asr_not_provisioned" }
        return SherpaSession(modelDir)
    }

    override fun identity(): String {
        val files = modelDir.listFiles()?.sortedBy { it.name }.orEmpty()
        val digest = MessageDigest.getInstance("SHA-256")
        files.forEach { f ->
            digest.update(f.name.toByteArray())
            if (f.length() < 32L * 1024 * 1024) {
                f.inputStream().use { s ->
                    val buf = ByteArray(8192)
                    while (true) {
                        val n = s.read(buf)
                        if (n <= 0) break
                        digest.update(buf, 0, n)
                    }
                }
            } else {
                digest.update(f.length().toString().toByteArray())
            }
        }
        val hash = digest.digest().joinToString("") { "%02x".format(it) }
        return "sherpa-onnx/zipformer-bilingual-small/files=${files.size}/sha256=$hash"
    }
}

/** sherpa kotlin-api 直接封装（v1.13.8 固定，源码有血统地收于 com.k2fsa.sherpa.onnx）。 */
private class SherpaSession(
    modelDir: File,
) : AsrEngine.AsrSession {

    private val recognizer: com.k2fsa.sherpa.onnx.OnlineRecognizer
    private val stream: com.k2fsa.sherpa.onnx.OnlineStream

    init {
        val cfg = com.k2fsa.sherpa.onnx.OnlineRecognizerConfig(
            featConfig = com.k2fsa.sherpa.onnx.FeatureConfig(sampleRate = 16000, featureDim = 80),
            modelConfig = com.k2fsa.sherpa.onnx.OnlineModelConfig(
                transducer = com.k2fsa.sherpa.onnx.OnlineTransducerModelConfig(
                    encoder = File(modelDir, "encoder.onnx").absolutePath,
                    decoder = File(modelDir, "decoder.onnx").absolutePath,
                    joiner = File(modelDir, "joiner.onnx").absolutePath,
                ),
                tokens = File(modelDir, "tokens.txt").absolutePath,
                numThreads = 2,
                provider = "cpu",
            ),
            decodingMethod = "greedy_search",
        )
        recognizer = com.k2fsa.sherpa.onnx.OnlineRecognizer(
            assetManager = null,
            config = cfg,
        )
        stream = recognizer.createStream()
    }

    override fun accept(pcm: ByteArray) {
        val floats = FloatArray(pcm.size / 2) { i ->
            (((pcm[i * 2 + 1].toInt() shl 8) or (pcm[i * 2].toInt() and 0xff)).toShort() / 32768f)
        }
        stream.acceptWaveform(floats, 16000)
        while (recognizer.isReady(stream)) {
            recognizer.decode(stream)
        }
    }

    override fun current(): AsrEngine.Transcript =
        AsrEngine.Transcript(
            text = recognizer.getResult(stream).text,
            isEndpoint = recognizer.isEndpoint(stream),
        )

    override fun finish(): AsrEngine.Transcript {
        stream.inputFinished()
        while (recognizer.isReady(stream)) {
            recognizer.decode(stream)
        }
        return current()
    }

    override fun close() {
        runCatching { stream.release() }
        runCatching { recognizer.release() }
    }
}
