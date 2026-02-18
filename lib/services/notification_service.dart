import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_management/utils/constants.dart';
import 'package:intl/intl.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  Future<void> showWarningNotification({
    required int categoryId,
    required String categoryName,
    required int usedMinutes,
    required int limitMinutes,
  }) async {
    if (await _isDuplicate(categoryId, 'warning')) return;

    final percent = ((usedMinutes / limitMinutes) * 100).round();
    await _plugin.show(
      categoryId * 10 + 1,
      'Usage Warning',
      'You\'ve used $percent% of your $categoryName limit ($usedMinutes/${limitMinutes} min)',
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.warningChannelId,
          AppConstants.warningChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    await _markNotified(categoryId, 'warning');
  }

  Future<void> showLimitReachedNotification({
    required int categoryId,
    required String categoryName,
    required int limitMinutes,
  }) async {
    if (await _isDuplicate(categoryId, 'limit')) return;

    await _plugin.show(
      categoryId * 10 + 2,
      'Limit Reached!',
      '$categoryName limit reached ($limitMinutes min). Consider taking a break.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.warningChannelId,
          AppConstants.warningChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    await _markNotified(categoryId, 'limit');
  }

  Future<bool> _isDuplicate(int categoryId, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = 'last_notif_${categoryId}_${type}_$today';
    return prefs.getBool(key) ?? false;
  }

  Future<void> _markNotified(int categoryId, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final key = 'last_notif_${categoryId}_${type}_$today';
    await prefs.setBool(key, true);
  }
}
