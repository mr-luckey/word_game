import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:word_game/core/config/notification_config.dart';

typedef NotificationTapCallback = void Function(String? payload);

/// Fully offline local notifications. Idempotent. Device-local timezone.
class LocalNotificationService {
  LocalNotificationService({
    required SharedPreferences prefs,
    NotificationConfig config = const NotificationConfig(),
    FlutterLocalNotificationsPlugin? plugin,
    this.onTap,
  })  : _config = config,
        _prefs = prefs,
        _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _fingerprintKey = 'local_notification_fingerprint_v1';

  final NotificationConfig _config;
  final SharedPreferences _prefs;
  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationTapCallback? onTap;

  bool _initialized = false;
  bool _exactAlarmsAllowed = false;

  Future<void> init() async {
    if (!_config.enabled || _initialized) return;
    try {
      tz_data.initializeTimeZones();
      final tzName = await _localTimezoneName();
      tz.setLocalLocation(tz.getLocation(tzName));
      debugPrint('LocalNotificationService timezone: $tzName');

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: (response) {
          onTap?.call(response.payload);
        },
      );
      await _ensureAndroidChannel();
      _initialized = true;
    } catch (error, stack) {
      debugPrint('LocalNotificationService.init failed: $error\n$stack');
    }
  }

  Future<void> _ensureAndroidChannel() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      AndroidNotificationChannel(
        _config.androidChannelId,
        _config.androidChannelName,
        description: 'Daily puzzle reminders',
        importance: Importance.high,
      ),
    );
  }

  Future<bool> requestPermission() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final androidOk = await android?.requestNotificationsPermission() ?? true;
      _exactAlarmsAllowed =
          await android?.requestExactAlarmsPermission() ?? true;
      final iosOk =
          await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
              true;
      debugPrint(
        'Notification permissions: post=$androidOk exact=$_exactAlarmsAllowed ios=$iosOk',
      );
      return androidOk && iosOk;
    } catch (error, stack) {
      debugPrint('Notification permission failed: $error\n$stack');
      return false;
    }
  }

  /// Safe to call on every launch. Does not create duplicates.
  Future<int> scheduleNotifications() async {
    if (!_config.enabled) return 0;
    await init();
    if (!_initialized) return 0;

    final allowed = await requestPermission();
    if (!allowed) return 0;

    try {
      final messages = await _loadMessages();
      if (messages.isEmpty) return 0;

      final fingerprint = await _fingerprint(messages);
      if (_prefs.getString(_fingerprintKey) == fingerprint) {
        final pending = await _plugin.pendingNotificationRequests();
        if (pending.isNotEmpty) return pending.length;
      }

      await _plugin.cancelAll();
      final count = await _scheduleUpcoming(messages);
      await _prefs.setString(_fingerprintKey, fingerprint);
      return count;
    } catch (error, stack) {
      debugPrint('scheduleNotifications failed: $error\n$stack');
      return 0;
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
      await _prefs.remove(_fingerprintKey);
    } catch (error, stack) {
      debugPrint('cancelAll notifications failed: $error\n$stack');
    }
  }

  /// Handles cold-start taps when the app was launched from a notification.
  Future<void> handleLaunchNotification() async {
    if (!_config.enabled) return;
    await init();
    if (!_initialized) return;

    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp ?? false) {
        onTap?.call(details!.notificationResponse?.payload);
      }
    } catch (error, stack) {
      debugPrint('handleLaunchNotification failed: $error\n$stack');
    }
  }

  /// Debug helper: shows one notification immediately, then schedules the rest.
  Future<int> scheduleTestNotifications({
    int count = 5,
    Duration firstDelay = const Duration(seconds: 5),
    Duration interval = const Duration(seconds: 5),
  }) async {
    if (!_config.enabled) return 0;
    await init();
    if (!_initialized) return 0;

    final allowed = await requestPermission();
    if (!allowed) {
      debugPrint('scheduleTestNotifications: permission denied');
      return 0;
    }

    try {
      final messages = await _loadMessages();
      if (messages.isEmpty) return 0;

      var scheduled = 0;
      final now = tz.TZDateTime.now(tz.local);
      final scheduleMode = _androidScheduleMode();

      // First notification fires immediately so we know the channel works.
      final first = messages[0];
      await _plugin.show(
        9000,
        '[TEST 1] ${first.title}',
        first.body,
        _notificationDetails(),
        payload: first.id,
      );
      scheduled++;
      debugPrint('Test notification 1 shown immediately');

      for (var i = 1; i < count; i++) {
        final fire = now.add(firstDelay + interval * (i - 1));
        final message = messages[i % messages.length];
        await _plugin.zonedSchedule(
          9000 + i,
          '[TEST ${i + 1}] ${message.title}',
          message.body,
          fire,
          _notificationDetails(),
          androidScheduleMode: scheduleMode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: message.id,
        );
        scheduled++;
        debugPrint('Test notification ${i + 1} scheduled for $fire');
      }

      final pending = await _plugin.pendingNotificationRequests();
      debugPrint(
        'Scheduled $scheduled test notifications (${pending.length} pending total)',
      );
      return scheduled;
    } catch (error, stack) {
      debugPrint('scheduleTestNotifications failed: $error\n$stack');
      return 0;
    }
  }

  @visibleForTesting
  Future<String> fingerprintFor(List<NotificationMessage> messages) {
    return _fingerprint(messages);
  }

  Future<List<NotificationMessage>> _loadMessages() async {
    final raw = await rootBundle.loadString(_config.assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['notifications'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(NotificationMessage.fromJson)
        .where((m) => m.id.isNotEmpty && m.title.isNotEmpty)
        .toList();
  }

  Future<int> _scheduleUpcoming(List<NotificationMessage> messages) async {
    var scheduled = 0;
    final now = tz.TZDateTime.now(tz.local);
    for (var day = 0; day < _config.daysToSchedule; day++) {
      final time = _timeForDay(day);
      if (time == null) continue;
      var fire = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ).add(Duration(days: day));
      if (!fire.isAfter(now)) continue;
      final message = messages[day % messages.length];
      await _plugin.zonedSchedule(
        day + 1,
        message.title,
        message.body,
        fire,
        _notificationDetails(),
        androidScheduleMode: _androidScheduleMode(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: message.id,
      );
      scheduled++;
    }
    return scheduled;
  }

  ({int hour, int minute})? _timeForDay(int dayIndex) {
    final times = _config.scheduleTimes;
    if (times.isEmpty) return null;
    final token = _config.rotationMode == NotificationRotationMode.alternate
        ? times[dayIndex % times.length]
        : times[0];
    final parts = token.split(':');
    if (parts.length != 2) return null;
    return (hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _config.androidChannelId,
        _config.androidChannelName,
        channelDescription: 'Daily puzzle reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  AndroidScheduleMode _androidScheduleMode() {
    if (_exactAlarmsAllowed) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }
    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

  Future<String> _localTimezoneName() async {
    return FlutterTimezone.getLocalTimezone();
  }

  Future<String> _fingerprint(List<NotificationMessage> messages) async {
    final payload = jsonEncode({
      'tz': await _localTimezoneName(),
      'times': _config.scheduleTimes,
      'mode': _config.rotationMode.name,
      'days': _config.daysToSchedule,
      'channel': _config.androidChannelId,
      'plugin': _config.pluginVersion,
      'messages': messages
          .map((m) => {'id': m.id, 'title': m.title, 'body': m.body})
          .toList(),
    });
    return payload;
  }
}
