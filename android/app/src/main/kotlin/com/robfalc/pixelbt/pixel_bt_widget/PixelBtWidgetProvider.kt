package com.robfalc.pixelbt.pixel_bt_widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews

/**
 * PixelBtWidgetProvider handles the app widget functionality for Pixel Bluetooth Widget.
 * It manages widget updates, handles click events, and coordinates with the Bluetooth system.
 */
class PixelBtWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Update each widget
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            ACTION_BLUETOOTH_TOGGLE -> {
                handleBluetoothToggle(context)
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

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val sharedPreferences = context.getSharedPreferences(
                "pixel_bt_widget_prefs",
                Context.MODE_PRIVATE
            )

            // Get current device state
            val deviceName = sharedPreferences.getString("selected_device_name", "No device")
                ?: "No device"
            val isEnabled = sharedPreferences.getBoolean("device_enabled", false)
            val deviceAddress = sharedPreferences.getString("selected_device_address", "")
                ?: ""

            // Create RemoteViews
            val remoteViews = RemoteViews(context.packageName, R.layout.pixel_bt_widget_layout)

            // Update title
            remoteViews.setTextViewText(
                R.id.widget_title,
                "Pixel Bluetooth"
            )

            // Update device status display
            val statusText = if (deviceAddress.isEmpty()) {
                "No device selected"
            } else {
                "$deviceName\n${if (isEnabled) "Connected" else "Disconnected"}"
            }

            remoteViews.setTextViewText(R.id.device_status, statusText)

            // Set the text color based on connection status
            val textColor = if (isEnabled) 0xFF4CAF50.toInt() else 0xFFB3B3B3.toInt()
            remoteViews.setTextColor(R.id.device_status, textColor)

            // Set click listener for toggle
            val toggleIntent = Intent(context, PixelBtWidgetProvider::class.java).apply {
                action = ACTION_BLUETOOTH_TOGGLE
                putExtra("device_address", deviceAddress)
                putExtra("device_name", deviceName)
            }

            val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                android.app.PendingIntent.getBroadcast(
                    context,
                    deviceAddress.hashCode(),
                    toggleIntent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
                )
            } else {
                @Suppress("DEPRECATION")
                android.app.PendingIntent.getBroadcast(
                    context,
                    deviceAddress.hashCode(),
                    toggleIntent,
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT
                )
            }

            remoteViews.setOnClickPendingIntent(R.id.device_container, pendingIntent)

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, remoteViews)
        }

        private fun handleBluetoothToggle(context: Context) {
            val sharedPreferences = context.getSharedPreferences(
                "pixel_bt_widget_prefs",
                Context.MODE_PRIVATE
            )

            val deviceAddress = sharedPreferences.getString("selected_device_address", "")
                ?: ""
            val deviceName = sharedPreferences.getString("selected_device_name", "Unknown")
                ?: "Unknown"
            val isCurrentlyEnabled = sharedPreferences.getBoolean("device_enabled", false)

            // Toggle the state
            val newState = !isCurrentlyEnabled

            // Save the new state
            sharedPreferences.edit().apply {
                putBoolean("device_enabled", newState)
                apply()
            }

            // Notify widget update
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, PixelBtWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }

            // TODO: Here you would typically trigger the actual Bluetooth connection/disconnection
            // This could be done through a service, WorkManager, or direct Bluetooth API calls
            // For now, this is just a UI update with state persistence
        }
    }
}
