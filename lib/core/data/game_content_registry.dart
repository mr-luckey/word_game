import 'package:word_game/core/data/models/achievement_badge_config.dart';
import 'package:word_game/core/data/models/daily_challenge_config.dart';
import 'package:word_game/core/data/models/explore_slot_display.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

/// Shared levels + per-theme explore names (same gameplay everywhere).
class GameContentRegistry {
  GameContentRegistry({
    required this.sharedLevels,
    required this.exploreByPreset,
    required this.dailyChallenge,
    required this.achievements,
  });

  final List<LevelJson> sharedLevels;
  final Map<AppThemePreset, List<ExploreSlotDisplay>> exploreByPreset;
  final DailyChallengeConfig dailyChallenge;
  final AchievementsConfig achievements;

  List<ExploreSlotDisplay> exploreForPreset(AppThemePreset preset) =>
      exploreByPreset[preset] ?? const [];

  ExploreSlotDisplay? exploreSlot(AppThemePreset preset, int slotId) {
    for (final slot in exploreForPreset(preset)) {
      if (slot.slotId == slotId) return slot;
    }
    return null;
  }

  /// Playable location: themed shell around [sharedLevels].
  ThemeCategoryEntity themeForSlot(AppThemePreset preset, int slotId) {
    final display = exploreSlot(preset, slotId) ??
        exploreForPreset(preset).firstOrNull;
    if (display == null) {
      return ThemeCategoryEntity(
        id: slotId,
        name: 'Adventure',
        theme: preset.folder,
        backgroundImage: '${preset.folder}/grid_full.webp',
        levels: sharedLevels,
      );
    }
    return ThemeCategoryEntity(
      id: display.slotId,
      name: display.name,
      theme: preset.folder,
      backgroundImage: display.backgroundImage,
      levels: sharedLevels,
    );
  }

  List<ThemeCategoryEntity> themesForPreset(AppThemePreset preset) =>
      exploreForPreset(preset)
          .map((s) => themeForSlot(preset, s.slotId))
          .toList();

  List<DestinationSpec> destinationsForPreset(AppThemePreset preset) =>
      exploreForPreset(preset)
          .map(
            (s) => DestinationSpec(
              id: s.slotId,
              name: s.name,
              country: s.country,
              preset: preset,
              imageSlug: s.imageSlug,
              unlockOrder: s.unlockOrder,
              hasLevels: true,
            ),
          )
          .toList();

  DestinationSpec? destinationForSlot(AppThemePreset preset, int slotId) {
    final slot = exploreSlot(preset, slotId);
    if (slot == null) return null;
    return DestinationSpec(
      id: slot.slotId,
      name: slot.name,
      country: slot.country,
      preset: preset,
      imageSlug: slot.imageSlug,
      unlockOrder: slot.unlockOrder,
      hasLevels: true,
    );
  }

  AppThemePreset presetForDestinationId(int id) => AppThemePreset.classicTravel;

  LevelEntity? levelById(int levelId, {AppThemePreset? preset, int? slotId}) {
    for (final level in sharedLevels) {
      if (level.id == levelId) {
        final p = preset ?? AppThemePreset.classicTravel;
        final slot = slotId ?? 1;
        final theme = themeForSlot(p, slot);
        return LevelEntity(
          id: level.id,
          themeId: theme.id,
          themeName: theme.name,
          backgroundImage: theme.backgroundImage,
          difficultyIndex: level.difficultyIndex,
          gridSize: level.gridSize,
          timeLimit: level.timeLimit,
          hintsAllowed: level.hintsAllowed,
          coinsReward: level.coinsReward,
          words: level.words,
        );
      }
    }
    return null;
  }

  LevelEntity buildDailyLevel({
    required AppThemePreset preset,
    required int coinsReward,
    required List<String> words,
  }) {
    final folder = preset.folder;
    final bg = dailyChallenge.backgroundImageTemplate
        .replaceAll('{themeFolder}', folder);
    return LevelEntity(
      id: dailyChallenge.levelId,
      themeId: 0,
      themeName: dailyChallenge.name,
      backgroundImage: bg,
      difficultyIndex: dailyChallenge.difficultyIndex,
      gridSize: dailyChallenge.gridSize,
      timeLimit: dailyChallenge.timeLimit,
      hintsAllowed: dailyChallenge.hintsAllowed,
      coinsReward: coinsReward,
      words: words,
    );
  }
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
