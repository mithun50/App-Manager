import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:app_management/models/app_usage.dart';
import 'package:app_management/models/daily_summary.dart';
import 'package:app_management/providers/category_provider.dart';
import 'package:app_management/services/database_service.dart';
import 'package:app_management/services/usage_stats_service.dart';
import 'package:app_management/services/notification_service.dart';
import 'package:app_management/utils/constants.dart';

class UsageProvider extends ChangeNotifier {
  Timer? _pollingTimer;

  bool _isLoading = false;
  bool _hasPermission = false;
  List<AppUsage> _todayUsage = [];
  List<DailySummary> _categorySummaries = [];
  int _totalMinutesToday = 0;

  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  List<AppUsage> get todayUsage => _todayUsage;
  List<DailySummary> get categorySummaries => _categorySummaries;
  int get totalMinutesToday => _totalMinutesToday;

  void setCategoryProvider(CategoryProvider provider) {
    // Available for future cross-provider logic
  }

  Future<void> checkPermission() async {
    _hasPermission = await UsageStatsService.instance.isPermissionGranted();
    notifyListeners();
  }

  Future<void> requestPermission() async {
    await UsageStatsService.instance.requestPermission();
  }

  void startPolling() {
    _pollingTimer?.cancel();
    refreshUsageData();
    _pollingTimer = Timer.periodic(AppConstants.pollingInterval, (_) {
      refreshUsageData();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> refreshUsageData() async {
    if (!_hasPermission) {
      await checkPermission();
      if (!_hasPermission) return;
    }

    _isLoading = _todayUsage.isEmpty;
    if (_isLoading) notifyListeners();

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final today = DateFormat('yyyy-MM-dd').format(now);

      // Fetch from platform channel
      final usageList = await UsageStatsService.instance.getUsageStats(
        startTime: startOfDay,
        endTime: now,
        date: today,
      );

      // Check for custom category mappings
      final db = DatabaseService.instance;
      final customMappings = await db.getAllAppCategoryMappings();

      final updatedUsage = usageList.map((u) {
        final customCat = customMappings[u.packageName];
        if (customCat != null) {
          return u.copyWith(categoryId: customCat);
        }
        return u;
      }).toList();

      // Persist to DB
      await db.upsertUsageRecords(updatedUsage);

      // Reload from DB for consistency
      _todayUsage = await db.getUsageForDate(today);
      _totalMinutesToday = await db.getTotalUsageForDate(today);

      // Build category summaries
      final summaryMaps = await db.getCategorySummaryForDate(today);
      _categorySummaries = summaryMaps.map((m) => DailySummary(
        categoryId: m['category_id'] as int,
        categoryName: m['category_name'] as String,
        totalMinutes: m['total_minutes'] as int,
        limitMinutes: m['limit_minutes'] as int,
        appCount: m['app_count'] as int,
      )).toList();

      // Check limits and fire notifications
      await _checkLimits();
    } catch (_) {
      // Silently handle polling errors
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _checkLimits() async {
    final notifService = NotificationService.instance;

    for (final summary in _categorySummaries) {
      if (!summary.hasLimit) continue;

      if (summary.isOverLimit) {
        await notifService.showLimitReachedNotification(
          categoryId: summary.categoryId,
          categoryName: summary.categoryName,
          limitMinutes: summary.limitMinutes,
        );
      } else if (summary.isNearLimit) {
        await notifService.showWarningNotification(
          categoryId: summary.categoryId,
          categoryName: summary.categoryName,
          usedMinutes: summary.totalMinutes,
          limitMinutes: summary.limitMinutes,
        );
      }
    }
  }

  Future<List<AppUsage>> getUsageForCategory(int categoryId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return DatabaseService.instance.getUsageForCategoryAndDate(categoryId, today);
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
