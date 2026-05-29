import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

abstract class LevelRepository {
  Future<List<ThemeCategoryEntity>> loadThemes();

  /// Explore locations for a visual theme (same shared levels inside).
  Future<List<ThemeCategoryEntity>> loadThemesForPreset(AppThemePreset preset);
  Future<LevelEntity?> getLevelById(int levelId);
  Future<LevelEntity?> getNextLevel(int currentLevelId);
}

abstract class ProgressRepository {
  Future<int?> getStarsForLevel(int levelId);
  Future<bool> isLevelUnlocked(int levelId, List<int> orderedLevelIds);
  Future<void> saveProgress({
    required int levelId,
    required int stars,
    required int timeSeconds,
  });
  Future<Map<int, int>> getAllStars();

  /// Stars for one explore slot; keys are shared level ids (101, 102, …).
  Future<Map<int, int>> getStarsForSlot(int slotId);

  /// Next shared level id to play (first incomplete, or last completed).
  Future<int> resolveResumeLevelId({
    required int slotId,
    required List<int> orderedSharedLevelIds,
  });
}

abstract class WalletRepository {
  Future<int> getCoins();
  Future<bool> spendCoins(int amount);
  Future<void> addCoins(int amount);
}
