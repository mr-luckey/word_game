import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/constants/game_config.dart';

enum SplashStatus { loading, complete }

class SplashState extends Equatable {
  const SplashState({
    required this.status,
    this.progress = 0,
  });

  final SplashStatus status;
  final double progress;

  int get progressPercent => (progress * 100).round().clamp(0, 100);

  @override
  List<Object?> get props => [status, progress];
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState(status: SplashStatus.loading)) {
    _start();
  }

  Timer? _timer;

  void _start() {
    const totalMs = GameConfig.splashDelayMs;
    const tickMs = 50;
    var elapsed = 0;

    _timer = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      elapsed += tickMs;
      final p = (elapsed / totalMs).clamp(0.0, 1.0);
      if (p >= 1.0) {
        emit(const SplashState(status: SplashStatus.complete, progress: 1));
        timer.cancel();
      } else {
        emit(SplashState(status: SplashStatus.loading, progress: p));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
