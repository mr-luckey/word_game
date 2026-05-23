import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/gradient_button.dart';
import 'package:word_game/core/widgets/journey_bottom_nav.dart';
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
      create: (_) => DestinationsCubit(getIt())..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ScenicBackground(
        imageAsset: AssetPaths.themeImage('paris_bg.jpg'),
        darken: 0.4,
        child: SafeArea(
          child: Column(
            children: [
              _HomeHeader(),
              Expanded(
                child: BlocBuilder<DestinationsCubit, DestinationsState>(
                  builder: (context, state) {
                    final theme = state.themes.isNotEmpty
                        ? state.themes.first
                        : null;
                    final total = theme?.levels.length ?? 50;
                    final completed = 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          Text(
                            'WORD SEARCH',
                            style: AppTextStyles.gameTitle.copyWith(
                              fontSize: 32,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: -0.2, end: 0),
                          const SizedBox(height: 4),
                          Text(
                            'JOURNEY',
                            style: AppTextStyles.gameTitle.copyWith(
                              fontSize: 28,
                              color: const Color(0xFFFFD54F),
                              letterSpacing: 6,
                            ),
                          )
                              .animate(delay: 150.ms)
                              .fadeIn()
                              .shimmer(
                                duration: 2.seconds,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                          const SizedBox(height: AppSizes.paddingLg),
                          DestinationCard(
                            title: theme?.name.toUpperCase() ?? 'PARIS ADVENTURE',
                            completed: completed,
                            total: total,
                            imageAsset: theme != null
                                ? AssetPaths.themeImage(theme.backgroundImage)
                                : null,
                            onTap: () => context.push(
                              '/levels?themeId=${theme?.id ?? 1}',
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingLg),
                          GradientButton(
                            label: 'PLAY NOW',
                            icon: Icons.play_arrow_rounded,
                            useGold: true,
                            onPressed: () =>
                                context.push('/levels?themeId=${theme?.id ?? 1}'),
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
                            '$completed / $total levels completed',
                            style: AppTextStyles.subtitle.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingSm),
                          TextButton.icon(
                            onPressed: () => context.push('/game?levelId=9999'),
                            icon: Icon(
                              Icons.card_giftcard_rounded,
                              color: Colors.amber.shade200,
                            ),
                            label: Text(
                              'Daily Bonus Challenge',
                              style: AppTextStyles.subtitle.copyWith(
                                color: Colors.amber.shade100,
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
      bottomNavigationBar: JourneyBottomNav(
        selectedIndex: 0,
        onSelected: (i) {
          switch (i) {
            case 0:
              break;
            case 1:
              context.push('/destinations');
            case 2:
              context.push('/shop');
            case 3:
              context.push('/profile');
          }
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSm,
        vertical: AppSizes.paddingXs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () => context.push('/settings'),
          ),
          const Spacer(),
          BlocBuilder<CoinCubit, CoinState>(
            builder: (context, state) => CoinDisplay(coins: state.coins, light: true),
          ),
        ],
      ),
    );
  }
}
