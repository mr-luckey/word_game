import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_theme.dart';
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
      ],
      child: MaterialApp.router(
        title: 'Word Search Journey',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
        builder: (context, child) => HeroMode(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Unique [Page.key] per navigation — prevents Navigator hero/key collisions.
CustomTransitionPage<void> _fadePage(
  GoRouterState state, {
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage<void> _slideFromRightPage(
  GoRouterState state, {
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
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
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
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
          ),
        ),
        GoRoute(
          path: '/destinations',
          pageBuilder: (context, state) => _slideFromRightPage(
            state,
            child: const DestinationsScreen(),
          ),
        ),
        GoRoute(
          path: '/shop',
          pageBuilder: (context, state) => _fadePage(
            state,
            child: const ShopScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _fadePage(
            state,
            child: const ProfileScreen(),
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
            );
          },
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _slideFromBottomPage(
            state,
            child: const SettingsScreen(),
          ),
        ),
      ],
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
        );
      },
    ),
  ],
);
