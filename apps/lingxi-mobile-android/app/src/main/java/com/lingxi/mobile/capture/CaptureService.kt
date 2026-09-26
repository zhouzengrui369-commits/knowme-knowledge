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
        _state.value = CaptureState(Phase.RECORDING, 0, outFile.absolutePath, null)
        startFg("录音中")

        recordJob = scope.launch {
            val buf = ByteArray(minBuf)
            var totalBytes = 0L
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
                            _state.value = _state.value.copy(
                                durationMs = System.currentTimeMillis() - startedAt,
                            )
                            AsrStreamBus.offer(buf.copyOf(n))
                        }
                    }
                    finalizeWav(raf, totalBytes)
                }
                partFile.renameTo(outFile)
                _state.value = _state.value.copy(
                    phase = Phase.PRESERVED,
                    bytes = totalBytes,
                )
                stopSelf()
            } catch (t: Throwable) {
                // 系统终止/中断：片段已分批落盘——诚实报停而非假装完成
                _state.value = _state.value.copy(
                    phase = Phase.INTERRUPTED,
                    bytes = totalBytes,
                    error = t.message,
                )
                stopForeground(STOP_FOREGROUND_DETACH)
                stopSelf()
            }
        }
    }

    private fun stopCapture(completed: Boolean) {
        _state.value = _state.value.copy(phase = if (completed) Phase.STOPPING else Phase.INTERRUPTED)
        recordJob?.cancel()
        audioRecord?.apply {
            runCatching { stop() }
            release()
        }
        audioRecord = null
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
