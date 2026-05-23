import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/scenic_page.dart';
import 'package:word_game/features/level_select/presentation/cubit/banner_ad_cubit.dart';
import 'package:word_game/features/level_select/presentation/cubit/level_select_cubit.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_card.dart';
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

Future<void> _openLevel(BuildContext context, int levelId) async {
  final progressUpdated =
      await context.push<bool>('/game?levelId=$levelId');
  if (progressUpdated == true && context.mounted) {
    await context.read<LevelSelectCubit>().load();
  }
}

class _LevelSelectView extends StatelessWidget {
  const _LevelSelectView();

  static const _diffLabels = ['Easy', 'Medium', 'Hard', 'Pro'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelSelectCubit, LevelSelectState>(
      builder: (context, state) {
        final colors = context.appColors;
        final bgAsset = state.backgroundImage.isNotEmpty
            ? AssetPaths.themeImage(state.backgroundImage)
            : AssetPaths.themeImage('paris_bg.jpg');

        final diffColors = [colors.easy, colors.medium, colors.hard, colors.pro];

        return ScenicPage(
          title: state.themeName,
          backgroundAsset: bgAsset,
          child: Column(
            children: [
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
                                ? diffColors[i].withValues(alpha: 0.95)
                                : colors.glassSurface,
                            borderRadius: BorderRadius.circular(20),
                            elevation: selected ? 4 : 0,
                            child: InkWell(
                              onTap: () => context
                                  .read<LevelSelectCubit>()
                                  .selectDifficulty(i),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  _diffLabels[i],
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.wordList(context).copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? colors.onPrimary
                                        : diffColors[i],
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
                    ? Center(
                        child: CircularProgressIndicator(color: colors.gold),
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
                                : () => _openLevel(context, level.id),
                          );
                        },
                      ),
              ),
              BlocBuilder<BannerAdCubit, BannerAd?>(
                builder: (context, banner) {
                  if (banner == null) return const SizedBox.shrink();
                  return ColoredBox(
                    color: colors.surface,
                    child: SizedBox(
                      width: banner.size.width.toDouble(),
                      height: banner.size.height.toDouble(),
                      child: AdWidget(ad: banner),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
