import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/features/game/presentation/widgets/word_list_panel.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/loading_overlay.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/tool_circle_button.dart';
import 'package:word_game/features/game/presentation/bloc/game_bloc.dart';
import 'package:word_game/features/game/presentation/bloc/game_event.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/features/game/presentation/widgets/level_complete_overlay.dart';
import 'package:word_game/features/game/presentation/widgets/letter_grid.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<GameBloc, GameState>(
          listenWhen: (p, c) => c is GameCompleted && p is! GameCompleted,
          listener: (context, state) {
            if (state is! GameCompleted) return;
            getIt<AdService>().onLevelComplete();
            context.read<CoinCubit>().refresh();
            final bloc = context.read<GameBloc>();
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => LevelCompleteOverlay(
                stars: state.stars,
                coinsEarned: state.coinsEarned,
                time: state.time,
                hintsUsed: state.hintsUsed,
                levelId: state.levelId,
                onHome: () {
                  Navigator.of(dialogContext).pop();
                  context.go('/home');
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
            );
          },
        ),
        BlocListener<GameBloc, GameState>(
          listenWhen: (p, c) => c is GameNoMoreLevels,
          listener: (context, state) {
            if (state is! GameNoMoreLevels) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All levels complete in this pack!')),
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
          final colors = context.appColors;
          final bg = state is GameInProgress
              ? AssetPaths.themeImage(state.backgroundImage)
              : state is GameCompleted
                  ? AssetPaths.themeImage('paris_bg.jpg')
                  : AssetPaths.themeImage('paris_bg.jpg');

          return Scaffold(
            body: Stack(
              children: [
                ScenicBackground(
                  imageAsset: bg,
                  blurSigma: 2,
                  darken: 0.45,
                ),
                SafeArea(
                  child: Stack(
                    children: [
                      if (state is GameInProgress)
                        _GameBody(state: state)
                      else if (state is GameLoading || state is GameInitial)
                        const LoadingOverlay(message: 'Loading level...')
                      else if (state is GameCompleted)
                        const SizedBox.shrink()
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
                if (state is GameInProgress && state.isPaused)
                  Container(
                    color: colors.scrim,
                    child: Center(
                      child: GlassPanel(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Paused', style: AppTextStyles.levelName(context)),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () =>
                                  context.read<GameBloc>().add(const GameResumed()),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Resume'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
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
        _CoinHintRow(state: state),
        const SizedBox(height: _sectionGap),
        WordListPanel(state: state),
        const SizedBox(height: _sectionGap),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
            child: LetterGrid(
              state: state,
              colors: colors,
              onDragStart: (r, c) => bloc.add(CellDragStarted(row: r, col: c)),
              onDragUpdate: (r, c) =>
                  bloc.add(CellDragUpdated(row: r, col: c)),
              onDragEnd: () => bloc.add(const CellDragEnded()),
            ),
          ),
        ),
        const SizedBox(height: _sectionGap),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () => context.pop(true),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  state.levelTheme.toUpperCase(),
                  style: AppTextStyles.appBarTitle(context).copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Level ${state.levelId}',
                  style: AppTextStyles.subtitle(context).copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: state.timerDanger
                  ? colors.timerDanger.withValues(alpha: 0.9)
                  : colors.scrimLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: state.timerDanger ? colors.timerDanger : colors.onScenicMuted,
              ),
            ),
            child: Text(
              _formatTimer(state.remainingSeconds),
              style: AppTextStyles.timer(context, danger: state.timerDanger),
            ),
          ),
          const SizedBox(width: 4),
          _CircleIconButton(
            icon: Icons.settings_rounded,
            onPressed: () => _openSettings(context),
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

  Future<void> _openSettings(BuildContext context) async {
    final bloc = context.read<GameBloc>();
    bloc.add(const GamePaused());
    await context.push('/settings');
    if (context.mounted) {
      bloc.add(const GameResumed());
    }
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.scrimLight,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: colors.onScenic, size: 22),
        ),
      ),
    );
  }
}

class _CoinHintRow extends StatelessWidget {
  const _CoinHintRow({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CoinDisplay(coins: state.coins, light: true),
          GlassPanel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb_rounded, color: colors.gold, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${state.hintsLeft}',
                  style: AppTextStyles.coinsScore(context).copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              if (state.isPaused) {
                bloc.add(const GameResumed());
              } else {
                bloc.add(const GamePaused());
              }
            },
            icon: Icon(
              state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: colors.onScenic,
            ),
            label: Text(
              state.isPaused ? 'Resume' : 'Pause',
              style: AppTextStyles.subtitle(context)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.paddingMd,
        0,
        AppSizes.paddingMd,
        AppSizes.paddingMd,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: colors.scrimLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: colors.onScenicMuted),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ToolCircleButton(
            label: 'Rotate',
            subtitle: 'FREE',
            icon: Icons.rotate_90_degrees_cw_rounded,
            highlight: true,
            onPressed: () => bloc.add(const BoardRotated()),
          ),
          ToolCircleButton(
            label: 'Hint',
            subtitle: '${GameConfig.hintCost}',
            icon: Icons.lightbulb_outline_rounded,
            onPressed: () => bloc.add(const HintRequested()),
          ),
          ToolCircleButton(
            label: 'Reveal',
            subtitle: '${GameConfig.revealCost}',
            icon: Icons.visibility_rounded,
            onPressed: () => bloc.add(const RevealRequested()),
          ),
          ToolCircleButton(
            label: 'Shuffle',
            subtitle: '${GameConfig.shuffleCost}',
            icon: Icons.shuffle_rounded,
            onPressed: () => bloc.add(const ShuffleRequested()),
          ),
        ],
      ),
    );
  }
}
