import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/utils/destination_unlock.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/injection.dart';

class DestinationsState extends Equatable {
  const DestinationsState({
    this.themes = const [],
    this.loading = true,
    this.featuredCompleted = 0,
    this.featuredTotal = 0,
    this.totalCompleted = 0,
    this.totalLevels = 0,
    this.starsBySlot = const {},
    this.unlockedSlots = const {},
  });

  final List<ThemeCategoryEntity> themes;
  final bool loading;
  final int featuredCompleted;
  final int featuredTotal;
  final int totalCompleted;
  final int totalLevels;
  /// Per explore slot: shared level id → stars.
  final Map<int, Map<int, int>> starsBySlot;
  final Set<int> unlockedSlots;

  int completedCountForSlot(int slotId) {
    final stars = starsBySlot[slotId];
    if (stars == null) return 0;
    return stars.values.where((s) => s > 0).length;
  }

  bool isSlotUnlocked(int slotId) => unlockedSlots.contains(slotId);

  @override
  List<Object?> get props => [
        themes,
        loading,
        featuredCompleted,
        featuredTotal,
        totalCompleted,
        totalLevels,
        starsBySlot,
        unlockedSlots,
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

    final unlockedSlots = <int>{};
    for (final theme in sortedThemes) {
      if (DestinationUnlock.isUnlocked(
        slotId: theme.id,
        sortedThemes: sortedThemes,
        starsBySlot: starsBySlot,
      )) {
        unlockedSlots.add(theme.id);
      }
    }

    var featuredCompleted = 0;
    var featuredTotal = sharedTotal;
    if (sortedThemes.isNotEmpty) {
      final first = sortedThemes.first;
      featuredTotal = first.levels.length;
      featuredCompleted = completedCountFromStars(starsBySlot[first.id]);
    }

    if (isClosed) return;

    emit(
      DestinationsState(
        themes: sortedThemes,
        loading: false,
        featuredCompleted: featuredCompleted,
        featuredTotal: featuredTotal,
        totalCompleted: featuredCompleted,
        totalLevels: sharedTotal,
        starsBySlot: starsBySlot,
        unlockedSlots: unlockedSlots,
      ),
    );
  }

  int completedCountFromStars(Map<int, int>? stars) {
    if (stars == null) return 0;
    return stars.values.where((s) => s > 0).length;
  }
}
