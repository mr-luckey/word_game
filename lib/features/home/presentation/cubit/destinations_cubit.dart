import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/utils/destination_unlock.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/core/services/current_level_resolver.dart';
import 'package:word_game/injection.dart';

class DestinationsState extends Equatable {
  const DestinationsState({
    this.themes = const [],
    this.loading = true,
    this.featuredSlotId = 1,
    this.featuredCompleted = 0,
    this.featuredTotal = 0,
    this.featuredCurrentLevel = 1,
    this.totalCompleted = 0,
    this.totalLevels = 0,
    this.starsBySlot = const {},
    this.unlockedSlots = const {},
    this.currentLevelBySlot = const {},
    this.completedBySlot = const {},
  });

  final List<ThemeCategoryEntity> themes;
  final bool loading;
  final int featuredSlotId;
  final int featuredCompleted;
  final int featuredTotal;
  final int featuredCurrentLevel;
  final int totalCompleted;
  final int totalLevels;
  /// Per explore slot: shared level id → stars.
  final Map<int, Map<int, int>> starsBySlot;
  final Set<int> unlockedSlots;
  final Map<int, int> currentLevelBySlot;
  final Map<int, int> completedBySlot;

  int currentLevelForSlot(int slotId) => currentLevelBySlot[slotId] ?? 1;

  int completedForSlot(int slotId) => completedBySlot[slotId] ?? 0;

  bool isSlotUnlocked(int slotId) => unlockedSlots.contains(slotId);

  @override
  List<Object?> get props => [
        themes,
        loading,
        featuredSlotId,
        featuredCompleted,
        featuredTotal,
        featuredCurrentLevel,
        totalCompleted,
        totalLevels,
        starsBySlot,
        unlockedSlots,
        currentLevelBySlot,
        completedBySlot,
      ];
}

class DestinationsCubit extends Cubit<DestinationsState> {
  DestinationsCubit(this._levels, this._progress) : super(const DestinationsState());

  final LevelRepository _levels;
  final ProgressRepository _progress;

  AppThemePreset get _activePreset => getIt<AppThemeBloc>().state.activePreset;

  Future<void> refresh() => load();

  Future<void> load() async {
    if (isClosed) return;

    final preset = _activePreset;
    final themes = await _levels.loadThemesForPreset(preset);
    if (isClosed) return;

    final sortedThemes = DestinationUnlock.sortByUnlockOrder(themes, preset);
    final sharedTotal =
        sortedThemes.isEmpty ? 0 : sortedThemes.first.levels.length;

    final starsBySlot = <int, Map<int, int>>{};
    for (final theme in sortedThemes) {
      starsBySlot[theme.id] = await _progress.getStarsForSlot(theme.id);
    }

    final unlockedSlots = <int>{} ;
    for (final theme in sortedThemes) {
      if (DestinationUnlock.isUnlocked(
        slotId: theme.id,
        sortedThemes: sortedThemes,
        starsBySlot: starsBySlot,
      )) {
        unlockedSlots.add(theme.id);
      }
    }

    final currentLevelBySlot = <int, int>{};
    final completedBySlot = <int, int>{};
    final resolver = getIt<CurrentLevelResolver>();

    for (final theme in sortedThemes) {
      final ordered = theme.levels.map((l) => l.id).toList()..sort();
      final info = await resolver.resolve(
        slotId: theme.id,
        orderedSharedLevelIds: ordered,
      );
      currentLevelBySlot[theme.id] = info.displayNumber;
      completedBySlot[theme.id] = info.completedCount;
    }

    final featuredSlotId =
        sortedThemes.isNotEmpty ? sortedThemes.first.id : 1;
    final featuredTotal =
        sortedThemes.isNotEmpty ? sortedThemes.first.levels.length : sharedTotal;
    final featuredCompleted = completedBySlot[featuredSlotId] ?? 0;
    final featuredCurrentLevel = currentLevelBySlot[featuredSlotId] ?? 1;

    if (isClosed) return;

    emit(
      DestinationsState(
        themes: sortedThemes,
        loading: false,
        featuredSlotId: featuredSlotId,
        featuredCompleted: featuredCompleted,
        featuredTotal: featuredTotal,
        featuredCurrentLevel: featuredCurrentLevel,
        totalCompleted: featuredCompleted,
        totalLevels: sharedTotal,
        starsBySlot: starsBySlot,
        unlockedSlots: unlockedSlots,
        currentLevelBySlot: currentLevelBySlot,
        completedBySlot: completedBySlot,
      ),
    );
  }
}
