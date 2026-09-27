package com.lingxi.mobile.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.lingxi.mobile.LingxiApp
import com.lingxi.mobile.ui.state.ConnectionStateStore
import kotlinx.coroutines.flow.MutableStateFlow

/**
 * 「知识」：在线搜全量（服务端限权）；离线只搜已下载副本，无命中不伪称全库无资料（J14）。
 * 默认渲染正文；缓存时间与基准 revision 可见；YAML/内部路径不进主阅读层。
 */
@Composable
fun KnowledgeScreen() {
    val app = LocalContext.current.applicationContext as LingxiApp
    val session by app.sessionStore.sessionFlow.collectAsState()
    val conn by app.connectionState.state.collectAsState()
    var query by remember { mutableStateOf("") }

    val notesFlow = remember(session?.accountId) {
        session?.accountId?.let { app.database.downloadedNotes().observeByAccount(it) }
            ?: MutableStateFlow(emptyList())
    }
    val notes by notesFlow.collectAsState(initial = emptyList())

    val online = conn.networkUp == ConnectionStateStore.Tri.OK &&
        conn.serverReachable == ConnectionStateStore.Tri.OK &&
        conn.identityValid == ConnectionStateStore.Tri.OK

    Column(Modifier.fillMaxSize().padding(16.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text("知识", style = MaterialTheme.typography.titleLarge)
        Text(
            if (online) "在线：检索范围为已获得授权的工作区" else "离线：仅检索本机已下载内容（最后同步时间见「我的」）",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.secondary,
        )
        OutlinedTextField(
            value = query,
            onValueChange = { query = it },
            modifier = Modifier.fillMaxWidth(),
            label = { Text(if (online) "搜索工作区" else "搜索已下载内容") },
            singleLine = true,
        )

        val shown = notes.filter {
            query.isBlank() || it.renderedMarkdown.contains(query, ignoreCase = true)
        }
        if (shown.isEmpty()) {
            Text(
                if (query.isBlank()) "还没有下载的知识副本。在线时打开一条知识即可离线下载。"
                else "已下载副本中没有命中「$query」——不代表整个知识库没有。",
                color = MaterialTheme.colorScheme.secondary,
            )
        }
        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            items(shown, key = { it.noteId }) { note ->
                Surface(shape = MaterialTheme.shapes.medium, tonalElevation = 1.dp) {
                    Column(Modifier.fillMaxWidth().padding(12.dp)) {
                        Text(
                            note.renderedMarkdown.take(80).lines().firstOrNull()?.removePrefix("# ")
                                ?: note.noteId,
                            style = MaterialTheme.typography.bodyLarge,
                        )
                        Text(
                            "基准 r${note.baseRevision} · 缓存于 ${note.cachedAt}",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.secondary,
                        )
                    }
                }
            }
        }
    }
}
