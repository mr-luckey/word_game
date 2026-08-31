import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:word_game/core/config/analytics_config.dart';

/// Central analytics facade. Never throw to callers. Never send PII.
class AnalyticsService {
  AnalyticsService({
    AnalyticsConfig config = const AnalyticsConfig(),
    FirebaseAnalytics? analytics,
  })  : _enabled = config.enabled,
        _analytics = analytics;

  bool _enabled;
  FirebaseAnalytics? _analytics;

  Future<void> init() async {
    if (!_enabled) return;
    try {
      final instance = _resolve();
      if (instance == null) return;
      await instance.setAnalyticsCollectionEnabled(true);
    } catch (error, stack) {
      debugPrint('Analytics init failed: $error\n$stack');
    }
  }

  void setEnabled(bool enabled) {
    _enabled = enabled;
    unawaited(_setCollection(enabled));
  }

  Future<void> _setCollection(bool enabled) async {
    try {
      final instance = _analytics ?? FirebaseAnalytics.instance;
      _analytics = instance;
      await instance.setAnalyticsCollectionEnabled(enabled);
    } catch (error, stack) {
      debugPrint('Analytics setEnabled failed: $error\n$stack');
    }
  }

  /// Existing game-bloc API. Maps onto [logLevelStarted].
  Future<void> logLevelStart(int levelId) {
    return logLevelStarted(levelNumber: levelId, source: 'game');
  }

  Future<void> logLevelStarted({
    int? levelNumber,
    String? difficulty,
    int? attemptNumber,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelStarted, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (source != null) 'source': source,
    });
  }

  /// Existing game-bloc API. Maps onto [logLevelCompleted].
  Future<void> logLevelComplete({
    required int levelId,
    required int stars,
  }) {
    return logLevelCompleted(
      levelNumber: levelId,
      source: 'game',
      extra: {'stars': stars},
    );
  }

  Future<void> logLevelCompleted({
    int? levelNumber,
    String? difficulty,
    int? moves,
    int? timeSeconds,
    int? attemptNumber,
    String? source,
    Map<String, Object>? extra,
  }) {
    return logEvent(AnalyticsConfig.eventLevelCompleted, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (moves != null) 'moves': moves,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (source != null) 'source': source,
      ...?extra,
    });
  }

  Future<void> logLevelFailed({
    int? levelNumber,
    String? difficulty,
    int? moves,
    int? timeSeconds,
    int? attemptNumber,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelFailed, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (moves != null) 'moves': moves,
      if (timeSeconds != null) 'time_seconds': timeSeconds,
      if (attemptNumber != null) 'attempt_number': attemptNumber,
      if (source != null) 'source': source,
    });
  }

  Future<void> logLevelAbandoned({
    int? levelNumber,
    String? difficulty,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventLevelAbandoned, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (difficulty != null) 'difficulty': difficulty,
      if (source != null) 'source': source,
    });
  }

  Future<void> logHintUsed({int? levelNumber, String? source}) {
    return logEvent(AnalyticsConfig.eventHintUsed, {
      if (levelNumber != null) 'level_number': levelNumber,
      if (source != null) 'source': source,
    });
  }

  Future<void> logRewardClaimed({String? rewardType, String? source}) {
    return logEvent(AnalyticsConfig.eventRewardClaimed, {
      if (rewardType != null) 'reward_type': rewardType,
      if (source != null) 'source': source,
    });
  }

  Future<void> logDailyRewardClaimed({int? day, String? source}) {
    return logEvent(AnalyticsConfig.eventDailyRewardClaimed, {
      if (day != null) 'day': day,
      if (source != null) 'source': source,
    });
  }

  Future<void> logNotificationOpened({
    String? notificationId,
    String? source,
  }) {
    return logEvent(AnalyticsConfig.eventNotificationOpened, {
      if (notificationId != null) 'notification_id': notificationId,
      if (source != null) 'source': source,
    });
  }

  Future<void> logNotificationScheduled({int? count, String? source}) {
    return logEvent(AnalyticsConfig.eventNotificationScheduled, {
      if (count != null) 'count': count,
      if (source != null) 'source': source,
    });
  }

  Future<void> logRewardedAdCompleted({String? placement, String? source}) {
    return logEvent(AnalyticsConfig.eventRewardedAdCompleted, {
      if (placement != null) 'placement': placement,
      if (source != null) 'source': source,
    });
  }

  Future<void> logPurchase(String productId) {
    return logEvent(AnalyticsConfig.eventPurchase, {
      'product_id': productId,
    });
  }

  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    if (!_enabled) return;
    try {
      final instance = _resolve();
      if (instance == null) return;
      await instance.logEvent(
        name: name,
        parameters: parameters == null ? null : _sanitize(parameters),
      );
    } catch (error, stack) {
      debugPrint('Analytics event "$name" failed: $error\n$stack');
    }
  }

  FirebaseAnalytics? _resolve() {
    if (!_enabled) return null;
    return _analytics ??= FirebaseAnalytics.instance;
  }

  Map<String, Object> _sanitize(Map<String, Object> parameters) {
    const blocked = {
      'password',
      'email',
      'phone',
      'token',
      'auth',
      'payment',
      'card',
    };
    final out = <String, Object>{};
    for (final entry in parameters.entries) {
      final key = entry.key.toLowerCase();
      if (blocked.any(key.contains)) continue;
      final value = entry.value;
      if (value is String || value is num || value is bool) {
        out[entry.key] = value;
      } else {
        out[entry.key] = value.toString();
      }
    }
    return out;
  }
}
