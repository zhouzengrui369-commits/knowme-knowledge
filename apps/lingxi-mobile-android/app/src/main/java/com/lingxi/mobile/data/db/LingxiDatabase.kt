package com.lingxi.mobile.data.db

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [
        CaptureEntity::class,
        RevisionEntity::class,
        OutboxEntity::class,
        DownloadedNoteEntity::class,
    ],
    version = 1,
    exportSchema = true,
)
abstract class LingxiDatabase : RoomDatabase() {

    abstract fun captures(): CaptureDao
    abstract fun revisions(): RevisionDao
    abstract fun outbox(): OutboxDao
    abstract fun downloadedNotes(): DownloadedNoteDao

    companion object {
        fun build(context: Context, name: String = "lingxi.db"): LingxiDatabase =
            Room.databaseBuilder(context, LingxiDatabase::class.java, name)
                // 迁移策略：version 2 引入 account 强制列时提供显式 Migration，
                // 不允许 fallbackToDestructiveMigration 吞掉未同步内容。
                .build()
    }
}
