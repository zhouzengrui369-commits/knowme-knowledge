package com.lingxi.mobile.data.prefs

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * 当前账户会话。设备凭据仅存本机私有 prefs（不入 Git、不进同步、不打印）。
 * account/workspace/device 三元组全部由服务端签发，客户端不自造。
 */
class SessionStore(context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences("lingxi_session", Context.MODE_PRIVATE)

    data class ActiveSession(
        val accountId: String,
        val workspaceId: String,
        val deviceId: String,
        val serverBaseUrl: String,
        val deviceToken: String,
        val lastSyncAt: String?,
    )

    /**
     * 响应式会话（真机联调修复 #7）：UI 必须 collect 这里，不能一次性 active()。
     * 否则 bind/unbind 后界面不重绘，看起来"点了没反应"。
     */
    private val _session = MutableStateFlow(readActive())
    val sessionFlow: StateFlow<ActiveSession?> = _session.asStateFlow()

    private fun refresh() { _session.value = readActive() }

    /** 未登录返回 null — UI 据此渲染通用壳 + 引导，不出现任何真实知识。 */
    fun active(): ActiveSession? = readActive()

    private fun readActive(): ActiveSession? {
        val accountId = prefs.getString(KEY_ACCOUNT, null) ?: return null
        val workspaceId = prefs.getString(KEY_WORKSPACE, null) ?: return null
        val deviceId = prefs.getString(KEY_DEVICE, null) ?: return null
        val base = prefs.getString(KEY_BASE, null) ?: return null
        val token = prefs.getString(KEY_TOKEN, null) ?: return null
        return ActiveSession(
            accountId = accountId,
            workspaceId = workspaceId,
            deviceId = deviceId,
            serverBaseUrl = base,
            deviceToken = token,
            lastSyncAt = prefs.getString(KEY_LAST_SYNC, null),
        )
    }

    fun bind(session: ActiveSession) {
        // refresh 必须在事务提交之后调用：edit{} 内读到的仍是旧值
        prefs.edit {
            putString(KEY_ACCOUNT, session.accountId)
            putString(KEY_WORKSPACE, session.workspaceId)
            putString(KEY_DEVICE, session.deviceId)
            putString(KEY_BASE, session.serverBaseUrl)
            putString(KEY_TOKEN, session.deviceToken)
            remove(KEY_LAST_SYNC)
        }
        refresh()
    }

    fun markSynced(isoTime: String) {
        prefs.edit { putString(KEY_LAST_SYNC, isoTime) }
        refresh()
    }

    /** 退出当前账户。未同步内容不清：由账户目录隔离 + outbox 表保证仍在原账户。 */
    fun unbind() {
        prefs.edit { clear() }
        refresh()
    }

    /** 切换账户：先结算当前会话（等价 unbind），再由调用方 bind 新账户。旧账户数据零继承。 */
    fun switchTo(newSession: ActiveSession) {
        unbind()
        bind(newSession)
    }

    fun isBound(): Boolean = active() != null

    private companion object {
        const val KEY_ACCOUNT = "account_id"
        const val KEY_WORKSPACE = "workspace_id"
        const val KEY_DEVICE = "device_id"
        const val KEY_BASE = "server_base_url"
        const val KEY_TOKEN = "device_token"
        const val KEY_LAST_SYNC = "last_sync_at"
    }
}
