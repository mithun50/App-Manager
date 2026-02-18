package com.idtl.appmanagement

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build

class AppCategoryMapper(private val context: Context) {

    // Category IDs match the default categories seeded in sqflite (1-indexed)
    companion object {
        const val SOCIAL_MEDIA = 1
        const val GAMES = 2
        const val PRODUCTIVITY = 3
        const val ENTERTAINMENT = 4
        const val COMMUNICATION = 5
        const val NEWS_READING = 6
        const val EDUCATION = 7
        const val OTHER = 8

        private val PACKAGE_CATEGORY_MAP = mapOf(
            // Social Media
            "com.facebook.katana" to SOCIAL_MEDIA,
            "com.facebook.lite" to SOCIAL_MEDIA,
            "com.instagram.android" to SOCIAL_MEDIA,
            "com.twitter.android" to SOCIAL_MEDIA,
            "com.zhiliaoapp.musically" to SOCIAL_MEDIA, // TikTok
            "com.snapchat.android" to SOCIAL_MEDIA,
            "com.pinterest" to SOCIAL_MEDIA,
            "com.reddit.frontpage" to SOCIAL_MEDIA,
            "com.linkedin.android" to SOCIAL_MEDIA,
            "in.mohalla.sharechat" to SOCIAL_MEDIA,

            // Games
            "com.supercell.clashofclans" to GAMES,
            "com.supercell.clashroyale" to GAMES,
            "com.kiloo.subwaysurf" to GAMES,
            "com.king.candycrushsaga" to GAMES,
            "com.mojang.minecraftpe" to GAMES,
            "com.pubg.imobile" to GAMES,
            "com.activision.callofduty.shooter" to GAMES,

            // Productivity
            "com.google.android.apps.docs" to PRODUCTIVITY,
            "com.google.android.apps.docs.editors.docs" to PRODUCTIVITY,
            "com.google.android.apps.docs.editors.sheets" to PRODUCTIVITY,
            "com.google.android.apps.docs.editors.slides" to PRODUCTIVITY,
            "com.microsoft.office.word" to PRODUCTIVITY,
            "com.microsoft.office.excel" to PRODUCTIVITY,
            "com.todoist" to PRODUCTIVITY,
            "com.ticktick.task" to PRODUCTIVITY,
            "notion.id" to PRODUCTIVITY,

            // Entertainment
            "com.google.android.youtube" to ENTERTAINMENT,
            "com.netflix.mediaclient" to ENTERTAINMENT,
            "com.amazon.avod.thirdpartyclient" to ENTERTAINMENT, // Prime Video
            "com.disney.disneyplus" to ENTERTAINMENT,
            "in.startv.hotstar" to ENTERTAINMENT,
            "com.spotify.music" to ENTERTAINMENT,
            "com.apple.android.music" to ENTERTAINMENT,

            // Communication
            "com.whatsapp" to COMMUNICATION,
            "org.telegram.messenger" to COMMUNICATION,
            "com.discord" to COMMUNICATION,
            "com.Slack" to COMMUNICATION,
            "com.google.android.apps.messaging" to COMMUNICATION,
            "com.skype.raider" to COMMUNICATION,
            "us.zoom.videomeetings" to COMMUNICATION,
            "com.google.android.apps.meet" to COMMUNICATION,

            // News & Reading
            "com.google.android.apps.magazines" to NEWS_READING,
            "flipboard.app" to NEWS_READING,
            "com.amazon.kindle" to NEWS_READING,
            "com.medium.reader" to NEWS_READING,
            "org.wikipedia" to NEWS_READING,

            // Education
            "com.duolingo" to EDUCATION,
            "com.google.android.apps.classroom" to EDUCATION,
            "com.byju" to EDUCATION,
            "com.khan.academy" to EDUCATION,
            "com.udemy.android" to EDUCATION,
        )
    }

    fun getCategoryId(packageName: String): Int {
        // Check hardcoded map first
        PACKAGE_CATEGORY_MAP[packageName]?.let { return it }

        // Try Android 8+ category API
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val appInfo = context.packageManager.getApplicationInfo(packageName, 0)
                return mapAndroidCategory(appInfo.category)
            } catch (_: PackageManager.NameNotFoundException) {}
        }

        return OTHER
    }

    private fun mapAndroidCategory(androidCategory: Int): Int {
        return when (androidCategory) {
            ApplicationInfo.CATEGORY_GAME -> GAMES
            ApplicationInfo.CATEGORY_AUDIO -> ENTERTAINMENT
            ApplicationInfo.CATEGORY_VIDEO -> ENTERTAINMENT
            ApplicationInfo.CATEGORY_IMAGE -> ENTERTAINMENT
            ApplicationInfo.CATEGORY_SOCIAL -> SOCIAL_MEDIA
            ApplicationInfo.CATEGORY_NEWS -> NEWS_READING
            ApplicationInfo.CATEGORY_MAPS -> PRODUCTIVITY
            ApplicationInfo.CATEGORY_PRODUCTIVITY -> PRODUCTIVITY
            else -> OTHER
        }
    }
}
