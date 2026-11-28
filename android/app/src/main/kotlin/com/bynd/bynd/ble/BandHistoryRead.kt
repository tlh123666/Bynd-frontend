package com.bynd.bynd.ble

/** Tracks V8's end markers and continuation requests for a single sync. */
internal class BandHistoryRead(private val requestedStreams: Set<String>) {
    private val remaining = requestedStreams.associateWith { 0 }.toMutableMap()

    val completedStreams: Set<String>
        get() = requestedStreams - remaining.keys

    val complete: Boolean
        get() = remaining.isEmpty()

    fun receivePage(stream: String, ended: Boolean): Boolean {
        val previous = remaining[stream] ?: return false
        if (ended) {
            remaining.remove(stream)
            return false
        }
        val count = previous + 1
        remaining[stream] = count
        // This is the continuation boundary used by the V8 Android demo.
        return count % 50 == 0
    }
}
