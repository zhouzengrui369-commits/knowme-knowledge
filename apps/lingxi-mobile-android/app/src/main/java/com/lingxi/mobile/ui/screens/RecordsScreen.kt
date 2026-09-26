package com.lingxi.mobile.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.lingxi.mobile.LingxiApp
import com.lingxi.mobile.capture.CaptureService
import kotlinx.coroutines.flow.MutableStateFlow

/**
 * 「记录」：真实采集列表 + 录音控制。
 * PX-02 防线：列表 key 用稳定 captureId，点击事件带 id 不带坐标。
 * PX-04：qualityWarning 非空的条目显式显示质量风险，不渲染普通完成。
 */
@Composable
fun RecordsScreen() {
    val app = LocalContext.current.applicationContext as LingxiApp
    val session = app.sessionStore.active()
    val captureState by CaptureService.state.collectAsState()

    Column(Modifier.fillMaxSize().padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("记录", style = MaterialTheme.typography.titleLarge)

        // 录音控制条：开始/暂停/继续/停止（R2 §2.2）
        Surface(color = MaterialTheme.colorScheme.surfaceVariant, shape = MaterialTheme.shapes.medium) {
            Row(
                Modifier.fillMaxWidth().padding(10.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                when (captureState.phase) {
                    CaptureService.Phase.RECORDING -> {
                        Button(onClick = { CaptureService.stop(app) }, modifier = Modifier.weight(1f)) {
                            Text("停止")
                        }
                        Text(
                            "录音中 ${captureState.durationMs / 1000}s",
                            modifier = Modifier.align(androidx.compose.ui.Alignment.CenterVertically),
                        )
                    }

                    else -> {
                        Button(
                            onClick = {
                                val ctx = app
                                val out = java.io.File(
                                    ctx.filesDir,
                                    "captures/" + System.currentTimeMillis() + ".wav",
                                )
                                CaptureService.start(ctx, out.absolutePath)
                            },
                            modifier = Modifier.weight(1f),
                        ) {
                            Text("开始录音")
                        }
                        Text(
                            when (captureState.phase) {
                                CaptureService.Phase.PRESERVED -> "已保存"
                                CaptureService.Phase.INTERRUPTED -> "被系统中断，片段已保全"
                                CaptureService.Phase.FAILED -> "失败：" + (captureState.error ?: "")
                                else -> "就绪"
                            },
                            modifier = Modifier.align(androidx.compose.ui.Alignment.CenterVertically),
                            style = MaterialTheme.typography.labelSmall,
                        )
                    }
                }
            }
        }

        // 真实采集列表（当前账户）
        if (session == null) {
            Text("未绑定账户：本地可离线保存，绑定后自动同步。", color = MaterialTheme.colorScheme.secondary)
        }
        CaptureList(app.sessionStore.active()?.accountId)
    }
}

@Composable
private fun CaptureList(accountId: String?) {
    val app = LocalContext.current.applicationContext as LingxiApp
    val itemsFlow = androidx.compose.runtime.remember(accountId) {
        accountId?.let { app.database.captures().observeByAccount(it) } ?: MutableStateFlow(emptyList())
    }
    val items by itemsFlow.collectAsState(initial = emptyList())

    if (items.isEmpty()) {
        Text("还没有记录。点上方「开始录音」或在「灵犀」里写文字。", color = MaterialTheme.colorScheme.secondary)
        return
    }

    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        items(items, key = { it.captureId }) { item ->
            Surface(
                shape = MaterialTheme.shapes.medium,
                tonalElevation = 1.dp,
                modifier = Modifier.fillMaxWidth(),
            ) {
                Column(Modifier.padding(12.dp)) {
                    Row {
                        Text(
                            item.title ?: item.captureId,
                            style = MaterialTheme.typography.bodyLarge,
                            modifier = Modifier.weight(1f),
                        )
                        Text(
                            statusLabel(item.status, item.qualityWarning),
                            style = MaterialTheme.typography.labelSmall,
                            color = if (item.qualityWarning != null) {
                                MaterialTheme.colorScheme.error
                            } else {
                                MaterialTheme.colorScheme.secondary
                            },
                        )
                    }
                    Text(
                        item.capturedAt,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.secondary,
                    )
                    if (item.qualityWarning != null) {
                        Text(
                            "质量风险：" + item.qualityWarning + "（可重录或继续保留）",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.error,
                        )
                    }
                }
            }
        }
    }
}

private fun statusLabel(status: String, qualityWarning: String?): String = when {
    qualityWarning != null -> "质量风险"
    else -> when (status) {
        "DRAFT" -> "草稿（未提交）"
        "QUEUED" -> "待同步"
        "RECEIVED" -> "工作台已接收"
        "PROCESSING" -> "整理中"
        "ORGANIZED" -> "已完成"
        "FAILED" -> "失败"
        else -> status
    }
}
