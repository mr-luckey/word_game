/// Local + cloud user metadata synced to Firestore `users/{uid}`.
class UserCloudData {
  const UserCloudData({
    this.removeAds = false,
    this.purchasedProducts = const [],
    this.stats = const {},
    this.achievementIds = const [],
    this.xp = 0,
    this.welcomeBonusGranted = false,
    this.streak = 0,
    this.lastPlayedDate = '',
    this.photoUrl = '',
  });

  final bool removeAds;
  final List<String> purchasedProducts;
  final Map<String, int> stats;
  final List<String> achievementIds;
  final int xp;
  final bool welcomeBonusGranted;
  final int streak;
  final String lastPlayedDate;
  final String photoUrl;

  factory UserCloudData.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) return const UserCloudData();

    final purchased = data['purchasedProducts'];
    final statsRaw = data['stats'];
    final achievementsRaw = data['achievements'];

    final stats = <String, int>{};
    if (statsRaw is Map) {
      for (final entry in statsRaw.entries) {
        final v = entry.value;
        if (v is num) {
          stats[entry.key.toString()] = v.toInt();
        } else {
          stats[entry.key.toString()] = int.tryParse(v.toString()) ?? 0;
        }
      }
    }

    final achievementIds = <String>[];
    if (achievementsRaw is Map) {
      for (final entry in achievementsRaw.entries) {
        final unlocked = entry.value is Map
            ? (entry.value['unlocked'] == true)
            : entry.value == true;
        if (unlocked) achievementIds.add(entry.key.toString());
      }
    }

    return UserCloudData(
      removeAds: data['removeAds'] == true,
      purchasedProducts: purchased is List
          ? purchased.map((e) => e.toString()).toList()
          : const [],
      stats: stats,
      achievementIds: achievementIds,
      xp: (data['xp'] as num?)?.toInt() ?? 0,
      welcomeBonusGranted: data['welcomeBonusGranted'] == true,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      lastPlayedDate: data['lastPlayedDate'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestoreFields() {
    return {
      'removeAds': removeAds,
      'purchasedProducts': purchasedProducts,
      'stats': stats.map((k, v) => MapEntry(k, v)),
      'achievements': {
        for (final id in achievementIds) id: {'unlocked': true},
      },
      'xp': xp,
      'welcomeBonusGranted': welcomeBonusGranted,
      'streak': streak,
      if (lastPlayedDate.isNotEmpty) 'lastPlayedDate': lastPlayedDate,
      if (photoUrl.isNotEmpty) 'photoUrl': photoUrl,
    };
  }
}
