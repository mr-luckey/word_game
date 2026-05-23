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
  });

  final String word;
  final bool found;
  final int index;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = found ? colors.foundColorForIndex(index) : colors.cellDefault;
    final hPad = compact ? 8.0 : 14.0;
    final vPad = compact ? 4.0 : 8.0;
    final radius = compact ? 12.0 : 20.0;

    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: found
            ? color.withValues(alpha: 0.25)
            : colors.glassSurface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: found ? color : colors.cellBorder,
          width: found ? 1.5 : 1,
        ),
        boxShadow: found
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Text(
        word,
        style: (found
                ? AppTextStyles.wordChipFound(context)
                : AppTextStyles.wordChip(context))
            .copyWith(
          color: found ? color.withValues(alpha: 0.95) : colors.onSurface,
          decorationColor: color,
        ),
      ),
    )
        .animate(target: found ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 200.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.05, 1.05),
          end: const Offset(1, 1),
          duration: 150.ms,
        );
  }
}
