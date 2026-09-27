package com.lingxi.mobile.data.db

import androidx.room.Entity
import androidx.room.Index
import androidx.room.PrimaryKey

/**
 * 四域分离（R2 §3-C / R3 §5 冻结）：
 *  - captures: 原始捕获层。原始音频/原文一经捕获不可被转写/整理覆盖。
 *  - revisions: 分层修订（initial_transcript / user_edit / server_supplement / organized）。
 *  - outbox: 已授权待同步队列，网络就绪自动推进；草稿（DRAFT）绝不进入 outbox 自动通道。
 *  - downloaded_notes: 可重取的下载副本（可受控清理），与未同步内容物理隔离。
 * 行级 account_id 保证 A/B 账户同机不串。
 */

@Entity(
    tableName = "captures",
    indices = [Index("accountId", "capturedAt"), Index(value = ["captureId"], unique = true)],
)
data class CaptureEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val captureId: String,            // client-uuid，幂等键之一
    val accountId: String,
    val workspaceId: String,
    val deviceId: String,
    val schemaVersion: Int = 2,
    val payloadRevision: Int,         // 幂等键之二
    val kind: String,                 // text | voice | attachment
    val capturedAt: String,           // 本地捕获时间（ISO，含原时区）
    val timezone: String,
    val originalAssetPath: String?,   // 原始音频/附件——永不覆盖
    val assetSha256: String?,
    val assetSize: Long?,
    val title: String?,
    // 生命周期：DRAFT → (用户显式提交) QUEUED → RECEIVED → PROCESSING → ORGANIZED / FAILED
    val status: String,
    val noteId: String?,              // 服务端回写
    val noteRevision: Int?,
    val error: String?,
    val qualityWarning: String?,      // 低质输入提示（PX-04）：非空则 UI 不得渲染普通完成
)

@Entity(
    tableName = "revisions",
    indices = [Index(value = ["captureId", "layer"], unique = true)],
)
data class RevisionEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val captureId: String,
    val layer: String,                // initial_transcript | user_edit | server_supplement | organized_result
    val body: String,
    val author: String,               // device | user | server
    val createdAt: String,
    val baseRevision: Int?,
)

@Entity(
    tableName = "outbox",
    indices = [Index("accountId", "state"), Index(value = ["outboxId"], unique = true)],
)
data class OutboxEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val outboxId: String,
    val accountId: String,
    val captureId: String?,
    val opType: String,               // capture_submit | asset_upload | note_submit | cancel_task
    val payloadJson: String,
    // QUEUED → IN_FLIGHT → ACKED（ACK 丢失回 QUEUED；服务端幂等防双效果）
    val state: String,
    val attempts: Int,
    val lastError: String?,
    val createdAt: String,
    val updatedAt: String,
)

@Entity(
    tableName = "downloaded_notes",
    indices = [Index(value = ["accountId", "noteId"], unique = true)],
)
data class DownloadedNoteEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val accountId: String,
    val workspaceId: String,
    val noteId: String,
    val baseRevision: Int,
    val renderedMarkdown: String,
    val sourceRef: String?,
    val cachedAt: String,             // 展示"缓存时间"（合同 J14）
    val dirtyLocalEdits: Boolean,     // 有未同步本地修订时禁止被清缓存吞掉
)
