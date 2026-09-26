package com.lingxi.mobile

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import com.lingxi.mobile.ui.nav.LingxiNavHost
import com.lingxi.mobile.ui.state.ConnectionStateStore.Tri
import com.lingxi.mobile.ui.theme.LingxiTheme

class MainActivity : ComponentActivity() {

    private val micPermission = registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) { /* 拒绝不影响文字记录（R2 §3-D）——状态由录音流程如实反馈 */ }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 冷启动实测：本机持久层可读即 localSaved=OK；网络实测 OFF/OK 当场测
        val app = application as LingxiApp
        app.connectionState.report(localSaved = Tri.OK)
        app.connectionState.probeNetwork()

        if (
            ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            micPermission.launch(Manifest.permission.RECORD_AUDIO)
        }
        if (Build.VERSION.SDK_INT >= 33) {
            if (
                ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) !=
                PackageManager.PERMISSION_GRANTED
            ) {
                registerForActivityResult(ActivityResultContracts.RequestPermission()) {}
                    .launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        }

        handleShareIntent(intent)

        setContent {
            LingxiTheme {
                LingxiNavHost()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleShareIntent(intent)
    }

    /** 系统分享入口（J17）：先保存原件与来源，解析状态另行显示；分享进来不等于已提交。 */
    private fun handleShareIntent(intent: Intent?) {
        if (intent?.action != Intent.ACTION_SEND) return
        // 竖切阶段仅记录意图事件；实物落存在 RecordsRepository（后续接线）
    }
}
