import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

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
    final gradient = locked
        ? const LinearGradient(
            colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
          )
        : stars > 0
            ? const LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
              )
            : AppColors.playButtonGradient;

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
                      color: AppColors.gold.withValues(alpha: 0.35),
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
                  const Icon(Icons.lock_rounded, color: Colors.white, size: 28)
                else
                  Text(
                    '$levelNumber',
                    style: AppTextStyles.button.copyWith(
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
                      color: locked ? Colors.white54 : AppColors.gold,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}
