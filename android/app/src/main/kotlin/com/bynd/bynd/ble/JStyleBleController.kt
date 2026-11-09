package com.bynd.bynd.ble

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.jstyle.blesdkv8.Util.BleSDK
import com.jstyle.blesdkv8.callback.DataListener2301
import com.jstyle.blesdkv8.constant.BleConst
import com.jstyle.blesdkv8.constant.DeviceKey
import com.jstyle.blesdkv8.model.AutoMode
import com.jstyle.blesdkv8.model.AutoTestMode
import com.jstyle.blesdkv8.model.MyDeviceTime
import com.jstyle.blesdkv8.model.MyPersonalInfo
import io.flutter.plugin.common.MethodChannel
import java.util.ArrayDeque
import java.util.Calendar
import java.util.UUID
import kotlin.math.roundToInt

class JStyleBleController(
    context: Context,
    private val onRealtimeEvent: ((Map<String, Any?>) -> Unit)? = null,
    private val onEcgEvent: ((Map<String, Any?>) -> Unit)? = null,
    private val enableRealtimeMeasurements: Boolean = true,
) {
    private val appContext = context.applicationContext
    private val mainHandler = Handler(Looper.getMainLooper())
    private val bluetoothManager =
        appContext.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    private val bluetoothAdapter: BluetoothAdapter?
        get() = bluetoothManager.adapter

    private val discoveredDevices = linkedMapOf<String, DeviceRecord>()
    private val writeQueue: ArrayDeque<ByteArray> = ArrayDeque()

    private var scanCallback: ScanCallback? = null
    private var scanTimeout: Runnable? = null
    private var pendingScanResult: MethodChannel.Result? = null

    private var currentGatt: BluetoothGatt? = null
    private var currentDevice: DeviceRecord? = null
    private var writeCharacteristic: BluetoothGattCharacteristic? = null
    private var notifyCharacteristic: BluetoothGattCharacteristic? = null
    private var connectionReady = false
    private var isWriting = false

    private var pendingConnectResult: MethodChannel.Result? = null
    private var connectTimeout: Runnable? = null
    private var pendingMetricsResult: MethodChannel.Result? = null
    private var metricsTimeout: Runnable? = null
    private var managementResult: MethodChannel.Result? = null
    private var managementTimeout: Runnable? = null
    private var managementExpectedSerial: String? = null
    private val managementReplies = mutableSetOf<String>()
    private var sleepHistoryResponseCount = 0
    private var dynamicHeartRateResponseCount = 0
    private var staticHeartRateResponseCount = 0
    private var pendingProfileSyncResult: MethodChannel.Result? = null
    private var profileSyncTimeout: Runnable? = null
    private var realtimeStepActive = false
    private var heartMeasurementActive = false
    private var measurementLoopRunnable: Runnable? = null
    private var ecgActive = false
    private var ecgStartedAtMillis = 0L
    private var ecgDurationSeconds = 0
    private var ecgFinishRunnable: Runnable? = null

    private var steps = 0
    private var heartRate = 0
    private var sleepHours = 0.0
    private var calories = 0
    private var bloodOxygen = 0
    private var batteryLevel = 0
    private var distance = 0.0
    private var temperature = 0.0
    private var hrv = 0
    private var stress = 0
    private var highBloodPressure = 0
    private var lowBloodPressure = 0
    private var vascularAging = 0
    private var exerciseTime = 0
    private var exerciseMinutes = 0
    private var chargingState = 0
    private var voltageValue = 0

    private val deviceInfo = linkedMapOf<String, Any?>()
    private val latestRealtime = linkedMapOf<String, Any?>()
    private val activityModeStatus = linkedMapOf<String, Any?>()
    private val historyData = linkedMapOf<String, MutableList<Map<String, Any?>>>()
    private val rawDataByType = linkedMapOf<String, Any?>()

    private val parser =
        object : DataListener2301 {
            override fun dataCallback(maps: MutableMap<String, Any>?) {
                if (maps != null) {
                    handleParsedData(maps)
                }
            }

            override fun dataCallback(value: ByteArray?) = Unit
        }

    fun scanDevices(result: MethodChannel.Result) {
        if (!ensureBluetoothAvailable(result)) return
        if (!ensureScanPermission(result)) return

        if (pendingScanResult != null) {
            result.error("scan_in_progress", "A BLE scan is already running.", null)
            return
        }

        discoveredDevices.clear()
        addBondedDevices()

        val adapter = bluetoothAdapter
        val scanner = adapter?.bluetoothLeScanner
        if (scanner == null) {
            result.error("scanner_unavailable", "Bluetooth LE scanner is unavailable.", null)
            return
        }

        val callback =
            object : ScanCallback() {
                override fun onScanResult(callbackType: Int, result: ScanResult) {
                    addScanResult(result)
                }

                override fun onBatchScanResults(results: MutableList<ScanResult>) {
                    results.forEach(::addScanResult)
                }

                override fun onScanFailed(errorCode: Int) {
                    mainHandler.post {
                        finishScanWithError(
                            "scan_failed",
                            "Bluetooth scan failed with code $errorCode.",
                        )
                    }
                }
            }

        pendingScanResult = result
        scanCallback = callback
        scanTimeout =
            Runnable {
                finishScan()
            }.also { mainHandler.postDelayed(it, SCAN_DURATION_MS) }

        try {
            val settings =
                ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                    .build()
            scanner.startScan(null, settings, callback)
        } catch (error: SecurityException) {
            finishScanWithError("permission_denied", "Bluetooth scan permission denied.")
        } catch (error: RuntimeException) {
            finishScanWithError("scan_failed", error.message ?: "Bluetooth scan failed.")
        }
    }

    fun connect(
        deviceId: String?,
        result: MethodChannel.Result,
    ) {
        if (!ensureBluetoothAvailable(result)) return
        if (!ensureConnectPermission(result)) return

        val address = deviceId?.trim().orEmpty()
        if (!BluetoothAdapter.checkBluetoothAddress(address)) {
            result.error("invalid_device", "A valid Bluetooth MAC address is required.", null)
            return
        }

        if (connectionReady && currentDevice?.id == address) {
            result.success(currentDeviceMap())
            return
        }

        if (pendingConnectResult != null) {
            result.error("connect_in_progress", "A device connection is already running.", null)
            return
        }

        stopScanInternal()
        clearGatt()
        resetMetrics()

        val adapter = bluetoothAdapter
        val device =
            try {
                adapter?.getRemoteDevice(address)
            } catch (error: IllegalArgumentException) {
                null
            }

        if (device == null) {
            result.error("not_found", "Bluetooth device not found.", null)
            return
        }

        pendingConnectResult = result
        connectTimeout =
            Runnable {
                failConnect("connection_timeout", "Timed out while connecting to the band.")
            }.also { mainHandler.postDelayed(it, CONNECT_TIMEOUT_MS) }

        try {
            currentDevice = device.toRecord(discoveredDevices[address]?.signalStrength ?: 0)
            currentGatt =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    device.connectGatt(appContext, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
                } else {
                    @Suppress("DEPRECATION")
                    device.connectGatt(appContext, false, gattCallback)
                }

            if (currentGatt == null) {
                failConnect("connection_failed", "Unable to create Bluetooth GATT connection.")
            }
        } catch (error: SecurityException) {
            failConnect("permission_denied", "Bluetooth connect permission denied.")
        } catch (error: RuntimeException) {
            failConnect("connection_failed", error.message ?: "Bluetooth connection failed.")
        }
    }

    fun disconnect(result: MethodChannel.Result? = null) {
        cancelScan()
        failManagement("device_disconnected", "The band disconnected.")
        finishMetrics()
        failProfileSync("disconnected", "Disconnected before profile sync completed.")
        failConnect("disconnected", "Disconnected before the band was ready.")

        val gatt = currentGatt
        if (gatt == null) {
            clearConnectionState()
            result?.success(null)
            return
        }

        try {
            gatt.disconnect()
        } catch (error: SecurityException) {
            Log.w(TAG, "Missing connect permission during disconnect.", error)
        } finally {
            mainHandler.postDelayed({ clearGatt(gatt) }, CLOSE_DELAY_MS)
            result?.success(null)
        }
    }

    fun fetchLatestMetrics(result: MethodChannel.Result) {
        if (!ensureConnectPermission(result)) return

        if (!connectionReady || currentGatt == null || currentDevice == null) {
            result.error("disconnected", "The band is not connected.", null)
            return
        }

        if (pendingMetricsResult != null) {
            result.success(metricsPayload())
            return
        }

        pendingMetricsResult = result
        sleepHistoryResponseCount = 0
        dynamicHeartRateResponseCount = 0
        staticHeartRateResponseCount = 0
        metricsTimeout =
            Runnable {
                finishMetrics()
            }.also { mainHandler.postDelayed(it, METRICS_TIMEOUT_MS) }

        enqueueCommands(
            listOf(
                BleSDK.GetDeviceTime(),
                BleSDK.GetPersonalInfo(),
                BleSDK.GetDeviceBatteryLevel(),
                BleSDK.GetDeviceMacAddress(),
                BleSDK.GetDeviceVersion(),
                BleSDK.GetDeviceName(),
                BleSDK.GetAutomatic(AutoMode.AutoHeartRate),
                BleSDK.GetAutomatic(AutoMode.AutoSpo2),
                BleSDK.GetAutomatic(AutoMode.AutoTemp),
                BleSDK.GetAutomatic(AutoMode.AutoHrv),
                BleSDK.GetTotalActivityDataWithMode(READ_START, ""),
                BleSDK.GetDetailActivityDataWithMode(READ_START, ""),
                BleSDK.GetDynamicHRWithMode(READ_START, ""),
                BleSDK.GetStaticHRWithMode(READ_START, ""),
                BleSDK.GetDetailSleepDataWithMode(READ_START, ""),
                BleSDK.GetHRVDataWithMode(READ_START, ""),
                BleSDK.GetTemperature_historyData(READ_START, ""),
                BleSDK.Oxygen_data(READ_START, ""),
                BleSDK.GetActivityModeDataWithMode(READ_START),
                BleSDK.FindActivityMode(),
            ),
        )
    }

    fun syncUserProfile(
        deviceId: String?,
        profile: Map<String, Any?>?,
        result: MethodChannel.Result,
    ) {
        if (!ensureConnectPermission(result)) return

        val address = deviceId?.trim().orEmpty()
        if (!connectionReady || currentGatt == null || currentDevice == null) {
            result.error("disconnected", "The band is not connected.", null)
            return
        }
        if (currentDevice?.id != address) {
            result.error("invalid_device", "The requested band is not connected.", null)
            return
        }
        if (pendingProfileSyncResult != null) {
            result.error("profile_sync_in_progress", "Profile sync is already running.", null)
            return
        }

        val payload = profile ?: emptyMap()
        val age = payload.profileInt("age")
        val sex = payload.profileInt("sex")
        val heightCm = payload.profileInt("heightCm")
        val weightKg = payload.profileInt("weightKg")
        val stepLengthCm = payload.profileInt("stepLengthCm")

        if (age == null || age !in 1..120) {
            result.error("invalid_profile", "Age must be between 1 and 120.", null)
            return
        }
        if (sex == null || sex !in 0..1) {
            result.error("invalid_profile", "Sex must be 0 or 1.", null)
            return
        }
        if (heightCm == null || heightCm !in 80..230) {
            result.error("invalid_profile", "Height must be between 80 and 230 cm.", null)
            return
        }
        if (weightKg == null || weightKg !in 25..250) {
            result.error("invalid_profile", "Weight must be between 25 and 250 kg.", null)
            return
        }
        if (stepLengthCm == null || stepLengthCm !in 20..160) {
            result.error("invalid_profile", "Step length must be between 20 and 160 cm.", null)
            return
        }

        val personalInfo =
            MyPersonalInfo().apply {
                setAge(age)
                setSex(sex)
                setHeight(heightCm)
                setWeight(weightKg)
                setStepLength(stepLengthCm)
            }

        pendingProfileSyncResult = result
        profileSyncTimeout =
            Runnable {
                failProfileSync("profile_sync_timeout", "Timed out while syncing profile to band.")
            }.also { mainHandler.postDelayed(it, PROFILE_SYNC_TIMEOUT_MS) }

        enqueueCommands(listOf(BleSDK.SetPersonalInfo(personalInfo)))
    }

    fun startEcgMeasurement(
        deviceId: String?,
        durationSeconds: Int,
        result: MethodChannel.Result,
    ) {
        if (!ensureConnectPermission(result)) return
        if (!connectionReady || currentGatt == null || currentDevice == null) {
            result.error("disconnected", "The band is not connected.", null)
            return
        }
        if (currentDevice?.id != deviceId?.trim()) {
            result.error("invalid_device", "The requested band is not connected.", null)
            return
        }
        if (ecgActive) {
            result.error("ecg_in_progress", "An ECG measurement is already running.", null)
            return
        }
        if (durationSeconds !in MIN_ECG_SECONDS..MAX_ECG_SECONDS) {
            result.error("invalid_duration", "ECG duration must be between 30 and 60 seconds.", null)
            return
        }

        measurementLoopRunnable?.let { mainHandler.removeCallbacks(it) }
        measurementLoopRunnable = null
        ecgActive = true
        ecgStartedAtMillis = System.currentTimeMillis()
        ecgDurationSeconds = durationSeconds
        onEcgEvent?.invoke(
            mapOf(
                "event" to "ecg_started",
                "startedAtMillis" to ecgStartedAtMillis,
                "durationSeconds" to durationSeconds,
            ),
        )
        enqueueCommands(
            listOf(
                BleSDK.SetDeviceMeasurementWithType(
                    AutoTestMode.AutoHRV,
                    durationSeconds * 1000L,
                    true,
                ),
                BleSDK.setECGRealtimeDuringHRVEnabled(true),
            ),
        )
        ecgFinishRunnable = Runnable { finishEcgMeasurement(cancelled = false) }
            .also { mainHandler.postDelayed(it, durationSeconds * 1000L + ECG_FINISH_GRACE_MS) }
        result.success(null)
    }

    fun stopEcgMeasurement(result: MethodChannel.Result? = null) {
        if (!ecgActive) {
            result?.success(null)
            return
        }
        finishEcgMeasurement(cancelled = true)
        result?.success(null)
    }

    private fun finishEcgMeasurement(cancelled: Boolean) {
        if (!ecgActive) return
        ecgFinishRunnable?.let { mainHandler.removeCallbacks(it) }
        ecgFinishRunnable = null
        enqueueCommands(
            listOf(
                BleSDK.setECGRealtimeDuringHRVEnabled(false),
                BleSDK.SetDeviceMeasurementWithType(
                    AutoTestMode.AutoHRV,
                    ecgDurationSeconds * 1000L,
                    false,
                ),
            ),
        )
        val elapsed = (System.currentTimeMillis() - ecgStartedAtMillis).coerceAtLeast(0L)
        ecgActive = false
        onEcgEvent?.invoke(
            mapOf(
                "event" to if (cancelled) "ecg_cancelled" else "ecg_completed",
                "durationMillis" to elapsed,
                "heartRate" to heartRate.takeIf { it > 0 },
                "hrv" to hrv.takeIf { it > 0 },
                "stress" to stress.takeIf { it > 0 },
                "systolicBloodPressure" to highBloodPressure.takeIf { it > 0 },
                "diastolicBloodPressure" to lowBloodPressure.takeIf { it > 0 },
            ),
        )
        if (connectionReady) {
            scheduleMeasurementLoop()
        }
    }

    fun close() {
        disconnect(null)
        clearGatt()
        mainHandler.removeCallbacksAndMessages(null)
    }

    fun cancelScan() { finishScan() }

    fun disconnectAddress(address: String?, result: MethodChannel.Result) {
        // This SDK maintains one GATT. A stale previous-device cleanup must
        // not disconnect the newly connected band after a cloud binding swap.
        if (address != null && currentDevice?.id != address) { result.success(null); return }
        disconnect(result)
    }

    fun ensureManagementConnection(address: String?, result: MethodChannel.Result) {
        if (connectionReady && currentDevice?.id == address) result.success(null)
        else connect(address, result)
    }

    fun readManagementStatus(expectedSerial: String?, result: MethodChannel.Result) {
        if (!ensureConnectPermission(result)) return
        if (!connectionReady || currentGatt == null) {
            result.error("device_disconnected", "The band is not connected.", null); return
        }
        if (managementResult != null) { result.error("busy", "A status read is already running.", null); return }
        managementResult = result
        managementExpectedSerial = expectedSerial
        managementReplies.clear()
        // Old replies must not be treated as fresh hardware measurements.
        deviceInfo.remove("macAddress")
        deviceInfo.remove("firmwareVersion")
        deviceInfo.remove("battery")
        managementTimeout = Runnable { finishManagement() }.also { mainHandler.postDelayed(it, 8000L) }
        enqueueCommands(listOf(BleSDK.GetDeviceMacAddress(), BleSDK.GetDeviceBatteryLevel(), BleSDK.GetDeviceVersion()))
    }

    private fun finishManagement() {
        val result = managementResult ?: return
        val serial = BandDeviceIdentity.serial(deviceInfo)
        if (serial == null) { failManagement("identity_missing", "The band did not report its hardware identity."); return }
        if (managementExpectedSerial?.let { !BandDeviceIdentity.matches(it, serial) } == true) {
            failManagement("identity_mismatch", "This is not the band bound to this account.")
            disconnect()
            return
        }
        managementTimeout?.let { mainHandler.removeCallbacks(it) }
        managementTimeout = null
        managementResult = null
        result.success(mapOf(
            "deviceId" to currentDevice?.id,
            "transportId" to currentDevice?.id,
            "serialNumber" to serial,
            // Keep the hardware model code used by JCVital cloud bindings.
            "manufacturer" to "BYND", "modelCode" to "V5", "modelName" to "Smart Band",
            "firmwareVersion" to (BandDeviceIdentity.firmware(deviceInfo) ?: ""),
            "batteryPercent" to batteryLevel.takeIf { BleConst.GetDeviceBatteryLevel in managementReplies && it in 0..100 },
            "rssi" to currentDevice?.signalStrength?.takeIf { it != DeviceRecord.NO_RSSI && it != 0 },
            "connected" to connectionReady,
        ))
    }

    private fun failManagement(code: String, message: String) {
        val result = managementResult ?: return
        managementTimeout?.let { mainHandler.removeCallbacks(it) }
        managementTimeout = null
        managementResult = null
        result.error(code, message, null)
    }

    @SuppressLint("MissingPermission")
    private fun addBondedDevices() {
        val adapter = bluetoothAdapter ?: return
        if (!hasConnectPermission()) return

        try {
            adapter.bondedDevices.forEach { device ->
                val record = device.toRecord(DeviceRecord.NO_RSSI)
                if (record.shouldKeep()) {
                    discoveredDevices[record.id] = record
                }
            }
        } catch (error: SecurityException) {
            Log.w(TAG, "Unable to read bonded devices.", error)
        }
    }

    private fun addScanResult(result: ScanResult) {
        mainHandler.post {
            val record = result.device.toRecord(result.rssi, result.scanRecord?.deviceName)
            if (record.shouldKeep()) {
                discoveredDevices[record.id] = record
            }
        }
    }

    private fun finishScan() {
        val result = pendingScanResult ?: return
        stopScanInternal()
        result.success(discoveredDevices.values.sortedForDisplay().map { it.toMap() })
    }

    private fun finishScanWithError(code: String, message: String) {
        val result = pendingScanResult ?: return
        stopScanInternal()
        result.error(code, message, null)
    }

    @SuppressLint("MissingPermission")
    private fun stopScanInternal() {
        val callback = scanCallback
        val timeout = scanTimeout
        if (timeout != null) {
            mainHandler.removeCallbacks(timeout)
        }
        scanTimeout = null
        scanCallback = null
        pendingScanResult = null

        if (callback != null && hasScanPermission()) {
            try {
                bluetoothAdapter?.bluetoothLeScanner?.stopScan(callback)
            } catch (error: SecurityException) {
                Log.w(TAG, "Missing scan permission while stopping scan.", error)
            } catch (error: RuntimeException) {
                Log.w(TAG, "Unable to stop BLE scan.", error)
            }
        }
    }

    private val gattCallback =
        object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                mainHandler.post {
                    if (gatt != currentGatt) { clearGatt(gatt); return@post }
                    when (newState) {
                        BluetoothProfile.STATE_CONNECTED -> {
                            if (status == BluetoothGatt.GATT_SUCCESS) {
                                discoverServices(gatt)
                            } else {
                                failConnect("connection_failed", "Bluetooth connection failed: $status.")
                            }
                        }

                        BluetoothProfile.STATE_DISCONNECTED -> {
                            failManagement("device_disconnected", "The band disconnected while reading status.")
                            val wasReady = connectionReady
                            clearGatt(gatt)
                            if (!wasReady) {
                                failConnect("connection_failed", "The band disconnected before setup completed.")
                            } else {
                                failMetrics("disconnected", "The band disconnected.")
                                failProfileSync("disconnected", "The band disconnected.")
                            }
                        }
                    }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                mainHandler.post {
                    if (gatt != currentGatt) return@post
                    if (status != BluetoothGatt.GATT_SUCCESS) {
                        failConnect("service_discovery_failed", "Bluetooth service discovery failed: $status.")
                        return@post
                    }

                    val service = gatt.getService(DATA_SERVICE_UUID)
                    if (service == null) {
                        failConnect("unsupported_device", "Required JStyle BLE service was not found.")
                        return@post
                    }

                    writeCharacteristic = service.getCharacteristic(WRITE_CHARACTERISTIC_UUID)
                    notifyCharacteristic = service.getCharacteristic(NOTIFY_CHARACTERISTIC_UUID)

                    if (writeCharacteristic == null || notifyCharacteristic == null) {
                        failConnect("unsupported_device", "Required JStyle BLE characteristics were not found.")
                        return@post
                    }

                    if (!enableNotifications(gatt, notifyCharacteristic)) {
                        failConnect("notification_failed", "Unable to enable band notifications.")
                    }
                }
            }

            override fun onDescriptorWrite(
                gatt: BluetoothGatt,
                descriptor: BluetoothGattDescriptor,
                status: Int,
            ) {
                mainHandler.post {
                    if (gatt != currentGatt) return@post
                    if (descriptor.uuid == CLIENT_CHARACTERISTIC_CONFIG_UUID) {
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            connectionReady = true
                            try {
                                gatt.requestConnectionPriority(BluetoothGatt.CONNECTION_PRIORITY_HIGH)
                            } catch (error: SecurityException) {
                                Log.w(TAG, "Missing connect permission while requesting high priority.", error)
                            } catch (error: RuntimeException) {
                                Log.w(TAG, "Unable to request high priority connection.", error)
                            }
                            completeConnect()
                        } else {
                            failConnect("notification_failed", "Notification setup failed: $status.")
                        }
                    }
                }
            }

            @Deprecated("Deprecated in Android 13.")
            override fun onCharacteristicChanged(
                gatt: BluetoothGatt,
                characteristic: BluetoothGattCharacteristic,
            ) {
                val value = characteristic.value ?: return
                if (gatt == currentGatt) parseIncoming(value, gatt)
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt,
                characteristic: BluetoothGattCharacteristic,
                value: ByteArray,
            ) {
                if (gatt == currentGatt) parseIncoming(value, gatt)
            }

            override fun onCharacteristicWrite(
                gatt: BluetoothGatt,
                characteristic: BluetoothGattCharacteristic,
                status: Int,
            ) {
                mainHandler.post {
                    if (gatt != currentGatt) return@post
                    isWriting = false
                    mainHandler.postDelayed({ writeNext() }, COMMAND_WRITE_GAP_MS)
                }
            }
        }

    @SuppressLint("MissingPermission")
    private fun discoverServices(gatt: BluetoothGatt) {
        try {
            if (!gatt.discoverServices()) {
                failConnect("service_discovery_failed", "Unable to start Bluetooth service discovery.")
            }
        } catch (error: SecurityException) {
            failConnect("permission_denied", "Bluetooth connect permission denied.")
        }
    }

    @SuppressLint("MissingPermission")
    private fun enableNotifications(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic?,
    ): Boolean {
        characteristic ?: return false

        return try {
            val descriptor = characteristic.getDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID)
                ?: return false
            if (!gatt.setCharacteristicNotification(characteristic, true)) {
                return false
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                gatt.writeDescriptor(descriptor, BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE) ==
                    BluetoothGatt.GATT_SUCCESS
            } else {
                @Suppress("DEPRECATION")
                descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                @Suppress("DEPRECATION")
                gatt.writeDescriptor(descriptor)
            }
        } catch (error: SecurityException) {
            Log.w(TAG, "Missing connect permission while enabling notifications.", error)
            false
        }
    }

    private fun enqueueCommands(commands: List<ByteArray>) {
        writeQueue.addAll(commands)
        writeNext()
    }

    @SuppressLint("MissingPermission")
    private fun writeNext() {
        if (isWriting) return

        val gatt = currentGatt ?: return
        val characteristic = writeCharacteristic ?: return
        val value = writeQueue.poll() ?: return

        try {
            isWriting = true
            val started =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    gatt.writeCharacteristic(
                        characteristic,
                        value,
                        BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT,
                    ) == BluetoothGatt.GATT_SUCCESS
                } else {
                    @Suppress("DEPRECATION")
                    characteristic.value = value
                    characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                    @Suppress("DEPRECATION")
                    gatt.writeCharacteristic(characteristic)
                }

            if (!started) {
                isWriting = false
                writeNext()
            }
        } catch (error: SecurityException) {
            Log.w(TAG, "Missing connect permission while writing BLE command.", error)
            isWriting = false
        }
    }

    private fun parseIncoming(value: ByteArray, sourceGatt: BluetoothGatt) {
        mainHandler.post {
            if (sourceGatt != currentGatt) return@post
            try {
                BleSDK.DataParsingWithData(value, parser)
            } catch (error: RuntimeException) {
                Log.w(TAG, "Unable to parse BLE payload.", error)
            }
        }
    }

    private fun handleParsedData(maps: Map<String, Any>) {
        val dataType = maps[DeviceKey.DataType]?.toString() ?: return
        rawDataByType[dataType] = normalizeMap(maps)
        // Parse/store this reply first, then complete the management read.
        if (managementResult != null && dataType in setOf(BleConst.GetDeviceMacAddress, BleConst.GetDeviceBatteryLevel, BleConst.GetDeviceVersion)) {
            managementReplies.add(dataType)
            if (managementReplies.size == 3) mainHandler.post { finishManagement() }
        }
        Log.d(TAG, "BLE parsed dataType=$dataType")

        when (dataType) {
            BleConst.Getppg -> {
                if (!ecgActive) return
                val entry = payloadMap(maps)
                val samples = entry.tokens(DeviceKey.arrayPpgRawData).mapNotNull { it.toIntOrNull() }
                if (samples.isNotEmpty()) {
                    onEcgEvent?.invoke(
                        mapOf(
                            "event" to "ecg_waveform",
                            "packetId" to entry.intValue(DeviceKey.packetID),
                            "samples" to samples,
                        ),
                    )
                }
            }
            BleConst.ECGResult -> {
                if (!ecgActive) return
                val entry = payloadMap(maps)
                heartRate = entry.intValue(DeviceKey.ECGHrValue) ?: heartRate
                hrv = entry.intValue(DeviceKey.ECGHrvValue) ?: hrv
                stress = entry.intValue(DeviceKey.ECGStreesValue) ?: stress
                highBloodPressure = entry.intValue(DeviceKey.ECGhighBpValue) ?: highBloodPressure
                lowBloodPressure = entry.intValue(DeviceKey.ECGLowBpValue) ?: lowBloodPressure
                onEcgEvent?.invoke(
                    mapOf(
                        "event" to "ecg_metrics",
                        "heartRate" to heartRate.takeIf { it > 0 },
                        "hrv" to hrv.takeIf { it > 0 },
                        "stress" to stress.takeIf { it > 0 },
                        "systolicBloodPressure" to highBloodPressure.takeIf { it > 0 },
                        "diastolicBloodPressure" to lowBloodPressure.takeIf { it > 0 },
                        "respiratoryRate" to entry.intValue(DeviceKey.ECGBreathValue),
                    ),
                )
            }
            BleConst.GetDeviceTime -> storeDeviceInfo("deviceTime", maps)
            BleConst.SetPersonalInfo -> finishProfileSync()
            BleConst.GetPersonalInfo -> storeDeviceInfo("personalInfo", maps)
            BleConst.GetDeviceMacAddress -> storeDeviceInfo("macAddress", maps)
            BleConst.GetDeviceVersion -> storeDeviceInfo("firmwareVersion", maps)
            BleConst.GetDeviceName -> storeDeviceInfo("deviceName", maps)
            BleConst.GetAutomatic -> storeAutomaticConfig(maps)

            BleConst.GetDeviceBatteryLevel -> {
                val payload = maps[DeviceKey.Data] as? Map<*, *>
                batteryLevel = payload.intValue(DeviceKey.BatteryLevel) ?: batteryLevel
                chargingState = payload.intValue(DeviceKey.Chargingstate) ?: chargingState
                voltageValue = payload.intValue(DeviceKey.Voltage_value) ?: voltageValue
                storeDeviceInfo("battery", maps)
            }

            BleConst.GetTotalActivityData -> {
                val records = storeHistory("totalActivity", maps)
                val entry = records.firstOrNull()
                steps = entry.intValue(DeviceKey.Step) ?: steps
                calories = entry.intValue(DeviceKey.Calories) ?: calories
                distance = entry.doubleValue(DeviceKey.Distance) ?: distance
                exerciseTime = entry.intValue(DeviceKey.ActiveMinutes) ?: exerciseTime
                exerciseMinutes = entry.intValue(DeviceKey.ExerciseMinutes) ?: exerciseMinutes
            }

            BleConst.GetDetailActivityData -> {
                storeHistory("detailActivity", maps)
            }

            BleConst.GetStaticHR -> {
                val records = storeHistory("staticHeartRate", maps)
                staticHeartRateResponseCount++
                val entry = records.maxByOrNull { it[DeviceKey.Date]?.toString().orEmpty() }
                heartRate = entry.intValue(DeviceKey.StaticHR) ?: heartRate
                if (records.isNotEmpty()) {
                    // History responses can arrive after the one-shot metrics
                    // request finishes. Publish each page so Flutter retains
                    // every timestamped reading instead of only the latest BPM.
                    pushRealtimeUpdate("static_heart_rate_history")
                }
                if (!maps.dataEnded() && staticHeartRateResponseCount % HEART_RATE_HISTORY_BATCH_SIZE == 0) {
                    enqueueCommands(listOf(BleSDK.GetStaticHRWithMode(READ_CONTINUE, "")))
                }
            }

            BleConst.GetDynamicHR -> {
                val records = storeHistory("dynamicHeartRate", maps)
                dynamicHeartRateResponseCount++
                val entry = records.maxByOrNull { it[DeviceKey.Date]?.toString().orEmpty() }
                val values = entry.tokens(DeviceKey.ArrayDynamicHR).mapNotNull { it.toIntOrNull() }
                heartRate = values.lastOrNull { it > 0 } ?: heartRate
                if (records.isNotEmpty()) {
                    pushRealtimeUpdate("dynamic_heart_rate_history")
                }
                if (!maps.dataEnded() && dynamicHeartRateResponseCount % HEART_RATE_HISTORY_BATCH_SIZE == 0) {
                    enqueueCommands(listOf(BleSDK.GetDynamicHRWithMode(READ_CONTINUE, "")))
                }
            }

            BleConst.GetDetailSleepData,
            BleConst.Obtain_detailed_sleep_data -> {
                val records = storeHistory("sleep", maps)
                sleepHistoryResponseCount++
                val entry = records.firstOrNull()
                val samples = entry.tokens(DeviceKey.ArraySleep)
                val unitMinutes = entry.intValue(DeviceKey.sleepUnitLength) ?: DEFAULT_SLEEP_UNIT_MINUTES
                if (samples.isNotEmpty()) {
                    sleepHours = samples.size * unitMinutes / MINUTES_PER_HOUR
                }
                Log.d(
                    TAG,
                    "BLE sleep history records=${records.size}, samples=${samples.size}, unitMinutes=$unitMinutes",
                )
                // Detailed sleep history is often delivered after the normal
                // metrics request has already timed out. Publish every packet
                // so Flutter persists the history and runs the idempotent
                // sleep upload instead of silently keeping it only in this
                // controller's in-memory map.
                if (records.isNotEmpty()) {
                    pushRealtimeUpdate("sleep_history")
                }
                // The vendor demo resumes a large history transfer every 50
                // responses with mode=2. Without this, a band holding more
                // than one batch can stop partway through its sleep history.
                if (!maps.dataEnded() && sleepHistoryResponseCount % SLEEP_HISTORY_BATCH_SIZE == 0) {
                    enqueueCommands(listOf(BleSDK.GetDetailSleepDataWithMode(READ_CONTINUE, "")))
                }
            }

            BleConst.GetHRVData -> {
                val records = storeHistory("hrv", maps)
                val entry = records.firstOrNull()
                heartRate = entry.intValue(DeviceKey.HeartRate) ?: heartRate
                hrv = entry.intValue(DeviceKey.HRV) ?: hrv
                stress = entry.intValue(DeviceKey.Stress) ?: stress
                highBloodPressure = entry.intValue(DeviceKey.highBP)
                    ?: entry.intValue(DeviceKey.HighPressure)
                    ?: highBloodPressure
                lowBloodPressure = entry.intValue(DeviceKey.lowBP)
                    ?: entry.intValue(DeviceKey.LowPressure)
                    ?: lowBloodPressure
                vascularAging = entry.intValue(DeviceKey.VascularAging) ?: vascularAging
            }

            BleConst.Temperature_history -> {
                val records = storeHistory("temperature", maps)
                val entry = records.firstOrNull()
                temperature = entry.doubleValue(DeviceKey.temperature) ?: temperature
            }

            BleConst.GetAutomaticSpo2Monitoring,
            BleConst.Blood_oxygen -> {
                val records = storeHistory("bloodOxygen", maps)
                val entry = records.firstOrNull()
                bloodOxygen = entry.intValue(DeviceKey.Blood_oxygen) ?: bloodOxygen
            }

            BleConst.GetActivityModeData -> {
                storeHistory("exercise", maps)
            }

            BleConst.FindActivityMode -> {
                activityModeStatus.clear()
                activityModeStatus.putAll(payloadMap(maps))
            }

            BleConst.MeasurementHeartCallback,
            BleConst.MeasurementHrvCallback,
            BleConst.MeasurementOxygenCallback,
            BleConst.StopMeasurementHeartCallback,
            BleConst.StopMeasurementHrvCallback,
            BleConst.StopMeasurementOxygenCallback -> {
                val entry = payloadMap(maps)
                heartRate = entry.intValue(DeviceKey.HeartRate) ?: heartRate
                bloodOxygen = entry.intValue(DeviceKey.Blood_oxygen) ?: bloodOxygen
                hrv = entry.intValue(DeviceKey.HRV) ?: hrv
                stress = entry.intValue(DeviceKey.Stress) ?: stress
                highBloodPressure = entry.intValue(DeviceKey.highBP)
                    ?: entry.intValue(DeviceKey.HighPressure)
                    ?: highBloodPressure
                lowBloodPressure = entry.intValue(DeviceKey.lowBP)
                    ?: entry.intValue(DeviceKey.LowPressure)
                    ?: lowBloodPressure
                vascularAging = entry.intValue(DeviceKey.VascularAging) ?: vascularAging
                latestRealtime.clear()
                latestRealtime.putAll(entry)
                pushRealtimeUpdate("measurement")
                if (ecgActive && dataType == BleConst.MeasurementHrvCallback) {
                    onEcgEvent?.invoke(
                        mapOf(
                            "event" to "ecg_metrics",
                            "heartRate" to heartRate.takeIf { it > 0 },
                            "hrv" to hrv.takeIf { it > 0 },
                            "stress" to stress.takeIf { it > 0 },
                            "systolicBloodPressure" to highBloodPressure.takeIf { it > 0 },
                            "diastolicBloodPressure" to lowBloodPressure.takeIf { it > 0 },
                            "respiratoryRate" to entry.intValue(DeviceKey.ECGBreathValue),
                        ),
                    )
                }
            }

            BleConst.RealTimeStep,
            BleConst.SportData -> {
                val entry = payloadMap(maps)
                steps = entry.intValue(DeviceKey.Step) ?: steps
                heartRate = entry.intValue(DeviceKey.HeartRate) ?: heartRate
                calories = entry.intValue(DeviceKey.Calories) ?: calories
                bloodOxygen = entry.intValue(DeviceKey.Blood_oxygen) ?: bloodOxygen
                distance = entry.doubleValue(DeviceKey.Distance) ?: distance
                temperature = entry.doubleValue(DeviceKey.TempData) ?: temperature
                exerciseTime = entry.intValue(DeviceKey.ActiveMinutes) ?: exerciseTime
                exerciseMinutes = entry.intValue(DeviceKey.ExerciseMinutes) ?: exerciseMinutes
                latestRealtime.clear()
                latestRealtime.putAll(entry)
                pushRealtimeUpdate("realtime")
            }
        }
    }

    private fun completeConnect() {
        val result = pendingConnectResult ?: return
        connectTimeout?.let { mainHandler.removeCallbacks(it) }
        connectTimeout = null
        pendingConnectResult = null
        result.success(currentDeviceMap())
        syncDeviceTimeToPhone()
        if (enableRealtimeMeasurements) {
            startRealtimeStep()
            startHeartMeasurement()
        }
    }

    private fun syncDeviceTimeToPhone() {
        if (!connectionReady) return

        val calendar = Calendar.getInstance()
        val deviceTime =
            MyDeviceTime().apply {
                year = calendar.get(Calendar.YEAR)
                month = calendar.get(Calendar.MONTH) + 1
                day = calendar.get(Calendar.DAY_OF_MONTH)
                hour = calendar.get(Calendar.HOUR_OF_DAY)
                minute = calendar.get(Calendar.MINUTE)
                second = calendar.get(Calendar.SECOND)
            }

        deviceInfo["phoneSyncedAt"] = String.format(
            "%04d-%02d-%02d %02d:%02d:%02d",
            deviceTime.year,
            deviceTime.month,
            deviceTime.day,
            deviceTime.hour,
            deviceTime.minute,
            deviceTime.second,
        )

        enqueueCommands(listOf(BleSDK.SetDeviceTime(deviceTime)))
    }

    private fun failConnect(code: String, message: String) {
        val result = pendingConnectResult
        connectTimeout?.let { mainHandler.removeCallbacks(it) }
        connectTimeout = null
        pendingConnectResult = null

        if (result != null) {
            clearGatt()
            result.error(code, message, null)
        }
    }

    private fun failMetrics(code: String, message: String) {
        val result = pendingMetricsResult ?: return
        metricsTimeout?.let { mainHandler.removeCallbacks(it) }
        metricsTimeout = null
        pendingMetricsResult = null
        result.error(code, message, null)
    }

    private fun finishMetrics() {
        val result = pendingMetricsResult ?: return
        metricsTimeout?.let { mainHandler.removeCallbacks(it) }
        metricsTimeout = null
        pendingMetricsResult = null
        Log.d(
            TAG,
            "BLE metrics finished; history=${historyData.mapValues { it.value.size }}",
        )
        result.success(metricsPayload())
    }

    private fun failProfileSync(code: String, message: String) {
        val result = pendingProfileSyncResult ?: return
        profileSyncTimeout?.let { mainHandler.removeCallbacks(it) }
        profileSyncTimeout = null
        pendingProfileSyncResult = null
        result.error(code, message, null)
    }

    private fun finishProfileSync() {
        val result = pendingProfileSyncResult ?: return
        profileSyncTimeout?.let { mainHandler.removeCallbacks(it) }
        profileSyncTimeout = null
        pendingProfileSyncResult = null
        result.success(null)
    }

    private fun startRealtimeStep() {
        if (realtimeStepActive || !connectionReady) return
        realtimeStepActive = true
        enqueueCommands(listOf(BleSDK.RealTimeStep(true, true)))
    }

    private fun startHeartMeasurement() {
        if (heartMeasurementActive || !connectionReady) return
        heartMeasurementActive = true
        triggerRealtimeMeasurements()
        scheduleMeasurementLoop()
    }

    private fun scheduleMeasurementLoop() {
        measurementLoopRunnable?.let { mainHandler.removeCallbacks(it) }
        measurementLoopRunnable =
            Runnable {
                if (!connectionReady) return@Runnable
                triggerRealtimeMeasurements()
                scheduleMeasurementLoop()
            }.also {
                mainHandler.postDelayed(it, HEART_MEASUREMENT_INTERVAL_MS)
            }
    }

    private fun triggerRealtimeMeasurements() {
        if (ecgActive) return
        enqueueCommands(
            listOf(
                BleSDK.SetDeviceMeasurementWithType(
                    AutoTestMode.AutoHeartRate,
                    HEART_MEASUREMENT_SECONDS,
                    true,
                ),
                BleSDK.SetDeviceMeasurementWithType(
                    AutoTestMode.AutoSpo2,
                    HEART_MEASUREMENT_SECONDS,
                    true,
                ),
            ),
        )
    }

    private fun pushRealtimeUpdate(source: String) {
        val payload =
            metricsPayload().toMutableMap().apply {
                this["event"] = source
            }
        onRealtimeEvent?.invoke(payload)
    }

    private fun currentDeviceMap(): Map<String, Any?> {
        val device = currentDevice
        return mapOf(
            "id" to (device?.id ?: ""),
            "name" to (device?.name ?: "JStyle Band"),
            "batteryLevel" to batteryLevel,
            "lastSyncLabel" to "Connected",
            "signalStrength" to (device?.signalStrength ?: 0),
            "isPaired" to (device?.isPaired ?: false),
        )
    }

    private fun metricsMap(): Map<String, Any> =
        mapOf(
            "steps" to steps,
            "heartRate" to heartRate,
            "sleepHours" to sleepHours,
            "calories" to calories,
            "bloodOxygen" to bloodOxygen,
            "batteryLevel" to batteryLevel,
            "distance" to distance,
            "temperature" to temperature,
            "hrv" to hrv,
            "stress" to stress,
            "highBloodPressure" to highBloodPressure,
            "lowBloodPressure" to lowBloodPressure,
            "vascularAging" to vascularAging,
            "exerciseTime" to exerciseTime,
            "exerciseMinutes" to exerciseMinutes,
            "chargingState" to chargingState,
            "voltageValue" to voltageValue,
        )

    private fun metricsPayload(): Map<String, Any?> =
        mapOf(
            "steps" to steps,
            "heartRate" to heartRate,
            "sleepHours" to sleepHours,
            "calories" to calories,
            "bloodOxygen" to bloodOxygen,
            "batteryLevel" to batteryLevel,
            "distance" to distance,
            "temperature" to temperature,
            "hrv" to hrv,
            "stress" to stress,
            "highBloodPressure" to highBloodPressure,
            "lowBloodPressure" to lowBloodPressure,
            "vascularAging" to vascularAging,
            "exerciseTime" to exerciseTime,
            "exerciseMinutes" to exerciseMinutes,
            "syncedAt" to System.currentTimeMillis().toString(),
            "device" to currentDeviceMap(),
            "metrics" to metricsMap(),
            "deviceInfo" to deviceInfo.toMap(),
            "realtime" to latestRealtime.toMap(),
            "activityMode" to activityModeStatus.toMap(),
            "history" to historyData.mapValues { it.value.toList() },
            "rawByType" to rawDataByType.toMap(),
        )

    private fun storeDeviceInfo(
        key: String,
        maps: Map<String, Any>,
    ) {
        deviceInfo[key] = normalizeValue(maps[DeviceKey.Data])
    }

    private fun storeAutomaticConfig(maps: Map<String, Any>) {
        val payload = payloadMap(maps)
        val configKey = when (payload.intValue(DeviceKey.WorkMode)) {
            1 -> "autoHeartRate"
            2 -> "autoSpo2"
            3 -> "autoTemperature"
            4 -> "autoHrv"
            else -> "automatic"
        }
        deviceInfo[configKey] = payload
    }

    private fun storeHistory(
        key: String,
        maps: Map<String, Any>,
    ): List<Map<String, Any?>> {
        val records = maps.records().map(::normalizeMap)
        if (records.isEmpty()) return emptyList()

        val bucket = historyData.getOrPut(key) { mutableListOf() }
        records.forEach { record ->
            val recordKey = record[DeviceKey.Date]?.toString() ?: record.toString()
            val index = bucket.indexOfFirst {
                (it[DeviceKey.Date]?.toString() ?: it.toString()) == recordKey
            }
            if (index >= 0) {
                bucket[index] = record
            } else {
                bucket.add(record)
            }
        }
        return records
    }

    private fun payloadMap(maps: Map<String, Any>): Map<String, Any?> {
        val payload = maps[DeviceKey.Data]
        return when (payload) {
            is Map<*, *> -> normalizeMap(payload)
            is List<*> -> payload.filterIsInstance<Map<*, *>>().firstOrNull()?.let(::normalizeMap)
                ?: emptyMap()
            else -> emptyMap()
        }
    }

    private fun normalizeMap(map: Map<*, *>): Map<String, Any?> =
        map.entries.associate { (key, value) ->
            key.toString() to normalizeValue(value)
        }

    private fun normalizeValue(value: Any?): Any? {
        return when (value) {
            null -> null
            is String -> value
            is Boolean -> value
            is Int -> value
            is Long -> value
            is Double -> value
            is Float -> value.toDouble()
            is Short -> value.toInt()
            is Byte -> value.toInt()
            is Number -> value.toDouble()
            is Map<*, *> -> normalizeMap(value)
            is Iterable<*> -> value.map(::normalizeValue).toList()
            is Array<*> -> value.map(::normalizeValue)
            else -> value.toString()
        }
    }

    private fun resetMetrics() {
        steps = 0
        heartRate = 0
        sleepHours = 0.0
        calories = 0
        bloodOxygen = 0
        batteryLevel = 0
        distance = 0.0
        temperature = 0.0
        hrv = 0
        stress = 0
        highBloodPressure = 0
        lowBloodPressure = 0
        vascularAging = 0
        exerciseTime = 0
        exerciseMinutes = 0
        chargingState = 0
        voltageValue = 0
        deviceInfo.clear()
        latestRealtime.clear()
        activityModeStatus.clear()
        historyData.clear()
        rawDataByType.clear()
    }

    @SuppressLint("MissingPermission")
    private fun clearGatt(gatt: BluetoothGatt? = currentGatt) {
        try {
            gatt?.close()
        } catch (error: RuntimeException) {
            Log.w(TAG, "Unable to close GATT.", error)
        }

        if (gatt == null || gatt == currentGatt) {
            clearConnectionState()
        }
    }

    private fun clearConnectionState() {
        if (ecgActive) {
            ecgActive = false
            onEcgEvent?.invoke(mapOf("event" to "ecg_failed", "message" to "Band disconnected."))
        }
        ecgFinishRunnable?.let { mainHandler.removeCallbacks(it) }
        ecgFinishRunnable = null
        measurementLoopRunnable?.let { mainHandler.removeCallbacks(it) }
        measurementLoopRunnable = null
        currentGatt = null
        writeCharacteristic = null
        notifyCharacteristic = null
        currentDevice = null
        connectionReady = false
        isWriting = false
        writeQueue.clear()
        realtimeStepActive = false
        heartMeasurementActive = false
    }

    private fun ensureBluetoothAvailable(result: MethodChannel.Result): Boolean {
        val adapter = bluetoothAdapter
        if (adapter == null) {
            result.error("bluetooth_unavailable", "Bluetooth is not available on this device.", null)
            return false
        }
        if (!adapter.isEnabled) {
            result.error("bluetooth_off", "Bluetooth is disabled.", null)
            return false
        }
        return true
    }

    private fun ensureScanPermission(result: MethodChannel.Result): Boolean {
        if (hasScanPermission()) return true
        result.error("permission_denied", "Bluetooth scan permission is required.", null)
        return false
    }

    private fun ensureConnectPermission(result: MethodChannel.Result): Boolean {
        if (hasConnectPermission()) return true
        result.error("permission_denied", "Bluetooth connect permission is required.", null)
        return false
    }

    private fun hasScanPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            hasPermission(Manifest.permission.BLUETOOTH_SCAN)
        } else {
            hasPermission(Manifest.permission.ACCESS_FINE_LOCATION)
        }
    }

    private fun hasConnectPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.S ||
            hasPermission(Manifest.permission.BLUETOOTH_CONNECT)
    }

    private fun hasPermission(permission: String): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M ||
            appContext.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED
    }

    @SuppressLint("MissingPermission")
    private fun BluetoothDevice.toRecord(
        rssi: Int,
        advertisedName: String? = null,
    ): DeviceRecord {
        val safeName =
            try {
                advertisedName?.takeIf { it.isNotBlank() } ?: name
            } catch (error: SecurityException) {
                advertisedName
            }.orEmpty()

        val address =
            try {
                this.address
            } catch (error: SecurityException) {
                ""
            }

        val displayName = safeName.trim()

        val paired =
            try {
                bondState == BluetoothDevice.BOND_BONDED
            } catch (error: SecurityException) {
                false
            }

        return DeviceRecord(
            id = address,
            name = displayName,
            signalStrength = rssi,
            isPaired = paired,
        )
    }

    private fun Iterable<DeviceRecord>.sortedForDisplay(): List<DeviceRecord> =
        sortedWith(
            compareByDescending<DeviceRecord> { it.isPaired }
                .thenByDescending { it.signalStrength },
        )

    private fun Map<String, Any>.records(): List<Map<*, *>> {
        val payload = this[DeviceKey.Data]
        return when (payload) {
            is List<*> -> payload.filterIsInstance<Map<*, *>>()
            is Map<*, *> -> listOf(payload)
            else -> emptyList()
        }
    }

    private fun Map<*, *>?.intValue(key: String): Int? {
        val value = this?.get(key) ?: return null
        return when (value) {
            is Number -> value.toDouble().roundToInt()
            is String -> value.replace(",", "").toDoubleOrNull()?.roundToInt()
            else -> null
        }
    }

    private fun Map<*, *>?.doubleValue(key: String): Double? {
        val value = this?.get(key) ?: return null
        return when (value) {
            is Number -> value.toDouble()
            is String -> value.replace(",", "").toDoubleOrNull()
            else -> null
        }
    }

    private fun Map<String, Any?>.profileInt(key: String): Int? {
        val value = this[key] ?: return null
        return when (value) {
            is Number -> value.toDouble().roundToInt()
            is String -> value.trim().toDoubleOrNull()?.roundToInt()
            else -> null
        }
    }

    private fun Map<*, *>?.tokens(key: String): List<String> {
        val value = this?.get(key)?.toString().orEmpty()
        return value
            .split(Regex("[\\s,\\[\\]]+"))
            .filter { it.isNotBlank() }
    }

    private fun Map<String, Any>.dataEnded(): Boolean {
        val value = this[DeviceKey.End]
        return when (value) {
            is Boolean -> value
            is String -> value.equals("true", ignoreCase = true)
            is Number -> value.toInt() != 0
            else -> false
        }
    }

    private data class DeviceRecord(
        val id: String,
        val name: String,
        val signalStrength: Int,
        val isPaired: Boolean,
    ) {
        fun shouldKeep(): Boolean {
            val normalizedName = name.trim()
            return id.isNotBlank() &&
                normalizedName.isNotBlank() &&
                !normalizedName.startsWith("Unknown Device", ignoreCase = true) &&
                !normalizedName.equals("Unknown", ignoreCase = true)
        }

        fun toMap(): Map<String, Any?> =
            mapOf(
                "id" to id,
                "name" to name,
                "batteryLevel" to 0,
                "lastSyncLabel" to if (isPaired) "Paired" else "Available",
                "signalStrength" to signalStrength,
                "isPaired" to isPaired,
            )

        companion object {
            const val NO_RSSI = -127
        }
    }

    companion object {
        private const val TAG = "JStyleBleController"
        private const val SCAN_DURATION_MS = 8000L
        private const val CONNECT_TIMEOUT_MS = 18000L
        // A history read can involve many 2-hour sleep packets. 20 seconds is
        // often not enough for the band to finish after the other sync
        // commands, especially on its first connection of the day.
        private const val METRICS_TIMEOUT_MS = 60000L
        private const val CLOSE_DELAY_MS = 500L
        private const val COMMAND_WRITE_GAP_MS = 180L
        private const val HEART_MEASUREMENT_SECONDS = 35L
        private const val HEART_MEASUREMENT_INTERVAL_MS = 45000L
        private const val MIN_ECG_SECONDS = 30
        // The Android V8 command stores duration in two bytes of milliseconds.
        // Keep this at 60 seconds so it cannot overflow the vendor protocol.
        private const val MAX_ECG_SECONDS = 60
        private const val ECG_FINISH_GRACE_MS = 2000L
        private const val PROFILE_SYNC_TIMEOUT_MS = 20000L
        private const val DEFAULT_SLEEP_UNIT_MINUTES = 5
        private const val MINUTES_PER_HOUR = 60.0
        private const val READ_START: Byte = 0x00
        private const val READ_CONTINUE: Byte = 0x02
        private const val SLEEP_HISTORY_BATCH_SIZE = 50
        private const val HEART_RATE_HISTORY_BATCH_SIZE = 50

        private val DATA_SERVICE_UUID: UUID =
            UUID.fromString("0000fff0-0000-1000-8000-00805f9b34fb")
        private val WRITE_CHARACTERISTIC_UUID: UUID =
            UUID.fromString("0000fff6-0000-1000-8000-00805f9b34fb")
        private val NOTIFY_CHARACTERISTIC_UUID: UUID =
            UUID.fromString("0000fff7-0000-1000-8000-00805f9b34fb")
        private val CLIENT_CHARACTERISTIC_CONFIG_UUID: UUID =
            UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
    }
}
