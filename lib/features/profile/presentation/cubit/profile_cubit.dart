import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/data/local/database.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/profile/domain/entities/achievement.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.loading = true,
    this.completedLevels = 0,
    this.totalLevels = 0,
    this.achievements = kAchievements,
  });

  final bool loading;
  final int completedLevels;
  final int totalLevels;
  final List<Achievement> achievements;

  @override
  List<Object?> get props => [loading, completedLevels, totalLevels, achievements];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._db, this._levels) : super(const ProfileState()) {
    load();
  }

  final AppDatabase _db;
  final LevelRepository _levels;

  Future<void> load() async {
    final progress = await _db.getAllProgress();
    final themes = await _levels.loadThemes();
    final total = themes.isEmpty ? 0 : themes.first.levels.length;
    final unlockedRows = await _db.getAchievements();
    final unlockedIds = unlockedRows.where((r) => r.unlocked).map((r) => r.id).toSet();
    final achievements = kAchievements
        .map((a) => a.copyWith(unlocked: unlockedIds.contains(a.id)))
        .toList();
    emit(
      ProfileState(
        loading: false,
        completedLevels: progress.length,
        totalLevels: total,
        achievements: achievements,
      ),
    );
  }
}
