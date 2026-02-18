package com.idtl.appmanagement

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import android.app.AppOpsManager
import android.content.Intent
import android.os.Process
import android.provider.Settings

class UsageStatsHelper(private val context: Context) {

    private val usageStatsManager =
        context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
    private val packageManager = context.packageManager

    fun isPermissionGranted(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.unsafeCheckOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            context.packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun getRequestPermissionIntent(): Intent {
        return Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
    }

    fun getUsageStats(startTime: Long, endTime: Long): List<Map<String, Any>> {
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, startTime, endTime
        )

        val categoryMapper = AppCategoryMapper(context)
        val result = mutableListOf<Map<String, Any>>()

        for (stat in stats) {
            if (stat.totalTimeInForeground <= 0) continue

            val packageName = stat.packageName
            val appName = getAppName(packageName) ?: continue
            val usageMinutes = (stat.totalTimeInForeground / 60000).toInt()
            val categoryId = categoryMapper.getCategoryId(packageName)

            result.add(
                mapOf(
                    "packageName" to packageName,
                    "appName" to appName,
                    "usageMinutes" to usageMinutes,
                    "categoryId" to categoryId
                )
            )
        }

        return result.sortedByDescending { it["usageMinutes"] as Int }
    }

    fun getInstalledApps(): List<Map<String, Any>> {
        val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val resolveInfos = packageManager.queryIntentActivities(intent, 0)

        return resolveInfos.mapNotNull { resolveInfo ->
            val packageName = resolveInfo.activityInfo.packageName
            val appName = resolveInfo.loadLabel(packageManager).toString()
            mapOf(
                "packageName" to packageName,
                "appName" to appName
            )
        }.distinctBy { it["packageName"] }
    }

    private fun getAppName(packageName: String): String? {
        return try {
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (e: PackageManager.NameNotFoundException) {
            null
        }
    }
}
