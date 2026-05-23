import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
  });

  final String title;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.levelName),
            const SizedBox(height: AppSizes.paddingSm),
            Text(
              'Levels: $completed / $total',
              style: AppTextStyles.wordList,
            ),
            const SizedBox(height: AppSizes.paddingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.cellAlt,
                valueColor: const AlwaysStoppedAnimation(AppColors.primaryBlue),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).round()}%',
              style: AppTextStyles.wordList,
            ),
          ],
        ),
      ),
    );
  }
}
