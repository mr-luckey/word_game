import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_game/app.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/services/app_rating_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await configureDependencies();
  await getIt<AdService>().initialize();
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
}
