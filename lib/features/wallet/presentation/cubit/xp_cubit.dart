import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class XpState extends Equatable {
  const XpState({required this.xp, this.loading = false});

  final int xp;
  final bool loading;

  XpState copyWith({int? xp, bool? loading}) =>
      XpState(xp: xp ?? this.xp, loading: loading ?? this.loading);

  @override
  List<Object?> get props => [xp, loading];
}

class XpCubit extends Cubit<XpState> {
  XpCubit(this._xp) : super(const XpState(xp: 0, loading: true)) {
    refresh();
  }

  final XpRepository _xp;

  Future<void> refresh() async {
    emit(state.copyWith(loading: true));
    final xp = await _xp.getXp();
    emit(XpState(xp: xp, loading: false));
  }

  Future<void> add(int amount) async {
    await _xp.addXp(amount);
    await refresh();
  }
}
