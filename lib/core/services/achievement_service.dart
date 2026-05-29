import 'package:drift/drift.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/profile/domain/entities/achievement.dart';

/// Tracks stats and unlocks achievements with coin rewards.
class AchievementService {
  AchievementService(this._db, this._wallet, this._dailyLevelId);

  final AppDatabase _db;
  final WalletRepository _wallet;
  final int _dailyLevelId;

  static const _statWords = 'stat_words_found';
  static const _statLevels = 'stat_levels_completed';
  static const _statNoHintStreak = 'stat_no_hint_streak';
  static const _statRotates = 'stat_rotates';

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
    return _check(['first_word', 'word_50', 'word_200']);
  }

  Future<List<AchievementUnlock>> onLevelComplete({
    required int stars,
    required int timeSeconds,
    required int hintsUsed,
    required int levelId,
  }) async {
    await incrementStat(_statLevels);
    if (hintsUsed == 0) {
      await incrementStat(_statNoHintStreak);
    } else {
      await _setStat(_statNoHintStreak, 0);
    }

    final ids = <String>[
      'first_level',
      'levels_10',
      'levels_25',
    ];
    if (stars == 3) ids.add('three_stars');
    if (timeSeconds < 60) ids.add('speed_demon');
    if (hintsUsed == 0) {
      final streak = await _stat(_statNoHintStreak);
      if (streak >= 5) ids.add('hint_free');
    }
    if (levelId == _dailyLevelId) ids.add('daily_bonus');

    final coins = await _wallet.getCoins();
    if (coins >= 1000) ids.add('coin_collector');

    return _check(ids);
  }

  Future<List<AchievementUnlock>> onBoardRotated() async {
    await incrementStat(_statRotates);
    final rotates = await _stat(_statRotates);
    if (rotates >= 20) {
      return _check(['rotate_master']);
    }
    return [];
  }

  Future<List<AchievementUnlock>> onCoinsChanged() async {
    final coins = await _wallet.getCoins();
    if (coins >= 1000) {
      return _check(['coin_collector']);
    }
    return [];
  }

  Future<List<AchievementUnlock>> _check(List<String> ids) async {
    final unlocked = <AchievementUnlock>[];
    for (final id in ids) {
      final result = await _tryUnlock(id);
      if (result != null) unlocked.add(result);
    }
    return unlocked;
  }

  Future<AchievementUnlock?> _tryUnlock(String id) async {
    final def = kAchievements.firstWhere((a) => a.id == id);
    final existing = await (_db.select(_db.achievementTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (existing?.unlocked == true) return null;

    if (!await _meetsCondition(id)) return null;

    await _db.unlockAchievement(id);
    if (def.coinReward > 0) {
      await _wallet.addCoins(def.coinReward);
    }
    return AchievementUnlock(
      achievement: def.copyWith(unlocked: true),
      coinsAwarded: def.coinReward,
    );
  }

  Future<bool> _meetsCondition(String id) async {
    final words = await _stat(_statWords);
    final levels = await _stat(_statLevels);
    final noHint = await _stat(_statNoHintStreak);
    final rotates = await _stat(_statRotates);
    final coins = await _wallet.getCoins();

    return switch (id) {
      'first_word' => words >= 1,
      'word_50' => words >= 50,
      'word_200' => words >= 200,
      'first_level' => levels >= 1,
      'levels_10' => levels >= 10,
      'levels_25' => levels >= 25,
      'speed_demon' => true, // checked before call
      'three_stars' => true,
      'hint_free' => noHint >= 5,
      'rotate_master' => rotates >= 20,
      'daily_bonus' => true,
      'coin_collector' => coins >= 1000,
      _ => false,
    };
  }
}
