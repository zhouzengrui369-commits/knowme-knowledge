package com.lingxi.mobile

import android.content.Context
import androidx.room.Room
import androidx.test.core.app.ApplicationProvider
import com.lingxi.mobile.data.db.LingxiDatabase
import com.lingxi.mobile.data.db.OutboxEntity
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * outbox 幂等与恢复（J06 防线）：
 * 同幂等键重复入队被拒；IN_FLIGHT 恢复回 QUEUED；
 * A/B 账户队列互不可见。
 */
@RunWith(RobolectricTestRunner::class)
class OutboxIdempotencyTest {

    private lateinit var db: LingxiDatabase

    @Before
    fun setup() {
        val ctx = ApplicationProvider.getApplicationContext<Context>()
        db = Room.inMemoryDatabaseBuilder(ctx, LingxiDatabase::class.java).build()
    }

    @After
    fun teardown() = db.close()

    private fun item(id: String, account: String) = OutboxEntity(
        outboxId = id,
        accountId = account,
        captureId = id,
        opType = "capture_submit",
        payloadJson = "{}",
        state = "QUEUED",
        attempts = 0,
        lastError = null,
        createdAt = "2026-09-26T10:00:00+08:00",
        updatedAt = "2026-09-26T10:00:00+08:00",
    )

    @Test
    fun `same idempotency key rejected on second enqueue`() = runTest {
        db.outbox().enqueue(item("ob-c1-1", "accA"))
        val dup = runCatching { db.outbox().enqueue(item("ob-c1-1", "accA")) }
        assertTrue("duplicate outbox id must be rejected", dup.isFailure)
    }

    @Test
    fun `inflight recovers back to queued`() = runTest {
        db.outbox().enqueue(item("ob-c2-1", "accA"))
        db.outbox().transition("ob-c2-1", "IN_FLIGHT", null, "2026-09-26T10:01:00+08:00")
        db.outbox().recoverInflight("2026-09-26T10:02:00+08:00")
        val queued = db.outbox().nextQueued("accA")
        assertEquals(1, queued.size)
        assertEquals("ob-c2-1", queued[0].outboxId)
        assertEquals("QUEUED", queued[0].state)
    }

    @Test
    fun `account A queue invisible to account B`() = runTest {
        db.outbox().enqueue(item("ob-c3-1", "accA"))
        db.outbox().enqueue(item("ob-c4-1", "accB"))
        assertEquals(1, db.outbox().nextQueued("accA").size)
        assertEquals(1, db.outbox().nextQueued("accB").size)
        assertEquals("ob-c3-1", db.outbox().nextQueued("accA")[0].outboxId)
        assertEquals("ob-c4-1", db.outbox().nextQueued("accB")[0].outboxId)
    }
}
