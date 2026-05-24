import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/services/achievement_service.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/audio_service.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/data/repositories/level_repository_impl.dart';
import 'package:word_game/data/repositories/progress_repository_impl.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/game/domain/usecases/load_level_usecase.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/shop/presentation/cubit/shop_cubit.dart';
import 'package:word_game/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  final db = AppDatabase();
  getIt.registerSingleton<AppDatabase>(db);

  getIt.registerLazySingleton<LevelRepository>(LevelRepositoryImpl.new);
  getIt.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(db),
  );
  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(db),
  );

  getIt.registerLazySingleton(() => LoadLevelUseCase(getIt()));
  getIt.registerLazySingleton(() => GetNextLevelUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveProgressUseCase(getIt()));
  getIt.registerLazySingleton(() => SpendCoinsUseCase(getIt()));
  getIt.registerLazySingleton(() => AddCoinsUseCase(getIt()));

  getIt.registerLazySingleton(() => AudioService(prefs));
  getIt.registerLazySingleton(() => AnalyticsService());
  getIt.registerLazySingleton(() => AdService(prefs));
  getIt.registerLazySingleton(() => AchievementService(db, getIt()));
  getIt.registerLazySingleton(() => AppThemeBloc(prefs)..add(const AppThemeStarted()));

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
    ),
  );
  getIt.registerFactory(() => ShopCubit(getIt(), getIt()));

  final row = await (db.select(db.keyValueTable)
        ..where((t) => t.key.equals('coins')))
      .getSingleOrNull();
  if (row == null) {
    await db.setCoins(250);
  }
}
