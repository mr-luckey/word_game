import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_game/core/navigation/route_back_handler.dart';
import 'package:word_game/core/config/app_ads_config.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/core/widgets/ads/shell_banner_ad.dart';
import 'package:word_game/features/achievements/presentation/widgets/achievement_widgets.dart';
import 'package:word_game/features/profile/domain/entities/achievement.dart';
import 'package:word_game/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:word_game/injection.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  String _category = 'all';
  static const _pageSize = 40;
  int _visibleCount = _pageSize;

  @override
  Widget build(BuildContext context) {
    return RouteBackHandler(
      child: BlocProvider(
        create: (_) => ProfileCubit(getIt(), getIt(), getIt()),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: ScenicBackground(
            child: SafeArea(
              child: JourneyContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: context.appColors.gold,
                              size: 20,
                            ),
                            onPressed: () => context.pop(),
                          ),
                          Expanded(
                            child: JourneySectionTitle(
                              title: 'Achievements',
                              subtitle: context.themePreset.exploreSubtitle,
                              align: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          if (state.loading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: context.appColors.gold,
                              ),
                            );
                          }
                          final filtered = _filter(state.achievements);
                          final visible = filtered.take(_visibleCount).toList();
                          return Column(
                            children: [
                              ProfileStatsRow(
                                completedLevels: state.completedLevels,
                                wordsFound: state.completedLevels * 6,
                                coinsCollected: 0,
                              ),
                              const SizedBox(height: 8),
                              _CategoryBar(
                                selected: _category,
                                onSelected: (c) => setState(() {
                                  _category = c;
                                  _visibleCount = _pageSize;
                                }),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: JourneyThemeKit.pagePadding(context),
                                  itemCount: visible.length +
                                      (visible.length < filtered.length ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index >= visible.length) {
                                      return TextButton(
                                        onPressed: () => setState(
                                          () => _visibleCount += _pageSize,
                                        ),
                                        child: const Text('Load more'),
                                      );
                                    }
                                    final a = visible[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSizes.paddingSm,
                                      ),
                                      child: AchievementListTile(
                                        title: a.title,
                                        description: a.description,
                                        coinReward: a.coinReward,
                                        unlocked: a.unlocked,
                                        target: a.target,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const ScreenFooterBanner(
                      placement: AdPlacements.bannerAchievements,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Achievement> _filter(List<Achievement> all) {
    if (_category == 'all') return all;
    return all.where((a) => a.category == _category).toList();
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  static const _cats = [
    ('all', 'All'),
    ('levels', 'Levels'),
    ('words', 'Words'),
    ('streak', 'Streak'),
    ('xp', 'XP'),
    ('daily', 'Daily'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (id, label) = _cats[i];
          final active = selected == id;
          return FilterChip(
            label: Text(label),
            selected: active,
            onSelected: (_) => onSelected(id),
          );
        },
      ),
    );
  }
}
