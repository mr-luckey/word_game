import 'package:firebase_auth/firebase_auth.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/data/local/database.dart';

/// Guest progress stays local; on login merges local + cloud then syncs to Firestore.
class ProgressSyncService {
  ProgressSyncService(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreUserService _firestore;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  bool get isLoggedIn => _uid != null;

  /// After sign-in: merge guest (local) with cloud, persist both ways.
  Future<void> mergeGuestProgressIntoCloud({
    required String uid,
    required String displayName,
    required String email,
  }) async {
    final localRows = await _db.getAllProgress();
    final localCoins = await _db.getCoins();
    final cloudProgress = await _firestore.fetchLevelProgress(uid);
    final cloudCoins = await _firestore.fetchCoins(uid) ?? 0;

    final mergedLevels = <int, LevelProgressRecord>{...cloudProgress};
    for (final row in localRows) {
      final existing = mergedLevels[row.levelId];
      if (existing == null || row.stars > existing.stars) {
        mergedLevels[row.levelId] = LevelProgressRecord(
          levelId: row.levelId,
          stars: row.stars,
          timeSeconds: row.timeSeconds,
        );
      }
    }

    final mergedCoins =
        localCoins > cloudCoins ? localCoins : cloudCoins;

    for (final entry in mergedLevels.values) {
      await _db.saveProgress(
        levelId: entry.levelId,
        stars: entry.stars,
        timeSeconds: entry.timeSeconds,
      );
    }
    await _db.setCoins(mergedCoins);

    await _firestore.upsertUserProfile(
      uid: uid,
      displayName: displayName,
      email: email,
      coins: mergedCoins,
    );

    for (final entry in mergedLevels.values) {
      await _firestore.saveLevelProgress(
        uid: uid,
        levelId: entry.levelId,
        stars: entry.stars,
        timeSeconds: entry.timeSeconds,
      );
    }
  }

  Future<void> syncLevelProgress({
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    await _firestore.saveLevelProgress(
      uid: uid,
      levelId: levelId,
      stars: stars,
      timeSeconds: timeSeconds,
    );
    final coins = await _db.getCoins();
    await _firestore.updateCoins(uid, coins);
  }

  Future<void> syncCoins() async {
    final uid = _uid;
    if (uid == null) return;
    final coins = await _db.getCoins();
    await _firestore.updateCoins(uid, coins);
  }

  Future<void> pushAllLocalToCloud() async {
    final uid = _uid;
    final user = FirebaseAuth.instance.currentUser;
    if (uid == null || user == null) return;

    final rows = await _db.getAllProgress();
    final coins = await _db.getCoins();
    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : 'Player';

    await _firestore.upsertUserProfile(
      uid: uid,
      displayName: name,
      email: user.email ?? '',
      coins: coins,
    );

    for (final row in rows) {
      await _firestore.saveLevelProgress(
        uid: uid,
        levelId: row.levelId,
        stars: row.stars,
        timeSeconds: row.timeSeconds,
      );
    }
  }
}
