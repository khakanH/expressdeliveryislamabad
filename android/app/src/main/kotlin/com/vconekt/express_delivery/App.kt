package com.vconekt.express_delivery

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.*
import android.os.Build
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            val background_channel = NotificationChannel("background_channel", "background", IMPORTANCE_LOW)
            val notification_channel = NotificationChannel("notification_channel", "notification", IMPORTANCE_HIGH)
            notification_channel.enableVibration(true)
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(background_channel)
            manager.createNotificationChannel(notification_channel)
        }
    }
}