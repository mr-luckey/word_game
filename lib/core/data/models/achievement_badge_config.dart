import 'package:flutter/material.dart';

class AchievementBadgeConfig {
  const AchievementBadgeConfig({
    required this.icon,
    required this.label,
    required this.progressTarget,
  });

  final IconData icon;
  final String label;
  final int progressTarget;

  factory AchievementBadgeConfig.fromJson(Map<String, dynamic> json) {
    return AchievementBadgeConfig(
      icon: _iconFromName(json['icon'] as String? ?? 'star'),
      label: json['label'] as String,
      progressTarget: json['progressTarget'] as int? ?? 1,
    );
  }

  static IconData _iconFromName(String name) => switch (name) {
        'explore' => Icons.explore_rounded,
        'public' => Icons.public_rounded,
        'star' => Icons.star_rounded,
        'eco' => Icons.eco_rounded,
        'pets' => Icons.pets_rounded,
        'terrain' => Icons.terrain_rounded,
        'ac_unit' => Icons.ac_unit_rounded,
        'waves' => Icons.waves_rounded,
        'sailing' => Icons.sailing_rounded,
        'anchor' => Icons.anchor_rounded,
        _ => Icons.emoji_events_rounded,
      };
}

class AchievementsConfig {
  const AchievementsConfig({
    required this.defaultBadges,
    required this.themeBadges,
  });

  final List<AchievementBadgeConfig> defaultBadges;
  final Map<String, List<AchievementBadgeConfig>> themeBadges;

  List<AchievementBadgeConfig> badgesForTheme(String themeFolder) =>
      themeBadges[themeFolder] ?? defaultBadges;

  factory AchievementsConfig.fromJson(Map<String, dynamic> json) {
    final defaults = (json['defaultBadges'] as List<dynamic>)
        .map((e) => AchievementBadgeConfig.fromJson(e as Map<String, dynamic>))
        .toList();
    final themes = <String, List<AchievementBadgeConfig>>{};
    final rawThemes = json['themeBadges'] as Map<String, dynamic>? ?? {};
    for (final entry in rawThemes.entries) {
      themes[entry.key] = (entry.value as List<dynamic>)
          .map((e) => AchievementBadgeConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return AchievementsConfig(defaultBadges: defaults, themeBadges: themes);
  }
}
