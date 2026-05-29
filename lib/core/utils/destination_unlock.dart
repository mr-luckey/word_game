import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';

/// Sequential explore destinations: slot N unlocks when slot N−1's last level is done.
class DestinationUnlock {
  DestinationUnlock._();

  static List<ThemeCategoryEntity> sortByUnlockOrder(
    List<ThemeCategoryEntity> themes,
    AppThemePreset preset,
  ) {
    final orderBySlot = {
      for (final d in DestinationCatalog.forPreset(preset)) d.id: d.unlockOrder,
    };
    final sorted = List<ThemeCategoryEntity>.from(themes);
    sorted.sort(
      (a, b) => (orderBySlot[a.id] ?? 999).compareTo(orderBySlot[b.id] ?? 999),
    );
    return sorted;
  }

  static int? lastLevelId(List<LevelJson> levels) {
    if (levels.isEmpty) return null;
    var maxId = levels.first.id;
    for (final level in levels) {
      if (level.id > maxId) maxId = level.id;
    }
    return maxId;
  }

  static bool isUnlocked({
    required int slotId,
    required List<ThemeCategoryEntity> sortedThemes,
    required Map<int, Map<int, int>> starsBySlot,
  }) {
    final index = sortedThemes.indexWhere((t) => t.id == slotId);
    if (index <= 0) return true;

    final previous = sortedThemes[index - 1];
    final lastId = lastLevelId(previous.levels);
    if (lastId == null) return true;

    final stars = starsBySlot[previous.id] ?? const {};
    return (stars[lastId] ?? 0) > 0;
  }

  /// Name of the destination that must be finished to unlock [slotId].
  static String? requiredPreviousName({
    required int slotId,
    required List<ThemeCategoryEntity> sortedThemes,
    required AppThemePreset preset,
  }) {
    final specs = DestinationCatalog.forPreset(preset);
    final order = specs.where((s) => s.id == slotId).firstOrNull?.unlockOrder;
    if (order == null || order <= 1) return null;
    final prevSpec =
        specs.where((s) => s.unlockOrder == order - 1).firstOrNull;
    if (prevSpec != null) return prevSpec.name;
    final idx = sortedThemes.indexWhere((t) => t.id == slotId);
    if (idx <= 0) return null;
    return sortedThemes[idx - 1].name;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
