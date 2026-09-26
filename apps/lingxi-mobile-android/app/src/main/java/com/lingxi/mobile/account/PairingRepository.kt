package com.lingxi.mobile.account

import android.content.Context
import com.lingxi.mobile.data.prefs.SessionStore
import com.lingxi.mobile.net.BridgeClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.util.concurrent.TimeUnit

/**
 * 账户绑定：工作台一次性配对码 → 设备凭据（R3 §1.2 / master plan §3）。
 * 不假设公共注册中心；服务器 URL 用户可配，不写死。
 */
class PairingRepository(
    private val context: Context,
    private val sessionStore: SessionStore,
    private val json: Json = Json { ignoreUnknownKeys = true },
) {

    @Serializable
    data class PairRequest(val pairCode: String, val deviceLabel: String, val platform: String = "android")

    @Serializable
    data class PairResponse(
        val deviceToken: String,
        val deviceId: String,
        val accountId: String,
        val workspaceId: String,
        val expiresAt: String? = null,
    )

    sealed class PairResult {
        data class Success(val session: SessionStore.ActiveSession) : PairResult()
        data class Rejected(val code: String, val message: String) : PairResult()
        data class Unreachable(val cause: String) : PairResult()
    }

    suspend fun pair(serverBaseUrl: String, pairCode: String, deviceLabel: String): PairResult =
        withContext(Dispatchers.IO) {
            val client = OkHttpClient.Builder()
                .connectTimeout(5, TimeUnit.SECONDS)
                .readTimeout(15, TimeUnit.SECONDS)
                .build()
            val body = json.encodeToString(
                PairRequest.serializer(),
                PairRequest(pairCode = pairCode.trim(), deviceLabel = deviceLabel),
            ).toRequestBody("application/json".toMediaType())
            val req = Request.Builder()
                .url(serverBaseUrl.trimEnd('/') + "/api/mobile-capture/v2/session/pair")
                .post(body)
                .build()
            try {
                client.newCall(req).execute().use { resp ->
                    val text = resp.body?.string().orEmpty()
                    when {
                        resp.isSuccessful -> {
                            val r = json.decodeFromString(PairResponse.serializer(), text)
                            val session = SessionStore.ActiveSession(
                                accountId = r.accountId,
                                workspaceId = r.workspaceId,
                                deviceId = r.deviceId,
                                serverBaseUrl = serverBaseUrl.trimEnd('/'),
                                deviceToken = r.deviceToken,
                                lastSyncAt = null,
                            )
                            sessionStore.bind(session)
                            PairResult.Success(session)
                        }

                        resp.code == 403 -> PairResult.Rejected("PAIR_CODE_INVALID", "配对码无效或已使用")
                        resp.code == 410 -> PairResult.Rejected("PAIR_CODE_EXPIRED", "配对码已过期，请在工作台重新生成")
                        else -> PairResult.Rejected("HTTP_" + resp.code, text.take(200))
                    }
                }
            } catch (e: IOException) {
                PairResult.Unreachable(e.message ?: "无法连接工作台")
            }
        }

    fun unbind() = sessionStore.unbind()
}
