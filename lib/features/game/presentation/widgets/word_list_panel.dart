import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/animated_word_chip.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

/// Compact multi-row word list — all words visible without oversized UI.
class WordListPanel extends StatelessWidget {
  const WordListPanel({super.key, required this.state});

  final GameInProgress state;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foundCount = state.foundWords.length;
    final total = state.wordsToFind.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingSm,
          vertical: 6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Words to find ($foundCount / $total)',
              textAlign: TextAlign.center,
              style: AppTextStyles.wordList(context).copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: state.wordsToFind.asMap().entries.map((e) {
                final found =
                    state.foundWords.any((f) => f.text == e.value.text);
                return AnimatedWordChip(
                  word: e.value.text,
                  found: found,
                  index: e.key,
                  compact: true,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
