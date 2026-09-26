package com.lingxi.mobile.ui.screens

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
import com.lingxi.mobile.ui.state.StatusStrip

/**
 * 「灵犀」：Agent 协作 + 单手可达录入入口。
 * 未登录：通用壳 + 引导，不出现真实知识（合同 master plan §4）。
 */
@Composable
fun LingxiHomeScreen(onGoPair: () -> Unit = {}, onGoRecords: () -> Unit = {}) {
    val app = LocalContext.current.applicationContext as LingxiApp
    val state by app.connectionState.state.collectAsState()
    val session = app.sessionStore.active()

    Column(Modifier.fillMaxSize()) {
        StatusStrip(state)

        if (session == null) {
            Column(
                Modifier.fillMaxSize().padding(24.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                Text("灵犀", style = MaterialTheme.typography.headlineMedium)
                Text(
                    "个人知识 Agent 工作台。绑定你的账户后开始录音、提问与同步。",
                    style = MaterialTheme.typography.bodyMedium,
                )
                Text(
                    "当前未绑定账户——仅为演示引导，不显示任何真实知识。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.secondary,
                )
                Button(onClick = onGoPair) {
                    Text("去绑定账户")
                }
            }
        } else {
            val messages = rememberConversation()

            LazyColumn(
                Modifier.weight(1f).fillMaxWidth().padding(horizontal = 16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                items(messages, key = { it.id }) { msg ->
                    Surface(
                        color = if (msg.fromUser) {
                            MaterialTheme.colorScheme.surfaceVariant
                        } else {
                            MaterialTheme.colorScheme.surface
                        },
                        shape = MaterialTheme.shapes.medium,
                    ) {
                        Column(Modifier.padding(12.dp)) {
                            Text(msg.text, style = MaterialTheme.typography.bodyMedium)
                            Text(
                                msg.meta,
                                style = MaterialTheme.typography.labelSmall,
                                color = MaterialTheme.colorScheme.secondary,
                            )
                        }
                    }
                }
            }

            Surface(tonalElevation = 2.dp) {
                Row(
                    Modifier.fillMaxWidth().padding(12.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                ) {
                    Button(onClick = onGoRecords, modifier = Modifier.weight(1f)) {
                        Text("语音")
                    }
                    OutlinedButton(onClick = onGoRecords, modifier = Modifier.weight(1f)) {
                        Text("文字")
                    }
                    OutlinedButton(onClick = onGoRecords, modifier = Modifier.weight(1f)) {
                        Text("附件")
                    }
                }
            }
        }
    }
}

private data class UiMessage(val id: String, val fromUser: Boolean, val text: String, val meta: String)

@Composable
private fun rememberConversation(): List<UiMessage> = listOf(
    UiMessage("welcome", false, "已连接你的工作区。问点什么，或从下方直接录入。", "灵犀 Agent · 本机上下文"),
)
