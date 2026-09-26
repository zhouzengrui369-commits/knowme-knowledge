package com.lingxi.mobile.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import com.lingxi.mobile.LingxiApp
import com.lingxi.mobile.account.PairingRepository
import kotlinx.coroutines.launch

/**
 * 「我的」：账户/工作区/服务器/设备/模型配置/数据去向/缓存同步/退出恢复。
 * 高级诊断收在这里，不占首屏（PX-06）。
 */
@Composable
fun ProfileScreen() {
    val app = LocalContext.current.applicationContext as LingxiApp
    val session = app.sessionStore.active()
    val scope = rememberCoroutineScope()

    Column(
        Modifier.fillMaxSize().padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        Text("我的", style = MaterialTheme.typography.titleLarge)

        if (session == null) {
            // 真机联调修复（GOAL-KK-04）：切 Tab 不丢表单（原 remember 会重置）
            var baseUrl by androidx.compose.runtime.saveable.rememberSaveable { mutableStateOf("http://192.168.1.10:8787") }
            var pairCode by androidx.compose.runtime.saveable.rememberSaveable { mutableStateOf("") }
            var status by androidx.compose.runtime.saveable.rememberSaveable { mutableStateOf("") }
            val pairing = remember { PairingRepository(app, app.sessionStore) }

            Text("绑定账户", style = MaterialTheme.typography.titleMedium)
            OutlinedTextField(
                value = baseUrl,
                onValueChange = { baseUrl = it },
                label = { Text("工作台地址") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true,
            )
            OutlinedTextField(
                value = pairCode,
                onValueChange = { pairCode = it },
                label = { Text("配对码（工作台生成，一次性）") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true,
                visualTransformation = PasswordVisualTransformation(),
            )
            Button(onClick = {
                status = "配对中…"
                scope.launch {
                    status = when (val r = pairing.pair(baseUrl, pairCode, android.os.Build.MODEL ?: "phone")) {
                        is PairingRepository.PairResult.Success ->
                            "已绑定工作区 " + r.session.workspaceId

                        is PairingRepository.PairResult.Rejected -> "被拒：" + r.message
                        is PairingRepository.PairResult.Unreachable -> "连不上工作台：" + r.cause
                    }
                }
            }) { Text("绑定") }
            if (status.isNotBlank()) Text(status, style = MaterialTheme.typography.bodySmall)
        } else {
            Text("账户：${session.accountId.take(8)}…", style = MaterialTheme.typography.bodyMedium)
            Text("工作区：${session.workspaceId.take(8)}…", style = MaterialTheme.typography.bodyMedium)
            Text("设备：${session.deviceId}", style = MaterialTheme.typography.bodyMedium)
            Text("服务器：${session.serverBaseUrl}", style = MaterialTheme.typography.bodyMedium)
            Text(
                "最后同步：${session.lastSyncAt ?: "从未"}",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.secondary,
            )
            OutlinedButton(onClick = { app.sessionStore.unbind() }) {
                Text("退出当前账户（未同步内容保留在本机）")
            }
        }

        Text("数据去向", style = MaterialTheme.typography.titleMedium)
        Text(
            "录音与草稿默认只保存在本机；只有你显式「交给灵犀」的内容才会同步到你的工作台。",
            style = MaterialTheme.typography.bodySmall,
        )
        Text(
            "手机 Agent 调用模型 API 时，你的问题与其引用的已下载知识片段会发到你配置的服务商；原始录音和完整知识库不会自动外发。",
            style = MaterialTheme.typography.bodySmall,
        )

        Text("高级诊断", style = MaterialTheme.typography.titleMedium)
        Text(
            "分项连接状态见「灵犀」顶部状态条；协议 v2；schema_version=2。",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.secondary,
        )
    }
}
