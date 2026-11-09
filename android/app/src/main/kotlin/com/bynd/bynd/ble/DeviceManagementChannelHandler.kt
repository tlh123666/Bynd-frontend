package com.bynd.bynd.ble

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** Adapts the refactored device contract to JCVital's real JStyle V8 driver. */
class DeviceManagementChannelHandler(private val activity: Activity) : MethodChannel.MethodCallHandler {
    private val controller = JStyleBleController(context = activity, enableRealtimeMeasurements = false)
    private var channel: MethodChannel? = null
    private var awaitingPermission: Pair<MethodCall, MethodChannel.Result>? = null
    private var closed = false

    fun register(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, "com.bynd/device_management").also { it.setMethodCallHandler(this) }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (closed) { result.error("disposed", "Bluetooth driver is closed.", null); return }
        when (call.method) {
            "close" -> { controller.close(); result.success(null) }
            "stopScan" -> {
                if (awaitingPermission?.first?.method == "scanDevices") {
                    awaitingPermission?.second?.success(emptyList<Any>())
                    awaitingPermission = null
                }
                controller.cancelScan(); result.success(null)
            }
            "capabilities" -> result.success(mapOf(
                "scan" to true, "connect" to true, "readStatus" to true,
                "restart" to false, "eraseUnsyncedData" to false, "installFirmware" to false,
            ))
            // A reset-to-factory command is NOT an erase-unsynced-data command.
            // The old V8 jar has no verified OTA transport/signature pipeline.
            "restart", "eraseUnsyncedData", "installFirmware" ->
                result.error("unsupported_operation", "No verified vendor implementation for this operation.", null)
            "scanDevices", "connect", "readStatus", "disconnect" -> withPermissions(call, result)
            else -> result.notImplemented()
        }
    }

    private fun withPermissions(call: MethodCall, result: MethodChannel.Result) {
        val required = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            if (call.method == "scanDevices") arrayOf(Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_CONNECT)
            else arrayOf(Manifest.permission.BLUETOOTH_CONNECT)
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && call.method == "scanDevices") {
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
        } else emptyArray()
        val missing = required.filter { activity.checkSelfPermission(it) != PackageManager.PERMISSION_GRANTED }
        if (missing.isEmpty()) { execute(call, result); return }
        if (awaitingPermission != null) {
            result.error("busy", "A permission request is already in progress.", null); return
        }
        awaitingPermission = call to result
        activity.requestPermissions(missing.toTypedArray(), PERMISSION_REQUEST)
    }

    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        if (requestCode != PERMISSION_REQUEST) return false
        val request = awaitingPermission ?: return true
        awaitingPermission = null
        if (closed) return true
        if (grantResults.isEmpty() || grantResults.any { it != PackageManager.PERMISSION_GRANTED }) {
            request.second.error("permission_denied", "Bluetooth permissions were not granted.", null)
        } else execute(request.first, request.second)
        return true
    }

    private fun execute(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "scanDevices" -> {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S && !locationEnabled()) {
                        result.error("location_disabled", "Enable location services for BLE discovery on this Android version.", null)
                        return
                    }
                    controller.scanDevices(object : ForwardResult(result) {
                        override fun success(value: Any?) {
                            val devices = (value as? List<*>)?.mapNotNull { raw ->
                                val item = raw as? Map<*, *> ?: return@mapNotNull null
                                mapOf("deviceId" to item["id"], "name" to item["name"], "rssi" to item["signalStrength"])
                            } ?: emptyList()
                            result.success(devices)
                        }
                    })
                }
                "connect" -> controller.connect(call.argument<String>("deviceId"), object : ForwardResult(result) {
                    override fun success(value: Any?) {
                        controller.readManagementStatus(null, object : ForwardResult(result) {
                            override fun error(code: String, message: String?, details: Any?) {
                                controller.disconnect()
                                result.error(code, message, details)
                            }
                        })
                    }
                })
                "readStatus" -> {
                    val address = call.argument<String>("deviceId")
                    controller.ensureManagementConnection(address, object : ForwardResult(result) {
                        override fun success(value: Any?) {
                            controller.readManagementStatus(call.argument<String>("serialNumber"), result)
                        }
                    })
                }
                "disconnect" -> controller.disconnectAddress(call.argument<String>("deviceId"), result)
            }
        } catch (_: SecurityException) {
            result.error("permission_denied", "Bluetooth permission is required.", null)
        } catch (_: RuntimeException) {
            result.error("bluetooth_error", "Bluetooth operation failed.", null)
        }
    }

    @Suppress("DEPRECATION")
    private fun locationEnabled(): Boolean {
        val manager = activity.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) manager.isLocationEnabled
        else manager.isProviderEnabled(LocationManager.GPS_PROVIDER) || manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }

    fun close() {
        closed = true
        awaitingPermission?.second?.error("disposed", "Activity was destroyed.", null)
        awaitingPermission = null
        channel?.setMethodCallHandler(null)
        channel = null
        controller.close()
    }

    private open class ForwardResult(private val result: MethodChannel.Result) : MethodChannel.Result {
        override fun success(value: Any?) = result.success(value)
        override fun error(code: String, message: String?, details: Any?) = result.error(code, message, details)
        override fun notImplemented() = result.notImplemented()
    }
    companion object { private const val PERMISSION_REQUEST = 8417 }
}
