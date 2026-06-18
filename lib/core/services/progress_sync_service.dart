import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_game/core/constants/game_config.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/core/constants/product_ids.dart';
import 'package:word_game/core/services/user_cloud_data.dart';
import 'package:word_game/core/services/vip_service.dart';
import 'package:word_game/data/local/database.dart';

/// Guest progress stays local; on login merges local + cloud then syncs to Firestore.
class ProgressSyncService {
  ProgressSyncService(this._db, this._firestore, this._prefs, this._vip);

  final AppDatabase _db;
  final FirestoreUserService _firestore;
  final SharedPreferences _prefs;
  final VipService _vip;

  static const _removeAdsKey = 'remove_ads';

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  bool get isLoggedIn => _uid != null;

  /// After sign-in: merge guest (local) with cloud, persist both ways.
  Future<void> mergeGuestProgressIntoCloud({
    required String uid,
    required String displayName,
    required String email,
    String? photoUrl,
  }) async {
    final localRows = await _db.getAllProgress();
    final localCoins = await _db.getCoins();
    final localXp = await _db.getXp();
    final localExtras = await _readLocalExtras();

    var cloudProgress = <int, LevelProgressRecord>{};
    var cloudCoins = 0;
    var cloudXp = 0;
    var cloudExtras = const UserCloudData();
    var isNewAccount = true;

    try {
      cloudProgress = await _firestore.fetchLevelProgress(uid);
      cloudCoins = await _firestore.fetchCoins(uid) ?? 0;
      cloudXp = await _firestore.fetchXp(uid) ?? 0;
      cloudExtras = await _firestore.fetchUserCloudData(uid);
      isNewAccount = !await _firestore.userDocExists(uid);
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

    var mergedCoins = localCoins > cloudCoins ? localCoins : cloudCoins;
    var mergedXp = localXp > cloudXp ? localXp : cloudXp;
    var mergedExtras = _mergeExtras(localExtras, cloudExtras);

    if (isNewAccount && !mergedExtras.welcomeBonusGranted) {
      if (mergedCoins < GameConfig.initialCoins) {
        mergedCoins = GameConfig.initialCoins;
      }
      mergedExtras = UserCloudData(
        removeAds: mergedExtras.removeAds,
        purchasedProducts: mergedExtras.purchasedProducts,
        stats: mergedExtras.stats,
        achievementIds: mergedExtras.achievementIds,
        xp: mergedXp,
        welcomeBonusGranted: true,
        streak: mergedExtras.streak,
        lastPlayedDate: mergedExtras.lastPlayedDate,
        photoUrl: photoUrl ?? mergedExtras.photoUrl,
      );
    }

    if (photoUrl != null && photoUrl.isNotEmpty) {
      mergedExtras = UserCloudData(
        removeAds: mergedExtras.removeAds,
        purchasedProducts: mergedExtras.purchasedProducts,
        stats: mergedExtras.stats,
        achievementIds: mergedExtras.achievementIds,
        xp: mergedExtras.xp,
        welcomeBonusGranted: mergedExtras.welcomeBonusGranted,
        streak: mergedExtras.streak,
        lastPlayedDate: mergedExtras.lastPlayedDate,
        photoUrl: photoUrl,
      );
    }

    for (final entry in mergedLevels.values) {
      await _db.saveProgress(
        levelId: entry.levelId,
        stars: entry.stars,
        timeSeconds: entry.timeSeconds,
      );
    }
    await _db.setCoins(mergedCoins);
    await _db.setXp(mergedXp);
    await _applyExtrasLocally(mergedExtras);

    try {
      await _firestore.upsertUserProfile(
        uid: uid,
        displayName: displayName,
        email: email,
        coins: mergedCoins,
        xp: mergedXp,
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
      final xp = await _db.getXp();
      await _firestore.updateCoins(uid, coins);
      await _firestore.updateXp(uid, xp);
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

  Future<void> syncXp() async {
    final uid = _uid;
    if (uid == null) return;
    final xp = await _db.getXp();
    try {
      await _firestore.updateXp(uid, xp);
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
      photoUrl: user.photoURL,
    );
  }

  Future<void> recordPurchaseAndSync(String productId) async {
    await _db.addPurchasedProduct(productId);
    if (productId == ProductIds.removeAds) {
      await _prefs.setBool(_removeAdsKey, true);
    }
    if (VipService.productGrantsVip(productId)) {
      await _vip.setVipActive(true);
    }
    if (!isLoggedIn) return;
    try {
      final extras = await _readLocalExtras();
      await _firestore.syncUserMetadata(uid: _uid!, extras: extras);
      await syncCoins();
      await syncXp();
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
      xp: await _db.getXp(),
      welcomeBonusGranted: await _db.getBool('welcome_bonus_granted'),
      streak: int.tryParse(await _db.getString('daily_streak') ?? '') ?? 0,
      lastPlayedDate: await _db.getString('last_played_date') ?? '',
    );
  }

  Future<void> _applyExtrasLocally(UserCloudData data) async {
    if (data.removeAds) {
      await _prefs.setBool(_removeAdsKey, true);
    }
    for (final id in data.purchasedProducts) {
      await _db.addPurchasedProduct(id);
      if (VipService.productGrantsVip(id)) {
        await _vip.setVipActive(true);
      }
    }
    await _db.applyGameplayStats(data.stats);
    await _db.applyUnlockedAchievements(data.achievementIds);
    await _db.setXp(data.xp);
    if (data.welcomeBonusGranted) {
      await _db.setBool('welcome_bonus_granted', true);
    }
    if (data.lastPlayedDate.isNotEmpty) {
      await _db.setString('last_played_date', data.lastPlayedDate);
    }
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
      xp: _maxInt(cloud.xp, local.xp),
      welcomeBonusGranted: local.welcomeBonusGranted || cloud.welcomeBonusGranted,
      streak: _maxInt(cloud.streak, local.streak),
      lastPlayedDate: _newerDate(local.lastPlayedDate, cloud.lastPlayedDate),
      photoUrl: local.photoUrl.isNotEmpty ? local.photoUrl : cloud.photoUrl,
    );
  }

  String _newerDate(String a, String b) {
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    return a.compareTo(b) >= 0 ? a : b;
  }

  int _maxInt(int? a, int b) {
    final left = a ?? 0;
    return left > b ? left : b;
  }
}
