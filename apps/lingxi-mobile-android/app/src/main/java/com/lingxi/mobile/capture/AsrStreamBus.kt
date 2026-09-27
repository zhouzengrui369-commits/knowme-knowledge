package com.lingxi.mobile.capture

import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow

/** 录音 PCM 分片总线：CaptureService 生产，SherpaAsrSession 消费。 */
object AsrStreamBus {
    private val _chunks = MutableSharedFlow<ByteArray>(
        extraBufferCapacity = 64,
        onBufferOverflow = BufferOverflow.DROP_OLDEST,
    )
    val chunks: SharedFlow<ByteArray> = _chunks

    fun offer(chunk: ByteArray) {
        _chunks.tryEmit(chunk)
    }
}
