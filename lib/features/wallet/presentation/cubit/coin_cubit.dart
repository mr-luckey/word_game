import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

class CoinState extends Equatable {
  const CoinState({required this.coins, this.loading = false});

  final int coins;
  final bool loading;

  CoinState copyWith({int? coins, bool? loading}) =>
      CoinState(coins: coins ?? this.coins, loading: loading ?? this.loading);

  @override
  List<Object?> get props => [coins, loading];
}

class CoinCubit extends Cubit<CoinState> {
  CoinCubit(this._wallet) : super(const CoinState(coins: 0, loading: true)) {
    refresh();
  }

  final WalletRepository _wallet;

  Future<void> refresh() async {
    emit(state.copyWith(loading: true));
    final coins = await _wallet.getCoins();
    emit(CoinState(coins: coins, loading: false));
  }

  Future<bool> spend(int amount) async {
    final ok = await _wallet.spendCoins(amount);
    if (ok) await refresh();
    return ok;
  }

  Future<void> add(int amount) async {
    await _wallet.addCoins(amount);
    await refresh();
  }
}
