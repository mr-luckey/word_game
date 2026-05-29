import 'package:word_game/core/services/auth_service.dart';
import 'package:word_game/core/services/firestore_user_service.dart';
import 'package:word_game/data/local/database.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.coins,
    required this.isCurrentUser,
  });

  final int rank;
  final String name;
  final int coins;
  final bool isCurrentUser;
}

/// Global ranking from Firestore — sorted by coins (desc).
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
        userCoins: null,
      );
    }

    try {
      final records = await _firestore.fetchLeaderboard(limit: 50);
      final uid = _auth.userId;
      final localCoins = await _db.getCoins();

      final entries = <LeaderboardEntry>[];
      var userRank = 0;
      var userCoins = localCoins;

      for (var i = 0; i < records.length; i++) {
        final record = records[i];
        final rank = i + 1;
        final isUser = record.uid == uid;
        if (isUser) {
          userRank = rank;
          userCoins = record.coins;
        }
        entries.add(
          LeaderboardEntry(
            rank: rank,
            name: record.displayName,
            coins: record.coins,
            isCurrentUser: isUser,
          ),
        );
      }

      // User not in top 50 — still show their rank estimate from coins.
      if (uid != null && userRank == 0 && records.isNotEmpty) {
        final higherCount =
            records.where((r) => r.coins > localCoins).length;
        userRank = higherCount + 1;
        userCoins = localCoins;
      }

      return LeaderboardSnapshot(
        entries: entries,
        userRank: userRank > 0 ? userRank : null,
        userCoins: userCoins,
      );
    } catch (_) {
      return LeaderboardSnapshot(
        entries: const [],
        userRank: null,
        userCoins: await _db.getCoins(),
        loadFailed: true,
      );
    }
  }
}

class LeaderboardSnapshot {
  const LeaderboardSnapshot({
    required this.entries,
    required this.userRank,
    required this.userCoins,
    this.loadFailed = false,
  });

  final List<LeaderboardEntry> entries;
  final int? userRank;
  final int? userCoins;
  final bool loadFailed;
}
