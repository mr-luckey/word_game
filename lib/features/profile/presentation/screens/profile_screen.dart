import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_game/core/constants/asset_paths.dart';
import 'package:word_game/core/theme/app_sizes.dart';
import 'package:word_game/core/theme/app_text_styles.dart';
import 'package:word_game/core/theme/theme_context.dart';
import 'package:word_game/core/widgets/coin_display.dart';
import 'package:word_game/core/widgets/journey_theme_kit.dart';
import 'package:word_game/core/widgets/scenic_background.dart';
import 'package:word_game/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:word_game/features/wallet/presentation/cubit/coin_cubit.dart';
import 'package:word_game/injection.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(getIt(), getIt()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: ScenicBackground(
          imageAsset: AssetPaths.themeSplash(context.themePreset),
          darken: 0.5,
          blurSigma: 1,
          child: SafeArea(
            child: JourneyContentWidth(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMd,
                      vertical: AppSizes.paddingSm,
                    ),
                    child: JourneyPanel(
                      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                      radius: 20,
                      child: Row(
                        children: [
                          const CompassBadge(
                              size: 42, icon: Icons.person_rounded),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: JourneySectionTitle(
                              title: 'PROFILE',
                              subtitle: 'Track and achieve',
                            ),
                          ),
                          BlocBuilder<CoinCubit, CoinState>(
                            builder: (context, coinState) => CoinDisplay(
                                coins: coinState.coins, light: true),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.08, end: 0),
                  Expanded(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final colors = context.appColors;
                        if (state.loading) {
                          return Center(
                            child:
                                CircularProgressIndicator(color: colors.gold),
                          );
                        }
                        return ListView(
                          padding: const EdgeInsets.all(AppSizes.paddingMd),
                          children: [
                            _ProfileCard(
                              child: Column(
                                children: [
                                  _ThemedAvatar(colors: colors),
                                  const SizedBox(height: 14),
                                  Text(
                                    context.themePreset.profilePersona
                                        .toUpperCase(),
                                    style: AppTextStyles.greeting(context)
                                        .copyWith(
                                      fontSize: 20,
                                      letterSpacing: 1.5,
                                      shadows:
                                          JourneyThemeKit.textGlow(context),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Level 1',
                                    style: AppTextStyles.bodyMuted(context)
                                        .copyWith(
                                      color: colors.accentCoin,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: 0.0,
                                      minHeight: 10,
                                      backgroundColor: colors.tertiary
                                          .withValues(alpha: 0.8),
                                      valueColor: AlwaysStoppedAnimation(
                                        colors.accentCoin,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '0 / 100 XP',
                                    style: AppTextStyles.bodyMuted(context)
                                        .copyWith(
                                      fontSize: 12,
                                      color: colors.accentCoin,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 500.ms).slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutCubic,
                                ),
                            const SizedBox(height: AppSizes.paddingMd),
                            Row(
                              children: [
                                _StatTile(
                                  index: 0,
                                  label: 'Levels\nCompleted',
                                  value: '${state.completedLevels}',
                                ),
                                const SizedBox(width: 8),
                                _StatTile(
                                  index: 1,
                                  label: 'Words\nFound',
                                  value: '${state.completedLevels * 6}',
                                ),
                                const SizedBox(width: 8),
                                BlocBuilder<CoinCubit, CoinState>(
                                  builder: (context, coinState) => _StatTile(
                                    index: 2,
                                    label: 'Coins\nCollected',
                                    value: '${coinState.coins}',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.paddingLg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ACHIEVEMENTS',
                                  style: AppTextStyles.sectionHeading(context)
                                      .copyWith(fontSize: 17, letterSpacing: 1),
                                ),
                                Text(
                                  'View All',
                                  style:
                                      AppTextStyles.bodyMuted(context).copyWith(
                                    color: colors.gold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ).animate(delay: 300.ms).fadeIn(),
                            const SizedBox(height: AppSizes.paddingSm),
                            ...state.achievements.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final a = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.paddingSm,
                                  ),
                                  child: _AchievementTile(
                                    title: a.title,
                                    description: a.description,
                                    coinReward: a.coinReward,
                                    unlocked: a.unlocked,
                                  )
                                      .animate(
                                        delay: (350 + index * 90).ms,
                                      )
                                      .fadeIn(
                                        duration: 450.ms,
                                        curve: Curves.easeOut,
                                      )
                                      .slideX(
                                        begin: 0.15,
                                        end: 0,
                                        curve: Curves.easeOutCubic,
                                      )
                                      .scale(
                                        begin: const Offset(0.94, 0.94),
                                        end: const Offset(1, 1),
                                        duration: 450.ms,
                                        curve: Curves.easeOutBack,
                                      ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemedAvatar extends StatelessWidget {
  const _ThemedAvatar({required this.colors});

  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final preset = context.themePreset;
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.gold, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: colors.gold.withValues(alpha: 0.35),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AssetPaths.themeSplash(preset),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => DecoratedBox(
                decoration: BoxDecoration(gradient: colors.primaryGradient),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.scrim.withValues(alpha: 0.36),
              ),
            ),
            Center(child: CompassBadge(size: 54)),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
          duration: 3.seconds,
          color: colors.gold.withValues(alpha: 0.2),
        );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.title,
    required this.description,
    required this.coinReward,
    required this.unlocked,
  });

  final String title;
  final String description;
  final int coinReward;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return _ProfileCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked
                  ? colors.gold.withValues(alpha: 0.18)
                  : colors.surface.withValues(alpha: 0.6),
              border: Border.all(
                color: unlocked
                    ? colors.gold
                    : colors.locked.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Icon(
              unlocked
                  ? Icons.emoji_events_rounded
                  : Icons.lock_outline_rounded,
              color: unlocked ? colors.gold : colors.locked,
              size: 24,
            ),
          )
              .animate(
                target: unlocked ? 1 : 0,
                onPlay: unlocked ? (c) => c.repeat(reverse: true) : null,
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.12, 1.12),
                duration: 1.2.seconds,
                curve: Curves.easeInOut,
              )
              .then()
              .shimmer(
                duration: 2.seconds,
                color: colors.gold.withValues(alpha: unlocked ? 0.35 : 0),
              ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.levelName(context).copyWith(
                    fontSize: 15,
                    color: colors.onScenic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodyMuted(context).copyWith(
                    fontSize: 12,
                    color: colors.accentCoin.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+$coinReward',
            style: AppTextStyles.coinsScore(context).copyWith(
              fontSize: 15,
              color: colors.gold,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(duration: 600.ms)
              .then()
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 1.seconds,
              ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final preset = context.themePreset;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(preset.cardRadius),
        color: colors.glassSurface,
        border: Border.all(
          color: colors.glassBorder.withValues(alpha: 0.75),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.glassBorder.withValues(alpha: 0.12),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.index,
    required this.label,
    required this.value,
  });

  final int index;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Expanded(
      child: _ProfileCard(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.coinsScore(context).copyWith(
                color: colors.gold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMuted(context).copyWith(
                fontSize: 11,
                color: colors.accentCoin.withValues(alpha: 0.9),
                height: 1.3,
              ),
            ),
          ],
        ),
      )
          .animate(delay: (150 + index * 80).ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.12, end: 0, curve: Curves.easeOutBack),
    );
  }
}
