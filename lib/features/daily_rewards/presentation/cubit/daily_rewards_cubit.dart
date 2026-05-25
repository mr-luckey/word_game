import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';

class DailyRewardsState extends Equatable {
  const DailyRewardsState({
    required this.days,
    required this.canClaim,
    this.cooldown,
    this.todayCoins = 50,
  });

  final List<DailyRewardDay> days;
  final bool canClaim;
  final Duration? cooldown;
  final int todayCoins;

  @override
  List<Object?> get props => [days, canClaim, cooldown, todayCoins];
}

class DailyRewardsCubit extends Cubit<DailyRewardsState> {
  DailyRewardsCubit(this._daily) : super(_build(_daily));

  final DailyChallengeService _daily;

  static DailyRewardsState _build(DailyChallengeService daily) {
    return DailyRewardsState(
      days: daily.buildWeekRewards(),
      canClaim: daily.canClaimNow(),
      cooldown: daily.cooldownRemaining(),
      todayCoins: daily.todayRewardCoins,
    );
  }

  void refresh() => emit(_build(_daily));
}
