import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/game_screen_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/animated_word_chip.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
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
    final gameSpec = context.themePreset.gameSpec;
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
            fontSize: embedded ? s(15) : 12,
            fontWeight: FontWeight.w800,
            color: gameSpec.lightAtmosphere
                ? gameSpec.wordChipText
                : colors.onScenic,
            letterSpacing: 0.4,
            shadows: gameSpec.lightAtmosphere
                ? null
                : [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: 6,
                    ),
                  ],
          ),
        ),
        SizedBox(height: embedded ? s(12) : 6),
        Wrap(
          spacing: embedded ? s(10) : 10,
          runSpacing: embedded ? s(10) : 8,
          alignment: WrapAlignment.center,
          children: state.wordsToFind.asMap().entries.map((e) {
            final found = state.foundWords.any((f) => f.text == e.value.text);
            if (embedded) {
              final iconColor = gameSpec
                  .wordIconColors[e.key % gameSpec.wordIconColors.length];
              final icon = gameWordIcons[e.key % gameWordIcons.length];
              return _EmbeddedWordChip(
                word: e.value.text,
                found: found,
                icon: icon,
                iconColor: iconColor,
                textColor: gameSpec.wordChipText,
                lightAtmosphere: gameSpec.lightAtmosphere,
                scale: s,
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

    if (embedded) return wordsContent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd),
      child: JourneyPanel(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
        radius: 18,
        child: wordsContent,
      ),
    );
  }
}

class _EmbeddedWordChip extends StatelessWidget {
  const _EmbeddedWordChip({
    required this.word,
    required this.found,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.lightAtmosphere,
    required this.scale,
  });

  final String word;
  final bool found;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final bool lightAtmosphere;
  final double Function(double) scale;

  @override
  Widget build(BuildContext context) {
    final fill = lightAtmosphere
        ? Colors.white.withValues(alpha: 0.92)
        : const Color(0xE6121828);
    final labelColor = textColor;

    return Opacity(
      opacity: found ? 0.5 : 1,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: scale(10),
          vertical: scale(6),
        ),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(scale(10)),
          border: Border.all(
            color: iconColor.withValues(alpha: 0.95),
            width: scale(1.4),
          ),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: lightAtmosphere ? 0.22 : 0.4),
              blurRadius: scale(8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: scale(17)),
            SizedBox(width: scale(6)),
            Text(
              word.toUpperCase(),
              style: AppTextStyles.wordList(context).copyWith(
                fontSize: scale(13),
                fontWeight: FontWeight.w800,
                color: labelColor,
                height: 1.1,
                decoration: found ? TextDecoration.lineThrough : null,
                decorationColor: labelColor,
                decorationThickness: scale(1.6),
                letterSpacing: 0.5,
                shadows: lightAtmosphere
                    ? null
                    : [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          blurRadius: 4,
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
