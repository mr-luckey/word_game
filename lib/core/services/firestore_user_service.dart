import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:word_game/core/services/user_cloud_data.dart';

/// Firestore paths: users/{uid} and users/{uid}/levelProgress/{levelId}
class FirestoreUserService {
  FirestoreUserService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _users.doc(uid);

  CollectionReference<Map<String, dynamic>> _progressCol(String uid) =>
      _userDoc(uid).collection('levelProgress');

  Future<bool> userDocExists(String uid) async {
    final snap = await _userDoc(uid).get();
    return snap.exists;
  }

  Future<void> upsertUserProfile({
    required String uid,
    required String displayName,
    required String email,
    required int coins,
    int? xp,
    UserCloudData? extras,
  }) async {
    await _userDoc(uid).set(
      {
        'displayName': displayName,
        'email': email,
        'coins': coins,
        if (xp != null) 'xp': xp,
        if (extras != null) ...extras.toFirestoreFields(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateCoins(String uid, int coins) async {
    await _userDoc(uid).set(
      {
        'coins': coins,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateXp(String uid, int xp) async {
    await _userDoc(uid).set(
      {
        'xp': xp,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateDisplayName(String uid, String displayName) async {
    await _userDoc(uid).set(
      {
        'displayName': displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> syncUserMetadata({
    required String uid,
    required UserCloudData extras,
  }) async {
    await _userDoc(uid).set(
      {
        ...extras.toFirestoreFields(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<int?> fetchCoins(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists) return null;
    return (snap.data()?['coins'] as num?)?.toInt();
  }

  Future<int?> fetchXp(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists) return null;
    return (snap.data()?['xp'] as num?)?.toInt();
  }

  Future<String?> fetchDisplayName(String uid) async {
    final snap = await _userDoc(uid).get();
    return snap.data()?['displayName'] as String?;
  }

  Future<UserCloudData> fetchUserCloudData(String uid) async {
    final snap = await _userDoc(uid).get();
    return UserCloudData.fromFirestore(snap.data());
  }

  Future<Map<int, LevelProgressRecord>> fetchLevelProgress(String uid) async {
    final snap = await _progressCol(uid).get();
    final map = <int, LevelProgressRecord>{};
    for (final doc in snap.docs) {
      final levelId = int.tryParse(doc.id);
      if (levelId == null) continue;
      final data = doc.data();
      map[levelId] = LevelProgressRecord(
        levelId: levelId,
        stars: (data['stars'] as num?)?.toInt() ?? 0,
        timeSeconds: (data['timeSeconds'] as num?)?.toInt() ?? 0,
      );
    }
    return map;
  }

  Future<void> saveLevelProgress({
    required String uid,
    required int levelId,
    required int stars,
    required int timeSeconds,
  }) async {
    await _progressCol(uid).doc('$levelId').set(
      {
        'stars': stars,
        'timeSeconds': timeSeconds,
        'completedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<List<LeaderboardRecord>> fetchLeaderboard({int limit = 50}) async {
    final snap =
        await _users.orderBy('xp', descending: true).limit(limit).get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return LeaderboardRecord(
        uid: doc.id,
        displayName: (data['displayName'] as String?)?.trim().isNotEmpty == true
            ? data['displayName'] as String
            : 'Player',
        xp: (data['xp'] as num?)?.toInt() ?? 0,
        photoUrl: data['photoUrl'] as String? ?? '',
        completedLevels: (data['completedLevels'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }
}

class LevelProgressRecord {
  const LevelProgressRecord({
    required this.levelId,
    required this.stars,
    required this.timeSeconds,
  });

  final int levelId;
  final int stars;
  final int timeSeconds;
}

class LeaderboardRecord {
  const LeaderboardRecord({
    required this.uid,
    required this.displayName,
    required this.xp,
    this.photoUrl = '',
    this.completedLevels = 0,
  });

  final String uid;
  final String displayName;
  final int xp;
  final String photoUrl;
  final int completedLevels;
}
