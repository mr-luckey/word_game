import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/constants/scenic_background_style.dart';
import 'package:word_game/core/navigation/journey_nav.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/shell_nav_metrics.dart';
import 'package:word_game/features/game/domain/entities/level_entity.dart';
import 'package:word_game/features/level_select/presentation/cubit/level_select_cubit.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_view.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_map_sections.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_select_header.dart';
import 'package:word_game/features/level_select/presentation/widgets/level_select_stats_panel.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
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
      ],
      child: const _LevelSelectView(),
    );
  }
}

Future<void> _openLevel(BuildContext context, int levelId) async {
  final progressUpdated = await context.push<bool>('/game?levelId=$levelId');
  if (!context.mounted) return;
  context.read<CoinCubit>().refresh();
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
    int? currentSharedLevelId,
    Set<int> unlocked,
  ) {
    if (currentSharedLevelId != null &&
        unlocked.contains(currentSharedLevelId)) {
      return currentSharedLevelId;
    }
    for (final level in levels) {
      if (unlocked.contains(level.id)) return level.id;
    }
    return null;
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
        final dest = DestinationCatalog.byId(themeId, context.themePreset);
        final bgAsset = preset == AppThemePreset.classicTravel
            ? AssetPaths.themeGrid(preset)
            : state.backgroundImage.isNotEmpty
                ? AssetPaths.themeImage(state.backgroundImage)
                : dest?.imageAsset ?? ScenicBackgroundStyle.hdAssetFor(preset);
        final mapLevels = sortedMapLevels(state.levels);
        final statsLevels = state.filteredLevels;
        final mapSections = buildLevelMapSections(mapLevels);
        final activeId = _activeLevelId(
          mapLevels,
          state.currentSharedLevelId,
          state.unlocked,
        );
        final hasMapLevels = mapLevels.isNotEmpty;
        final activeIndex =
            hasMapLevels ? _activeIndex(mapLevels, activeId) : 0;
        final lastCompleted = hasMapLevels
            ? _progressThroughIndex(mapLevels, state.stars, activeIndex)
            : 0;
        final pathThrough = hasMapLevels
            ? (lastCompleted > activeIndex ? lastCompleted : activeIndex)
            : 0;
        final levelLabel =
            'Level ${state.currentDisplayNumber} of ${mapLevels.length}';

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ScenicBackground(
            imageAsset: bgAsset,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: ShellNavMetrics.contentBottomPadding(context),
                ),
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
                        : state.destinationLocked
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock_rounded,
                                        size: 56,
                                        color: colors.locked,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Destination locked',
                                        style: AppTextStyles.levelName(context),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        state.unlockRequirement == null
                                            ? 'Complete the previous destination to unlock.'
                                            : 'Finish ${state.unlockRequirement} first.',
                                        style: AppTextStyles.bodyMuted(context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _tab == LevelSelectTab.map
                            ? !hasMapLevels
                                ? Center(
                                    child: Text(
                                      'No levels in this destination',
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
                                      sections: mapSections,
                                      levels: [
                                        for (var i = 0; i < mapLevels.length; i++)
                                          LevelMapEntry(
                                            levelNumber: i + 1,
                                            stars: state.stars[mapLevels[i].id] ?? 0,
                                            locked: !state.unlocked
                                                .contains(mapLevels[i].id),
                                            isActive: state.unlocked
                                                    .contains(mapLevels[i].id) &&
                                                mapLevels[i].id == activeId,
                                            isCompleted: state.unlocked
                                                    .contains(mapLevels[i].id) &&
                                                (state.stars[mapLevels[i].id] ??
                                                        0) >
                                                    0,
                                            onTap: state.unlocked
                                                    .contains(mapLevels[i].id)
                                                ? () => _openLevel(
                                                      context,
                                                      mapLevels[i].id,
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
                                  statsLevels,
                                  state.unlocked,
                                ),
                                totalCount: statsLevels.length,
                                totalStars: _totalStars(
                                  state.stars,
                                  statsLevels,
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
