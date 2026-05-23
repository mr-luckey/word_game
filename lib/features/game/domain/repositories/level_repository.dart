import 'package:word_game/features/game/domain/entities/level_entity.dart';

abstract class LevelRepository {
  Future<List<ThemeCategoryEntity>> loadThemes();
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
}

abstract class WalletRepository {
  Future<int> getCoins();
  Future<bool> spendCoins(int amount);
  Future<void> addCoins(int amount);
}
