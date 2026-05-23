import 'package:word_game/data/local/database.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<int?> getStarsForLevel(int levelId) async {
    final row = await _db.getProgress(levelId);
    return row?.stars;
  }

  @override
  Future<bool> isLevelUnlocked(int levelId, List<int> orderedLevelIds) async {
    final index = orderedLevelIds.indexOf(levelId);
    if (index <= 0) return true;
    final prevId = orderedLevelIds[index - 1];
    final prev = await _db.getProgress(prevId);
    return prev != null;
  }

  @override
  Future<void> saveProgress({
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) =>
      _db.saveProgress(
        levelId: levelId,
        stars: stars,
        timeSeconds: timeSeconds,
      );

  @override
  Future<Map<int, int>> getAllStars() async {
    final rows = await _db.getAllProgress();
    return {for (final r in rows) r.levelId: r.stars};
  }
}

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<int> getCoins() => _db.getCoins();

  @override
  Future<bool> spendCoins(int amount) async {
    final current = await getCoins();
    if (current < amount) return false;
    await _db.setCoins(current - amount);
    return true;
  }

  @override
  Future<void> addCoins(int amount) async {
    final current = await getCoins();
    await _db.setCoins(current + amount);
  }
}
