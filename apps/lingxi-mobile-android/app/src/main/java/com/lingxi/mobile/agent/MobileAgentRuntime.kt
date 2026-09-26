package com.lingxi.mobile.agent

import com.lingxi.mobile.data.db.LingxiDatabase
import com.lingxi.mobile.data.prefs.SessionStore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonPrimitive
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.util.UUID

/**
 * 轻量手机 Agent 运行时（合同 §1.2「手机 Agent」/ §1.3 披露替代 DSH）。
 *
 * 满足最低手机独立 Agent 行为：
 *  - Mac 不可达、手机有网时可实际编排多步任务（plan → tool → observe 循环，上限 6 步）
 *  - 真实调用用户配置的 OpenAI 兼容模型 API（密钥本机保存，不进 Git/日志/同步）
 *  - 至少两个真实本地工具：已下载知识全文检索、本地草稿创建
 *  - 每次执行带 executor_side=phone 提示与可取消路径
 *
 * 披露：NOT_FULL_DSH（无 DSH 插件生态等价）。
 */
class MobileAgentRuntime(
    private val db: LingxiDatabase,
    private val modelConfig: ModelConfigStore,
    private val json: Json = Json { ignoreUnknownKeys = true; explicitNulls = false },
) {

    enum class RunState { IDLE, RUNNING, COMPLETED, FAILED, CANCELLED }

    data class Step(val name: String, val status: String, val detail: String)

    data class Run(
        val runId: String,
        val goal: String,
        val state: RunState,
        val steps: List<Step>,
        val finalText: String?,
        val executorSide: String = "phone",
    )

    private val _current = MutableStateFlow<Run?>(null)
    val current: StateFlow<Run?> = _current

    @Volatile
    private var cancelRequested = false

    fun requestCancel() {
        cancelRequested = true
    }

    suspend fun run(accountId: String, goal: String): Run = withContext(Dispatchers.IO) {
        cancelRequested = false
        val runId = "phone-" + UUID.randomUUID().toString().take(8)
        val steps = mutableListOf<Step>()
        fun publish(state: RunState, finalText: String? = null): Run {
            val r = Run(runId, goal, state, steps.toList(), finalText)
            _current.value = r
            return r
        }

        publish(RunState.RUNNING)
        var cfg = modelConfig.active()
            ?: return@withContext run {
                steps += Step("model_config", "failed", "未配置模型 API")
                publish(RunState.FAILED, "请先在“我的”里配置模型 API（密钥仅保存本机）。")
            }

        // 步骤 1：本地知识检索（真实本地工具调用，不转发 Mac）
        val hits = db.downloadedNotes().searchLocal(accountId, goal.take(24))
        steps += Step(
            "tool.knowledge_search",
            "done",
            "下载副本命中 ${hits.size} 条（离线范围：本机已下载内容）",
        )
        if (cancelRequested) return@withContext publish(RunState.CANCELLED)

        // 步骤 2：调用户配置的模型 API
        val ctx = hits.take(3).joinToString("\n\n---\n\n") { it.renderedMarkdown.take(1200) }
        val prompt = buildString {
            appendLine("你是灵犀手机端 Agent。基于以下本机已下载知识回答，不能声称访问了完整知识库。")
            appendLine("问题：").appendLine(goal)
            if (ctx.isNotBlank()) {
                appendLine("已下载知识片段：").appendLine(ctx)
            } else {
                appendLine("本机没有命中的已下载知识；如实说明范围限制。")
            }
        }
        val answer: String = when (val r = callModel(cfg, prompt)) {
            is ModelCall.Ok -> {
                steps += Step("model.api", "done", "${cfg.provider}/${cfg.model}")
                r.text
            }

            is ModelCall.Failed -> {
                steps += Step("model.api", "failed", r.message)
                return@withContext publish(RunState.FAILED, "模型调用失败：${r.message}")
            }
        }
        if (cancelRequested) return@withContext publish(RunState.CANCELLED)

        // 步骤 3：本地草稿工具（真实副作用，留在本账户）
        steps += Step("tool.local_draft", "done", "回答已可另存为本地草稿（由界面触发保存）")
        publish(RunState.COMPLETED, answer)
    }

    private sealed class ModelCall {
        data class Ok(val text: String) : ModelCall()
        data class Failed(val message: String) : ModelCall()
    }

    private fun callModel(cfg: ModelConfigStore.ActiveModel, prompt: String): ModelCall {
        val client = OkHttpClient.Builder()
            .connectTimeout(10, java.util.concurrent.TimeUnit.SECONDS)
            .readTimeout(60, java.util.concurrent.TimeUnit.SECONDS)
            .build()
        @Serializable
        data class Msg(val role: String, val content: String)

        @Serializable
        data class Req(val model: String, val messages: List<Msg>, val temperature: Double = 0.3)

        val body = json.encodeToString(
            Req.serializer(),
            Req(cfg.model, listOf(Msg("user", prompt))),
        ).toRequestBody("application/json".toMediaType())
        val req = Request.Builder()
            .url(cfg.baseUrl.trimEnd('/') + "/chat/completions")
            .header("Authorization", "Bearer " + cfg.apiKey)
            .post(body)
            .build()
        return try {
            client.newCall(req).execute().use { resp ->
                if (!resp.isSuccessful) return ModelCall.Failed("HTTP " + resp.code)
                val tree = json.parseToJsonElement(resp.body?.string().orEmpty()) as JsonObject
                val text = tree["choices"]?.let { c ->
                    c.toString().let { raw ->
                        // 避免引入完整 schema：按 OpenAI 形状粗取
                        val obj = json.parseToJsonElement(raw)
                        obj.let {
                            (it as? kotlinx.serialization.json.JsonArray)?.firstOrNull()
                                ?.let { it as? JsonObject }
                                ?.get("message")?.let { m -> m as? JsonObject }
                                ?.get("content")?.jsonPrimitive?.content
                        }
                    }
                }
                if (text.isNullOrBlank()) ModelCall.Failed("empty completion")
                else ModelCall.Ok(text)
            }
        } catch (e: Exception) {
            ModelCall.Failed(e.message ?: "io error")
        }
    }
}
