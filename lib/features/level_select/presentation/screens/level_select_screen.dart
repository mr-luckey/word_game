import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/navigation/journey_nav.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_level_banner.dart';
import 'package:word_game/core/widgets/journey_screen_header.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/level_select/presentation/cubit/banner_ad_cubit.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/level_select/presentation/cubit/level_select_cubit.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_card.dart';
import 'package:word_game/injection.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key, required this.themeId});

  final int themeId;

  @override
  Widget build(BuildContext context) {
    getIt<AppThemeBloc>().setDestinationContext(themeId);
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
  final progressUpdated = await context.push<bool>('/game?levelId=$levelId');
  if (progressUpdated == true && context.mounted) {
    await context.read<LevelSelectCubit>().load();
  }
}

class _LevelSelectView extends StatelessWidget {
  const _LevelSelectView();

  static const _diffLabels = ['Easy', 'Medium', 'Hard', 'Pro'];

  int? _activeLevelId(
    List<LevelJson> levels,
    Set<int> unlocked,
    Map<int, int> stars,
  ) {
    for (final level in levels) {
      if (unlocked.contains(level.id) && (stars[level.id] ?? 0) == 0) {
        return level.id;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelSelectCubit, LevelSelectState>(
      builder: (context, state) {
        final colors = context.appColors;
        final preset = context.themePreset;
        final themeId = context.read<LevelSelectCubit>().themeId;
        final dest = DestinationCatalog.byId(themeId);
        final bgAsset = state.backgroundImage.isNotEmpty
            ? AssetPaths.themeImage(state.backgroundImage)
            : dest?.imageAsset ?? AssetPaths.themeSplash(preset);
        final filtered = state.filteredLevels;
        final activeId = _activeLevelId(filtered, state.unlocked, state.stars);

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ScenicBackground(
            showBackgroundImage: false,
            child: SafeArea(
              child: JourneyContentWidth(
                child: Column(
                  children: [
                    JourneyScreenHeader(
                      leading: IconButton(
                        icon:
                            Icon(Icons.arrow_back_rounded, color: colors.gold),
                        onPressed: () => journeyPopFromLevels(context),
                      ),
                    ),
                    JourneyLevelBanner(
                      title: state.themeName.toUpperCase(),
                      imageAsset: bgAsset,
                    ),
                    Padding(
                      padding: JourneyThemeKit.pagePadding(context),
                      child: JourneyPanel(
                        padding: const EdgeInsets.all(4),
                        radius: 24,
                        child: Row(
                          children: List.generate(4, (i) {
                            final selected = state.difficultyIndex == i;
                            return Expanded(
                              child: Material(
                                color:
                                    selected ? colors.gold : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
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
                                      style: AppTextStyles.wordList(context)
                                          .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: selected
                                            ? colors.onPrimary
                                            : colors.onScenicMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      child: state.loading
                          ? Center(
                              child:
                                  CircularProgressIndicator(color: colors.gold),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(AppSizes.paddingMd),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.88,
                              ),
                              itemCount: filtered.length.clamp(0, 20),
                              itemBuilder: (context, index) {
                                final level = filtered[index];
                                final stars = state.stars[level.id] ?? 0;
                                final locked =
                                    !state.unlocked.contains(level.id);
                                return LevelCard(
                                  levelNumber: index + 1,
                                  stars: stars,
                                  locked: locked,
                                  isActive: !locked && level.id == activeId,
                                  onTap: locked
                                      ? null
                                      : () => _openLevel(context, level.id),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                        vertical: AppSizes.paddingSm,
                      ),
                      child: JourneyPanel(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        radius: 18,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              color: colors.gold,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Complete levels to earn coins',
                              style: AppTextStyles.bodyMuted(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<BannerAdCubit, BannerAd?>(
                      builder: (context, banner) {
                        if (banner == null) return const SizedBox.shrink();
                        return ColoredBox(
                          color: colors.navSurface,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
