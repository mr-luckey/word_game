import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/app_theme_bloc.dart';
import 'package:word_game/core/theme/destination_catalog.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_screen_header.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/injection.dart';

class DestinationsScreen extends StatelessWidget {
  const DestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    return BlocProvider(
      create: (_) => DestinationsCubit(getIt(), getIt())..load(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.themeGrid(preset),
          darken: 0.55,
          blurSigma: 1.5,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const JourneyScreenHeader(showSettings: false),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMd,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'EXPLORE',
                        style: AppTextStyles.sectionHeading(context),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Destinations',
                        style: AppTextStyles.levelName(context).copyWith(
                          fontSize: 20,
                          color: context.appColors.onScenic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Discover iconic cities and new word adventures.',
                        style: AppTextStyles.bodyMuted(context),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Expanded(
                  child: BlocBuilder<DestinationsCubit, DestinationsState>(
                    builder: (context, state) {
                      final colors = context.appColors;
                      if (state.loading) {
                        return Center(
                          child: CircularProgressIndicator(color: colors.gold),
                        );
                      }

                      final playableIds =
                          state.themes.map((t) => t.id).toSet();
                      final destinations =
                          DestinationCatalog.forPreset(preset);

                      return ListView.builder(
                        padding: const EdgeInsets.all(AppSizes.paddingMd),
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final dest = destinations[index];
                          final unlocked = playableIds.contains(dest.id);
                          final levelCount = state.themes
                              .where((t) => t.id == dest.id)
                              .map((t) => t.levels.length)
                              .firstOrNull;

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSizes.paddingMd,
                            ),
                            child: _ExploreDestinationCard(
                              name: dest.name,
                              country: dest.country,
                              imageAsset: dest.imageAsset,
                              levelLabel: unlocked
                                  ? '0/${levelCount ?? 20} levels'
                                  : 'Locked',
                              locked: !unlocked,
                              onTap: unlocked
                                  ? () {
                                      getIt<AppThemeBloc>()
                                          .setDestinationContext(dest.id);
                                      context.go('/levels?themeId=${dest.id}');
                                    }
                                  : null,
                            )
                                .animate(delay: (index * 80).ms)
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.06, end: 0),
                          );
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

class _ExploreDestinationCard extends StatelessWidget {
  const _ExploreDestinationCard({
    required this.name,
    required this.country,
    required this.imageAsset,
    required this.levelLabel,
    required this.locked,
    this.onTap,
  });

  final String name;
  final String country;
  final String imageAsset;
  final String levelLabel;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(preset.cardRadius),
        child: Ink(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(preset.cardRadius),
            border: Border.all(
              color: colors.glassBorder.withValues(alpha: locked ? 0.25 : 0.55),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(preset.cardRadius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  color: locked ? Colors.black54 : null,
                  colorBlendMode: locked ? BlendMode.darken : null,
                  errorBuilder: (_, __, ___) => DecoratedBox(
                    decoration: BoxDecoration(gradient: colors.primaryGradient),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        colors.scrim.withValues(alpha: 0.75),
                        colors.scrim.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name.toUpperCase(),
                              style: AppTextStyles.levelName(context).copyWith(
                                fontSize: 16,
                                color: locked ? colors.locked : colors.onScenic,
                              ),
                            ),
                            Text(
                              country,
                              style: AppTextStyles.bodyMuted(context).copyWith(
                                color: colors.onScenicMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              levelLabel,
                              style: AppTextStyles.wordList(context).copyWith(
                                fontSize: 12,
                                color: colors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (locked)
                        Icon(Icons.lock_rounded, color: colors.gold, size: 28)
                      else
                        Icon(Icons.chevron_right_rounded,
                            color: colors.gold, size: 28),
                    ],
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
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
