import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/hd_asset_image.dart';

/// Featured destination card — image + title overlay + progress footer.
class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
    this.imageAsset,
    this.onTap,
    this.progressPercent,
  });

  final String title;
  final int completed;
  final int total;
  final String? imageAsset;
  final VoidCallback? onTap;
  final int? progressPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    final progress = total > 0 ? completed / total : 0.0;
    final pct = progressPercent ?? (progress * 100).round();
    final image = imageAsset ??
        AssetPaths.themeImage('classic_travel/paris.webp');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(preset.cardRadius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(preset.cardRadius),
            border: Border.all(color: colors.glassBorder, width: 1),
            color: colors.surface.withValues(alpha: 0.85),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(preset.cardRadius),
                ),
                child: SizedBox(
                  height: 168,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      HdAssetImage(
                        asset: image,
                        fallback: DecoratedBox(
                          decoration:
                              BoxDecoration(gradient: colors.primaryGradient),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              colors.scrim.withValues(alpha: 0.15),
                              colors.scrim.withValues(alpha: 0.75),
                            ],
                            stops: const [0.35, 0.65, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.levelName(context).copyWith(
                            color: colors.onScenic,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            shadows: [
                              Shadow(color: colors.scrim, blurRadius: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$completed / $total levels completed',
                            style: AppTextStyles.bodyMuted(context).copyWith(
                              fontSize: 12,
                              color: colors.bodyMuted,
                            ),
                          ),
                        ),
                        Text(
                          '$pct%',
                          style: AppTextStyles.coinsScore(context).copyWith(
                            fontSize: 13,
                            color: colors.gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0, 1),
                        minHeight: 6,
                        backgroundColor: colors.tertiary.withValues(alpha: 0.6),
                        valueColor: AlwaysStoppedAnimation(colors.gold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0);
  }
}
