package com.lingxi.mobile.ui.state

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * 分项实测状态仓（R3 §8 / 防 PX-01）。
 * 六条状态各自独立、全部由当次实测写入；禁止"记忆中的已连接"。
 * UI 只读这里；任何一处刷新都必须带 measuredAt，历史值永不冒充当前。
 */
class ConnectionStateStore(context: Context) {

    private val cm = context.getSystemService(ConnectivityManager::class.java)

    enum class Tri { OK, OFF, UNKNOWN }

    data class State(
        val localSaved: Tri = Tri.UNKNOWN,      // 本机持久层可用
        val networkUp: Tri = Tri.UNKNOWN,       // 系统层网络
        val identityValid: Tri = Tri.UNKNOWN,   // 设备凭据在线校验
        val serverReachable: Tri = Tri.UNKNOWN, // 工作台可达
        val modelReady: Tri = Tri.UNKNOWN,      // 本机 ASR 资源 / 模型 API
        val toolsReady: Tri = Tri.UNKNOWN,      // 远端工具目录
        val measuredAt: Long = 0L,
    )

    private val _state = MutableStateFlow(State())
    val state: StateFlow<State> = _state.asStateFlow()

    /** 每次实测整体覆盖写入，附时间戳；UI 展示"最后实测于 HH:mm:ss"。 */
    fun report(
        localSaved: Tri? = null,
        networkUp: Tri? = null,
        identityValid: Tri? = null,
        serverReachable: Tri? = null,
        modelReady: Tri? = null,
        toolsReady: Tri? = null,
    ) {
        val cur = _state.value
        _state.value = State(
            localSaved = localSaved ?: cur.localSaved,
            networkUp = networkUp ?: cur.networkUp,
            identityValid = identityValid ?: cur.identityValid,
            serverReachable = serverReachable ?: cur.serverReachable,
            modelReady = modelReady ?: cur.modelReady,
            toolsReady = toolsReady ?: cur.toolsReady,
            measuredAt = System.currentTimeMillis(),
        )
    }

    /** 系统层网络实测（飞行模式冷开时必须是 OFF，不许沿用旧值）。 */
    fun probeNetwork(): Tri {
        val caps = cm.activeNetwork?.let { cm.getNetworkCapabilities(it) }
        val ok = caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
        val tri = if (ok) Tri.OK else Tri.OFF
        report(networkUp = tri)
        return tri
    }
}
