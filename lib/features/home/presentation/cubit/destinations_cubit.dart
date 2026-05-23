import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class DestinationsState extends Equatable {
  const DestinationsState({
    this.themes = const [],
    this.loading = true,
  });

  final List<ThemeCategoryEntity> themes;
  final bool loading;

  @override
  List<Object?> get props => [themes, loading];
}

class DestinationsCubit extends Cubit<DestinationsState> {
  DestinationsCubit(this._levels) : super(const DestinationsState());

  final LevelRepository _levels;

  Future<void> load() async {
    final themes = await _levels.loadThemes();
    emit(DestinationsState(themes: themes, loading: false));
  }
}
