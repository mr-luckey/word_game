import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class LevelSelectState extends Equatable {
  const LevelSelectState({
    this.loading = true,
    this.themeName = '',
    this.backgroundImage = '',
    this.levels = const [],
    this.stars = const {},
    this.unlocked = const {},
    this.difficultyIndex = 0,
  });

  final bool loading;
  final String themeName;
  final String backgroundImage;
  final List<LevelJson> levels;
  final Map<int, int> stars;
  final Set<int> unlocked;
  final int difficultyIndex;

  List<LevelJson> get filteredLevels =>
      levels.where((l) => l.difficultyIndex == difficultyIndex).toList();

  @override
  List<Object?> get props =>
      [loading, themeName, backgroundImage, levels, stars, unlocked, difficultyIndex];
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

    final themes = await _levels.loadThemes();
    if (isClosed) return;

    final theme = themes.firstWhere(
      (t) => t.id == themeId,
      orElse: () => themes.first,
    );
    final stars = await _progress.getAllStars();
    if (isClosed) return;

    final ordered = theme.levels.map((l) => l.id).toList()..sort();
    final unlocked = <int>{};
    for (final id in ordered) {
      if (isClosed) return;
      if (await _progress.isLevelUnlocked(id, ordered)) {
        unlocked.add(id);
      }
    }
    if (isClosed) return;

    emit(
      LevelSelectState(
        loading: false,
        themeName: theme.name,
        backgroundImage: theme.backgroundImage,
        levels: theme.levels,
        stars: stars,
        unlocked: unlocked,
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
    ));
  }
}
