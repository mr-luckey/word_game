import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class AnimatedWordChip extends StatelessWidget {
  const AnimatedWordChip({
    super.key,
    required this.word,
    required this.found,
    required this.index,
  });

  final String word;
  final bool found;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = found
        ? AppColors.foundColorForIndex(index)
        : AppColors.cellDefault;

    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: found ? color.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: found ? color : AppColors.cellBorder,
          width: found ? 2 : 1,
        ),
        boxShadow: found
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        word,
        style: (found ? AppTextStyles.wordListFound : AppTextStyles.wordList).copyWith(
          color: found ? color.withValues(alpha: 0.95) : AppColors.darkText,
          fontWeight: found ? FontWeight.w700 : FontWeight.w500,
          decoration: found ? TextDecoration.lineThrough : null,
          decorationColor: color,
        ),
      ),
    )
        .animate(target: found ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.08, 1.08),
          duration: 200.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.08, 1.08),
          end: const Offset(1, 1),
          duration: 150.ms,
        );
  }
}
