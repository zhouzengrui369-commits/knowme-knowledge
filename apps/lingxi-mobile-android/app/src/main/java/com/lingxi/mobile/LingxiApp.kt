package com.lingxi.mobile

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import com.lingxi.mobile.data.db.LingxiDatabase
import com.lingxi.mobile.data.prefs.SessionStore
import com.lingxi.mobile.ui.state.ConnectionStateStore

/**
 * 灵犀移动工作台 Application。
 * 账户维度目录隔离：files/accounts/<account_id>/ 为该账户全部本地数据根。
 */
class LingxiApp : Application() {

    lateinit var database: LingxiDatabase
        private set
    lateinit var sessionStore: SessionStore
        private set
    lateinit var connectionState: ConnectionStateStore
        private set

    val bridgeClient: com.lingxi.mobile.net.BridgeClient by lazy {
        com.lingxi.mobile.net.BridgeClient()
    }

    /** 离线 ASR 引擎：provision 与录音链共用同一实例（真机联调接线 #8）。 */
    val asrEngine: com.lingxi.mobile.asr.SherpaAsrEngine by lazy {
        com.lingxi.mobile.asr.SherpaAsrEngine(this)
    }

    /** Outbox 推进器（真机联调接线）：文字采集显式提交后由 UI 触发 tick()。 */
    val syncEngine: com.lingxi.mobile.sync.SyncEngine by lazy {
        com.lingxi.mobile.sync.SyncEngine(
            this, database, sessionStore, bridgeClient, connectionState,
        )
    }

    override fun onCreate() {
        super.onCreate()
        sessionStore = SessionStore(this)
        database = LingxiDatabase.build(this)
        connectionState = ConnectionStateStore(this)
        // 首启后台 provision 随包 ASR 模型；完成前 UI 如实显示 NOT_PROVISIONED
        asrEngine.provisionIfNeeded()

        val nm = getSystemService(NotificationManager::class.java)
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_CAPTURE,
                getString(R.string.channel_capture),
                NotificationManager.IMPORTANCE_LOW,
            ),
        )
        nm.createNotificationChannel(
            NotificationChannel(
                CHANNEL_SYNC,
                getString(R.string.channel_sync),
                NotificationManager.IMPORTANCE_MIN,
            ),
        )
    }

    companion object {
        const val CHANNEL_CAPTURE = "capture"
        const val CHANNEL_SYNC = "sync"
    }
}
