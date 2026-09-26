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
import androidx.compose.runtime.setValue
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.lingxi.mobile.LingxiApp
import com.lingxi.mobile.capture.CaptureService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch

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
        TextCaptureSection(app)
        CaptureList(app.sessionStore.active()?.accountId)
    }
}

/**
 * 文字采集（R3 真机联调接线）：保存草稿 → 本机 DRAFT，绝不自动上传；
 * 「交给灵犀」为显式授权 → QUEUED 进 outbox，网络/服务就绪后推进。
 */
@Composable
private fun TextCaptureSection(app: com.lingxi.mobile.LingxiApp) {
    var draft by rememberSaveable { androidx.compose.runtime.mutableStateOf("") }
    var feedback by rememberSaveable { androidx.compose.runtime.mutableStateOf("") }
    val scope = androidx.compose.runtime.rememberCoroutineScope()

    Surface(color = MaterialTheme.colorScheme.surfaceVariant, shape = MaterialTheme.shapes.medium) {
        Column(Modifier.fillMaxWidth().padding(10.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
            androidx.compose.material3.OutlinedTextField(
                value = draft,
                onValueChange = { draft = it },
                label = { Text("文字记录") },
                modifier = Modifier.fillMaxWidth(),
                minLines = 2,
            )
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedButton(
                    onClick = {
                        val text = draft.trim()
                        if (text.isEmpty()) {
                            feedback = "内容为空，未保存"
                        } else {
                            scope.launch {
                                runCatching { saveTextCapture(app, text, submit = false) }
                                    .onSuccess { feedback = "草稿已保存本机（不上传）"; draft = "" }
                                    .onFailure { feedback = "保存失败：" + it.message }
                            }
                        }
                    },
                    modifier = Modifier.weight(1f),
                ) { Text("保存草稿") }
                Button(
                    onClick = {
                        val text = draft.trim()
                        if (text.isEmpty()) {
                            feedback = "内容为空，未提交"
                        } else {
                            scope.launch {
                                runCatching { saveTextCapture(app, text, submit = true) }
                                    .onSuccess { feedback = "已交给灵犀（待同步）"; draft = "" }
                                    .onFailure { feedback = "提交失败：" + it.message }
                            }
                        }
                    },
                    modifier = Modifier.weight(1f),
                ) { Text("交给灵犀") }
            }
            if (feedback.isNotBlank()) {
                Text(feedback, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.secondary)
            }
        }
    }
}

private suspend fun saveTextCapture(app: com.lingxi.mobile.LingxiApp, text: String, submit: Boolean) {
    val session = app.sessionStore.active()
    val now = java.time.OffsetDateTime.now()
    val captureId = "cap-" + java.util.UUID.randomUUID().toString().replace("-", "").take(20)
    val db = app.database
    db.captures().insert(
        com.lingxi.mobile.data.db.CaptureEntity(
            captureId = captureId,
            accountId = session?.accountId ?: "local",
            workspaceId = session?.workspaceId ?: "local",
            deviceId = session?.deviceId ?: "dev-local",
            payloadRevision = 1,
            kind = "text",
            capturedAt = now.toString(),
            timezone = java.time.ZoneId.systemDefault().id,
            originalAssetPath = null,
            assetSha256 = null,
            assetSize = text.toByteArray().size.toLong(),
            title = text.take(24),
            status = if (submit) "QUEUED" else "DRAFT",
            noteId = null,
            noteRevision = null,
            error = null,
            qualityWarning = null,
        ),
    )
    db.revisions().upsert(
        com.lingxi.mobile.data.db.RevisionEntity(
            captureId = captureId,
            layer = "initial_transcript",
            body = text,
            author = "device",
            createdAt = now.toString(),
            baseRevision = null,
        ),
    )
    if (submit && session != null) {
        app.syncEngine.enqueueCaptureSubmit(
            session,
            captureId,
            com.lingxi.mobile.net.BridgeClient.CaptureSubmit(
                captureId = captureId,
                payloadRevision = 1,
                deviceId = session.deviceId,
                kind = "text",
                capturedAt = now.toString(),
                timezone = java.time.ZoneId.systemDefault().id,
                contentHash = null,
                size = text.toByteArray().size.toLong(),
                text = text,
                intent = "organize",
            ),
        )
        app.syncEngine.tick()
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
