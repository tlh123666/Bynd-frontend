package com.bynd.bynd.ble

import org.junit.Assert.*
import org.junit.Test

class BandDeviceIdentityTest {
    @Test fun nestedVendorPayloadUsesScalarInsteadOfMapString() {
        val info = mapOf<String, Any?>(
            "macAddress" to mapOf("macAddress" to " AA:BB:CC:DD:EE:FF "),
            "firmwareVersion" to mapOf("deviceVersion" to "1.2.3"),
        )
        assertEquals("AA:BB:CC:DD:EE:FF", BandDeviceIdentity.serial(info))
        assertEquals("1.2.3", BandDeviceIdentity.firmware(info))
    }
    @Test fun formattingDifferencesMatchWithoutAcceptingAnotherBand() {
        assertTrue(BandDeviceIdentity.matches("AA:BB:CC:DD:EE:FF", "aa-bb-cc-dd-ee-ff"))
        assertFalse(BandDeviceIdentity.matches("AA:BB:CC:DD:EE:FF", "AA:BB:CC:DD:EE:00"))
        assertFalse(BandDeviceIdentity.matches("", ""))
    }
    @Test fun missingIdentityIsNeverReplacedByAdvertisedName() {
        assertNull(BandDeviceIdentity.serial(mapOf("name" to "BYND ONE", "firmwareVersion" to "2.4.1")))
        assertNull(BandDeviceIdentity.serial(mapOf("macAddress" to emptyMap<String, Any>())))
        assertNull(BandDeviceIdentity.serial(mapOf("macAddress" to "00:00:00:00:00:00")))
        assertNull(BandDeviceIdentity.serial(mapOf("macAddress" to "not-a-mac")))
    }
}
