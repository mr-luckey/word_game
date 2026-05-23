import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/animated_word_chip.dart';
import 'package:word_game/core/widgets/coin_display.dart';
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
    return BlocListener<GameBloc, GameState>(
      listenWhen: (p, c) => c is GameCompleted,
      listener: (context, state) {
        if (state is! GameCompleted) return;
        getIt<AdService>().onLevelComplete();
        context.read<CoinCubit>().refresh();
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => LevelCompleteOverlay(
            stars: state.stars,
            coinsEarned: state.coinsEarned,
            time: state.time,
            hintsUsed: state.hintsUsed,
            levelId: state.levelId,
          ),
        );
      },
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          final bg = state is GameInProgress
              ? AssetPaths.themeImage(state.backgroundImage)
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
                      else if (state is GameError)
                        Center(
                          child: GlassPanel(
                            child: Text(
                              state.message,
                              style: AppTextStyles.levelName,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
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

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    return Column(
      children: [
        _TopBar(state: state),
        _CoinHintRow(state: state),
        _WordChips(state: state),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingSm,
              vertical: AppSizes.paddingXs,
            ),
            child: LetterGrid(
              state: state,
              onDragStart: (r, c) => bloc.add(CellDragStarted(row: r, col: c)),
              onDragUpdate: (r, c) =>
                  bloc.add(CellDragUpdated(row: r, col: c)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  state.levelTheme.toUpperCase(),
                  style: AppTextStyles.appBarTitle.copyWith(
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Level ${state.levelId}',
                  style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: state.timerDanger
                  ? AppColors.timerDanger.withValues(alpha: 0.9)
                  : Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: state.timerDanger
                    ? AppColors.timerDanger
                    : Colors.white24,
              ),
            ),
            child: Text(
              _formatTimer(state.remainingSeconds),
              style: AppTextStyles.timer(danger: state.timerDanger).copyWith(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 4),
          _CircleIconButton(
            icon: Icons.settings_rounded,
            onPressed: () => context.push('/settings'),
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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 22),
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
                const Icon(Icons.lightbulb_rounded, color: AppColors.gold, size: 20),
                const SizedBox(width: 6),
                Text(
                  '${state.hintsLeft}',
                  style: AppTextStyles.coinsScore.copyWith(fontSize: 16),
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
              color: Colors.white,
            ),
            label: Text(
              state.isPaused ? 'Resume' : 'Pause',
              style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordChips extends StatelessWidget {
  const _WordChips({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
        children: state.wordsToFind.asMap().entries.map((e) {
          final found = state.foundWords.any((f) => f.text == e.value.text);
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingSm),
            child: AnimatedWordChip(
              word: e.value.text,
              found: found,
              index: e.key,
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingMd),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: Colors.white24),
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
