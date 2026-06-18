import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/profile/domain/entities/achievement.dart';
import 'package:word_game/core/data/achievement_catalog_loader.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/injection.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.loading = true,
    this.completedLevels = 0,
    this.totalLevels = 0,
    this.achievements = const [],
  });

  final bool loading;
  final int completedLevels;
  final int totalLevels;
  final List<Achievement> achievements;

  @override
  List<Object?> get props => [loading, completedLevels, totalLevels, achievements];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._db, this._levels, this._progress) : super(const ProfileState()) {
    load();
  }

  final AppDatabase _db;
  final LevelRepository _levels;
  final ProgressRepository _progress;

  Future<void> load() async {
    final themes = await _levels.loadThemes();
    final total = themes.isEmpty ? 0 : themes.first.levels.length;
    final slotId = getIt<AppThemeBloc>().state.activeDestinationId ??
        (themes.isNotEmpty ? themes.first.id : 1);
    final completedLevels = await _progress.countCompletedLevels(slotId);
    final unlockedRows = await _db.getAchievements();
    final unlockedIds = unlockedRows.where((r) => r.unlocked).map((r) => r.id).toSet();
    final catalog = await AchievementCatalogLoader.load();
    final achievements = catalog
        .map((a) => a.copyWith(unlocked: unlockedIds.contains(a.id)))
        .toList();
    emit(
      ProfileState(
        loading: false,
        completedLevels: completedLevels,
        totalLevels: total,
        achievements: achievements,
      ),
    );
  }
}
