/// Normalizes star maps and computes resume / completed counts for a level pack.
class LevelProgressStats {
  LevelProgressStats._();

  /// Maps legacy slot-1 ids (101 → 1, 102 → 2, …) onto current pack ids.
  static int? packIdForLegacyShared(int sharedId, List<int> orderedPackIds) {
    if (orderedPackIds.contains(sharedId)) return sharedId;
    if (sharedId >= 100) {
      final mapped = sharedId - 100;
      if (orderedPackIds.contains(mapped)) return mapped;
    }
    return null;
  }

  /// Merges raw DB stars onto the active pack ids (handles legacy 101+ and compact 1–99).
  static Map<int, int> normalizeStars(
    Map<int, int> raw,
    List<int> orderedPackIds,
  ) {
    if (orderedPackIds.isEmpty) return const {};

    final normalized = <int, int>{};
    for (final entry in raw.entries) {
      if (entry.value <= 0) continue;
      final packId = packIdForLegacyShared(entry.key, orderedPackIds);
      if (packId == null) continue;
      final prev = normalized[packId] ?? 0;
      if (entry.value > prev) normalized[packId] = entry.value;
    }
    return normalized;
  }

  static int completedCount(
    Map<int, int> stars,
    List<int> orderedPackIds,
  ) {
    var count = 0;
    for (final id in orderedPackIds) {
      if ((stars[id] ?? 0) > 0) count++;
    }
    return count;
  }

  /// First unlocked pack level to play: earliest with 0 stars after completed run.
  static Future<int> pickResumeSharedId({
    required Map<int, int> normalizedStars,
    required List<int> orderedPackIds,
    required Future<bool> Function(int storageId, List<int> orderedStorageIds)
        isUnlocked,
    required List<int> orderedStorageIds,
  }) async {
    if (orderedPackIds.isEmpty) return 1;

    for (var i = 0; i < orderedPackIds.length; i++) {
      final sharedId = orderedPackIds[i];
      final storageId = orderedStorageIds[i];
      if (!await isUnlocked(storageId, orderedStorageIds)) break;
      if ((normalizedStars[sharedId] ?? 0) == 0) return sharedId;
    }

    for (var i = orderedPackIds.length - 1; i >= 0; i--) {
      final sharedId = orderedPackIds[i];
      if ((normalizedStars[sharedId] ?? 0) > 0) return sharedId;
    }

    return orderedPackIds.first;
  }

  static int displayNumberFor(List<int> orderedPackIds, int sharedLevelId) {
    final index = orderedPackIds.indexOf(sharedLevelId);
    return index >= 0 ? index + 1 : 1;
  }
}
