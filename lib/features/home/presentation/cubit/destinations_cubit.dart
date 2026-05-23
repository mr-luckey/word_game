import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class DestinationsState extends Equatable {
  const DestinationsState({
    this.themes = const [],
    this.loading = true,
    this.featuredCompleted = 0,
    this.featuredTotal = 0,
    this.totalCompleted = 0,
    this.totalLevels = 0,
  });

  final List<ThemeCategoryEntity> themes;
  final bool loading;
  final int featuredCompleted;
  final int featuredTotal;
  final int totalCompleted;
  final int totalLevels;

  @override
  List<Object?> get props => [
        themes,
        loading,
        featuredCompleted,
        featuredTotal,
        totalCompleted,
        totalLevels,
      ];
}

class DestinationsCubit extends Cubit<DestinationsState> {
  DestinationsCubit(this._levels, this._progress) : super(const DestinationsState());

  final LevelRepository _levels;
  final ProgressRepository _progress;

  Future<void> refresh() => load();

  Future<void> load() async {
    if (isClosed) return;

    final themes = await _levels.loadThemes();
    if (isClosed) return;

    final stars = await _progress.getAllStars();
    if (isClosed) return;

    var totalCompleted = 0;
    var totalLevels = 0;
    var featuredCompleted = 0;
    var featuredTotal = 0;

    for (var i = 0; i < themes.length; i++) {
      final theme = themes[i];
      totalLevels += theme.levels.length;
      final themeCompleted =
          theme.levels.where((l) => stars.containsKey(l.id)).length;
      totalCompleted += themeCompleted;
      if (i == 0) {
        featuredCompleted = themeCompleted;
        featuredTotal = theme.levels.length;
      }
    }

    if (isClosed) return;

    emit(
      DestinationsState(
        themes: themes,
        loading: false,
        featuredCompleted: featuredCompleted,
        featuredTotal: featuredTotal,
        totalCompleted: totalCompleted,
        totalLevels: totalLevels,
      ),
    );
  }
}
