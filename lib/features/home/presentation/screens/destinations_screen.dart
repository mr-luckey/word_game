import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/glass_panel.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class DestinationsScreen extends StatelessWidget {
  const DestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DestinationsCubit(getIt(), getIt())..load(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.splashBg,
          darken: 0.35,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSm,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Text(
                          'Explore Destinations',
                          style: AppTextStyles.appBarTitle(context)
                              .copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      BlocBuilder<CoinCubit, CoinState>(
                        builder: (context, state) =>
                            CoinDisplay(coins: state.coins, light: true),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<DestinationsCubit, DestinationsState>(
                    builder: (context, state) {
                      final colors = context.appColors;
                      if (state.loading) {
                        return Center(
                          child: CircularProgressIndicator(color: colors.gold),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        itemCount: state.themes.length,
                        itemBuilder: (context, index) {
                          final theme = state.themes[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.paddingMd,
                            ),
                            child: GlassPanel(
                              padding: EdgeInsets.zero,
                              onTap: () =>
                                  context.go('/levels?themeId=${theme.id}'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(AppSizes.radiusLg),
                                    ),
                                    child: SizedBox(
                                      height: 130,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            AssetPaths.themeImage(
                                              theme.backgroundImage,
                                            ),
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: colors.primaryGradient,
                                              ),
                                            ),
                                          ),
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  colors.scrim,
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: AppSizes.paddingMd,
                                            bottom: AppSizes.paddingMd,
                                            child: Text(
                                              theme.name,
                                              style: AppTextStyles.levelName(
                                                context,
                                              ).copyWith(
                                                color: colors.onScenic,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      AppSizes.paddingMd,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.map_rounded,
                                          color: colors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${theme.levels.length} levels',
                                          style: AppTextStyles.wordList(context),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: colors.locked,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate(delay: (index * 80).ms)
                              .fadeIn(duration: 400.ms)
                              .slideX(begin: 0.1, end: 0);
                        },
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
