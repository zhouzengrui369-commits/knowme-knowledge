package com.lingxi.mobile.data.db

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface CaptureDao {

    @Insert(onConflict = OnConflictStrategy.ABORT)
    suspend fun insert(capture: CaptureEntity): Long

    @Update
    suspend fun update(capture: CaptureEntity)

    @Query("SELECT * FROM captures WHERE accountId = :accountId ORDER BY capturedAt DESC")
    fun observeByAccount(accountId: String): Flow<List<CaptureEntity>>

    @Query("SELECT * FROM captures WHERE captureId = :captureId LIMIT 1")
    suspend fun byCaptureId(captureId: String): CaptureEntity?

    @Query(
        "UPDATE captures SET status = :status, noteId = :noteId, noteRevision = :noteRevision," +
            " error = :error WHERE captureId = :captureId AND payloadRevision = :revision",
    )
    suspend fun markProgress(
        captureId: String,
        revision: Int,
        status: String,
        noteId: String?,
        noteRevision: Int?,
        error: String?,
    )

    @Query("SELECT * FROM captures WHERE accountId = :accountId AND status = 'DRAFT'")
    fun observeDrafts(accountId: String): Flow<List<CaptureEntity>>

    /** 同名同分钟不同 captureId 必须各行其是（J06 反向断言用）。 */
    @Query("SELECT COUNT(*) FROM captures WHERE captureId IN (:captureIds)")
    suspend fun countByIds(captureIds: List<String>): Int
}

@Dao
interface RevisionDao {

    /** 每层每 capture 只有一条；同层再写落入"显式用户修订优先"语义由仓储控制。 */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(revision: RevisionEntity): Long

    @Query("SELECT * FROM revisions WHERE captureId = :captureId ORDER BY id ASC")
    fun observeByCapture(captureId: String): Flow<List<RevisionEntity>>

    @Query("SELECT * FROM revisions WHERE captureId = :captureId AND layer = :layer LIMIT 1")
    suspend fun byLayer(captureId: String, layer: String): RevisionEntity?
}

@Dao
interface OutboxDao {

    @Insert(onConflict = OnConflictStrategy.ABORT)
    suspend fun enqueue(item: OutboxEntity): Long

    @Query(
        "SELECT * FROM outbox WHERE accountId = :accountId AND state = 'QUEUED'" +
            " ORDER BY createdAt ASC",
    )
    suspend fun nextQueued(accountId: String): List<OutboxEntity>

    @Query("UPDATE outbox SET state = :state, attempts = attempts + 1, lastError = :error, updatedAt = :now WHERE outboxId = :id")
    suspend fun transition(id: String, state: String, error: String?, now: String)

    /** ACK 丢失恢复：IN_FLIGHT 一律回 QUEUED，由服务端幂等键防止双效果。 */
    @Query("UPDATE outbox SET state = 'QUEUED', updatedAt = :now WHERE state = 'IN_FLIGHT'")
    suspend fun recoverInflight(now: String)

    @Query("SELECT COUNT(*) FROM outbox WHERE accountId = :accountId AND state != 'ACKED'")
    fun observePendingCount(accountId: String): Flow<Int>
}

@Dao
interface DownloadedNoteDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsert(note: DownloadedNoteEntity): Long

    @Query("SELECT * FROM downloaded_notes WHERE accountId = :accountId ORDER BY cachedAt DESC")
    fun observeByAccount(accountId: String): Flow<List<DownloadedNoteEntity>>

    /** 离线检索只搜已下载内容（J14）；无命中不得伪称全库无资料。 */
    @Query(
        "SELECT * FROM downloaded_notes WHERE accountId = :accountId AND" +
            " (renderedMarkdown LIKE '%' || :query || '%' OR noteId LIKE '%' || :query || '%')" +
            " ORDER BY cachedAt DESC",
    )
    suspend fun searchLocal(accountId: String, query: String): List<DownloadedNoteEntity>

    /** 清缓存只清可重取副本；dirtyLocalEdits=1 的不得删除（合同 J14/J22）。 */
    @Query("DELETE FROM downloaded_notes WHERE accountId = :accountId AND dirtyLocalEdits = 0")
    suspend fun purgeClean(accountId: String): Int

    @Query("SELECT * FROM downloaded_notes WHERE accountId = :accountId AND noteId = :noteId LIMIT 1")
    suspend fun byNoteId(accountId: String, noteId: String): DownloadedNoteEntity?
}
