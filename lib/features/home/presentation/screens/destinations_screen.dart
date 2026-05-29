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
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/shell_nav_metrics.dart';
import 'package:word_game/features/home/presentation/cubit/destinations_cubit.dart';
import 'package:word_game/injection.dart';

class DestinationsScreen extends StatelessWidget {
  const DestinationsScreen({super.key});

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
        child: BlocBuilder<AppThemeBloc, AppThemeState>(
          buildWhen: (prev, next) => prev.activePreset != next.activePreset,
          builder: (context, themeState) =>
              _DestinationsBody(preset: themeState.activePreset),
        ),
      ),
    );
  }
}

class _DestinationsBody extends StatefulWidget {
  const _DestinationsBody({required this.preset});

  final AppThemePreset preset;

  @override
  State<_DestinationsBody> createState() => _DestinationsBodyState();
}

class _DestinationsBodyState extends State<_DestinationsBody> {
  bool _isFirstActivate = true;

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
    final preset = widget.preset;
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.themeGrid(preset),
          darken: 0.55,
          blurSigma: 1.5,
          child: SafeArea(
            bottom: false,
            child: JourneyContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const JourneyScreenHeader(showSettings: false),
                  Padding(
                    padding: JourneyThemeKit.pagePadding(context),
                    child: JourneyPanel(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      radius: 20,
                      child: Row(
                        children: [
                          const CompassBadge(size: 44, simple: true, icon: Icons.map_rounded),
                          const SizedBox(width: 14),
                          Expanded(
                            child: JourneySectionTitle(
                              title: 'Explore',
                              subtitle: preset.exploreSubtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingSm),
                  Expanded(
                    child: BlocBuilder<DestinationsCubit, DestinationsState>(
                      builder: (context, state) {
                        final colors = context.appColors;
                        if (state.loading) {
                          return Center(
                            child:
                                CircularProgressIndicator(color: colors.gold),
                          );
                        }

                        if (state.themes.isEmpty) {
                          return Center(
                            child: Text(
                              'No explore locations in JSON',
                              style: AppTextStyles.bodyMuted(context),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            AppSizes.paddingMd,
                            AppSizes.paddingMd,
                            AppSizes.paddingMd,
                            ShellNavMetrics.listBottomPadding(context),
                          ),
                          itemCount: state.themes.length,
                          itemBuilder: (context, index) {
                            final theme = state.themes[index];
                            final meta =
                                DestinationCatalog.byId(theme.id, preset);
                            final slotStars =
                                state.starsBySlot[theme.id] ?? const {};
                            final completed = theme.levels
                                .where((l) => slotStars.containsKey(l.id))
                                .length;
                            final total = theme.levels.length;
                            final imagePath = theme.backgroundImage.isNotEmpty
                                ? AssetPaths.themeImage(theme.backgroundImage)
                                : meta?.imageAsset ??
                                    AssetPaths.themeSplash(preset);

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.paddingMd,
                              ),
                              child: _ExploreDestinationCard(
                                name: theme.name,
                                country: meta?.country ?? '',
                                imageAsset: imagePath,
                                levelLabel: '$completed/$total levels',
                                onTap: () {
                                  getIt<AppThemeBloc>()
                                      .setDestinationContext(theme.id);
                                  context.go('/levels?themeId=${theme.id}');
                                },
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
    required this.onTap,
  });

  final String name;
  final String country;
  final String imageAsset;
  final String levelLabel;
  final VoidCallback onTap;

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
          height: 124,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(preset.cardRadius),
            border: Border.all(
              color: colors.glassBorder.withValues(alpha: 0.55),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: context.themePreset.homeSpec.playButtonGlow
                    .withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(preset.cardRadius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
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
                                color: colors.onScenic,
                              ),
                            ),
                            Text(
                              country,
                              style: AppTextStyles.bodyMuted(context).copyWith(
                                color: colors.onScenicMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.scrim.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: colors.glassBorder
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                levelLabel,
                                style: AppTextStyles.wordList(context).copyWith(
                                  fontSize: 12,
                                  color: colors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
