package com.bynd.bynd.ble

/** Scalar extraction kept compatible with JCVital/device_info_value.dart. */
internal object BandDeviceIdentity {
    fun find(node: Any?, keys: Set<String>): String? {
        when (node) {
            is Map<*, *> -> {
                for ((key, value) in node) {
                    val normalized = key.toString().filter { it.isLetter() }.lowercase()
                    if (normalized in keys) scalar(value)?.let { return it }
                }
                for (value in node.values) find(value, keys)?.let { return it }
            }
            is Iterable<*> -> for (value in node) find(value, keys)?.let { return it }
        }
        return null
    }

    private fun scalar(value: Any?): String? = when (value) {
        is String -> value.trim().takeIf { it.isNotEmpty() }
        is Number -> value.toString()
        is Map<*, *>, is Iterable<*> -> find(value, setOf("data", "value"))
        else -> null
    }

    fun serial(info: Map<String, Any?>): String? {
        find(info, setOf("serialnumber"))?.let { return it }
        val mac = find(info, setOf("macaddress", "devicemacaddress")) ?: return null
        val key = mac.filter { it.isLetterOrDigit() }.uppercase()
        return mac.takeIf { key.matches(Regex("[0-9A-F]{12}")) && key != "000000000000" && key != "FFFFFFFFFFFF" }
    }

    fun firmware(info: Map<String, Any?>): String? =
        find(info, setOf("firmwareversion", "deviceversion", "version"))

    fun matches(expected: String, actual: String): Boolean {
        fun normalized(value: String) = value.filter { it.isLetterOrDigit() }.uppercase()
        val key = normalized(expected)
        return key.isNotEmpty() && key == normalized(actual)
    }
}
