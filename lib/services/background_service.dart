import 'package:workmanager/workmanager.dart';
import 'package:app_management/services/database_service.dart';
import 'package:app_management/services/notification_service.dart';
import 'package:app_management/utils/constants.dart';
import 'package:intl/intl.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == AppConstants.backgroundTaskName) {
      await _checkLimitsInBackground();
    }
    return true;
  });
}

Future<void> _checkLimitsInBackground() async {
  try {
    final db = DatabaseService.instance;
    final notificationService = NotificationService.instance;
    await notificationService.init();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final summaries = await db.getCategorySummaryForDate(today);

    for (final summary in summaries) {
      final limitMinutes = summary['limit_minutes'] as int;
      final totalMinutes = summary['total_minutes'] as int;
      final categoryId = summary['category_id'] as int;
      final categoryName = summary['category_name'] as String;

      if (limitMinutes <= 0) continue;

      final ratio = totalMinutes / limitMinutes;

      if (ratio >= AppConstants.limitThreshold) {
        await notificationService.showLimitReachedNotification(
          categoryId: categoryId,
          categoryName: categoryName,
          limitMinutes: limitMinutes,
        );
      } else if (ratio >= AppConstants.warningThreshold) {
        await notificationService.showWarningNotification(
          categoryId: categoryId,
          categoryName: categoryName,
          usedMinutes: totalMinutes,
          limitMinutes: limitMinutes,
        );
      }
    }
  } catch (_) {
    // Background tasks should not crash
  }
}

class BackgroundService {
  BackgroundService._();
  static final BackgroundService instance = BackgroundService._();

  void init() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      'usage_limit_check',
      AppConstants.backgroundTaskName,
      frequency: AppConstants.backgroundInterval,
      constraints: Constraints(
        networkType: NetworkType.not_required,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }
}
