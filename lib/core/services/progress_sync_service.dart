import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/core/services/user_cloud_data.dart';
import 'package:word_game/data/local/database.dart';

/// Guest progress stays local; on login merges local + cloud then syncs to Firestore.
class ProgressSyncService {
  ProgressSyncService(this._db, this._firestore, this._prefs);

  final AppDatabase _db;
  final FirestoreUserService _firestore;
  final SharedPreferences _prefs;

  static const _removeAdsKey = 'remove_ads';

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
    final localExtras = await _readLocalExtras();

    var cloudProgress = <int, LevelProgressRecord>{};
    var cloudCoins = 0;
    var cloudExtras = const UserCloudData();

    try {
      cloudProgress = await _firestore.fetchLevelProgress(uid);
      cloudCoins = await _firestore.fetchCoins(uid) ?? 0;
      cloudExtras = await _firestore.fetchUserCloudData(uid);
    } on FirebaseException catch (e) {
      if (e.code != 'permission-denied') rethrow;
    }

    final mergedLevels = <int, LevelProgressRecord>{...cloudProgress};
    for (final row in localRows) {
      final existing = mergedLevels[row.levelId];
      if (_isLocalLevelBetter(row.stars, row.timeSeconds, existing)) {
        mergedLevels[row.levelId] = LevelProgressRecord(
          levelId: row.levelId,
          stars: row.stars,
          timeSeconds: row.timeSeconds,
        );
      }
    }

    final mergedCoins = localCoins > cloudCoins ? localCoins : cloudCoins;
    final mergedExtras = _mergeExtras(localExtras, cloudExtras);

    for (final entry in mergedLevels.values) {
      await _db.saveProgress(
        levelId: entry.levelId,
        stars: entry.stars,
        timeSeconds: entry.timeSeconds,
      );
    }
    await _db.setCoins(mergedCoins);
    await _applyExtrasLocally(mergedExtras);

    try {
      await _firestore.upsertUserProfile(
        uid: uid,
        displayName: displayName,
        email: email,
        coins: mergedCoins,
        extras: mergedExtras,
      );

      for (final entry in mergedLevels.values) {
        await _firestore.saveLevelProgress(
          uid: uid,
          levelId: entry.levelId,
          stars: entry.stars,
          timeSeconds: entry.timeSeconds,
        );
      }
    } on FirebaseException catch (e) {
      if (e.code != 'permission-denied') rethrow;
    }
  }

  Future<void> syncLevelProgress({
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _firestore.saveLevelProgress(
        uid: uid,
        levelId: levelId,
        stars: stars,
        timeSeconds: timeSeconds,
      );
      final coins = await _db.getCoins();
      await _firestore.updateCoins(uid, coins);
    } on FirebaseException catch (_) {}
  }

  Future<void> syncCoins() async {
    final uid = _uid;
    if (uid == null) return;
    final coins = await _db.getCoins();
    try {
      await _firestore.updateCoins(uid, coins);
    } on FirebaseException catch (_) {}
  }

  /// Push purchases, achievements, stats, coins, and all level rows to cloud.
  Future<void> syncAllUserDataToCloud() async {
    final uid = _uid;
    final user = FirebaseAuth.instance.currentUser;
    if (uid == null || user == null) return;

    await mergeGuestProgressIntoCloud(
      uid: uid,
      displayName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!.trim()
          : 'Player',
      email: user.email ?? '',
    );
  }

  Future<void> recordPurchaseAndSync(String productId) async {
    await _db.addPurchasedProduct(productId);
    if (productId == 'remove_ads') {
      await _prefs.setBool(_removeAdsKey, true);
    }
    if (!isLoggedIn) return;
    try {
      final extras = await _readLocalExtras();
      await _firestore.syncUserMetadata(uid: _uid!, extras: extras);
      await syncCoins();
    } on FirebaseException catch (_) {}
  }

  bool _isLocalLevelBetter(
    int localStars,
    int localTime,
    LevelProgressRecord? cloud,
  ) {
    if (cloud == null) return true;
    if (localStars > cloud.stars) return true;
    if (localStars < cloud.stars) return false;
    if (localTime <= 0) return false;
    return cloud.timeSeconds <= 0 || localTime < cloud.timeSeconds;
  }

  Future<UserCloudData> _readLocalExtras() async {
    return UserCloudData(
      removeAds: _prefs.getBool(_removeAdsKey) ?? false,
      purchasedProducts: await _db.getPurchasedProducts(),
      stats: await _db.getGameplayStats(),
      achievementIds: await _db.getUnlockedAchievementIds(),
    );
  }

  Future<void> _applyExtrasLocally(UserCloudData data) async {
    if (data.removeAds) {
      await _prefs.setBool(_removeAdsKey, true);
    }
    for (final id in data.purchasedProducts) {
      await _db.addPurchasedProduct(id);
    }
    await _db.applyGameplayStats(data.stats);
    await _db.applyUnlockedAchievements(data.achievementIds);
  }

  UserCloudData _mergeExtras(UserCloudData local, UserCloudData cloud) {
    final purchased = {...cloud.purchasedProducts, ...local.purchasedProducts}
        .toList();
    final stats = <String, int>{...cloud.stats};
    for (final entry in local.stats.entries) {
      stats[entry.key] = _maxInt(stats[entry.key], entry.value);
    }
    final achievements = {
      ...cloud.achievementIds,
      ...local.achievementIds,
    }.toList();

    return UserCloudData(
      removeAds: local.removeAds || cloud.removeAds,
      purchasedProducts: purchased,
      stats: stats,
      achievementIds: achievements,
    );
  }

  int _maxInt(int? a, int b) {
    final left = a ?? 0;
    return left > b ? left : b;
  }
}
