package com.lingxi.mobile.sync

import android.content.Context
import com.lingxi.mobile.data.db.LingxiDatabase
import com.lingxi.mobile.data.db.OutboxEntity
import com.lingxi.mobile.data.prefs.SessionStore
import com.lingxi.mobile.net.BridgeClient
import com.lingxi.mobile.ui.state.ConnectionStateStore
import com.lingxi.mobile.ui.state.ConnectionStateStore.Tri
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import java.time.OffsetDateTime
import java.util.UUID

/**
 * Outbox 推进器。
 * 规则（合同 §9 / PX-05）：
 *  - 只推 QUEUED 且已显式授权的条目；DRAFT 永不自动上传。
 *  - durable_received ≠ organized；状态推进严格按服务端回执。
 *  - 恢复时先回绑已有结果（orphan），不产生第二效果。
 */
class SyncEngine(
    private val context: Context,
    private val db: LingxiDatabase,
    private val sessionStore: SessionStore,
    private val bridge: BridgeClient,
    private val stateStore: ConnectionStateStore,
    private val json: Json = Json { ignoreUnknownKeys = true },
) {

    suspend fun tick(): Int = withContext(Dispatchers.IO) {
        val session = sessionStore.active() ?: run {
            stateStore.report(identityValid = Tri.OFF)
            return@withContext 0
        }

        if (stateStore.probeNetwork() == Tri.OFF) {
            stateStore.report(serverReachable = Tri.OFF)
            return@withContext 0
        }

        when (bridge.ping(session)) {
            is BridgeClient.Result.Ok ->
                stateStore.report(serverReachable = Tri.OK, identityValid = Tri.OK, toolsReady = Tri.OK)

            is BridgeClient.Result.Rejected -> {
                stateStore.report(serverReachable = Tri.OK, identityValid = Tri.OFF)
                return@withContext 0
            }

            is BridgeClient.Result.Unreachable -> {
                stateStore.report(serverReachable = Tri.OFF)
                return@withContext 0
            }
        }

        db.outbox().recoverInflight(nowIso())
        val queued = db.outbox().nextQueued(session.accountId)
        var advanced = 0
        for (item in queued) {
            if (advance(session, item)) advanced++
        }
        if (advanced > 0) sessionStore.markSynced(nowIso())
        advanced
    }

    private suspend fun advance(session: SessionStore.ActiveSession, item: OutboxEntity): Boolean {
        val now = nowIso()
        db.outbox().transition(item.outboxId, "IN_FLIGHT", null, now)
        return when (item.opType) {
            OP_CAPTURE_SUBMIT -> {
                val body = json.decodeFromString(BridgeClient.CaptureSubmit.serializer(), item.payloadJson)
                when (val r = bridge.submitCapture(session, body)) {
                    is BridgeClient.Result.Ok -> {
                        db.outbox().transition(item.outboxId, "ACKED", null, nowIso())
                        // 服务接收 ≠ 完成：capture 状态推进到 RECEIVED，等待 task/organize 查询
                        item.captureId?.let { cid ->
                            db.captures().byCaptureId(cid)?.let { cap ->
                                db.captures().markProgress(
                                    cid, cap.payloadRevision, "RECEIVED", null, null, null,
                                )
                            }
                        }
                        true
                    }

                    is BridgeClient.Result.Rejected -> {
                        db.outbox().transition(item.outboxId, "QUEUED", r.code, nowIso())
                        false
                    }

                    is BridgeClient.Result.Unreachable -> {
                        db.outbox().transition(item.outboxId, "QUEUED", "unreachable", nowIso())
                        false
                    }
                }
            }

            else -> {
                // asset_upload / note_submit / cancel_task 在竖切后续实现；先看守不误推
                db.outbox().transition(item.outboxId, "QUEUED", "op_not_implemented", nowIso())
                false
            }
        }
    }

    fun enqueueCaptureSubmit(session: SessionStore.ActiveSession, captureId: String, body: BridgeClient.CaptureSubmit) {
        // 幂等键 capture_id+payload_revision：重复点击不产生第二条 outbox
        val outboxId = "ob-" + captureId + "-" + body.payloadRevision
        val now = nowIso()
        val entity = OutboxEntity(
            outboxId = outboxId,
            accountId = session.accountId,
            captureId = captureId,
            opType = OP_CAPTURE_SUBMIT,
            payloadJson = json.encodeToString(BridgeClient.CaptureSubmit.serializer(), body),
            state = "QUEUED",
            attempts = 0,
            lastError = null,
            createdAt = now,
            updatedAt = now,
        )
        kotlinx.coroutines.runBlocking {
            runCatching { db.outbox().enqueue(entity) }
                .onFailure { /* 已存在同幂等键条目即视为已排队 */ }
        }
    }

    fun newDeviceId(): String = "dev-" + UUID.randomUUID().toString().replace("-", "").take(12)

    private fun nowIso(): String = OffsetDateTime.now().toString()

    companion object {
        const val OP_CAPTURE_SUBMIT = "capture_submit"
        const val OP_ASSET_UPLOAD = "asset_upload"
        const val OP_NOTE_SUBMIT = "note_submit"
        const val OP_CANCEL_TASK = "cancel_task"
    }
}
