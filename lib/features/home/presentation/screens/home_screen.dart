import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/home/presentation/widgets/home_achievements_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_background.dart';
import 'package:word_game/features/home/presentation/widgets/home_brand_title.dart';
import 'package:word_game/features/home/presentation/widgets/home_treasure_box.dart';
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
      child: const _HomeView(),
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
          bottom: false,
          child: JourneyContentWidth(
            child: BlocBuilder<DestinationsCubit, DestinationsState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final featured = DestinationCatalog.forPreset(preset)
                    .where((d) => d.unlockOrder == 1)
                    .first;
                final theme = state.themes
                    .where((t) => t.id == featured.id)
                    .firstOrNull;
                final imagePath = theme?.backgroundImage.isNotEmpty == true
                    ? AssetPaths.themeImage(theme!.backgroundImage)
                    : featured.imageAsset;
                final completed = theme == null
                    ? 0
                    : theme.levels
                        .where((level) =>
                            state.completedLevelIds.contains(level.id))
                        .length;
                final total = theme?.levels.length ?? 20;
                final destinationId = theme?.id ?? featured.id;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const HomeTopBar(),
                          const HomeBrandTitle(),
                          HomeFeaturedCard(
                            title: theme?.name ?? featured.name,
                            country: featured.country,
                            completed: completed,
                            total: total,
                            imageAsset: imagePath,
                            height: metrics.featuredHeight,
                            compact: metrics.compact,
                            dense: metrics.dense,
                            onTap: () => _goLevels(context, destinationId),
                          ),
                          SizedBox(height: metrics.sectionGap),
                          HomePlayButton(
                            height: metrics.playButtonHeight,
                            onPressed: () =>
                                _goLevels(context, destinationId),
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
                                      onTap: () => context.go('/profile'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: metrics.sectionGap +
                                MediaQuery.paddingOf(context).bottom +
                                72,
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

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
