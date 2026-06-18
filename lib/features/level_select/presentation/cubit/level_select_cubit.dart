import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/utils/destination_unlock.dart';
import 'package:word_game/core/utils/level_progress_id.dart';
import 'package:word_game/core/utils/level_progress_stats.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/core/services/current_level_resolver.dart';
import 'package:word_game/injection.dart';

class LevelSelectState extends Equatable {
  const LevelSelectState({
    this.loading = true,
    this.themeName = '',
    this.backgroundImage = '',
    this.levels = const [],
    this.stars = const {},
    this.unlocked = const {},
    this.difficultyIndex = 0,
    this.destinationLocked = false,
    this.unlockRequirement,
    this.currentDisplayNumber = 1,
    this.currentSharedLevelId,
  });

  final bool loading;
  final String themeName;
  final String backgroundImage;
  final List<LevelJson> levels;
  final Map<int, int> stars;
  final Set<int> unlocked;
  final int difficultyIndex;
  final bool destinationLocked;
  final String? unlockRequirement;
  final int currentDisplayNumber;
  final int? currentSharedLevelId;

  List<LevelJson> get filteredLevels =>
      levels.where((l) => l.difficultyIndex == difficultyIndex).toList();

  @override
  List<Object?> get props => [
        loading,
        themeName,
        backgroundImage,
        levels,
        stars,
        unlocked,
        difficultyIndex,
        destinationLocked,
        unlockRequirement,
        currentDisplayNumber,
        currentSharedLevelId,
      ];
}

class LevelSelectCubit extends Cubit<LevelSelectState> {
  LevelSelectCubit(this._levels, this._progress, this.themeId)
      : super(const LevelSelectState());

  final LevelRepository _levels;
  final ProgressRepository _progress;
  final int themeId;

  /// Reload stars / unlock state (e.g. after returning from a level).
  Future<void> refresh() => load();

  Future<void> load() async {
    if (isClosed) return;

    final preset = getIt<AppThemeBloc>().state.activePreset;
    final themes = await _levels.loadThemesForPreset(preset);
    if (isClosed) return;

    final sorted = DestinationUnlock.sortByUnlockOrder(themes, preset);
    final theme = sorted.firstWhere(
      (t) => t.id == themeId,
      orElse: () => sorted.first,
    );

    final starsBySlot = <int, Map<int, int>>{};
    for (final t in sorted) {
      starsBySlot[t.id] = await _progress.getStarsForSlot(t.id);
    }
    if (isClosed) return;

    if (!DestinationUnlock.isUnlocked(
      slotId: themeId,
      sortedThemes: sorted,
      starsBySlot: starsBySlot,
    )) {
      final requirement = DestinationUnlock.requiredPreviousName(
        slotId: themeId,
        sortedThemes: sorted,
        preset: preset,
      );
      emit(
        LevelSelectState(
          loading: false,
          themeName: theme.name,
          backgroundImage: theme.backgroundImage,
          destinationLocked: true,
          unlockRequirement: requirement,
        ),
      );
      return;
    }

    final rawStars = starsBySlot[themeId] ?? {};
    if (isClosed) return;

    final orderedShared = theme.levels.map((l) => l.id).toList()..sort();
    final stars = LevelProgressStats.normalizeStars(rawStars, orderedShared);
    final orderedStorage = orderedShared
        .map(
          (id) => LevelProgressId.encode(slotId: themeId, sharedLevelId: id),
        )
        .toList();
    final unlocked = <int>{};
    for (var i = 0; i < orderedShared.length; i++) {
      if (isClosed) return;
      final storageId = orderedStorage[i];
      final sharedId = orderedShared[i];
      if (await _progress.isLevelUnlocked(storageId, orderedStorage)) {
        unlocked.add(sharedId);
      }
    }
    if (isClosed) return;

    final resolver = getIt<CurrentLevelResolver>();
    final currentLevel = await resolver.resolve(
      slotId: themeId,
      orderedSharedLevelIds: orderedShared,
    );

    emit(
      LevelSelectState(
        loading: false,
        themeName: theme.name,
        backgroundImage: theme.backgroundImage,
        levels: theme.levels,
        stars: stars,
        unlocked: unlocked,
        currentDisplayNumber: currentLevel.displayNumber,
        currentSharedLevelId: currentLevel.sharedLevelId,
      ),
    );
  }

  void selectDifficulty(int index) {
    emit(LevelSelectState(
      loading: state.loading,
      themeName: state.themeName,
      backgroundImage: state.backgroundImage,
      levels: state.levels,
      stars: state.stars,
      unlocked: state.unlocked,
      difficultyIndex: index,
      destinationLocked: state.destinationLocked,
      unlockRequirement: state.unlockRequirement,
      currentDisplayNumber: state.currentDisplayNumber,
      currentSharedLevelId: state.currentSharedLevelId,
    ));
  }
}
