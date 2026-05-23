import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/widgets/coin_display.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LevelSelectCubit, LevelSelectState>(
          builder: (context, state) => Text(state.themeName),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<CoinCubit, CoinState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: AppSizes.paddingMd),
              child: Center(child: CoinDisplay(coins: state.coins)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<LevelSelectCubit, LevelSelectState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(AppSizes.paddingSm),
                child: Row(
                  children: List.generate(4, (i) {
                    final selected = state.difficultyIndex == i;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(_diffLabels[i]),
                          selected: selected,
                          onSelected: (_) => context
                              .read<LevelSelectCubit>()
                              .selectDifficulty(i),
                          selectedColor: _diffColors[i].withValues(alpha: 0.3),
                          checkmarkColor: _diffColors[i],
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<LevelSelectCubit, LevelSelectState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final levels = state.filteredLevels;
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSizes.paddingSm,
                    crossAxisSpacing: AppSizes.paddingSm,
                  ),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final stars = state.stars[level.id] ?? 0;
                    final locked = !state.unlocked.contains(level.id);
                    return LevelCard(
                      levelNumber: index + 1,
                      stars: stars,
                      locked: locked,
                      onTap: locked
                          ? null
                          : () => context.push('/game?levelId=${level.id}'),
                    );
                  },
                );
              },
            ),
          ),
          BlocBuilder<BannerAdCubit, BannerAd?>(
            builder: (context, banner) {
              if (banner == null) return const SizedBox.shrink();
              return SizedBox(
                width: banner.size.width.toDouble(),
                height: banner.size.height.toDouble(),
                child: AdWidget(ad: banner),
              );
            },
          ),
        ],
      ),
    );
  }
}
