package com.vconekt.express_delivery

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.firestore.FirebaseFirestore
import io.flutter.plugins.firebase.auth.Constants.TAG

class CheckForNewOrder : Service() {

    override fun onCreate() {
        super.onCreate()
        val notificationManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val builder = NotificationCompat.Builder(this, "background_channel")
                    .setContentText("Looking for new orders to notify you.")
                    .setContentTitle("Express Delivery")
                    .setSmallIcon(R.mipmap.ic_launcher)
            startForeground(101, builder.build())
        }

        // Access a Cloud Firestore instance from your Activity
        val db: FirebaseFirestore = FirebaseFirestore.getInstance()
        db.collection("orders")
                .whereEqualTo("status", "pending")
                .addSnapshotListener { value, e ->
                    if (e != null) {
                        Log.w(TAG, "Listen failed.", e)
                        return@addSnapshotListener
                    }

                    for (doc in value!!) {
                        val builder = NotificationCompat.Builder(this, "notification_channel")
                                .setContentText("Visit App.")
                                .setContentTitle("New Order")
                                .setSmallIcon(R.mipmap.ic_launcher)
                                .build()
//                        startForeground(102, builder.build())
                        notificationManager.notify(110, builder)

                    }

                }
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("check for new order")
    }
}