package com.lingxi.mobile

import android.content.Context
import androidx.room.Room
import androidx.test.core.app.ApplicationProvider
import com.lingxi.mobile.data.db.CaptureEntity
import com.lingxi.mobile.data.db.LingxiDatabase
import com.lingxi.mobile.data.db.RevisionEntity
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * 采集层行为（J06/J08/J18 防线）：
 * 同名同分钟不同 captureId 共存互不覆盖；修订分层保留；
 * 账户 A 的记录对 B 不可见。
 */
@RunWith(RobolectricTestRunner::class)
class CaptureIsolationTest {

    private lateinit var db: LingxiDatabase

    @Before
    fun setup() {
        val ctx = ApplicationProvider.getApplicationContext<Context>()
        db = Room.inMemoryDatabaseBuilder(ctx, LingxiDatabase::class.java).build()
    }

    @After
    fun teardown() = db.close()

    private fun cap(cid: String, account: String, title: String, minute: String) = CaptureEntity(
        captureId = cid,
        accountId = account,
        workspaceId = "ws-" + account,
        deviceId = "dev1",
        payloadRevision = 1,
        kind = "text",
        capturedAt = minute,
        timezone = "Asia/Shanghai",
        originalAssetPath = null,
        assetSha256 = null,
        assetSize = null,
        title = title,
        status = "DRAFT",
        noteId = null,
        noteRevision = null,
        error = null,
        qualityWarning = null,
    )

    @Test
    fun `same name same minute different ids coexist`() = runTest {
        db.captures().insert(cap("c-twin-1", "accA", "会议记录", "2026-09-26T14:00:00+08:00"))
        db.captures().insert(cap("c-twin-2", "accA", "会议记录", "2026-09-26T14:00:00+08:00"))
        assertEquals(2, db.captures().countByIds(listOf("c-twin-1", "c-twin-2")))
        assertNotNull(db.captures().byCaptureId("c-twin-1"))
        assertNotNull(db.captures().byCaptureId("c-twin-2"))
    }

    @Test
    fun `revision layers preserved independently`() = runTest {
        db.captures().insert(cap("c-layers", "accA", "九点", "2026-09-26T09:00:00+08:00"))
        db.revisions().upsert(
            RevisionEntity(
                captureId = "c-layers", layer = "initial_transcript",
                body = "会议原定九点", author = "device",
                createdAt = "2026-09-26T09:01:00+08:00", baseRevision = null,
            ),
        )
        db.revisions().upsert(
            RevisionEntity(
                captureId = "c-layers", layer = "user_edit",
                body = "会议改到十点", author = "user",
                createdAt = "2026-09-26T10:00:00+08:00", baseRevision = 1,
            ),
        )
        db.revisions().upsert(
            RevisionEntity(
                captureId = "c-layers", layer = "server_supplement",
                body = "补充：十一点开始", author = "server",
                createdAt = "2026-09-26T11:00:00+08:00", baseRevision = 2,
            ),
        )
        val layers = db.revisions().observeByCapture("c-layers").first()
        assertEquals(3, layers.size)
        assertEquals("会议原定九点", layers.first { it.layer == "initial_transcript" }.body)
        assertEquals("会议改到十点", layers.first { it.layer == "user_edit" }.body)
        assertEquals("补充：十一点开始", layers.first { it.layer == "server_supplement" }.body)
    }

    @Test
    fun `account A captures invisible to account B`() = runTest {
        db.captures().insert(cap("c-a-1", "accA", "A 的记录", "2026-09-26T12:00:00+08:00"))
        val bList = db.captures().observeByAccount("accB").first()
        assertEquals(0, bList.size)
        val aList = db.captures().observeByAccount("accA").first()
        assertEquals(1, aList.size)
    }
}
