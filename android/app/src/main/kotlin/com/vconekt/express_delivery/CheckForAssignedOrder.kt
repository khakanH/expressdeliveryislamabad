package com.vconekt.express_delivery

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.FirebaseFirestore
import io.flutter.plugins.firebase.auth.Constants

class CheckForAssignedOrder : Service() {
    override fun onCreate() {
        super.onCreate()
        val notificationManager: NotificationManagerCompat = NotificationManagerCompat.from(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            val builder = NotificationCompat.Builder(this, "background_channel")
                    .setContentText("Looking for new order assigned to you.")
                    .setContentTitle("Express Delivery")
                    .setSmallIcon(R.mipmap.ic_launcher)
            startForeground(101, builder.build())
        }

        // Access a Cloud Firestore instance from your Activity
        val db: FirebaseFirestore = FirebaseFirestore.getInstance()

        db.collection("orders")
                .whereEqualTo("riderPhoneNum", FirebaseAuth.getInstance().currentUser?.phoneNumber)
                .whereEqualTo("status", "assigned")
                .addSnapshotListener { value, e ->
                    if (e != null) {
                        Log.w(Constants.TAG, "Listen failed.", e)
                        return@addSnapshotListener
                    }

                    for (doc in value!!) {
                        val builder = NotificationCompat.Builder(this, "notification_channel")
                                .setContentText("Visit App.")
                                .setContentTitle("New Order")
                                .setSmallIcon(R.mipmap.ic_launcher)
                                .build()
//                        startForeground(102, builder.build())
                        notificationManager.notify(313, builder)

                    }

                }

    }
    override fun onBind(intent: Intent?): IBinder? {
        TODO("listen for assigned order")
    }
}