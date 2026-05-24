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
import 'package:word_game/features/home/presentation/widgets/home_daily_bonus_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_featured_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_play_button.dart';
import 'package:word_game/features/home/presentation/widgets/home_top_bar.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: HomeBackground(
        child: SafeArea(
          child: JourneyContentWidth(
            child: Column(
              children: [
                const HomeTopBar(),
                const HomeBrandTitle(),
                Expanded(
                  child: BlocBuilder<DestinationsCubit, DestinationsState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final featured = DestinationCatalog.forPreset(preset)
                          .where((d) => d.unlockOrder == 1)
                          .first;
                      final theme = state.themes
                          .where((t) => t.id == featured.id)
                          .firstOrNull;
                      final imagePath =
                          theme?.backgroundImage.isNotEmpty == true
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

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            HomeFeaturedCard(
                              title: theme?.name ?? featured.name,
                              completed: completed,
                              total: total,
                              imageAsset: imagePath,
                              onTap: () => _goLevels(context, destinationId),
                            ),
                            const SizedBox(height: 14),
                            HomePlayButton(
                              onPressed: () =>
                                  _goLevels(context, destinationId),
                            ),
                            const SizedBox(height: 14),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: HomeDailyBonusCard(
                                      onTap: () async {
                                        final updated = await context
                                            .push<bool>('/game?levelId=9999');
                                        if (updated == true &&
                                            context.mounted) {
                                          context
                                              .read<DestinationsCubit>()
                                              .refresh();
                                          context.read<CoinCubit>().refresh();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: HomeAchievementsCard(
                                      onTap: () => context.go('/profile'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
