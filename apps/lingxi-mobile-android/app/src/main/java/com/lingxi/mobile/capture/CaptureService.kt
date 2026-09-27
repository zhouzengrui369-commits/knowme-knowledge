package com.lingxi.mobile.capture

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.lingxi.mobile.LingxiApp
import com.lingxi.mobile.MainActivity
import com.lingxi.mobile.R
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.RandomAccessFile

/**
 * 录音前台服务（FGS microphone）。
 * 合同 R2 §3-A：用户主动开始；后台/锁屏按系统机制保持；被系统终止时保全已完成片段并诚实报停。
 * 音频写 PCM 流 + 结束时补 WAV 头；分段落盘，任何异常都不丢已完成部分。
 */
class CaptureService : Service() {

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private var recordJob: Job? = null
    private var audioRecord: AudioRecord? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                val path = intent.getStringExtra(EXTRA_OUTPUT_PATH)
                if (path == null) {
                    markFailed("no_output_path")
                    return START_NOT_STICKY
                }
                startCapture(path)
            }

            ACTION_STOP -> stopCapture(completed = true)
        }
        return START_STICKY
    }

    private fun startCapture(outputPath: String) {
        if (_state.value.phase != Phase.IDLE) return
        val outFile = File(outputPath)
        outFile.parentFile?.mkdirs()

        val minBuf = AudioRecord.getMinBufferSize(SAMPLE_RATE, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT)
        val rec = try {
            AudioRecord(
                MediaRecorder.AudioSource.MIC,
                SAMPLE_RATE,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
                minBuf * 2,
            )
        } catch (e: SecurityException) {
            markFailed("mic_permission_denied")
            return
        }
        if (rec.state != AudioRecord.STATE_INITIALIZED) {
            rec.release()
            markFailed("mic_init_failed")
            return
        }

        audioRecord = rec
        val startedAt = System.currentTimeMillis()
        // 真机联调接线 #8：录音链直挂离线 ASR。模型未就绪也照常录音，如实标注仅录音。
        val asr = (application as LingxiApp).asrEngine
        val asrSession = runCatching {
            if (asr.provisionState() == com.lingxi.mobile.asr.AsrEngine.ProvisionState.READY) {
                asr.openSession()
            } else null
        }.getOrNull()
        _state.value = CaptureState(
            Phase.RECORDING, 0, outFile.absolutePath, null,
            asrLive = asrSession != null,
        )
        startFg(if (asrSession != null) "录音中（离线转写已就绪）" else "录音中（模型未就绪，仅保全音频）")

        recordJob = scope.launch {
            val buf = ByteArray(minBuf)
            var totalBytes = 0L
            var lastPartialPush = 0L
            val partFile = File(outFile.parentFile, outFile.name + ".part")
            try {
                rec.startRecording()
                RandomAccessFile(partFile, "rw").use { raf ->
                    raf.setLength(44) // WAV 头占位
                    while (_state.value.phase == Phase.RECORDING) {
                        if (_state.value.paused) continue
                        val n = rec.read(buf, 0, buf.size)
                        if (n > 0) {
                            raf.write(buf, 0, n)
                            totalBytes += n
                            val nowMs = System.currentTimeMillis()
                            // 直接喂引擎；bus 保留给未来的第二消费方
                            asrSession?.accept(buf.copyOf(n))
                            AsrStreamBus.offer(buf.copyOf(n))
                            _state.value = if (nowMs - lastPartialPush > 600) {
                                lastPartialPush = nowMs
                                _state.value.copy(
                                    durationMs = nowMs - startedAt,
                                    transcriptPartial = asrSession?.let {
                                        runCatching { it.current().text }.getOrDefault("")
                                    } ?: "",
                                )
                            } else {
                                _state.value.copy(durationMs = nowMs - startedAt)
                            }
                        }
                    }
                    finalizeWav(raf, totalBytes)
                }
                partFile.renameTo(outFile)
                val finalText = asrSession?.let { runCatching { it.finish().text }.getOrDefault("") } ?: ""
                persistVoiceDraft(
                    startedAt = startedAt,
                    wavPath = outFile.absolutePath,
                    transcript = finalText,
                    interrupted = false,
                )
                _state.value = _state.value.copy(
                    phase = Phase.PRESERVED,
                    bytes = totalBytes,
                    transcriptPartial = finalText,
                    transcriptFinal = finalText,
                )
                stopSelf()
            } catch (t: Throwable) {
                // 系统终止/中断：片段已分批落盘——诚实报停而非假装完成
                val partialFinal = asrSession?.let { s ->
                    runCatching { s.finish().text }.getOrDefault("")
                } ?: ""
                // 协程可能已被 cancel（如 onDestroy）：保全动作必须 NonCancellable，否则草稿静默丢失
                withContext(kotlinx.coroutines.NonCancellable) {
                    persistVoiceDraft(
                        startedAt = startedAt,
                        wavPath = partFile.takeIf { it.exists() && it.length() > 44 }?.absolutePath
                            ?: outFile.absolutePath,
                        transcript = partialFinal,
                        interrupted = true,
                    )
                }
                _state.value = _state.value.copy(
                    phase = Phase.INTERRUPTED,
                    bytes = totalBytes,
                    error = t.message,
                    transcriptPartial = partialFinal,
                    transcriptFinal = partialFinal,
                )
                stopForeground(STOP_FOREGROUND_DETACH)
                stopSelf()
            } finally {
                runCatching { asrSession?.close() }
            }
        }
    }

    private fun stopCapture(completed: Boolean) {
        // 真机修复 #9：只改 phase，不 cancel recordJob——
        // 取消会让 finalize/persist 里的挂起函数直接抛 CancellationException，草稿静默丢失。
        _state.value = _state.value.copy(phase = if (completed) Phase.STOPPING else Phase.INTERRUPTED)
    }

    /**
     * 语音草稿落盘（R3 真机联调接线 #8）：
     * 与文字采集同构——原件（WAV）与初始转写层分存；status=DRAFT，绝不自动上传；
     * 转写为空是合法状态（静音段/噪声），如实记 qualityWarning，不伪造文字。
     */
    private suspend fun persistVoiceDraft(
        startedAt: Long,
        wavPath: String,
        transcript: String,
        interrupted: Boolean,
    ) {
        val app = application as LingxiApp
        val session = app.sessionStore.active()
        val f = File(wavPath)
        if (!f.exists() || f.length() <= 44) {
            // 连头都没有的声音不是有效采集，不落假数据
            return
        }
        val nowIso = java.time.OffsetDateTime.now().toString()
        val startedIso = java.time.Instant.ofEpochMilli(startedAt)
            .atZone(java.time.ZoneId.systemDefault()).toOffsetDateTime().toString()
        val captureId = "cap-" + java.util.UUID.randomUUID().toString().replace("-", "").take(20)
        val sha = java.security.MessageDigest.getInstance("SHA-256")
            .digest(f.readBytes()).joinToString("") { "%02x".format(it) }
        app.database.captures().insert(
            com.lingxi.mobile.data.db.CaptureEntity(
                captureId = captureId,
                accountId = session?.accountId ?: "local",
                workspaceId = session?.workspaceId ?: "local",
                deviceId = session?.deviceId ?: "dev-local",
                payloadRevision = 1,
                kind = "voice",
                capturedAt = startedIso,
                timezone = java.time.ZoneId.systemDefault().id,
                originalAssetPath = wavPath,
                assetSha256 = sha,
                assetSize = f.length(),
                title = if (transcript.isNotBlank()) transcript.take(24) else "语音采集（无转写）",
                // 中断保全片段也是 DRAFT：是否交给灵犀仍由用户决定
                status = "DRAFT",
                noteId = null,
                noteRevision = null,
                error = if (interrupted) "recording_interrupted" else null,
                qualityWarning = if (transcript.isBlank()) "transcript_empty" else null,
            ),
        )
        app.database.revisions().upsert(
            com.lingxi.mobile.data.db.RevisionEntity(
                captureId = captureId,
                layer = "initial_transcript",
                body = transcript,
                author = "device-asr",
                createdAt = nowIso,
                baseRevision = null,
            ),
        )
    }

    private fun markFailed(error: String) {
        _state.value = CaptureState(Phase.FAILED, 0, null, error)
        stopSelf()
    }

    private fun startFg(text: String) {
        val pi = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE,
        )
        val n: Notification = NotificationCompat.Builder(this, LingxiApp.CHANNEL_CAPTURE)
            .setContentTitle("灵犀录音")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setContentIntent(pi)
            .setOngoing(true)
            .build()
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(NOTIF_ID, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE)
        } else {
            startForeground(NOTIF_ID, n)
        }
    }

    private fun finalizeWav(raf: RandomAccessFile, dataBytes: Long) {
        val total = dataBytes + 36
        val byteRate = SAMPLE_RATE * 2
        raf.seek(0)
        raf.write("RIFF".toByteArray()); raf.writeInt(Integer.reverseBytes(total.toInt()))
        raf.write("WAVE".toByteArray())
        raf.write("fmt ".toByteArray()); raf.writeInt(Integer.reverseBytes(16))
        raf.writeShort(java.lang.Short.reverseBytes(1).toInt())   // PCM
        raf.writeShort(java.lang.Short.reverseBytes(1).toInt())   // mono
        raf.writeInt(Integer.reverseBytes(SAMPLE_RATE))
        raf.writeInt(Integer.reverseBytes(byteRate))
        raf.writeShort(java.lang.Short.reverseBytes(2).toInt())   // block align
        raf.writeShort(java.lang.Short.reverseBytes(16).toInt())  // bits
        raf.write("data".toByteArray()); raf.writeInt(Integer.reverseBytes(dataBytes.toInt()))
    }

    override fun onDestroy() {
        if (_state.value.phase == Phase.RECORDING) {
            // 进程被杀路径：状态如实为 INTERRUPTED，音频片段保持 .part/完工文件
            _state.value = _state.value.copy(phase = Phase.INTERRUPTED, error = "service_destroyed")
        }
        scope.cancel()
        super.onDestroy()
    }

    enum class Phase { IDLE, RECORDING, STOPPING, PRESERVED, INTERRUPTED, FAILED }

    data class CaptureState(
        val phase: Phase = Phase.IDLE,
        val durationMs: Long = 0,
        val outputPath: String? = null,
        val error: String? = null,
        val paused: Boolean = false,
        val bytes: Long = 0,
        val asrLive: Boolean = false,
        val transcriptPartial: String = "",
        val transcriptFinal: String = "",
    )

    companion object {
        const val ACTION_START = "com.lingxi.mobile.capture.START"
        const val ACTION_STOP = "com.lingxi.mobile.capture.STOP"
        const val EXTRA_OUTPUT_PATH = "output_path"
        const val SAMPLE_RATE = 16000
        private const val NOTIF_ID = 41

        private val _state = MutableStateFlow(CaptureState())
        val state: StateFlow<CaptureState> = _state

        fun start(context: Context, outputPath: String) {
            val i = Intent(context, CaptureService::class.java)
                .setAction(ACTION_START)
                .putExtra(EXTRA_OUTPUT_PATH, outputPath)
            context.startForegroundService(i)
        }

        fun stop(context: Context) {
            val i = Intent(context, CaptureService::class.java).setAction(ACTION_STOP)
            context.startService(i)
        }
    }
}
