import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_game/app.dart';
import 'package:word_game/core/constants/debug_flags.dart';
import 'package:word_game/core/services/ad_pitch_handler.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/app_rating_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/core/services/local_notification_service.dart';
import 'package:word_game/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await configureDependencies();
  unawaited(getIt<AnalyticsService>().init());
  unawaited(getIt<AdService>().initialize());
  installAdPitchHandler();
  unawaited(_scheduleLocalNotifications());
  await getIt<AppRatingService>().recordAppLaunch();
  await getIt<AudioService>().startBackgroundMusic();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const WordSearchApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(getIt<LocalNotificationService>().handleLaunchNotification());
  });
}

Future<void> _scheduleLocalNotifications() async {
  final service = getIt<LocalNotificationService>();
  final count = await service.scheduleNotifications();
  await getIt<AnalyticsService>().logNotificationScheduled(
    count: count,
    source: 'app_start',
  );
  if (DebugFlags.sendTestNotifications) {
    final testCount = await service.scheduleTestNotifications(count: 5);
    debugPrint('Test notifications scheduled: $testCount');
  }
}
