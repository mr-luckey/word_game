import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/level_select/presentation/cubit/banner_ad_cubit.dart';
import 'package:word_game/features/level_select/presentation/cubit/level_select_cubit.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_card.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key, required this.themeId});

  final int themeId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LevelSelectCubit(getIt(), getIt(), themeId)..load(),
        ),
        BlocProvider(create: (_) => BannerAdCubit(getIt())),
      ],
      child: const _LevelSelectView(),
    );
  }
}

class _LevelSelectView extends StatelessWidget {
  const _LevelSelectView();

  static const _diffColors = [
    AppColors.easy,
    AppColors.medium,
    AppColors.hard,
    AppColors.pro,
  ];

  static const _diffLabels = ['Easy', 'Medium', 'Hard', 'Pro'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelSelectCubit, LevelSelectState>(
      builder: (context, state) {
        final bgAsset = state.backgroundImage.isNotEmpty
            ? AssetPaths.themeImage(state.backgroundImage)
            : AssetPaths.themeImage('paris_bg.jpg');

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ScenicBackground(
            imageAsset: bgAsset,
            blurSigma: 1.5,
            darken: 0.4,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingSm,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            state.themeName,
                            style: AppTextStyles.appBarTitle.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        BlocBuilder<CoinCubit, CoinState>(
                          builder: (context, coinState) =>
                              CoinDisplay(coins: coinState.coins, light: true),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.paddingSm),
                    child: Row(
                      children: List.generate(4, (i) {
                        final selected = state.difficultyIndex == i;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              child: Material(
                                color: selected
                                    ? _diffColors[i].withValues(alpha: 0.95)
                                    : Colors.white.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(20),
                                elevation: selected ? 4 : 0,
                                child: InkWell(
                                  onTap: () => context
                                      .read<LevelSelectCubit>()
                                      .selectDifficulty(i),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      _diffLabels[i],
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.wordList.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? Colors.white
                                            : _diffColors[i],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: state.loading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.gold),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(AppSizes.paddingMd),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: AppSizes.paddingSm,
                              crossAxisSpacing: AppSizes.paddingSm,
                            ),
                            itemCount: state.filteredLevels.length,
                            itemBuilder: (context, index) {
                              final level = state.filteredLevels[index];
                              final stars = state.stars[level.id] ?? 0;
                              final locked = !state.unlocked.contains(level.id);
                              return LevelCard(
                                levelNumber: index + 1,
                                stars: stars,
                                locked: locked,
                                onTap: locked
                                    ? null
                                    : () => context.push(
                                          '/game?levelId=${level.id}',
                                        ),
                              );
                            },
                          ),
                  ),
                  BlocBuilder<BannerAdCubit, BannerAd?>(
                    builder: (context, banner) {
                      if (banner == null) return const SizedBox.shrink();
                      return Container(
                        color: Colors.white,
                        width: banner.size.width.toDouble(),
                        height: banner.size.height.toDouble(),
                        child: AdWidget(ad: banner),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
