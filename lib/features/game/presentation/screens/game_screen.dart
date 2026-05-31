import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/navigation/journey_nav.dart';
import 'package:word_game/core/navigation/route_back_handler.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/features/game/presentation/widgets/word_list_panel.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/loading_overlay.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/tool_circle_button.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/game/presentation/bloc/game_event.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/features/game/presentation/widgets/level_complete_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/pause_menu_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/game_timeout_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/letter_grid.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/injection.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.levelId});

  final int levelId;

  @override
  Widget build(BuildContext context) {
    return _GameView(levelId: levelId);
  }
}

class _GameView extends StatelessWidget {
  const _GameView({required this.levelId});

  final int levelId;

  @override
  Widget build(BuildContext context) {
    return RouteBackHandler(
      onPop: () {
        final state = context.read<GameBloc>().state;
        final themeId = switch (state) {
          GameInProgress(:final themeId) => themeId,
          GameCompleted(:final themeId) => themeId,
          _ => null,
        };
        journeyPopFromGame(context, themeId: themeId);
      },
      child: MultiBlocListener(
      listeners: [
        BlocListener<GameBloc, GameState>(
          listenWhen: (p, c) =>
              c is GameInProgress &&
              (p is! GameInProgress || p.coins != c.coins),
          listener: (context, state) {
            if (state is GameInProgress) {
              context.read<CoinCubit>().syncCoins(state.coins);
            }
          },
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (p, c) => c is GameCompleted && p is! GameCompleted,
          listener: (context, state) {
            if (state is! GameCompleted) return;
            context.read<CoinCubit>().refresh();
            final bloc = context.read<GameBloc>();
            final isDaily = state.levelId ==
                getIt<GameContentRegistry>().dailyChallenge.levelId;
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => LevelCompleteOverlay(
                stars: state.stars,
                coinsEarned: state.coinsEarned,
                time: state.time,
                hintsUsed: state.hintsUsed,
                levelId: state.levelId,
                isDailyChallenge: isDaily,
                onHome: () async {
                  Navigator.of(dialogContext).pop();
                  if (isDaily) {
                    await getIt<DailyChallengeService>()
                        .recordSuccessfulClaim();
                    if (context.mounted && context.canPop()) {
                      context.pop(true);
                    } else if (context.mounted) {
                      context.go('/home');
                    }
                  } else {
                    context.go('/home');
                  }
                },
                onReplay: () {
                  Navigator.of(dialogContext).pop();
                  bloc.add(LoadLevel(state.levelId));
                },
                onNext: () {
                  Navigator.of(dialogContext).pop();
                  bloc.add(const LoadNextLevel());
                },
              ),
            ).then((_) {
              getIt<AdService>().onLevelComplete();
            });
          },
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (p, c) => c is GameNoMoreLevels,
          listener: (context, state) {
            if (state is! GameNoMoreLevels) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('All levels complete in this pack!')),
            );
            context.go('/levels?themeId=${state.themeId}');
          },
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (p, c) =>
              c is GameInProgress &&
              c.feedback != null &&
              (p is! GameInProgress || p.feedback != c.feedback),
          listener: (context, state) {
            if (state is! GameInProgress || state.feedback == null) return;
            if (state.feedback!.startsWith('🏆')) {
              context.read<CoinCubit>().refresh();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.feedback!),
                duration: const Duration(seconds: 2),
              ),
            );
            context.read<GameBloc>().add(const ClearGameFeedback());
          },
        ),
      ],
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          final bg = state is GameInProgress
              ? AssetPaths.themeImage(state.backgroundImage)
              : AssetPaths.themeSplash(context.themePreset);

          return Scaffold(
            body: Stack(
              children: [
                ScenicBackground(
                  imageAsset: bg,
                  blurSigma: 2,
                  darken: 0.45,
                ),
                SafeArea(
                  child: JourneyContentWidth(
                    child: Stack(
                      children: [
                        if (state is GameInProgress)
                          _GameBody(state: state)
                        else if (state is GameLoading || state is GameInitial)
                          const LoadingOverlay(message: 'Loading level...')
                        else if (state is GameCompleted)
                          const LoadingOverlay(message: 'Level complete!')
                        else if (state is GameError)
                          Center(
                            child: GlassPanel(
                              child: Text(
                                state.message,
                                style: AppTextStyles.levelName(context),
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                if (state is GameInProgress && state.isCompleting)
                  const LoadingOverlay(message: 'Level complete...'),
                if (state is GameInProgress && state.isTimedOut)
                  GameTimeoutOverlay(
                    state: state,
                    onRetry: () =>
                        context.read<GameBloc>().add(LoadLevel(state.levelId)),
                    onQuit: () => journeyPopFromGame(
                      context,
                      themeId: state.themeId,
                    ),
                  )
                else if (state is GameInProgress && state.isPaused)
                  PauseMenuOverlay(
                    state: state,
                    onResume: () =>
                        context.read<GameBloc>().add(const GameResumed()),
                    onRestart: () {
                      final bloc = context.read<GameBloc>();
                      bloc.add(LoadLevel(state.levelId));
                    },
                    onSettings: () => context.push('/settings'),
                    onQuit: () => journeyPopFromGame(
                      context,
                      themeId: state.themeId,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    ),
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody({required this.state});

  final GameInProgress state;

  static const _sectionGap = AppSizes.paddingSm;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final colors = context.appColors;
    return Column(
      children: [
        _TopBar(state: state),
        const SizedBox(height: _sectionGap),
        WordListPanel(state: state),
        const SizedBox(height: _sectionGap),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: LetterGrid(
              state: state,
              colors: colors,
              onDragStart: (r, c) => bloc.add(CellDragStarted(row: r, col: c)),
              onDragUpdate: (r, c) => bloc.add(CellDragUpdated(row: r, col: c)),
              onDragEnd: () => bloc.add(const CellDragEnded()),
            ),
          ),
        ),
        _Toolbar(state: state),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bloc = context.read<GameBloc>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: JourneyPanel(
        padding: const EdgeInsets.fromLTRB(6, 6, 8, 8),
        radius: 20,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: colors.gold),
                  onPressed: () => journeyPopFromGame(context,
                      result: true, themeId: state.themeId),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        state.levelTheme.toUpperCase(),
                        style: AppTextStyles.levelName(context).copyWith(
                          fontSize: 15,
                          letterSpacing: 0.6,
                          shadows: JourneyThemeKit.textGlow(context),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Level ${state.levelId}',
                        style: AppTextStyles.bodyMuted(context).copyWith(
                          fontSize: 11,
                          color: colors.onScenicMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                CoinDisplay(coins: state.coins, light: true),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 76),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.scrim.withValues(
                        alpha: state.timerDanger ? 0.92 : 0.55,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: state.timerDanger
                            ? colors.timerDanger
                            : colors.glassBorder.withValues(alpha: 0.4),
                        width: state.timerDanger ? 2 : 1,
                      ),
                      boxShadow: state.timerDanger
                          ? [
                              BoxShadow(
                                color: colors.timerDanger.withValues(alpha: 0.45),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: state.timerDanger ? Colors.white : colors.gold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatTimer(state.remainingSeconds),
                          style: AppTextStyles.timer(
                            context,
                            danger: state.timerDanger,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      if (state.isPaused) {
                        bloc.add(const GameResumed());
                      } else {
                        bloc.add(const GamePaused());
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.onScenic,
                      side: BorderSide(color: colors.glassBorder),
                      backgroundColor: colors.scrim.withValues(alpha: 0.45),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    icon: Icon(
                      state.isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      size: 18,
                      color: colors.gold,
                    ),
                    label: Text(
                      state.isPaused ? 'Resume' : 'Pause',
                      style: AppTextStyles.subtitle(context).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.onScenic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingMd,
        4,
        AppSizes.paddingMd,
        10,
      ),
      child: JourneyPanel(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        radius: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ToolCircleButton(
              compact: true,
              label: 'Hint',
              subtitle: '${GameConfig.hintCost}',
              icon: Icons.lightbulb_outline_rounded,
              onPressed: () => bloc.add(const HintRequested()),
            ),
            ToolCircleButton(
              compact: true,
              label: 'Reveal',
              subtitle: '${GameConfig.revealCost}',
              icon: Icons.visibility_rounded,
              onPressed: () => bloc.add(const RevealRequested()),
            ),
            ToolCircleButton(
              compact: true,
              label: 'Shuffle',
              subtitle: '${GameConfig.shuffleCost}',
              icon: Icons.shuffle_rounded,
              onPressed: () => bloc.add(const ShuffleRequested()),
            ),
          ],
        ),
      ),
    );
  }
}
