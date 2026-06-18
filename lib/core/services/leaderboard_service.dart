import 'package:word_game/core/services/auth_service.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/data/local/database.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.isCurrentUser,
    this.photoUrl = '',
    this.completedLevels = 0,
  });

  final int rank;
  final String name;
  final int xp;
  final bool isCurrentUser;
  final String photoUrl;
  final int completedLevels;
}

/// Global ranking from Firestore — sorted by XP (desc).
class LeaderboardService {
  LeaderboardService(this._firestore, this._auth, this._db);

  final FirestoreUserService _firestore;
  final AuthService _auth;
  final AppDatabase _db;

  Future<LeaderboardSnapshot> buildSnapshot() async {
    if (!_auth.isSignedIn) {
      return const LeaderboardSnapshot(
        entries: [],
        userRank: null,
        userXp: null,
      );
    }

    try {
      final records = await _firestore.fetchLeaderboard(limit: 50);
      final uid = _auth.userId;
      final localXp = await _db.getXp();

      final entries = <LeaderboardEntry>[];
      var userRank = 0;
      var userXp = localXp;

      for (var i = 0; i < records.length; i++) {
        final record = records[i];
        final rank = i + 1;
        final isUser = record.uid == uid;
        if (isUser) {
          userRank = rank;
          userXp = record.xp;
        }
        entries.add(
          LeaderboardEntry(
            rank: rank,
            name: record.displayName,
            xp: record.xp,
            isCurrentUser: isUser,
            photoUrl: record.photoUrl,
            completedLevels: record.completedLevels,
          ),
        );
      }

      if (uid != null && userRank == 0 && records.isNotEmpty) {
        final higherCount = records.where((r) => r.xp > localXp).length;
        userRank = higherCount + 1;
        userXp = localXp;
      }

      return LeaderboardSnapshot(
        entries: entries,
        userRank: userRank > 0 ? userRank : null,
        userXp: userXp,
      );
    } catch (_) {
      return LeaderboardSnapshot(
        entries: const [],
        userRank: null,
        userXp: await _db.getXp(),
        loadFailed: true,
      );
    }
  }
}

class LeaderboardSnapshot {
  const LeaderboardSnapshot({
    required this.entries,
    required this.userRank,
    required this.userXp,
    this.loadFailed = false,
  });

  final List<LeaderboardEntry> entries;
  final int? userRank;
  final int? userXp;
  final bool loadFailed;
}
