import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';

/// Daily Bonus / Achievements tile — dark card, gold icon, bordered.
class HomeActionTile extends StatelessWidget {
  const HomeActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(preset.cardRadius),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(preset.cardRadius),
            color: colors.surface.withValues(alpha: 0.88),
            border: Border.all(
              color: colors.glassBorder.withValues(alpha: 0.7),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: colors.gold, size: 30),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: AppTextStyles.levelName(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.onScenic,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMuted(context).copyWith(fontSize: 11),
                ),
                if (badge != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.monetization_on_rounded,
                          color: colors.gold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        badge!,
                        style: AppTextStyles.coinsScore(context).copyWith(
                          fontSize: 13,
                          color: colors.accentCoin,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
