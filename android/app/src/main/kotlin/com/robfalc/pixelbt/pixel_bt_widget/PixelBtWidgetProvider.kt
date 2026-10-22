package com.robfalc.pixelbt.pixel_bt_widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

/**
 * PixelBtWidgetProvider handles the app widget functionality for Pixel Bluetooth Widget.
 * It manages widget updates, handles click events, and coordinates with the Bluetooth system.
 *
 * Features:
 * - Displays configured Bluetooth devices with connection status
 * - Supports multiple favorite/active devices
 * - One-tap toggle via PendingIntent with instantaneous visual feedback
 * - Graceful fallback when no devices are configured (directs user to configure)
 */
class PixelBtWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Update each widget instance
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            ACTION_BLUETOOTH_TOGGLE -> {
                handleBluetoothToggle(context, intent)
            }
            AppWidgetManager.ACTION_APPWIDGET_UPDATE -> {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = ComponentName(context, PixelBtWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                onUpdate(context, appWidgetManager, appWidgetIds)
            }
        }
    }

    companion object {
        private const val ACTION_BLUETOOTH_TOGGLE = "com.robfalc.pixelbt.BLUETOOTH_TOGGLE"
        private const val PREFS_NAME = "pixel_bt_widget_prefs"
        private const val KEY_DEVICES = "pixel_widget_devices"

        private val gson = Gson()

        /**
         * Updates the widget UI based on the current device configuration.
         * If no devices are configured, shows setup instruction.
         * If devices exist, displays active/favorite devices with connection status.
         */
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val remoteViews = RemoteViews(context.packageName, R.layout.pixel_bt_widget_layout)

            // Load configured devices from SharedPreferences
            val devicesJson = sharedPreferences.getString(KEY_DEVICES, null)
            val devices = parseDevices(devicesJson)

            // Filter for favorite/active devices
            val favoriteDevices = devices.filter { it.isFavorite }.sortedBy { it.priorityOrder }

            if (favoriteDevices.isEmpty()) {
                // No devices configured yet - show setup instruction
                setupNoDevicesView(context, remoteViews)
            } else {
                // Display favorite devices
                setupDevicesView(context, remoteViews, favoriteDevices)
            }

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
        }

        /**
         * Handles Bluetooth toggle action from widget button.
         * Toggles the device state in SharedPreferences and immediately updates the RemoteViews.
         */
        private fun handleBluetoothToggle(context: Context, intent: Intent) {
            val deviceAddress = intent.getStringExtra("device_address") ?: return
            val deviceName = intent.getStringExtra("device_name") ?: "Unknown"

            val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            // Load current devices
            val devicesJson = sharedPreferences.getString(KEY_DEVICES, null)
            val devices = parseDevices(devicesJson).toMutableList()

            // Find and toggle the device
            val targetDevice = devices.find { it.macAddress == deviceAddress }
            if (targetDevice != null) {
                val index = devices.indexOf(targetDevice)
                val updatedDevice = targetDevice.copy(isConnected = !targetDevice.isConnected)
                devices[index] = updatedDevice

                // Save updated devices back to SharedPreferences
                val updatedJson = gson.toJson(devices)
                sharedPreferences.edit().apply {
                    putString(KEY_DEVICES, updatedJson)
                    apply()
                }

                // Immediate visual feedback: update all widgets without waiting for system update
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = ComponentName(context, PixelBtWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

                for (appWidgetId in appWidgetIds) {
                    updateAppWidget(context, appWidgetManager, appWidgetId)
                }

                // TODO: Trigger actual Bluetooth connection/disconnection via BluetoothAdapter
                // This would be handled through a service, WorkManager, or Bluetooth API
            }
        }

        /**
         * Sets up the widget view when no devices are configured.
         * Shows title and instruction text, with PendingIntent to launch MainActivity for setup.
         */
        private fun setupNoDevicesView(context: Context, remoteViews: RemoteViews) {
            remoteViews.setViewVisibility(R.id.txt_empty_guide, View.VISIBLE)
            remoteViews.setTextViewText(R.id.txt_empty_guide, "Tocca per aprire Pixel Studio e configurare i tuoi device")

            // Hide all 4 slot buttons
            remoteViews.setViewVisibility(R.id.btn_device_1, View.GONE)
            remoteViews.setViewVisibility(R.id.btn_device_2, View.GONE)
            remoteViews.setViewVisibility(R.id.btn_device_3, View.GONE)
            remoteViews.setViewVisibility(R.id.btn_device_4, View.GONE)

            // Set PendingIntent on txt_empty_guide to open MainActivity
            val setupIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = createPendingIntent(context, setupIntent, 0)
            remoteViews.setOnClickPendingIntent(R.id.txt_empty_guide, pendingIntent)
        }

        /**
         * Sets up the widget view with configured favorite devices.
         * Displays up to 4 device slots with name, icon representation, and connection status.
         */
        private fun setupDevicesView(
            context: Context,
            remoteViews: RemoteViews,
            devices: List<DeviceData>
        ) {
            remoteViews.setViewVisibility(R.id.txt_empty_guide, View.GONE)

            val btnIds = intArrayOf(R.id.btn_device_1, R.id.btn_device_2, R.id.btn_device_3, R.id.btn_device_4)
            val txtIds = intArrayOf(R.id.txt_device_1, R.id.txt_device_2, R.id.txt_device_3, R.id.txt_device_4)
            val statusIds = intArrayOf(R.id.status_device_1, R.id.status_device_2, R.id.status_device_3, R.id.status_device_4)

            for (i in 0 until 4) {
                if (i < devices.size) {
                    val dev = devices[i]
                    remoteViews.setViewVisibility(btnIds[i], View.VISIBLE)

                    val name = dev.customName?.takeIf { it.isNotEmpty() } ?: dev.name
                    remoteViews.setTextViewText(txtIds[i], name)

                    remoteViews.setTextViewText(statusIds[i], if (dev.isConnected) "●" else "○")
                    remoteViews.setTextColor(statusIds[i], if (dev.isConnected) 0xFFFFFFFF.toInt() else 0xFF8E8E8E.toInt())

                    // Set PendingIntent on button with ACTION_BLUETOOTH_TOGGLE
                    val toggleIntent = Intent(context, PixelBtWidgetProvider::class.java).apply {
                        action = ACTION_BLUETOOTH_TOGGLE
                        putExtra("device_address", dev.macAddress)
                        putExtra("device_name", dev.name)
                    }
                    val pendingIntent = createPendingIntent(
                        context,
                        toggleIntent,
                        dev.macAddress.hashCode()
                    )
                    remoteViews.setOnClickPendingIntent(btnIds[i], pendingIntent)
                } else {
                    remoteViews.setViewVisibility(btnIds[i], View.GONE)
                }
            }
        }

        /**
         * Helper function to create a PendingIntent with appropriate flags for the API level.
         */
        private fun createPendingIntent(
            context: Context,
            intent: Intent,
            requestCode: Int
        ): android.app.PendingIntent {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                android.app.PendingIntent.getBroadcast(
                    context,
                    requestCode,
                    intent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                )
            } else {
                @Suppress("DEPRECATION")
                android.app.PendingIntent.getBroadcast(
                    context,
                    requestCode,
                    intent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT
                )
            }
        }

        /**
         * Parses device JSON from SharedPreferences.
         * Returns an empty list if parsing fails or no devices are stored.
         */
        private fun parseDevices(devicesJson: String?): List<DeviceData> {
            return try {
                if (devicesJson.isNullOrEmpty()) return emptyList()
                val type = object : TypeToken<List<DeviceData>>() {}.type
                gson.fromJson(devicesJson, type)
            } catch (e: Exception) {
                emptyList()
            }
        }

        /**
         * Data class representing a Bluetooth device as stored in SharedPreferences.
         * Mirrors the BtDeviceItem structure from the Flutter app.
         */
        data class DeviceData(
            val id: String,
            val macAddress: String,
            val name: String,
            val customName: String? = null,
            val iconType: String = "generic",
            val isFavorite: Boolean = false,
            val isConnected: Boolean = false,
            val isConnecting: Boolean = false,
            val priorityOrder: Int = 0
        )
    }
}
