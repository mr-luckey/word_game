import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.levelNumber,
    required this.stars,
    required this.locked,
    this.isActive = false,
    this.onTap,
  });

  final int levelNumber;
  final int stars;
  final bool locked;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final completed = !locked && stars > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: JourneyDecorations.levelTileDecoration(
            context,
            locked: locked,
            isActive: isActive,
            completed: completed,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingSm,
              horizontal: 4,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (locked)
                  Icon(Icons.lock_rounded, color: colors.gold, size: 26)
                else
                  Text(
                    '$levelNumber',
                    style: AppTextStyles.button(context).copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isActive ? colors.onSurface : colors.onScenic,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = !locked && i < stars;
                    return Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 12,
                      color: locked
                          ? colors.locked
                          : filled
                              ? colors.gold
                              : colors.gold.withValues(alpha: 0.55),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 280.ms).scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
