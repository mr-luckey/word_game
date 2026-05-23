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
    this.onTap,
  });

  final int levelNumber;
  final int stars;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final gradient = locked
        ? LinearGradient(
            colors: [colors.levelLockedStart, colors.levelLockedEnd],
          )
        : stars > 0
            ? LinearGradient(
                colors: [colors.levelCompleteStart, colors.levelCompleteEnd],
              )
            : colors.playButtonGradient;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            boxShadow: locked
                ? null
                : [
                    BoxShadow(
                      color: colors.gold.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingSm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (locked)
                  Icon(Icons.lock_rounded, color: colors.onPrimary, size: 28)
                else
                  Text(
                    '$levelNumber',
                    style: AppTextStyles.button(context).copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Icon(
                      i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 14,
                      color: locked
                          ? colors.onPrimary.withValues(alpha: 0.5)
                          : colors.gold,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
