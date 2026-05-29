import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/data/game_content_loader.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/services/achievement_service.dart';
import 'package:word_game/core/services/auth_service.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/core/services/leaderboard_service.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/core/services/progress_sync_service.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/data/repositories/level_repository_impl.dart';
import 'package:word_game/core/utils/level_progress_id.dart';
import 'package:word_game/data/repositories/progress_repository_impl.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/game/domain/usecases/load_level_usecase.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:word_game/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  final content = await GameContentLoader.load();
  getIt.registerSingleton<GameContentRegistry>(content);
  DestinationCatalog.bind(content);

  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);
  await _migrateLegacyProgressKeys(db);

  getIt.registerLazySingleton(() => FirestoreUserService(FirebaseFirestore.instance));
  getIt.registerLazySingleton(() => ProgressSyncService(db, getIt(), prefs));
  getIt.registerLazySingleton(
    () => AuthService(
      FirebaseAuth.instance,
      GoogleSignIn(),
      prefs,
      getIt(),
      getIt(),
    ),
  );

  getIt.registerLazySingleton<LevelRepository>(
    () => LevelRepositoryImpl(content),
  );
  getIt.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(db, getIt()),
  );
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(db, getIt()),
  );

  getIt.registerLazySingleton(() => LoadLevelUseCase(getIt()));
  getIt.registerLazySingleton(() => GetNextLevelUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveProgressUseCase(getIt()));
  getIt.registerLazySingleton(() => SpendCoinsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddCoinsUseCase(getIt()));

  getIt.registerLazySingleton(() => AudioService(prefs));
  getIt.registerLazySingleton(() => AnalyticsService());
  getIt.registerLazySingleton(() => AdService(prefs));
  getIt.registerLazySingleton(
    () => AchievementService(db, getIt(), content.dailyChallenge.levelId),
  );
  getIt.registerLazySingleton(() => DailyChallengeService(prefs, content));
  getIt.registerLazySingleton(() => LeaderboardService(getIt(), getIt(), db));
  getIt.registerLazySingleton(() => AppThemeBloc(prefs)..add(const AppThemeStarted()));
  getIt.registerLazySingleton(() => AuthCubit(getIt()));

  getIt.registerFactory(() => CoinCubit(getIt()));
  getIt.registerFactory(SplashCubit.new);
  getIt.registerFactory(
    () => GameBloc(
      loadLevel: getIt(),
      getNextLevel: getIt(),
      saveProgress: getIt(),
      spendCoins: getIt(),
      addCoins: getIt(),
      wallet: getIt(),
      audio: getIt(),
      analytics: getIt(),
      achievements: getIt(),
      dailyChallenge: getIt(),
      themeBloc: getIt(),
      content: getIt(),
    ),
  );
  getIt.registerFactory(() => ShopCubit(getIt(), getIt(), getIt()));

  final row = await (db.select(db.keyValueTable)
        ..where((t) => t.key.equals('coins')))
      .getSingleOrNull();
  if (row == null) {
    await db.setCoins(250);
  }
}

/// Old saves used raw ids (1–99 or 101+). Copy into per-slot keys for slot 1.
Future<void> _migrateLegacyProgressKeys(AppDatabase db) async {
  final rows = await db.getAllProgress();
  for (final row in rows) {
    final isLegacy = LevelProgressId.isLegacyStorageKey(row.levelId);
    final isCompact = LevelProgressId.isCompactUnencodedKey(row.levelId);
    if (!isLegacy && !isCompact) continue;

    final encoded = LevelProgressId.encode(
      slotId: 1,
      sharedLevelId: row.levelId,
    );
    if (encoded == row.levelId) continue;

    final existing = await db.getProgress(encoded);
    if (existing == null || row.stars > existing.stars) {
      await db.saveProgress(
        levelId: encoded,
        stars: row.stars,
        timeSeconds: row.timeSeconds,
      );
    }
  }
}
