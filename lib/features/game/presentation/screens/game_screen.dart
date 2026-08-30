import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/navigation/journey_nav.dart';
import 'package:word_game/core/navigation/route_back_handler.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/theme/game_screen_styles.dart';
import 'package:word_game/features/game/presentation/widgets/game_action_button.dart';
import 'package:word_game/features/game/presentation/widgets/game_neon_panel.dart';
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
            final bg = AssetPaths.themeGrid(preset);

            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ScenicBackground(
                          imageAsset: bg,
                          blurSigma: 0,
                          darken: 0.16,
                          showCompass: false,
                        ),
                        SafeArea(
                          bottom: false,
                          child: JourneyContentWidth(
                            child: Stack(
                              children: [
                                if (state is GameInProgress)
                                  _GameWithTutorial(state: state)
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

class _GameWithTutorial extends StatefulWidget {
  const _GameWithTutorial({required this.state});

  final GameInProgress state;

  @override
  State<_GameWithTutorial> createState() => _GameWithTutorialState();
}

class _GameWithTutorialState extends State<_GameWithTutorial> {
  final _gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _GameBody(state: widget.state, gridKey: _gridKey),
        if (widget.state.showTutorial)
          LevelTutorialOverlay(
            state: widget.state,
            gridKey: _gridKey,
            onDismiss: () =>
                context.read<GameBloc>().add(const TutorialDismissed()),
          ),
      ],
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody({required this.state, required this.gridKey});

  final GameInProgress state;
  final GlobalKey gridKey;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final colors = context.appColors;
    final lightBoard = context.themePreset.gameSpec.lightAtmosphere;
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
                      padding: EdgeInsets.fromLTRB(m.s(8), m.s(4), m.s(8), 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GameNeonPanel(
                            borderStyle: GamePanelBorderStyle.wordList,
                            padding: EdgeInsets.fromLTRB(
                              m.s(12),
                              m.s(10),
                              m.s(12),
                              m.s(10),
                            ),
                            child: WordListPanel(state: state, embedded: true),
                          ),
                          SizedBox(height: m.s(10)),
                          GameNeonPanel(
                            borderStyle: GamePanelBorderStyle.grid,
                            padding: EdgeInsets.fromLTRB(
                              m.s(6),
                              m.s(8),
                              m.s(6),
                              m.s(8),
                            ),
                            child: LetterGrid(
                              state: state,
                              colors: colors,
                              embedded: true,
                              darkBoard: !lightBoard,
                              gridBoundsKey: gridKey,
                              onDragStart: (r, c) =>
                                  bloc.add(CellDragStarted(row: r, col: c)),
                              onDragUpdate: (r, c) =>
                                  bloc.add(CellDragUpdated(row: r, col: c)),
                              onDragEnd: () => bloc.add(const CellDragEnded()),
                            ),
                          ),
                        ],
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
      padding: EdgeInsets.fromLTRB(m.s(10), m.s(6), m.s(10), m.s(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _GoldCoinPill(coins: state.coins, scale: m.s),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(m.s(86), m.s(86)),
                  painter: _RadarPainter(
                    color: colors.gold.withValues(alpha: 0.55),
                  ),
                ),
                Text(
                  'Level ${state.displayNumber}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cinzel(
                    fontSize: m.s(24),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = m.s(3)
                      ..color = Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                Text(
                  'Level ${state.displayNumber}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cinzel(
                    fontSize: m.s(24),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: colors.goldLight,
                    shadows: JourneyThemeKit.textGlow(context, strength: 1.4),
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
              borderRadius: BorderRadius.circular(m.s(12)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: m.s(12),
                  vertical: m.s(7),
                ),
                decoration: BoxDecoration(
                  color: colors.scrim.withValues(
                    alpha: state.timerDanger ? 0.92 : 0.65,
                  ),
                  borderRadius: BorderRadius.circular(m.s(12)),
                  border: Border.all(
                    color: state.timerDanger
                        ? colors.timerDanger
                        : colors.gold.withValues(alpha: 0.55),
                    width: state.timerDanger ? m.s(2) : m.s(1.2),
                  ),
                  boxShadow: state.timerDanger
                      ? [
                          BoxShadow(
                            color: colors.timerDanger.withValues(alpha: 0.45),
                            blurRadius: m.s(8),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: colors.gold.withValues(alpha: 0.15),
                            blurRadius: m.s(6),
                          ),
                        ],
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
    final gameSpec = context.themePreset.gameSpec;
    final revealsLeft = state.revealsLeft;
    final revealLocked = revealsLeft <= 0;
    final m = GameScreenScope.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(m.s(12), m.s(4), m.s(12), m.s(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GameActionButton(
            label: 'Hint',
            icon: Icons.lightbulb_outline_rounded,
            glowColor: gameSpec.hintButtonGlow,
            subtitle: '${GameConfig.hintCost}',
            showCoin: true,
            onPressed: () => bloc.add(const HintRequested()),
          ),
          GameActionButton(
            label: revealLocked ? 'Locked' : 'Reveal',
            icon: revealLocked ? Icons.lock_rounded : Icons.visibility_rounded,
            glowColor: gameSpec.revealButtonGlow,
            subtitle: revealLocked
                ? '${state.maxReveals}/${state.maxReveals}'
                : 'Left: $revealsLeft',
            disabled: revealLocked,
            large: true,
            onPressed:
                revealLocked ? null : () => bloc.add(const RevealRequested()),
          ),
          GameActionButton(
            label: 'Shuffle',
            icon: Icons.shuffle_rounded,
            glowColor: gameSpec.shuffleButtonGlow,
            subtitle: '${GameConfig.shuffleCost}',
            showCoin: true,
            onPressed: () => bloc.add(const ShuffleRequested()),
          ),
        ],
      ),
    );
  }
}

class _GoldCoinPill extends StatelessWidget {
  const _GoldCoinPill({required this.coins, required this.scale});

  final int coins;
  final double Function(double) scale;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scale(12),
        vertical: scale(7),
      ),
      decoration: BoxDecoration(
        color: colors.scrim.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(scale(14)),
        border: Border.all(
          color: colors.gold.withValues(alpha: 0.85),
          width: scale(1.4),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.4),
            blurRadius: scale(10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            color: colors.gold,
            size: scale(20),
          ),
          SizedBox(width: scale(6)),
          Text(
            '$coins',
            style: AppTextStyles.coinsScore(context).copyWith(
              color: colors.onScenic,
              fontSize: scale(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawCircle(center, radius * 0.98, stroke);
    canvas.drawCircle(center, radius * 0.62, stroke);
    canvas.drawCircle(center, radius * 0.28, stroke);
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      stroke,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.color != color;
}

