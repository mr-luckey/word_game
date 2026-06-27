import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/constants/scenic_background_style.dart';
import 'package:word_game/core/navigation/journey_nav.dart';
import 'package:word_game/core/navigation/route_back_handler.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/features/game/presentation/widgets/word_list_panel.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/loading_overlay.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/game/presentation/bloc/game_event.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/features/game/presentation/widgets/game_screen_metrics.dart';
import 'package:word_game/features/game/presentation/widgets/level_complete_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/pause_menu_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/game_timeout_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/letter_grid.dart';
import 'package:word_game/core/widgets/insufficient_coins_dialog.dart';
import 'package:word_game/features/game/presentation/widgets/level_tutorial_overlay.dart';
import 'package:word_game/features/level_select/presentation/cubit/banner_ad_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/xp_cubit.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/injection.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.levelId});

  final int levelId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BannerAdCubit(getIt()),
      child: _GameView(levelId: levelId),
    );
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
              context.read<XpCubit>().refresh();
              final bloc = context.read<GameBloc>();
              final isDaily = state.levelId ==
                  getIt<GameContentRegistry>().dailyChallenge.levelId;
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => LevelCompleteOverlay(
                  stars: state.stars,
                  coinsEarned: state.coinsEarned,
                  xpEarned: state.xpEarned,
                  time: state.time,
                  hintsUsed: state.hintsUsed,
                  levelId: state.levelId,
                  displayNumber: state.displayNumber,
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
              if (state.feedback == kInsufficientCoinsFeedback) {
                InsufficientCoinsDialog.show(context);
                context.read<GameBloc>().add(const ClearGameFeedback());
                return;
              }
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
            final preset = context.themePreset;
            final bg =
                state is GameInProgress && state.backgroundImage.isNotEmpty
                    ? AssetPaths.themeImage(state.backgroundImage)
                    : ScenicBackgroundStyle.hdAssetFor(preset);

            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ScenicBackground(imageAsset: bg),
                        SafeArea(
                          bottom: false,
                          child: JourneyContentWidth(
                            child: Stack(
                              children: [
                                if (state is GameInProgress)
                                  Stack(
                                    children: [
                                      _GameBody(state: state),
                                      if (state.showTutorial)
                                        LevelTutorialOverlay(
                                          state: state,
                                          onDismiss: () => context
                                              .read<GameBloc>()
                                              .add(const TutorialDismissed()),
                                        ),
                                    ],
                                  )
                                else if (state is GameLoading ||
                                    state is GameInitial)
                                  const LoadingOverlay(
                                      message: 'Loading level...')
                                else if (state is GameCompleted)
                                  const LoadingOverlay(
                                      message: 'Level complete!')
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
                            onRetry: () => context
                                .read<GameBloc>()
                                .add(LoadLevel(state.levelId)),
                            onQuit: () => journeyPopFromGame(
                              context,
                              themeId: state.themeId,
                            ),
                          )
                        else if (state is GameInProgress && state.isPaused)
                          PauseMenuOverlay(
                            state: state,
                            onResume: () => context
                                .read<GameBloc>()
                                .add(const GameResumed()),
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
                  ),
                  if (state is GameInProgress) const _GameBannerAd(),
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

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final colors = context.appColors;
    final m = GameScreenMetrics.of(context);
    return GameScreenScope(
      metrics: m,
      child: Column(
        children: [
          _TopBar(state: state),
          Expanded(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(m.s(6), m.s(8), m.s(6), m.s(10)),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(m.s(6), m.s(4), m.s(6), m.s(2)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(m.s(18)),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.12),
                              blurRadius: m.s(8),
                              offset: Offset(0, m.s(2)),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            WordListPanel(state: state, embedded: true),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: m.s(8)),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: colors.cellBorder.withValues(alpha: 0.45),
                              ),
                            ),
                            LetterGrid(
                              state: state,
                              colors: colors,
                              embedded: true,
                              onDragStart: (r, c) =>
                                  bloc.add(CellDragStarted(row: r, col: c)),
                              onDragUpdate: (r, c) =>
                                  bloc.add(CellDragUpdated(row: r, col: c)),
                              onDragEnd: () => bloc.add(const CellDragEnded()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: _Toolbar(state: state),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final m = GameScreenScope.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(m.s(10), m.s(50), m.s(10), m.s(40)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CoinDisplay(coins: state.coins, compact: true),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Level ${state.displayNumber}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.levelName(context).copyWith(
                    fontSize: m.s(28),
                    letterSpacing: 0.6,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = m.s(2)
                      ..color = Colors.black,
                  ),
                ),
                Text(
                  'Level ${state.displayNumber}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.levelName(context).copyWith(
                    fontSize: m.s(28),
                    letterSpacing: 0.6,
                    shadows: JourneyThemeKit.textGlow(context),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (state.isPaused) {
                  bloc.add(const GameResumed());
                } else {
                  bloc.add(const GamePaused());
                }
              },
              borderRadius: BorderRadius.circular(m.s(10)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: m.s(10),
                  vertical: m.s(6),
                ),
                decoration: BoxDecoration(
                  color: colors.scrim.withValues(
                    alpha: state.timerDanger ? 0.92 : 0.55,
                  ),
                  borderRadius: BorderRadius.circular(m.s(10)),
                  border: Border.all(
                    color: state.timerDanger
                        ? colors.timerDanger
                        : colors.glassBorder.withValues(alpha: 0.4),
                    width: state.timerDanger ? m.s(2) : m.s(1),
                  ),
                  boxShadow: state.timerDanger
                      ? [
                          BoxShadow(
                            color: colors.timerDanger.withValues(alpha: 0.45),
                            blurRadius: m.s(8),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTimer(state.remainingSeconds),
                      style: AppTextStyles.timer(
                        context,
                        danger: state.timerDanger,
                      ).copyWith(fontSize: m.s(state.timerDanger ? 16 : 14)),
                    ),
                    SizedBox(width: m.s(8)),
                    Icon(
                      state.isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      size: m.s(18),
                      color: state.timerDanger ? Colors.white : colors.gold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _GameBannerAd extends StatelessWidget {
  const _GameBannerAd();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocBuilder<BannerAdCubit, BannerAd?>(
      builder: (context, banner) {
        if (banner == null) return const SizedBox.shrink();
        return ColoredBox(
          color: colors.navSurface,
          child: SafeArea(
            top: false,
            child: Center(
              child: SizedBox(
                width: banner.size.width.toDouble(),
                height: banner.size.height.toDouble(),
                child: AdWidget(ad: banner),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final revealsLeft = state.revealsLeft;
    final revealLocked = revealsLeft <= 0;
    final m = GameScreenScope.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(m.s(6), 0, m.s(6), m.s(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionChip(
            label: 'Hint',
            cost: GameConfig.hintCost,
            icon: Icons.lightbulb_outline_rounded,
            onPressed: () => bloc.add(const HintRequested()),
          ),
          _ActionChip(
            label: revealLocked ? 'Locked' : 'Reveal',
            cost: GameConfig.revealCost,
            icon: revealLocked ? Icons.lock_rounded : Icons.visibility_rounded,
            badge: revealLocked
                ? '${state.maxReveals}/${state.maxReveals}'
                : 'Left: $revealsLeft',
            disabled: revealLocked,
            onPressed:
                revealLocked ? null : () => bloc.add(const RevealRequested()),
          ),
          _ActionChip(
            label: 'Shuffle',
            cost: GameConfig.shuffleCost,
            icon: Icons.shuffle_rounded,
            onPressed: () => bloc.add(const ShuffleRequested()),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.cost,
    required this.icon,
    required this.onPressed,
    this.badge,
    this.disabled = false,
  });

  final String label;
  final int cost;
  final IconData icon;
  final VoidCallback? onPressed;
  final String? badge;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final m = GameScreenScope.of(context);
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(m.s(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: m.s(4),
              vertical: m.s(2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: m.s(14),
                    vertical: m.s(8),
                  ),
                  decoration: BoxDecoration(
                    color: colors.scrim.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(m.s(10)),
                    border: Border.all(
                      color: colors.glassBorder.withValues(alpha: 0.4),
                      width: m.s(1),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: colors.gold,
                    size: m.s(24),
                  ),
                ),
                SizedBox(height: m.s(4)),
                Text(
                  label,
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontSize: m.s(11),
                    fontWeight: FontWeight.w600,
                    color: colors.onScenic,
                  ),
                ),
                if (badge != null)
                  Text(
                    badge!,
                    style: AppTextStyles.bodyMuted(context).copyWith(
                      fontSize: m.s(9),
                      color: colors.onScenicMuted,
                    ),
                  )
                else
                  Text(
                    '$cost',
                    style: AppTextStyles.bodyMuted(context).copyWith(
                      fontSize: m.s(10),
                      color: colors.onScenicMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
