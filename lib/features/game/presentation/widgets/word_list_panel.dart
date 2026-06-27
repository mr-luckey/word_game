import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/animated_word_chip.dart';
import 'package:word_game/features/game/presentation/bloc/game_state.dart';

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

    final wordsContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Words to find ($foundCount / $total)',
          textAlign: TextAlign.center,
          style: AppTextStyles.wordList(context).copyWith(
            fontSize: embedded ? 13 : 12,
            fontWeight: FontWeight.w700,
            color: embedded ? Colors.black : colors.onScenic,
          ),
        ),
        SizedBox(height: embedded ? 8 : 6),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: state.wordsToFind.asMap().entries.map((e) {
            final found =
                state.foundWords.any((f) => f.text == e.value.text);
            return AnimatedWordChip(
              word: e.value.text,
              found: found,
              index: e.key,
              compact: true,
              scenic: !embedded,
              onLightBackground: embedded,
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
