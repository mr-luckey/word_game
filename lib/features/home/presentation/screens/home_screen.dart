import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/home/presentation/widgets/home_background.dart';
import 'package:word_game/features/home/presentation/widgets/home_brand_title.dart';
import 'package:word_game/features/home/presentation/widgets/home_treasure_box.dart';
import 'package:word_game/features/home/presentation/widgets/home_achievements_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_featured_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_layout_metrics.dart';
import 'package:word_game/features/home/presentation/widgets/home_play_button.dart';
import 'package:word_game/features/home/presentation/widgets/home_top_bar.dart';
import 'package:word_game/injection.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DestinationsCubit(getIt(), getIt())..load(),
      child: BlocListener<AppThemeBloc, AppThemeState>(
        listenWhen: (prev, next) => prev.activePreset != next.activePreset,
        listener: (context, _) {
          final cubit = context.read<DestinationsCubit>();
          if (!cubit.isClosed) cubit.load();
        },
        child: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool _isFirstActivate = true;

  void _goLevels(BuildContext context, int themeId) {
    getIt<AppThemeBloc>().setDestinationContext(themeId);
    context.go('/levels?themeId=$themeId');
  }

  Future<void> _continuePlay(
    BuildContext context,
    int fallbackDestinationId,
  ) async {
    final themeBloc = getIt<AppThemeBloc>();
    var destinationId =
        themeBloc.state.activeDestinationId ?? fallbackDestinationId;

    final destState = context.read<DestinationsCubit>().state;
    if (!destState.loading &&
        destState.unlockedSlots.isNotEmpty &&
        !destState.isSlotUnlocked(destinationId)) {
      destinationId = destState.unlockedSlots.first;
    }

    themeBloc.setDestinationContext(destinationId);

    final themes = await getIt<LevelRepository>()
        .loadThemesForPreset(themeBloc.state.activePreset);
    if (!context.mounted) return;

    final theme = themes.where((t) => t.id == destinationId).firstOrNull ??
        themes.firstOrNull;
    if (theme == null) {
      if (!context.mounted) return;
      _goLevels(context, destinationId);
      return;
    }

    final ordered = theme.levels.map((l) => l.id).toList()..sort();
    final levelId = await getIt<ProgressRepository>().resolveResumeLevelId(
      slotId: destinationId,
      orderedSharedLevelIds: ordered,
    );
    if (!context.mounted) return;

    final progressUpdated =
        await context.push<bool>('/game?levelId=$levelId');
    if (!context.mounted) return;
    if (progressUpdated == true) {
      context.read<DestinationsCubit>().refresh();
    }
  }

  @override
  void activate() {
    super.activate();
    if (_isFirstActivate) {
      _isFirstActivate = false;
      return;
    }
    if (!mounted) return;
    final cubit = context.read<DestinationsCubit>();
    if (!cubit.isClosed) cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    final metrics = HomeLayoutMetrics.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: HomeBackground(
        child: SafeArea(
          child: JourneyContentWidth(
            child: BlocBuilder<DestinationsCubit, DestinationsState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final presetDestinations = DestinationCatalog.forPreset(preset);
                if (presetDestinations.isEmpty) {
                  return const Center(
                    child: Text('Destinations could not be loaded'),
                  );
                }
                final featured = presetDestinations
                        .where((d) => d.unlockOrder == 1)
                        .firstOrNull ??
                    presetDestinations.first;
                final completed = state.featuredCompleted;
                final total =
                    state.featuredTotal > 0 ? state.featuredTotal : 20;
                final destinationId = featured.id;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const HomeTopBar(),
                          const HomeBrandTitle(),
                          HomeFeaturedCard(
                            key: ValueKey('featured-${preset.name}-$destinationId'),
                            title: featured.name,
                            country: featured.country,
                            completed: completed,
                            total: total,
                            imageAsset: featured.imageAsset,
                            height: metrics.featuredHeight,
                            compact: metrics.compact,
                            dense: metrics.dense,
                            onTap: () => _goLevels(context, destinationId),
                          ),
                          SizedBox(height: metrics.sectionGap),
                          HomePlayButton(
                            height: metrics.playButtonHeight,
                            onPressed: () =>
                                _continuePlay(context, destinationId),
                          ),
                          SizedBox(height: metrics.sectionGap),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: metrics.sideCardHeight,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: HomeTreasureBox(
                                      height: metrics.sideCardHeight,
                                      compact: metrics.compact,
                                      dense: metrics.dense,
                                      onTap: () =>
                                          context.push('/daily-rewards'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: HomeAchievementsCard(
                                      height: metrics.sideCardHeight,
                                      compact: metrics.compact,
                                      dense: metrics.dense,
                                      onTap: () =>
                                          context.push('/achievements'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: metrics.sectionGap),
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

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
