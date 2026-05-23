import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_colors.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class DestinationsScreen extends StatelessWidget {
  const DestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DestinationsCubit(getIt())..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Destinations'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            BlocBuilder<CoinCubit, CoinState>(
              builder: (context, state) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.paddingMd),
                child: Center(child: CoinDisplay(coins: state.coins)),
              ),
            ),
          ],
        ),
        body: BlocBuilder<DestinationsCubit, DestinationsState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.paddingMd),
              itemCount: state.themes.length,
              itemBuilder: (context, index) {
                final theme = state.themes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () =>
                        context.push('/levels?themeId=${theme.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                AssetPaths.themeImage(theme.backgroundImage),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryBlue,
                                        AppColors.oceanBlue.withValues(
                                          alpha: 0.6 + index * 0.05,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.black.withValues(alpha: 0.35),
                              ),
                              Center(
                                child: Icon(
                                  Icons.location_city,
                                  size: 48,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(theme.name, style: AppTextStyles.levelName),
                              Text(
                                '${theme.levels.length} levels',
                                style: AppTextStyles.wordList,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
