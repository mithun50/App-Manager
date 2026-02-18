package com.idtl.appmanagement

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.idtl.appmanagement/usage_stats"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val usageStatsHelper = UsageStatsHelper(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isPermissionGranted" -> {
                        result.success(usageStatsHelper.isPermissionGranted())
                    }

                    "requestPermission" -> {
                        startActivity(usageStatsHelper.getRequestPermissionIntent())
                        result.success(null)
                    }

                    "getUsageStats" -> {
                        val startTime = call.argument<Long>("startTime")
                        val endTime = call.argument<Long>("endTime")
                        if (startTime == null || endTime == null) {
                            result.error("INVALID_ARGS", "startTime and endTime required", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val stats = usageStatsHelper.getUsageStats(startTime, endTime)
                            result.success(stats)
                        } catch (e: Exception) {
                            result.error("USAGE_STATS_ERROR", e.message, null)
                        }
                    }

                    "getInstalledApps" -> {
                        try {
                            val apps = usageStatsHelper.getInstalledApps()
                            result.success(apps)
                        } catch (e: Exception) {
                            result.error("INSTALLED_APPS_ERROR", e.message, null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
