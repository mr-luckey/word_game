import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/animated_word_chip.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';
import 'package:word_game/features/game/presentation/widgets/game_screen_metrics.dart';

class WordListPanel extends StatelessWidget {
  const WordListPanel({
    super.key,
    required this.state,
    this.embedded = false,
  });

  final GameInProgress state;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foundCount = state.foundWords.length;
    final total = state.wordsToFind.length;
    final m = embedded ? GameScreenScope.maybeOf(context) : null;
    final s = m?.s ?? (double v) => v;

    final wordsContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Words to find ($foundCount / $total)',
          textAlign: TextAlign.center,
          style: AppTextStyles.wordList(context).copyWith(
            fontSize: embedded ? s(17) : 12,
            fontWeight: FontWeight.w800,
            color: embedded ? Colors.black : colors.onScenic,
          ),
        ),
        SizedBox(height: embedded ? s(10) : 6),
        Wrap(
          spacing: embedded ? s(14) : 10,
          runSpacing: embedded ? s(6) : 8,
          alignment: WrapAlignment.center,
          children: state.wordsToFind.asMap().entries.map((e) {
            final found = state.foundWords.any((f) => f.text == e.value.text);
            if (embedded) {
              final accent = colors.foundColorForIndex(e.key);
              return Text(
                e.value.text,
                style: AppTextStyles.wordList(context).copyWith(
                  fontSize: s(16),
                  fontWeight: FontWeight.w700,
                  color: accent,
                  decoration: found ? TextDecoration.lineThrough : null,
                  decorationColor: accent,
                  decorationThickness: s(2),
                ),
              );
            }
            return AnimatedWordChip(
              word: e.value.text,
              found: found,
              index: e.key,
              compact: true,
              scenic: true,
            );
          }).toList(),
        ),
      ],
    );

    final content = wordsContent;

    if (embedded) return content;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: JourneyPanel(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
        radius: 18,
        child: content,
      ),
    );
  }
}
