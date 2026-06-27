import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

class AnimatedWordChip extends StatelessWidget {
  const AnimatedWordChip({
    super.key,
    required this.word,
    required this.found,
    required this.index,
    this.compact = false,
    this.scenic = false,
    this.onLightBackground = false,
  });

  final String word;
  final bool found;
  final int index;
  final bool compact;
  final bool scenic;
  final bool onLightBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = colors.foundColorForIndex(index);
    final hPad = onLightBackground ? 12.0 : (compact ? 10.0 : 14.0);
    final vPad = onLightBackground ? 6.0 : (compact ? 5.0 : 8.0);
    final radius = onLightBackground ? 12.0 : (compact ? 14.0 : 20.0);
    final fontSize = onLightBackground ? 13.0 : (compact ? 11.0 : 12.0);

    final textColor = onLightBackground
        ? accent
        : found
            ? accent
            : scenic
                ? colors.onScenic
                : colors.onSurface;

    final textStyle = (found
            ? AppTextStyles.wordChipFound(context)
            : onLightBackground
                ? AppTextStyles.wordList(context)
                : scenic
                    ? AppTextStyles.wordList(context)
                    : AppTextStyles.wordChip(context))
        .copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: textColor,
      decoration: found ? TextDecoration.lineThrough : null,
      decorationColor: accent,
    );

    if (scenic && !onLightBackground) {
      return Text(word, style: textStyle)
          .animate(target: found ? 1 : 0)
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.04, 1.04),
            duration: 200.ms,
          )
          .then()
          .scale(
            begin: const Offset(1.04, 1.04),
            end: const Offset(1, 1),
            duration: 150.ms,
          );
    }

    final bg = onLightBackground || found
        ? accent.withValues(alpha: found ? 0.24 : 0.14)
        : colors.glassSurface;
    final borderColor = onLightBackground || found ? accent : colors.cellBorder;

    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor,
          width: found ? 1.5 : 1.2,
        ),
      ),
      child: Text(word, style: textStyle),
    )
        .animate(target: found ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.04, 1.04),
          duration: 200.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.04, 1.04),
          end: const Offset(1, 1),
          duration: 150.ms,
        );
  }
}
