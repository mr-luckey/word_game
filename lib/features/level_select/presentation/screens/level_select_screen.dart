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
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/level_select/presentation/cubit/banner_ad_cubit.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/level_select/presentation/cubit/level_select_cubit.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_view.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_select_header.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_select_stats_panel.dart';
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

class _LevelSelectView extends StatefulWidget {
  const _LevelSelectView();

  @override
  State<_LevelSelectView> createState() => _LevelSelectViewState();
}

class _LevelSelectViewState extends State<_LevelSelectView> {
  LevelSelectTab _tab = LevelSelectTab.map;

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
    if (levels.isNotEmpty && unlocked.contains(levels.first.id)) {
      return levels.first.id;
    }
    return null;
  }

  int _activeLevelNumber(
    List<LevelJson> levels,
    int? activeId,
    Set<int> unlocked,
  ) {
    if (activeId != null) {
      final idx = levels.indexWhere((l) => l.id == activeId);
      if (idx >= 0) return idx + 1;
    }
    for (var i = 0; i < levels.length; i++) {
      if (unlocked.contains(levels[i].id)) return i + 1;
    }
    return 1;
  }

  int _totalStars(Map<int, int> stars, List<LevelJson> levels) {
    var sum = 0;
    for (final level in levels) {
      sum += stars[level.id] ?? 0;
    }
    return sum;
  }

  int _completedCount(
    Map<int, int> stars,
    List<LevelJson> levels,
    Set<int> unlocked,
  ) {
    var count = 0;
    for (final level in levels) {
      if (unlocked.contains(level.id) && (stars[level.id] ?? 0) > 0) {
        count++;
      }
    }
    return count;
  }

  int _activeIndex(List<LevelJson> levels, int? activeId) {
    if (activeId == null) return 0;
    final idx = levels.indexWhere((l) => l.id == activeId);
    return idx >= 0 ? idx : 0;
  }

  /// Last level with stars — path lights up through here (Candy Crush style).
  int _progressThroughIndex(
    List<LevelJson> levels,
    Map<int, int> stars,
    int activeIndex,
  ) {
    if (levels.isEmpty) return 0;
    var last = -1;
    for (var i = 0; i < levels.length; i++) {
      if ((stars[levels[i].id] ?? 0) > 0) last = i;
    }
    final maxIdx = levels.length - 1;
    if (last < 0) {
      return activeIndex < 0
          ? 0
          : activeIndex > maxIdx
              ? maxIdx
              : activeIndex;
    }
    return last > maxIdx ? maxIdx : last;
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
        final displayLevels = filtered.take(20).toList();
        final activeId =
            _activeLevelId(displayLevels, state.unlocked, state.stars);
        final hasLevels = displayLevels.isNotEmpty;
        final activeIndex =
            hasLevels ? _activeIndex(displayLevels, activeId) : 0;
        final lastCompleted = hasLevels
            ? _progressThroughIndex(displayLevels, state.stars, activeIndex)
            : 0;
        final pathThrough = hasLevels
            ? (lastCompleted > activeIndex ? lastCompleted : activeIndex)
            : 0;
        final levelLabel = 'Level ${_activeLevelNumber(displayLevels, activeId, state.unlocked)}';

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ScenicBackground(
            imageAsset: bgAsset,
            darken: 0.28,
            blurSigma: 0,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LevelSelectHeader(
                    destinationTitle: state.themeName.toUpperCase(),
                    currentLevelLabel: levelLabel,
                    selectedTab: _tab,
                    onTabChanged: (t) => setState(() => _tab = t),
                    onBack: () => journeyPopFromLevels(context),
                  ),
                  Expanded(
                    child: state.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colors.gold,
                            ),
                          )
                        : _tab == LevelSelectTab.map
                            ? !hasLevels
                                ? Center(
                                    child: Text(
                                      'No levels for this difficulty',
                                      style: AppTextStyles.bodyMuted(context),
                                    ),
                                  )
                                : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  8,
                                  0,
                                  8,
                                  4,
                                ),
                                child: LevelMapView(
                                  activeIndex: activeIndex,
                                  progressThroughIndex: pathThrough,
                                  levels: [
                                    for (var i = 0; i < displayLevels.length; i++)
                                      LevelMapEntry(
                                        levelNumber: i + 1,
                                        stars: state.stars[displayLevels[i].id] ?? 0,
                                        locked: !state.unlocked
                                            .contains(displayLevels[i].id),
                                        isActive: !state.unlocked
                                                .contains(displayLevels[i].id)
                                            ? false
                                            : displayLevels[i].id == activeId,
                                        isCompleted: state.unlocked
                                                .contains(displayLevels[i].id) &&
                                            (state.stars[displayLevels[i].id] ?? 0) > 0,
                                        onTap: state.unlocked
                                                .contains(displayLevels[i].id)
                                            ? () => _openLevel(
                                                  context,
                                                  displayLevels[i].id,
                                                )
                                            : null,
                                      ),
                                  ],
                                ),
                              )
                            : LevelSelectStatsPanel(
                                difficultyIndex: state.difficultyIndex,
                                onDifficultyChanged: context
                                    .read<LevelSelectCubit>()
                                    .selectDifficulty,
                                completedCount: _completedCount(
                                  state.stars,
                                  displayLevels,
                                  state.unlocked,
                                ),
                                totalCount: displayLevels.length,
                                totalStars: _totalStars(
                                  state.stars,
                                  displayLevels,
                                ),
                              ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: colors.navSurface.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: colors.glassBorder.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard_rounded,
                            color: colors.gold,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Complete levels to earn coins',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMuted(context),
                            ),
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
        );
      },
    );
  }
}
