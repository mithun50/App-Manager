class AppConstants {
  AppConstants._();

  static const String channelName = 'com.idtl.appmanagement/usage_stats';
  static const String dbName = 'app_management.db';
  static const int dbVersion = 1;

  static const String warningChannelId = 'usage_warnings';
  static const String warningChannelName = 'Usage Warnings';
  static const String summaryChannelId = 'daily_summary';
  static const String summaryChannelName = 'Daily Summary';

  static const String backgroundTaskName = 'usageLimitCheck';
  static const Duration pollingInterval = Duration(seconds: 30);
  static const Duration backgroundInterval = Duration(minutes: 15);

  static const double warningThreshold = 0.8;
  static const double limitThreshold = 1.0;

  static const String prefThemeMode = 'theme_mode';
  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefWarningThreshold = 'warning_threshold';
}
