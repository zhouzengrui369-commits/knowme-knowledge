package com.lingxi.mobile.ui.state

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * 分项状态条（合同 R3 §8：不许一个绿点冒充全部在线）。
 * 展示 本机/网络/身份/服务/模型/工具 六项 + 最后实测时间。
 */
@Composable
fun StatusStrip(state: ConnectionStateStore.State) {
    Surface(color = MaterialTheme.colorScheme.surfaceVariant) {
        Column(Modifier.fillMaxWidth().padding(horizontal = 12.dp, vertical = 6.dp)) {
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Chip("本机", state.localSaved)
                Chip("网络", state.networkUp)
                Chip("身份", state.identityValid)
                Chip("服务", state.serverReachable)
                Chip("模型", state.modelReady)
                Chip("工具", state.toolsReady)
            }
            if (state.measuredAt > 0) {
                Text(
                    "实测于 " + SimpleDateFormat("HH:mm:ss", Locale.CHINA).format(Date(state.measuredAt)),
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.secondary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
        }
    }
}

@Composable
private fun Chip(label: String, tri: ConnectionStateStore.Tri) {
    val (text, color) = when (tri) {
        ConnectionStateStore.Tri.OK -> label + "✓" to androidx.compose.ui.graphics.Color(0xFF1B7A38)
        ConnectionStateStore.Tri.OFF -> label + "✗" to androidx.compose.ui.graphics.Color(0xFFB3261E)
        ConnectionStateStore.Tri.UNKNOWN -> label + "?" to androidx.compose.ui.graphics.Color(0xFF7A7468)
    }
    Text(text, style = MaterialTheme.typography.labelSmall, color = color)
}
