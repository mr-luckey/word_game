import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

/// Cinematic header banner on level select (image + title overlay).
class JourneyLevelBanner extends StatelessWidget {
  const JourneyLevelBanner({
    super.key,
    required this.title,
    required this.imageAsset,
  });

  final String title;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 118,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imageAsset,
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
                      colors.scrim.withValues(alpha: 0.15),
                      colors.scrim.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Center(child: CompassBadge(size: 32)),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionHeading(context).copyWith(
                      fontSize: 18,
                      color: colors.onScenic,
                      letterSpacing: 1.2,
                      shadows: JourneyThemeKit.textGlow(context),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.glassBorder.withValues(alpha: 0.85),
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: spec.playButtonGlow.withValues(alpha: 0.2),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: -0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
