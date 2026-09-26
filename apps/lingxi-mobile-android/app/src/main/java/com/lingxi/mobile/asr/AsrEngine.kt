package com.lingxi.mobile.asr

/**
 * 本机中文 ASR 引擎抽象。
 * 合同要求：飞行模式可用；资源必须已存在于设备；CER≤20% 按固定参照评估——
 * 引擎必须暴露 provision 状态，NOT_PROVISIONED 时 UI 明说不等下载。
 */
interface AsrEngine {

    enum class ProvisionState { READY, NOT_PROVISIONED, INCOMPATIBLE_DEVICE }

    data class Transcript(val text: String, val isEndpoint: Boolean)

    fun provisionState(): ProvisionState

    /** 开一条流式会话；喂 16kHz/mono/16bit PCM。不用时 close。 */
    fun openSession(): AsrSession

    interface AsrSession {
        fun accept(pcm: ByteArray)
        fun current(): Transcript
        fun finish(): Transcript
        fun close()
    }

    /** 引擎身份（J13/Manifest 证据用）：名字+模型标识+资源 hash。 */
    fun identity(): String
}
