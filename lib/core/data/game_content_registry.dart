import 'package:word_game/core/data/models/achievement_badge_config.dart';
import 'package:word_game/core/data/models/daily_challenge_config.dart';
import 'package:word_game/core/data/models/daily_game_config.dart';
import 'package:word_game/core/data/models/explore_slot_display.dart';
import 'package:word_game/core/data/models/slots_config.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

/// Explore card = slot number (1–10). Same levels in every theme for that slot.
class GameContentRegistry {
  GameContentRegistry({
    required this.exploreByPreset,
    required this.dailyChallenge,
    required this.achievements,
    required this.slotsConfig,
    required this.levelPacksBySlot,
  });

  final Map<AppThemePreset, List<ExploreSlotDisplay>> exploreByPreset;
  final DailyChallengeConfig dailyChallenge;
  final AchievementsConfig achievements;
  final SlotsConfig slotsConfig;
  final Map<int, List<LevelJson>> levelPacksBySlot;

  List<ExploreSlotDisplay> exploreForPreset(AppThemePreset preset) =>
      exploreByPreset[preset] ?? const [];

  ExploreSlotDisplay? exploreSlot(AppThemePreset preset, int slotId) {
    for (final slot in exploreForPreset(preset)) {
      if (slot.slotId == slotId) return slot;
    }
    return null;
  }

  /// Game data for destination card [slotId] — same in classic_travel, forest_quest, etc.
  List<LevelJson> levelsForSlot(int slotId) {
    return levelPacksBySlot[slotId] ?? const [];
  }

  ThemeCategoryEntity themeForSlot(AppThemePreset preset, int slotId) {
    final display = exploreSlot(preset, slotId) ??
        exploreForPreset(preset).firstOrNull;
    final levels = levelsForSlot(slotId);
    if (display == null) {
      return ThemeCategoryEntity(
        id: slotId,
        name: 'Adventure',
        theme: preset.folder,
        backgroundImage: '${preset.folder}/grid_full.webp',
        levels: levels,
      );
    }
    return ThemeCategoryEntity(
      id: display.slotId,
      name: display.name,
      theme: preset.folder,
      backgroundImage: display.backgroundImage,
      levels: levels,
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

  LevelEntity? levelById(int levelId, {AppThemePreset? preset, int? slotId}) {
    final p = preset ?? AppThemePreset.classicTravel;
    final slot = slotId ?? 1;
    final levels = levelsForSlot(slot);
    for (final level in levels) {
      if (level.id == levelId) {
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

  DailyGameConfig pickDailyGame(int daySeed) {
    final config = dailyChallenge;
    if (config.hasGames) {
      final index = daySeed.abs() % config.games.length;
      return config.games[index];
    }
    return DailyGameConfig(
      id: 0,
      words: config.wordPool,
    );
  }

  LevelEntity buildDailyLevel({
    required AppThemePreset preset,
    required int coinsReward,
    required DailyGameConfig game,
  }) {
    final folder = preset.folder;
    final bg = dailyChallenge.backgroundImageTemplate
        .replaceAll('{themeFolder}', folder);
    final words = game.words.length > dailyChallenge.wordsPerDay
        ? game.words.take(dailyChallenge.wordsPerDay).toList()
        : game.words;

    return LevelEntity(
      id: dailyChallenge.levelId,
      themeId: 0,
      themeName: dailyChallenge.name,
      backgroundImage: bg,
      difficultyIndex: game.difficultyIndex ?? dailyChallenge.difficultyIndex,
      gridSize: game.gridSize ?? dailyChallenge.gridSize,
      timeLimit: game.timeLimit ?? dailyChallenge.timeLimit,
      hintsAllowed: game.hintsAllowed ?? dailyChallenge.hintsAllowed,
      coinsReward: coinsReward,
      words: words,
    );
  }
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
