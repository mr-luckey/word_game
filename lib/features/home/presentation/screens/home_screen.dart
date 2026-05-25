import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/app_theme_preset.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/home/presentation/screens/world_tour_home_screen.dart';
import 'package:word_game/features/home/presentation/widgets/home_achievements_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_background.dart';
import 'package:word_game/features/home/presentation/widgets/home_brand_title.dart';
import 'package:word_game/features/home/presentation/widgets/home_daily_bonus_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_featured_card.dart';
import 'package:word_game/features/home/presentation/widgets/home_play_button.dart';
import 'package:word_game/features/home/presentation/widgets/home_top_bar.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DestinationsCubit(getIt(), getIt())..load(),
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        buildWhen: (p, c) => p.activePreset != c.activePreset,
        builder: (context, themeState) {
          if (themeState.activePreset == AppThemePreset.worldTour) {
            return const WorldTourHomeScreen();
          }
          return const _ClassicHomeView();
        },
      ),
    );
  }
}

class _ClassicHomeView extends StatefulWidget {
  const _ClassicHomeView();

  @override
  State<_ClassicHomeView> createState() => _ClassicHomeViewState();
}

class _ClassicHomeViewState extends State<_ClassicHomeView> {
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

                    final theme =
                        state.themes.isNotEmpty ? state.themes.first : null;
                    final featured = DestinationCatalog.forPreset(preset)
                        .where((d) => d.unlockOrder == 1)
                        .first;
                    final meta =
                        (theme != null ? DestinationCatalog.byId(theme.id) : null) ??
                            featured;
                    final imagePath = theme != null
                        ? AssetPaths.themeImage(theme.backgroundImage)
                        : meta.imageAsset;
                    final completed = state.featuredCompleted;
                    final total =
                        state.featuredTotal > 0 ? state.featuredTotal : 20;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          HomeFeaturedCard(
                            title: theme?.name ?? meta.name,
                            completed: completed,
                            total: total,
                            imageAsset: imagePath,
                            onTap: () =>
                                _goLevels(context, theme?.id ?? meta.id),
                          ),
                          const SizedBox(height: 14),
                          HomePlayButton(
                            onPressed: () =>
                                _goLevels(context, theme?.id ?? meta.id),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: HomeDailyBonusCard(
                                    onTap: () async {
                                      final updated = await context
                                          .push<bool>('/game?levelId=9999');
                                      if (updated == true && context.mounted) {
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
    );
  }
}
