import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/constants/game_config.dart';

enum SplashStatus { initial, complete }

class SplashState extends Equatable {
  const SplashState(this.status);
  final SplashStatus status;

  @override
  List<Object?> get props => [status];
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState(SplashStatus.initial)) {
    _start();
  }

  void _start() {
    Timer(
      const Duration(milliseconds: GameConfig.splashDelayMs),
      () => emit(const SplashState(SplashStatus.complete)),
    );
  }
}
