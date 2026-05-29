import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_game/core/data/game_content_registry.dart';
import 'package:word_game/core/services/daily_challenge_service.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/treasure_chest_image.dart';
import 'package:word_game/features/daily_rewards/presentation/cubit/daily_rewards_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class DailyRewardsScreen extends StatelessWidget {
  const DailyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DailyRewardsCubit(getIt<DailyChallengeService>())..refresh(),
      child: const _DailyRewardsView(),
    );
  }
}

class _DailyRewardsView extends StatelessWidget {
  const _DailyRewardsView();

  Future<void> _claim(BuildContext context) async {
    final cubit = context.read<DailyRewardsCubit>();
    final state = cubit.state;
    if (!state.canClaim) return;

    final dailyId = getIt<GameContentRegistry>().dailyChallenge.levelId;
    final won = await context.push<bool>('/game?levelId=$dailyId');
    if (won == true && context.mounted) {
      cubit.refresh();
      context.read<CoinCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ScenicBackground(
        imageAsset: context.themePreset.homeBackgroundAsset,
        darken: 0.35,
        child: SafeArea(
          child: JourneyContentWidth(
            child: BlocBuilder<DailyRewardsCubit, DailyRewardsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: Row(
                        children: [
                          _CircleBack(onTap: () => context.pop()),
                          const Spacer(),
                          BlocBuilder<CoinCubit, CoinState>(
                            builder: (context, coinState) =>
                                CoinDisplay(coins: coinState.coins, light: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TreasureChestImage(
                      size: 88,
                      animate: state.canClaim,
                      glowColor: spec.dailyBonusAccent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Come back every day',
                      style: GoogleFonts.cinzel(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: colors.onScenic,
                      ),
                    ),
                    Text(
                      'and claim your rewards!',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: colors.onScenicMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingMd,
                        ),
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.82,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, i) {
                              return _DayCard(day: state.days[i]);
                            },
                          ),
                          const SizedBox(height: 10),
                          if (state.days.length >= 7)
                            _DaySevenCard(day: state.days[6]),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingMd),
                      child: Column(
                        children: [
                          if (!state.canClaim && state.cooldown != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Next reward in ${DailyChallengeService.formatCountdown(state.cooldown!)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.accentCoin,
                                ),
                              ),
                            ),
                          _ClaimButton(
                            enabled: state.canClaim,
                            label: state.canClaim ? 'CLAIM' : 'COME BACK LATER',
                            onPressed: state.canClaim
                                ? () => _claim(context)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleBack extends StatelessWidget {
  const _CircleBack({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.onScenic.withValues(alpha: 0.92),
          ),
          child: Icon(Icons.arrow_back_rounded, color: colors.primary),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});

  final DailyRewardDay day;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final collected = day.status == DailyDayStatus.collected;
    final available = day.status == DailyDayStatus.available;

    Color border = colors.glassBorder.withValues(alpha: 0.5);
    if (collected) border = colors.success;
    if (available) border = spec.dailyBonusAccent;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassSurface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: available ? 2 : 1.2),
        boxShadow: [
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Day ${day.day}',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.onScenicMuted,
            ),
          ),
          const SizedBox(height: 6),
          if (collected)
            Column(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: colors.success, size: 32),
                const SizedBox(height: 4),
                Text(
                  'Collected',
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: colors.success,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Icon(Icons.monetization_on_rounded,
                    color: colors.gold, size: 28),
                Text(
                  '${day.coins}',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.onScenic,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DaySevenCard extends StatelessWidget {
  const _DaySevenCard({required this.day});

  final DailyRewardDay day;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spec = context.themePreset.homeSpec;
    final collected = day.status == DailyDayStatus.collected;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            spec.cardFill.withValues(alpha: 0.95),
            colors.primary.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: spec.dailyBonusAccent, width: 1.5),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day 7',
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: colors.onScenic,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.monetization_on_rounded,
                      color: colors.gold, size: 22),
                  Text(
                    ' ${day.coins}',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: colors.onScenic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          collected
              ? Icon(Icons.check_circle_rounded,
                  size: 48, color: colors.success)
              : TreasureChestImage(
                  size: 56,
                  animate: true,
                  glowColor: spec.dailyBonusAccent,
                ),
        ],
      ),
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({
    required this.enabled,
    required this.label,
    this.onPressed,
  });

  final bool enabled;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final spec = context.themePreset.homeSpec;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: enabled
                ? spec.playButtonGradient
                : LinearGradient(
                    colors: [
                      Colors.grey.shade600,
                      Colors.grey.shade700,
                    ],
                  ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: spec.playButtonGlow.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: enabled
                    ? spec.playButtonTextColor
                    : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
