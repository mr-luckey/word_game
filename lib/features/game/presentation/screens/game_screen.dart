import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/loading_overlay.dart';
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
          return Scaffold(
            backgroundColor: AppColors.lightBlueBg,
            body: SafeArea(
              child: Stack(
                children: [
                  if (state is GameInProgress)
                    _GameBody(state: state)
                  else if (state is GameLoading || state is GameInitial)
                    const LoadingOverlay(message: 'Loading level...')
                  else if (state is GameError)
                    Center(child: Text(state.message))
                  else
                    const SizedBox.shrink(),
                ],
              ),
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
            padding: const EdgeInsets.all(AppSizes.paddingSm),
            child: LetterGrid(
              state: state,
              onDragStart: (r, c) =>
                  bloc.add(CellDragStarted(row: r, col: c)),
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
    return Container(
      color: AppColors.primaryBlue,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingSm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              state.levelTheme.toUpperCase(),
              style: AppTextStyles.appBarTitle,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            _formatTimer(state.remainingSeconds),
            style: AppTextStyles.timer(danger: state.timerDanger),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
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

class _CoinHintRow extends StatelessWidget {
  const _CoinHintRow({required this.state});
  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameBloc>();
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CoinDisplay(coins: state.coins),
          Text('${state.hintsLeft} Hints', style: AppTextStyles.wordList),
          TextButton.icon(
            onPressed: () {
              if (state.isPaused) {
                bloc.add(const GameResumed());
              } else {
                bloc.add(const GamePaused());
              }
            },
            icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause),
            label: Text(state.isPaused ? 'Resume' : 'Pause'),
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
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
        children: state.wordsToFind.map((w) {
          final found = state.foundWords.any((f) => f.text == w.text);
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingSm),
            child: Chip(
              label: Text(
                w.text,
                style: found ? AppTextStyles.wordListFound : AppTextStyles.wordList,
              ),
              backgroundColor:
                  found ? AppColors.cellFound : AppColors.cellDefault,
            ),
          );
        }).toList(),
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
    return Container(
      height: AppSizes.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ToolButton(
            label: 'Rotate',
            subtitle: 'FREE',
            icon: Icons.rotate_90_degrees_cw,
            onPressed: () => bloc.add(const BoardRotated()),
          ),
          _ToolButton(
            label: 'Hint',
            subtitle: '${GameConfig.hintCost}',
            icon: Icons.lightbulb_outline,
            onPressed: () => bloc.add(const HintRequested()),
          ),
          _ToolButton(
            label: 'Reveal',
            subtitle: '${GameConfig.revealCost}',
            icon: Icons.visibility,
            onPressed: () => bloc.add(const RevealRequested()),
          ),
          _ToolButton(
            label: 'Shuffle',
            subtitle: '${GameConfig.shuffleCost}',
            icon: Icons.shuffle,
            onPressed: () => bloc.add(const ShuffleRequested()),
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: AppColors.primaryBlue),
        ),
        Text(label, style: AppTextStyles.wordList.copyWith(fontSize: 12)),
        Text(subtitle, style: AppTextStyles.coinsScore.copyWith(fontSize: 10)),
      ],
    );
  }
}
