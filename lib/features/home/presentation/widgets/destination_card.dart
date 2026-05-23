import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/glass_panel.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    this.imageAsset,
    this.onTap,
  });

  final String title;
  final int completed;
  final int total;
  final String? imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final progress = total > 0 ? completed / total : 0.0;
    final image = imageAsset ?? AssetPaths.themeImage('paris_bg.jpg');

    return GlassPanel(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusLg),
            ),
            child: SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => DecoratedBox(
                      decoration: BoxDecoration(gradient: colors.primaryGradient),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colors.scrim,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSizes.paddingMd,
                    right: AppSizes.paddingMd,
                    bottom: AppSizes.paddingMd,
                    child: Row(
                      children: [
                        Icon(
                          Icons.flight_takeoff_rounded,
                          color: colors.gold,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.levelName(context).copyWith(
                              color: colors.onScenic,
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                  color: colors.scrim,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Levels $completed / $total',
                      style: AppTextStyles.wordList(context).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.coinsScore(context)
                          .copyWith(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: colors.cellAlt,
                    valueColor: AlwaysStoppedAnimation(colors.gold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(
          begin: 0.15,
          end: 0,
          curve: Curves.easeOutCubic,
        );
  }
}
