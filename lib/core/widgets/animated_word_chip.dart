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
  });

  final String word;
  final bool found;
  final int index;
  final bool compact;
  final bool scenic;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = found ? colors.foundColorForIndex(index) : null;
    final hPad = compact ? 10.0 : 14.0;
    final vPad = compact ? 5.0 : 8.0;
    final radius = compact ? 14.0 : 20.0;

    final bg = found
        ? (accent ?? colors.success).withValues(alpha: 0.22)
        : scenic
            ? colors.scrim.withValues(alpha: 0.55)
            : colors.glassSurface;
    final borderColor = found
        ? (accent ?? colors.success)
        : scenic
            ? colors.onScenicMuted.withValues(alpha: 0.35)
            : colors.cellBorder;
    final textColor = found
        ? (accent ?? colors.success)
        : scenic
            ? colors.onScenicMuted
            : colors.onSurface;

    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor,
          width: found ? 1.5 : 1,
        ),
      ),
      child: Text(
        word,
        style: (found
                ? AppTextStyles.wordChipFound(context)
                : AppTextStyles.wordChip(context))
            .copyWith(
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: textColor,
          decorationColor: accent ?? colors.success,
        ),
      ),
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
