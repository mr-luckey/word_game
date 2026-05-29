import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:word_game/core/services/progress_sync_service.dart';
import 'package:word_game/core/utils/level_progress_id.dart';
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
    final prev = await _db.getProgress(prevId);
    return prev != null;
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
}
