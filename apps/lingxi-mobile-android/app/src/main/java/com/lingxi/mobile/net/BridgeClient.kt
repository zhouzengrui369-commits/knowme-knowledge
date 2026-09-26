package com.lingxi.mobile.net

import com.lingxi.mobile.data.prefs.SessionStore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.util.concurrent.TimeUnit

/**
 * mobile-capture v2 客户端草案实现。
 * account/workspace 一律由服务端凭据反查，客户端只携带 token（R3 §1.2 服务端校验）。
 */
class BridgeClient(
    private val json: Json = Json { ignoreUnknownKeys = true },
) {

    private val http = OkHttpClient.Builder()
        .connectTimeout(5, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .writeTimeout(60, TimeUnit.SECONDS)
        .build()

    sealed class Result<out T> {
        data class Ok<T>(val value: T) : Result<T>()
        data class Rejected(val code: String, val message: String) : Result<Nothing>()
        data class Unreachable(val cause: String) : Result<Nothing>()
    }

    @Serializable
    data class CaptureSubmit(
        val captureId: String,
        val schemaVersion: Int = 2,
        val payloadRevision: Int,
        val deviceId: String,
        val kind: String,
        val capturedAt: String,
        val timezone: String,
        val contentHash: String?,
        val size: Long?,
        val text: String?,
        val intent: String = "organize",
        val orphanRecovery: Boolean = false,
        val originTaskId: String? = null,
    )

    @Serializable
    data class CaptureSubmitResponse(
        val taskId: String,
        val durableReceivedAt: String,
    )

    @Serializable
    data class CaptureStatus(
        val captureId: String,
        val transferStatus: String,
        val processingStatus: String,
        val taskId: String?,
        val noteId: String?,
        val revision: Int?,
        val error: String?,
    )

    @Serializable
    data class TaskStatus(
        val taskId: String,
        val status: String,
        val executorSide: String, // phone | mac
        val resultRefs: List<String> = emptyList(),
        val cancelable: Boolean = false,
    )

    @Serializable
    data class OrphanResult(
        val taskId: String,
        val noteId: String,
        val revision: Int,
        val resultRefs: List<String> = emptyList(),
    )

    suspend fun submitCapture(session: SessionStore.ActiveSession, body: CaptureSubmit): Result<CaptureSubmitResponse> =
        post(session, "/api/mobile-capture/v2/captures", json.encodeToString(CaptureSubmit.serializer(), body))
            .map { json.decodeFromString(CaptureSubmitResponse.serializer(), it) }

    suspend fun captureStatus(session: SessionStore.ActiveSession, captureId: String): Result<CaptureStatus> =
        get(session, "/api/mobile-capture/v2/captures/$captureId")
            .map { json.decodeFromString(CaptureStatus.serializer(), it) }

    suspend fun taskStatus(session: SessionStore.ActiveSession, taskId: String): Result<TaskStatus> =
        get(session, "/api/mobile-capture/v2/tasks/$taskId")
            .map { json.decodeFromString(TaskStatus.serializer(), it) }

    /** 孤儿结果回绑：命中即复用原 task_id，不重启任务（合同 M3/PX-07）。 */
    suspend fun orphanLookup(session: SessionStore.ActiveSession, captureId: String): Result<OrphanResult?> =
        get(session, "/api/mobile-capture/v2/results/orphan?capture_id=$captureId")
            .mapNullable404 { json.decodeFromString(OrphanResult.serializer(), it) }

    suspend fun ping(session: SessionStore.ActiveSession): Result<String> =
        get(session, "/api/mobile-capture/v2/capabilities").map { it }

    // ---- transport ----

    private fun <T, R> Result<T>.map(f: (T) -> R): Result<R> = when (this) {
        is Result.Ok -> try {
            Result.Ok(f(value))
        } catch (e: Exception) {
            Result.Rejected("DECODE_ERROR", e.message ?: "decode failed")
        }

        is Result.Rejected -> this
        is Result.Unreachable -> this
    }

    private inline fun <R> Result<String>.mapNullable404(crossinline f: (String) -> R): Result<R?> = when (this) {
        is Result.Ok -> Result.Ok(f(this.value))
        is Result.Rejected -> if (code == "HTTP_404") Result.Ok(null) else this as Result<R?>
        is Result.Unreachable -> this as Result<R?>
    }

    private suspend fun get(session: SessionStore.ActiveSession, path: String): Result<String> =
        call(session, Request.Builder().url(session.serverBaseUrl + path).get().build())

    private suspend fun post(session: SessionStore.ActiveSession, path: String, bodyJson: String): Result<String> =
        call(
            session,
            Request.Builder()
                .url(session.serverBaseUrl + path)
                .post(bodyJson.toRequestBody("application/json".toMediaType()))
                .build(),
        )

    private suspend fun call(session: SessionStore.ActiveSession, req: Request): Result<String> =
        withContext(Dispatchers.IO) {
            val authed = req.newBuilder()
                .header("Authorization", "Bearer " + session.deviceToken)
                .build()
            try {
                http.newCall(authed).execute().use { resp ->
                    val text = resp.body?.string().orEmpty()
                    when {
                        resp.isSuccessful -> Result.Ok(text)
                        resp.code == 401 -> Result.Rejected("DEVICE_REVOKED", "凭据失效或被撤销")
                        resp.code == 403 -> Result.Rejected("WORKSPACE_FORBIDDEN", "工作区越权")
                        else -> {
                            val code = runCatching { Json.parseToJsonElement(text).jsonObject["code"]?.toString()?.trim('"') }
                                .getOrNull() ?: "HTTP_" + resp.code
                            Result.Rejected(code, text.take(300))
                        }
                    }
                }
            } catch (e: IOException) {
                Result.Unreachable(e.message ?: "network error")
            }
        }
}
