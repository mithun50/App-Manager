import 'package:flutter/services.dart';
import 'package:app_management/models/app_usage.dart';
import 'package:app_management/models/app_info.dart';
import 'package:app_management/utils/constants.dart';

class UsageStatsService {
  UsageStatsService._();
  static final UsageStatsService instance = UsageStatsService._();

  static const _channel = MethodChannel(AppConstants.channelName);

  Future<bool> isPermissionGranted() async {
    try {
      final result = await _channel.invokeMethod<bool>('isPermissionGranted');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> requestPermission() async {
    try {
      await _channel.invokeMethod('requestPermission');
    } on PlatformException {
      // User will navigate back after granting
    }
  }

  Future<List<AppUsage>> getUsageStats({
    required DateTime startTime,
    required DateTime endTime,
    required String date,
  }) async {
    try {
      final result = await _channel.invokeMethod<List>('getUsageStats', {
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      });

      if (result == null) return [];

      return result.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return AppUsage(
          packageName: map['packageName'] as String,
          appName: map['appName'] as String,
          categoryId: map['categoryId'] as int,
          usageMinutes: map['usageMinutes'] as int,
          date: date,
        );
      }).where((u) => u.usageMinutes > 0).toList();
    } on PlatformException {
      return [];
    }
  }

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final result = await _channel.invokeMethod<List>('getInstalledApps');
      if (result == null) return [];

      return result.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return AppInfo.fromMap(map);
      }).toList();
    } on PlatformException {
      return [];
    }
  }
}
