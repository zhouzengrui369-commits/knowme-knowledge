package com.lingxi.mobile.agent

import android.content.Context
import androidx.core.content.edit

/**
 * 手机端模型 API 配置（R3 §10：密钥用户在设备配置、受保护保存；
 * 不写入 APK/Git/日志/知识同步；电脑密钥不自动下发手机）。
 */
class ModelConfigStore(context: Context) {

    private val prefs = context.getSharedPreferences("lingxi_model_cfg", Context.MODE_PRIVATE)

    data class ActiveModel(
        val provider: String,
        val baseUrl: String,
        val model: String,
        val apiKey: String,
    )

    fun save(provider: String, baseUrl: String, model: String, apiKey: String) = prefs.edit {
        putString("provider", provider)
        putString("base_url", baseUrl)
        putString("model", model)
        putString("api_key", apiKey)
    }

    fun active(): ActiveModel? {
        val base = prefs.getString("base_url", null) ?: return null
        val model = prefs.getString("model", null) ?: return null
        val key = prefs.getString("api_key", null) ?: return null
        return ActiveModel(prefs.getString("provider", "openai-compatible") ?: "openai-compatible", base, model, key)
    }

    fun clear() = prefs.edit { clear() }

    /** 供 UI 显示的数据去向说明（合同：说明哪些上下文会离开本地）。 */
    fun disclosure(): String =
        "手机 Agent 调用模型 API 时，你的问题和其引用的本机知识片段会发送到你配置的服务商；" +
            "原始录音和完整知识库不会自动外发。"
}
