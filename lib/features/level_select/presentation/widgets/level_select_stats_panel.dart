import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

class LevelSelectStatsPanel extends StatelessWidget {
  const LevelSelectStatsPanel({
    super.key,
    required this.difficultyIndex,
    required this.onDifficultyChanged,
    required this.completedCount,
    required this.totalCount,
    required this.totalStars,
  });

  final int difficultyIndex;
  final ValueChanged<int> onDifficultyChanged;
  final int completedCount;
  final int totalCount;
  final int totalStars;

  static const _diffLabels = ['Easy', 'Medium', 'Hard', 'Pro'];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListView(
      padding: JourneyThemeKit.pagePadding(context),
      children: [
        JourneyPanel(
          padding: const EdgeInsets.all(4),
          radius: 24,
          child: Row(
            children: List.generate(4, (i) {
              final selected = difficultyIndex == i;
              return Expanded(
                child: Material(
                  color: selected ? colors.gold : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => onDifficultyChanged(i),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _diffLabels[i],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? colors.onPrimary
                              : colors.onScenicMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        _StatCard(
          label: 'Levels completed',
          value: '$completedCount / $totalCount',
          icon: Icons.flag_rounded,
        ),
        const SizedBox(height: 10),
        _StatCard(
          label: 'Stars earned',
          value: '$totalStars',
          icon: Icons.star_rounded,
        ),
        const SizedBox(height: 10),
        _StatCard(
          label: 'Difficulty',
          value: _diffLabels[difficultyIndex],
          icon: Icons.tune_rounded,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return JourneyPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      radius: 16,
      child: Row(
        children: [
          Icon(icon, color: colors.gold, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyMuted(context).copyWith(
                    fontSize: 12,
                    color: colors.onScenicMuted,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.sectionHeading(context).copyWith(
                    fontSize: 18,
                    color: colors.onScenic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
