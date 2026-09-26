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

    override fun onCreate() {
        super.onCreate()
        sessionStore = SessionStore(this)
        database = LingxiDatabase.build(this)
        connectionState = ConnectionStateStore(this)

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
