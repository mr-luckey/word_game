import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/achievements/presentation/widgets/achievement_widgets.dart';
import 'package:word_game/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(getIt(), getIt()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.themeSplash(context.themePreset),
          darken: 0.48,
          blurSigma: 0.8,
          child: SafeArea(
            child: JourneyContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: context.appColors.gold,
                            size: 20,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: JourneySectionTitle(
                            title: 'Achievements',
                            subtitle: context.themePreset.exploreSubtitle,
                            align: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final colors = context.appColors;
                        if (state.loading) {
                          return Center(
                            child: CircularProgressIndicator(color: colors.gold),
                          );
                        }
                        return BlocBuilder<CoinCubit, CoinState>(
                          builder: (context, coinState) {
                            return ListView(
                              padding: JourneyThemeKit.pagePadding(context)
                                  .copyWith(
                                top: AppSizes.paddingSm,
                                bottom: AppSizes.paddingLg + 16,
                              ),
                              children: [
                                ProfileStatsRow(
                                  completedLevels: state.completedLevels,
                                  wordsFound: state.completedLevels * 6,
                                  coinsCollected: coinState.coins,
                                )
                                    .animate()
                                    .fadeIn(duration: 450.ms)
                                    .slideY(begin: 0.08, end: 0),
                                const SizedBox(height: AppSizes.paddingLg),
                                Text(
                                  'BADGES',
                                  style: AppTextStyles.sectionHeading(context)
                                      .copyWith(
                                    fontSize: 17,
                                    letterSpacing: 1,
                                  ),
                                ).animate(delay: 120.ms).fadeIn(),
                                const SizedBox(height: AppSizes.paddingSm),
                                ...state.achievements.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final a = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSizes.paddingSm,
                                      ),
                                      child: AchievementListTile(
                                        title: a.title,
                                        description: a.description,
                                        coinReward: a.coinReward,
                                        unlocked: a.unlocked,
                                      )
                                          .animate(delay: (180 + index * 70).ms)
                                          .fadeIn(duration: 420.ms)
                                          .slideX(begin: 0.1, end: 0),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
