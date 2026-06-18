import 'package:word_game/core/utils/level_progress_id.dart';
import 'package:word_game/core/utils/level_progress_stats.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

/// Single source of truth for "current level" across Home, Map, and Explore.
class CurrentLevelInfo {
  const CurrentLevelInfo({
    required this.sharedLevelId,
    required this.displayNumber,
    required this.storageId,
    required this.totalLevels,
    required this.completedCount,
  });

  final int sharedLevelId;
  final int displayNumber;
  final int storageId;
  final int totalLevels;
  final int completedCount;
}

class CurrentLevelResolver {
  CurrentLevelResolver(this._progress);

  final ProgressRepository _progress;

  Future<CurrentLevelInfo> resolve({
    required int slotId,
    required List<int> orderedSharedLevelIds,
  }) async {
    if (orderedSharedLevelIds.isEmpty) {
      return const CurrentLevelInfo(
        sharedLevelId: 1,
        displayNumber: 1,
        storageId: 10001,
        totalLevels: 0,
        completedCount: 0,
      );
    }

    final sorted = [...orderedSharedLevelIds]..sort();
    final rawStars = await _progress.getStarsForSlot(slotId);
    final stars = LevelProgressStats.normalizeStars(rawStars, sorted);
    final orderedStorage = sorted
        .map((id) => LevelProgressId.encode(slotId: slotId, sharedLevelId: id))
        .toList();

    final sharedLevelId = await LevelProgressStats.pickResumeSharedId(
      normalizedStars: stars,
      orderedPackIds: sorted,
      isUnlocked: _progress.isLevelUnlocked,
      orderedStorageIds: orderedStorage,
    );

    return CurrentLevelInfo(
      sharedLevelId: sharedLevelId,
      displayNumber:
          LevelProgressStats.displayNumberFor(sorted, sharedLevelId),
      storageId: LevelProgressId.encode(
        slotId: slotId,
        sharedLevelId: sharedLevelId,
      ),
      totalLevels: sorted.length,
      completedCount: LevelProgressStats.completedCount(stars, sorted),
    );
  }
}
