import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/progress_sync_service.dart';
import 'package:word_game/core/utils/level_progress_id.dart';
import 'package:word_game/core/utils/level_progress_stats.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._db, this._sync);

  final AppDatabase _db;
  final ProgressSyncService _sync;

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
    return _hasCompletedStorageLevel(prevId);
  }

  Future<bool> _hasCompletedStorageLevel(int storageLevelId) async {
    if ((await _db.getProgress(storageLevelId)) != null) return true;

    if (storageLevelId >= LevelProgressId.slotMultiplier) {
      final slotId = storageLevelId ~/ LevelProgressId.slotMultiplier;
      final sharedId = storageLevelId % LevelProgressId.slotMultiplier;
      if (slotId == 1 &&
          (LevelProgressId.isLegacyStorageKey(sharedId) ||
              LevelProgressId.isCompactUnencodedKey(sharedId))) {
        if ((await _db.getProgress(sharedId)) != null) return true;
      }
      if (slotId == 1 && sharedId < 100) {
        final legacyShared = sharedId + 100;
        final legacyEncoded = LevelProgressId.encode(
          slotId: slotId,
          sharedLevelId: legacyShared,
        );
        if ((await _db.getProgress(legacyEncoded)) != null) return true;
        if (LevelProgressId.isLegacyStorageKey(legacyShared) &&
            (await _db.getProgress(legacyShared)) != null) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<int> resolveResumeLevelId({
    required int slotId,
    required List<int> orderedSharedLevelIds,
  }) async {
    if (orderedSharedLevelIds.isEmpty) return 1;

    final sorted = [...orderedSharedLevelIds]..sort();
    final rawStars = await getStarsForSlot(slotId);
    final stars = LevelProgressStats.normalizeStars(rawStars, sorted);
    final orderedStorage = sorted
        .map((id) => LevelProgressId.encode(slotId: slotId, sharedLevelId: id))
        .toList();

    return LevelProgressStats.pickResumeSharedId(
      normalizedStars: stars,
      orderedPackIds: sorted,
      isUnlocked: isLevelUnlocked,
      orderedStorageIds: orderedStorage,
    );
  }

  @override
  Future<void> saveProgress({
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) async {
    await _db.saveProgress(
      levelId: levelId,
      stars: stars,
      timeSeconds: timeSeconds,
    );
    unawaited(
      _sync
          .syncLevelProgress(
            levelId: levelId,
            stars: stars,
            timeSeconds: timeSeconds,
          )
          .catchError((Object e, StackTrace st) {
        debugPrint('Cloud level sync failed: $e\n$st');
      }),
    );
  }

  @override
  Future<Map<int, int>> getAllStars() async {
    final rows = await _db.getAllProgress();
    return {for (final r in rows) r.levelId: r.stars};
  }

  @override
  Future<Map<int, int>> getStarsForSlot(int slotId) async {
    final rows = await _db.getAllProgress();
    final stars = <int, int>{};
    for (final row in rows) {
      if (!LevelProgressId.matchesSlot(row.levelId, slotId)) continue;
      final sharedId = LevelProgressId.sharedLevelIdFromStorageKey(row.levelId);
      stars[sharedId] = row.stars;
    }
    return stars;
  }

  @override
  Future<int> countCompletedLevels(int slotId) async {
    final stars = await getStarsForSlot(slotId);
    return stars.values.where((s) => s > 0).length;
  }
}

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._db, this._sync);

  final AppDatabase _db;
  final ProgressSyncService _sync;

  @override
  Future<int> getCoins() => _db.getCoins();

  @override
  Future<bool> spendCoins(int amount) async {
    final current = await getCoins();
    if (current < amount) return false;
    await _db.setCoins(current - amount);
    unawaited(_sync.syncCoins().catchError((Object e, StackTrace st) {
      debugPrint('Cloud coins sync failed: $e\n$st');
    }));
    return true;
  }

  @override
  Future<void> addCoins(int amount) async {
    final current = await getCoins();
    await _db.setCoins(current + amount);
    unawaited(_sync.syncCoins().catchError((Object e, StackTrace st) {
      debugPrint('Cloud coins sync failed: $e\n$st');
    }));
  }

  @override
  Future<bool> hasWelcomeBonusGranted() => _db.getBool('welcome_bonus_granted');

  @override
  Future<void> grantWelcomeBonus() async {
    if (await hasWelcomeBonusGranted()) return;
    await _db.setCoins(GameConfig.initialCoins);
    await _db.setBool('welcome_bonus_granted', true);
    unawaited(_sync.syncCoins().catchError((Object e, StackTrace st) {
      debugPrint('Cloud coins sync failed: $e\n$st');
    }));
  }
}

class XpRepositoryImpl implements XpRepository {
  XpRepositoryImpl(this._db, this._sync);

  final AppDatabase _db;
  final ProgressSyncService _sync;

  @override
  Future<int> getXp() => _db.getXp();

  @override
  Future<void> addXp(int amount) async {
    final current = await getXp();
    await _db.setXp(current + amount);
    unawaited(_sync.syncXp().catchError((Object e, StackTrace st) {
      debugPrint('Cloud xp sync failed: $e\n$st');
    }));
  }

  @override
  Future<void> setXp(int amount) async {
    await _db.setXp(amount);
    unawaited(_sync.syncXp().catchError((Object e, StackTrace st) {
      debugPrint('Cloud xp sync failed: $e\n$st');
    }));
  }
}
