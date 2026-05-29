import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
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
    this.completedLevelIds = const {},
  });

  final List<ThemeCategoryEntity> themes;
  final bool loading;
  final int featuredCompleted;
  final int featuredTotal;
  final int totalCompleted;
  final int totalLevels;
  final Set<int> completedLevelIds;

  @override
  List<Object?> get props => [
        themes,
        loading,
        featuredCompleted,
        featuredTotal,
        totalCompleted,
        totalLevels,
        completedLevelIds,
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

    final stars = await _progress.getAllStars();
    if (isClosed) return;

    final sharedTotal =
        themes.isEmpty ? 0 : themes.first.levels.length;
    var totalCompleted = 0;
    for (final level in themes.firstOrNull?.levels ?? const <LevelJson>[]) {
      if (stars.containsKey(level.id)) totalCompleted++;
    }

    var featuredCompleted = 0;
    var featuredTotal = sharedTotal;
    if (themes.isNotEmpty) {
      featuredTotal = themes.first.levels.length;
      featuredCompleted = themes.first.levels
          .where((l) => stars.containsKey(l.id))
          .length;
    }

    if (isClosed) return;

    emit(
      DestinationsState(
        themes: themes,
        loading: false,
        featuredCompleted: featuredCompleted,
        featuredTotal: featuredTotal,
        totalCompleted: totalCompleted,
        totalLevels: sharedTotal,
        completedLevelIds: stars.keys.toSet(),
      ),
    );
  }
}

extension _FirstTheme on List<ThemeCategoryEntity> {
  ThemeCategoryEntity? get firstOrNull => isEmpty ? null : first;
}
