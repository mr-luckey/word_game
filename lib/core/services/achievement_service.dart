import 'package:drift/drift.dart';
import 'package:word_game/core/data/achievement_catalog_loader.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/profile/domain/entities/achievement.dart';

/// Tracks stats and unlocks achievements with coin/XP rewards.
class AchievementService {
  AchievementService(this._db, this._wallet, this._xp, this._dailyLevelId);

  final AppDatabase _db;
  final WalletRepository _wallet;
  final XpRepository _xp;
  final int _dailyLevelId;

  static const _statWords = 'stat_words_found';
  static const _statLevels = 'stat_levels_completed';
  static const _statNoHintStreak = 'stat_no_hint_streak';
  static const _statNoRevealStreak = 'stat_no_reveal_streak';
  static const _statRotates = 'stat_rotates';
  static const _statFastLevels = 'stat_fast_levels';
  static const _statDaily = 'stat_daily_challenges';

  Future<int> _stat(String key) async {
    final row = await (_db.select(_db.keyValueTable)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? 0;
  }

  Future<void> _setStat(String key, int value) async {
    await _db.into(_db.keyValueTable).insertOnConflictUpdate(
          KeyValueTableCompanion(
            key: Value(key),
            value: Value(value.toString()),
          ),
        );
  }

  Future<void> incrementStat(String key, [int by = 1]) async {
    final current = await _stat(key);
    await _setStat(key, current + by);
  }

  Future<List<AchievementUnlock>> onWordFound() async {
    await incrementStat(_statWords);
    return _checkCatalog(category: 'words', statKey: _statWords);
  }

  Future<List<AchievementUnlock>> onLevelComplete({
    required int stars,
    required int timeSeconds,
    required int hintsUsed,
    required int revealsUsed,
    required int levelId,
  }) async {
    await incrementStat(_statLevels);
    if (hintsUsed == 0) {
      await incrementStat(_statNoHintStreak);
    } else {
      await _setStat(_statNoHintStreak, 0);
    }
    if (revealsUsed == 0) {
      await incrementStat(_statNoRevealStreak);
    } else {
      await _setStat(_statNoRevealStreak, 0);
    }
    if (timeSeconds < 60) {
      await incrementStat(_statFastLevels);
    }
    if (levelId == _dailyLevelId) {
      await incrementStat(_statDaily);
    }

    final unlocks = <AchievementUnlock>[];
    unlocks.addAll(await _checkCatalog(category: 'levels', statKey: _statLevels));
    unlocks.addAll(await _checkCatalog(category: 'no_hint', statKey: _statNoHintStreak));
    unlocks.addAll(await _checkCatalog(category: 'no_reveal', statKey: _statNoRevealStreak));
    unlocks.addAll(await _checkCatalog(category: 'fast', statKey: _statFastLevels));
    unlocks.addAll(await _checkCatalog(category: 'daily', statKey: _statDaily));
    unlocks.addAll(await _checkCatalog(category: 'xp', statKey: null, value: await _xp.getXp()));
    return unlocks;
  }

  Future<List<AchievementUnlock>> onBoardRotated() async {
    await incrementStat(_statRotates);
    return _checkCatalog(category: 'misc', statKey: _statRotates);
  }

  Future<List<AchievementUnlock>> onCoinsChanged() async {
    final coins = await _wallet.getCoins();
    if (coins >= 1000) {
      return _tryUnlockById('coin_collector');
    }
    return [];
  }

  Future<List<AchievementUnlock>> _checkCatalog({
    required String category,
    String? statKey,
    int? value,
  }) async {
    final catalog = await AchievementCatalogLoader.load();
    final current = value ?? (statKey != null ? await _stat(statKey) : 0);
    final unlocks = <AchievementUnlock>[];
    for (final def in catalog.where((a) => a.category == category)) {
      if (current >= def.target) {
        final result = await _tryUnlock(def);
        if (result != null) unlocks.add(result);
      }
    }
    return unlocks;
  }

  Future<List<AchievementUnlock>> _tryUnlockById(String id) async {
    final catalog = await AchievementCatalogLoader.load();
    final def = catalog.where((a) => a.id == id).firstOrNull;
    if (def == null) return [];
    final result = await _tryUnlock(def);
    return result != null ? [result] : [];
  }

  Future<AchievementUnlock?> _tryUnlock(Achievement def) async {
    final existing = await (_db.select(_db.achievementTable)
          ..where((t) => t.id.equals(def.id)))
        .getSingleOrNull();
    if (existing?.unlocked == true) return null;

    await _db.unlockAchievement(def.id);
    if (def.coinReward > 0) {
      await _wallet.addCoins(def.coinReward);
    }
    if (def.xpReward > 0) {
      await _xp.addXp(def.xpReward);
    }
    return AchievementUnlock(
      achievement: def.copyWith(unlocked: true),
      coinsAwarded: def.coinReward,
      xpAwarded: def.xpReward,
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
