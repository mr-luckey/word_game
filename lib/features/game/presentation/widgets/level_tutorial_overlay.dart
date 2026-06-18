import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

/// First-level tutorial overlay with hand animation guide.
class LevelTutorialOverlay extends StatelessWidget {
  const LevelTutorialOverlay({
    super.key,
    required this.state,
    required this.onDismiss,
  });

  final GameInProgress state;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    if (!state.showTutorial || state.wordsToFind.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;
    final firstWord = state.wordsToFind.first.text;
    final indices = state.tutorialHighlightIndices.toList()..sort();
    if (indices.length < 2) {
      return _TutorialScrim(
        firstWord: firstWord,
        onDismiss: onDismiss,
      );
    }

    return Positioned.fill(
      child: Material(
        color: colors.scrim.withValues(alpha: 0.72),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'Swipe letters to find the word',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionHeading(context).copyWith(
                  color: colors.onScenic,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Find: "$firstWord"',
                style: AppTextStyles.levelName(context).copyWith(
                  color: colors.gold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 24),
              Icon(Icons.back_hand_rounded, size: 48, color: colors.gold)
                  .animate(onPlay: (c) => c.repeat())
                  .moveY(begin: -8, end: 8, duration: 900.ms, curve: Curves.easeInOut)
                  .then()
                  .moveY(begin: 8, end: -8, duration: 900.ms),
              const Spacer(flex: 3),
              TextButton(
                onPressed: onDismiss,
                child: Text('Got it', style: TextStyle(color: colors.gold, fontSize: 16)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialScrim extends StatelessWidget {
  const _TutorialScrim({required this.firstWord, required this.onDismiss});

  final String firstWord;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: context.appColors.scrim.withValues(alpha: 0.72),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Swipe letters to find the word',
                  style: AppTextStyles.sectionHeading(context)),
              Text('Find: "$firstWord"'),
              TextButton(onPressed: onDismiss, child: const Text('Got it')),
            ],
          ),
        ),
      ),
    );
  }
}
