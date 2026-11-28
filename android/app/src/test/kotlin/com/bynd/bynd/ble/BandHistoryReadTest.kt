package com.bynd.bynd.ble

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class BandHistoryReadTest {
    @Test
    fun onlyRequestedStreamsWithEndMarkersComplete() {
        val read = BandHistoryRead(setOf("dynamicHeartRate", "temperature"))

        assertFalse(read.receivePage("hrv", ended = true))
        assertFalse(read.receivePage("temperature", ended = true))
        assertEquals(setOf("temperature"), read.completedStreams)
        assertFalse(read.complete)

        assertFalse(read.receivePage("dynamicHeartRate", ended = false))
        assertFalse(read.complete)

        assertFalse(read.receivePage("dynamicHeartRate", ended = true))
        assertTrue(read.complete)
        assertEquals(setOf("dynamicHeartRate", "temperature"), read.completedStreams)
    }

    @Test
    fun continuesAtTheVendorPageBoundaryUntilTheEndMarker() {
        val read = BandHistoryRead(setOf("sleep"))
        repeat(49) { assertFalse(read.receivePage("sleep", ended = false)) }
        assertTrue(read.receivePage("sleep", ended = false))
        assertFalse(read.complete)
        repeat(49) { assertFalse(read.receivePage("sleep", ended = false)) }
        assertFalse(read.receivePage("sleep", ended = true))
        assertTrue(read.complete)
    }
}
