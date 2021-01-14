package com.vconekt.express_delivery

import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
//
//    private forNewOrderService : Intent(this@MainActivity, MyService::class.java)
//
//    private forNewAssignedOrderService: Intent

    private val CHANNEL = "com.vconekt.express_delivery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        var forNewOrderService = Intent(applicationContext, CheckForNewOrder::class.java)
        var forNewAssignedOrderService = Intent(this@MainActivity, CheckForAssignedOrder::class.java)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startNewOrderService") {
                startNewOrderService(forNewOrderService)
                result.success("NewOrderService Started")
            }
            else if (call.method == "stopNewOrderService") {
                stopNewOrderService(forNewOrderService)
                result.success("stopNewOrderService Called")
            }
            // assigned order headache
            else if (call.method == "startNewAssignedOrderService") {
                startAssignedOrderService(forNewAssignedOrderService)
                result.success("startNewAssignedOrderService Started")
            }
            else if (call.method == "stopAssignedOrderService") {
                stopAssignedOrderService(forNewAssignedOrderService)
                result.success("stopAssignedOrderService Called")
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun startAssignedOrderService(forNewAssignedOrderService: Intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(forNewAssignedOrderService)
        } else {
            startService(forNewAssignedOrderService)
        }
    }

    private fun stopAssignedOrderService(forNewAssignedOrderService: Intent) {
        stopService(forNewAssignedOrderService);
    }

    private fun startNewOrderService(forNewOrderService: Intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(forNewOrderService)
        } else {
            startService(forNewOrderService)
        }
    }

    private fun stopNewOrderService(forNewOrderService: Intent) {
        stopService(forNewOrderService);
    }


}
