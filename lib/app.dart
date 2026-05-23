import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_theme_cubit.dart';
import 'package:word_game/core/widgets/main_shell.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/game/presentation/bloc/game_event.dart';
import 'package:word_game/features/game/presentation/screens/game_screen.dart';
import 'package:word_game/features/home/presentation/screens/destinations_screen.dart';
import 'package:word_game/features/home/presentation/screens/home_screen.dart';
import 'package:word_game/features/level_select/presentation/screens/level_select_screen.dart';
import 'package:word_game/features/profile/presentation/screens/profile_screen.dart';
import 'package:word_game/features/settings/presentation/screens/settings_screen.dart';
import 'package:word_game/features/shop/presentation/screens/shop_screen.dart';
import 'package:word_game/features/splash/presentation/screens/splash_screen.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class WordSearchApp extends StatelessWidget {
  const WordSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CoinCubit>()),
        BlocProvider.value(value: getIt<AppThemeCubit>()),
      ],
      child: BlocBuilder<AppThemeCubit, AppThemeState>(
        builder: (context, themeState) => MaterialApp.router(
          title: 'Word Search Journey',
          debugShowCheckedModeBanner: false,
          theme: themeState.themeData,
          routerConfig: _router,
          builder: (context, child) => child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Unique page keys per route to avoid navigator key collisions.
CustomTransitionPage<void> _fadePage(
  GoRouterState state, {
  required Widget child,
  required String keyName,
}) =>
    CustomTransitionPage<void>(
      key: ValueKey(keyName),
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage<void> _slideFromRightPage(
  GoRouterState state, {
  required Widget child,
  required String keyName,
}) =>
    CustomTransitionPage<void>(
      key: ValueKey(keyName),
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );

CustomTransitionPage<void> _slideFromBottomPage(
  GoRouterState state, {
  required Widget child,
  required String keyName,
}) =>
    CustomTransitionPage<void>(
      key: ValueKey(keyName),
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _fadePage(
        state,
        child: const SplashScreen(),
        keyName: 'splash-${state.uri}',
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _fadePage(
            state,
            child: const HomeScreen(),
            keyName: 'home-${state.uri}',
          ),
        ),
        GoRoute(
          path: '/destinations',
          pageBuilder: (context, state) => _slideFromRightPage(
            state,
            child: const DestinationsScreen(),
            keyName: 'destinations-${state.uri}',
          ),
        ),
        GoRoute(
          path: '/shop',
          pageBuilder: (context, state) => _fadePage(
            state,
            child: const ShopScreen(),
            keyName: 'shop-${state.uri}',
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _fadePage(
            state,
            child: const ProfileScreen(),
            keyName: 'profile-${state.uri}',
          ),
        ),
        GoRoute(
          path: '/levels',
          pageBuilder: (context, state) {
            final themeId =
                int.tryParse(state.uri.queryParameters['themeId'] ?? '1') ?? 1;
            return _slideFromRightPage(
              state,
              child: LevelSelectScreen(themeId: themeId),
              keyName: 'levels-${state.uri}',
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => _slideFromBottomPage(
        state,
        child: const SettingsScreen(),
        keyName: 'settings-${state.uri}',
      ),
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) {
        final levelId =
            int.tryParse(state.uri.queryParameters['levelId'] ?? '101') ?? 101;
        return _fadePage(
          state,
          child: BlocProvider(
            create: (_) => getIt<GameBloc>()..add(LoadLevel(levelId)),
            child: GameScreen(levelId: levelId),
          ),
          keyName: 'game-${state.uri}',
        );
      },
    ),
  ],
);
