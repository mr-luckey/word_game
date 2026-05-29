/// Shared level packs use ids per slot file (1–80 in slot_1, 101+ in others).
/// Progress is stored as [slotId * 10000 + sharedLevelId] so each destination
/// tracks completion independently.
class LevelProgressId {
  LevelProgressId._();

  static const int slotMultiplier = 10000;
  static const int dailyChallengeLevelId = 9999;

  /// Slot pack level (excludes daily challenge id).
  static bool isSharedPackLevel(int levelId) =>
      levelId >= 1 &&
      levelId < 9000 &&
      levelId != dailyChallengeLevelId;

  static int encode({required int slotId, required int sharedLevelId}) {
    if (!isSharedPackLevel(sharedLevelId)) return sharedLevelId;
    return slotId * slotMultiplier + sharedLevelId;
  }

  /// Raw 101–8999 saved before per-slot encoding (slot 1 only).
  static bool isLegacyStorageKey(int storageKey) =>
      storageKey < slotMultiplier &&
      storageKey >= 100 &&
      isSharedPackLevel(storageKey);

  /// Raw 1–99 saved without encoding (slot 1 compact packs).
  static bool isCompactUnencodedKey(int storageKey) =>
      storageKey < slotMultiplier && storageKey >= 1 && storageKey < 100;

  static bool matchesSlot(int storageKey, int slotId) {
    if (isLegacyStorageKey(storageKey) || isCompactUnencodedKey(storageKey)) {
      return slotId == 1;
    }
    if (storageKey >= slotMultiplier) {
      return storageKey ~/ slotMultiplier == slotId;
    }
    return false;
  }

  static int sharedLevelIdFromStorageKey(int storageKey) {
    if (isLegacyStorageKey(storageKey) || isCompactUnencodedKey(storageKey)) {
      return storageKey;
    }
    if (storageKey >= slotMultiplier) {
      return storageKey % slotMultiplier;
    }
    return storageKey;
  }
}
