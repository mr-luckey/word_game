import 'package:flutter/material.dart';
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
    final bg = locked
        ? AppColors.lockedGray
        : stars > 0
            ? AppColors.success
            : AppColors.primaryBlue;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingSm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (locked)
                const Icon(Icons.lock, color: Colors.white)
              else
                Text(
                  '$levelNumber',
                  style: AppTextStyles.button.copyWith(fontSize: 22),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    size: 14,
                    color: AppColors.gold,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
