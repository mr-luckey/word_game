import 'package:flutter/material.dart';
import 'package:word_game/core/theme/app_theme_extension.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

class LevelMapSection {
  const LevelMapSection({
    required this.label,
    required this.nodeIndex,
    required this.difficultyIndex,
  });

  final String label;
  final int nodeIndex;
  final int difficultyIndex;
}

const _difficultyLabels = ['Easy', 'Medium', 'Hard', 'Pro'];

List<LevelJson> sortedMapLevels(List<LevelJson> levels) {
  final copy = List<LevelJson>.from(levels)..sort((a, b) => a.id.compareTo(b.id));
  return copy;
}

/// Section markers wherever difficulty changes (level 1 Easy, level 6 Medium, …).
List<LevelMapSection> buildLevelMapSections(List<LevelJson> levels) {
  final sorted = sortedMapLevels(levels);
  if (sorted.isEmpty) return const [];

  final sections = <LevelMapSection>[];
  int? lastDifficulty;

  for (var i = 0; i < sorted.length; i++) {
    final d = sorted[i].difficultyIndex.clamp(0, 3);
    if (d != lastDifficulty) {
      sections.add(
        LevelMapSection(
          label: _difficultyLabels[d],
          nodeIndex: i,
          difficultyIndex: d,
        ),
      );
      lastDifficulty = d;
    }
  }

  return sections;
}

Color sectionColor(AppThemeColors colors, int difficultyIndex) {
  return switch (difficultyIndex.clamp(0, 3)) {
    0 => colors.easy,
    1 => colors.medium,
    2 => colors.hard,
    3 => colors.pro,
    _ => colors.easy,
  };
}
