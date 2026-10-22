package com.robfalc.pixelbt.pixel_bt_widget

import android.appwidget.AppWidgetManager
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.ComponentName
import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.robfalc.pixelbt/bluetooth"
    }

    private lateinit var methodChannel: MethodChannel
    private lateinit var sharedPreferences: SharedPreferences

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize SharedPreferences
        sharedPreferences = getSharedPreferences("pixel_bt_widget_prefs", Context.MODE_PRIVATE)

        // Set up MethodChannel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getBondedDevices" -> {
                    result.success(getBondedDevices())
                }
                "toggleDevice" -> {
                    val deviceAddress = call.argument<String>("address")
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    if (deviceAddress != null) {
                        toggleDevice(deviceAddress, enabled)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Device address is null", null)
                    }
                }
                "updateWidget" -> {
                    val deviceAddress = call.argument<String>("address")
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    val deviceName = call.argument<String>("name") ?: "Unknown"
                    if (deviceAddress != null) {
                        updateWidgetData(deviceAddress, enabled, deviceName)
                        notifyWidgetUpdate()
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Device address is null", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getBondedDevices(): List<Map<String, String>> {
        val bluetoothManager = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            getSystemService(BluetoothManager::class.java)
        } else {
            @Suppress("DEPRECATION")
            null
        }

        val bluetoothAdapter = if (bluetoothManager != null) {
            bluetoothManager.adapter
        } else {
            @Suppress("DEPRECATION")
            BluetoothAdapter.getDefaultAdapter()
        }

        val devices = mutableListOf<Map<String, String>>()

        if (bluetoothAdapter != null) {
            val bondedDevices = bluetoothAdapter.bondedDevices
            for (device in bondedDevices) {
                devices.add(
                    mapOf(
                        "name" to (device.name ?: "Unknown"),
                        "address" to device.address
                    )
                )
            }
        }

        return devices
    }

    private fun toggleDevice(deviceAddress: String, enabled: Boolean) {
        // This is a placeholder for actual Bluetooth connection toggle logic
        // In practice, you would connect/disconnect from the device here
        // For now, we just store the state in SharedPreferences
        saveDeviceState(deviceAddress, enabled)
    }

    private fun updateWidgetData(deviceAddress: String, enabled: Boolean, deviceName: String) {
        sharedPreferences.edit().apply {
            putString("selected_device_address", deviceAddress)
            putString("selected_device_name", deviceName)
            putBoolean("device_enabled", enabled)
            apply()
        }
    }

    private fun saveDeviceState(deviceAddress: String, enabled: Boolean) {
        sharedPreferences.edit().apply {
            putString("selected_device_address", deviceAddress)
            putBoolean("device_enabled", enabled)
            apply()
        }
    }

    private fun notifyWidgetUpdate() {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val componentName = ComponentName(this, PixelBtWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
        if (appWidgetIds.isNotEmpty()) {
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, 0)
        }
    }
}
