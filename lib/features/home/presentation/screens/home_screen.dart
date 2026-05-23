import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/home/presentation/widgets/destination_card.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

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

  @override
  void activate() {
    super.activate();
    // Skip first activate — BlocProvider already calls load() on create.
    if (_isFirstActivate) {
      _isFirstActivate = false;
      return;
    }
    if (!mounted) return;
    final cubit = context.read<DestinationsCubit>();
    if (!cubit.isClosed) {
      cubit.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ScenicBackground(
        imageAsset: AssetPaths.themeImage('paris_bg.jpg'),
        darken: 0.4,
        child: SafeArea(
          child: Column(
            children: [
              const _HomeHeader(),
              Expanded(
                child: BlocBuilder<DestinationsCubit, DestinationsState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return Center(
                        child: CircularProgressIndicator(color: colors.gold),
                      );
                    }

                    final theme =
                        state.themes.isNotEmpty ? state.themes.first : null;
                    final cardCompleted = state.featuredCompleted;
                    final cardTotal = state.featuredTotal;
                    final overallCompleted = state.totalCompleted;
                    final overallTotal = state.totalLevels;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            'WORD SEARCH',
                            style: AppTextStyles.gameTitle(context).copyWith(
                              fontSize: 32,
                              shadows: [
                                Shadow(
                                  color: colors.scrim,
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 600.ms).slideY(
                                begin: -0.2,
                                end: 0,
                              ),
                          const SizedBox(height: 4),
                          Text(
                            'JOURNEY',
                            style: AppTextStyles.gameTitle(context).copyWith(
                              fontSize: 28,
                              color: colors.goldLight,
                              letterSpacing: 6,
                            ),
                          )
                              .animate(delay: 150.ms)
                              .fadeIn()
                              .shimmer(
                                duration: 2.seconds,
                                color: colors.onScenic.withValues(alpha: 0.3),
                              ),
                          const SizedBox(height: AppSizes.paddingLg),
                          DestinationCard(
                            title: theme?.name.toUpperCase() ?? 'PARIS ADVENTURE',
                            completed: cardCompleted,
                            total: cardTotal > 0 ? cardTotal : 1,
                            imageAsset: theme != null
                                ? AssetPaths.themeImage(theme.backgroundImage)
                                : null,
                            onTap: () => context.go(
                              '/levels?themeId=${theme?.id ?? 1}',
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingLg),
                          GradientButton(
                            label: 'PLAY NOW',
                            icon: Icons.play_arrow_rounded,
                            useGold: true,
                            onPressed: () => context.go(
                              '/levels?themeId=${theme?.id ?? 1}',
                            ),
                          )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.04, 1.04),
                                duration: 900.ms,
                                curve: Curves.easeInOut,
                              ),
                          const SizedBox(height: AppSizes.paddingMd),
                          Text(
                            '$overallCompleted / $overallTotal levels completed',
                            style: AppTextStyles.subtitle(context).copyWith(
                              color: colors.onScenic.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingSm),
                          TextButton.icon(
                            onPressed: () async {
                              final updated = await context.push<bool>(
                                '/game?levelId=9999',
                              );
                              if (updated == true && context.mounted) {
                                context.read<DestinationsCubit>().refresh();
                                context.read<CoinCubit>().refresh();
                              }
                            },
                            icon: Icon(
                              Icons.card_giftcard_rounded,
                              color: colors.goldLight,
                            ),
                            label: Text(
                              'Daily Bonus Challenge',
                              style: AppTextStyles.subtitle(context).copyWith(
                                color: colors.goldLight.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(flex: 2),
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.settings_rounded, color: colors.onScenic),
            onPressed: () => context.go('/settings'),
          ),
          const Spacer(),
          BlocBuilder<CoinCubit, CoinState>(
            builder: (context, state) =>
                CoinDisplay(coins: state.coins, light: true),
          ),
        ],
      ),
    );
  }
}
