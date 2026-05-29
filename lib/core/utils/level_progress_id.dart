/// Shared level packs reuse ids (101, 102, …) across every explore slot.
/// Progress is stored as [slotId * 10000 + sharedLevelId] so each destination
/// tracks completion independently.
class LevelProgressId {
  LevelProgressId._();

  static const int slotMultiplier = 10000;

  /// Levels from [shared_levels.json] (not daily challenge, etc.).
  static bool isSharedPackLevel(int levelId) => levelId >= 100 && levelId < 9000;

  static int encode({required int slotId, required int sharedLevelId}) {
    if (!isSharedPackLevel(sharedLevelId)) return sharedLevelId;
    return slotId * slotMultiplier + sharedLevelId;
  }

  /// Legacy rows saved before per-slot encoding (treated as slot 1 only).
  static bool isLegacyStorageKey(int storageKey) =>
      storageKey < slotMultiplier && isSharedPackLevel(storageKey);

  static bool matchesSlot(int storageKey, int slotId) {
    if (isLegacyStorageKey(storageKey)) return slotId == 1;
    if (storageKey >= slotMultiplier) {
      return storageKey ~/ slotMultiplier == slotId;
    }
    return false;
  }

  static int sharedLevelIdFromStorageKey(int storageKey) {
    if (isLegacyStorageKey(storageKey)) return storageKey;
    if (storageKey >= slotMultiplier) {
      return storageKey % slotMultiplier;
    }
    return storageKey;
  }
}
